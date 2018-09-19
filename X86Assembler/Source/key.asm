TITLE CUSTOM CHARACTER SET KEYBOARD DRIVER

                ; ------------------------
                ; | ANGELOS KARAGEORGIOU |
                ; | MARCH 1990           |
                ; ------------------------
                ; MAJOR REVISION
                ; FEB 1992

;-------------------------------------------------------------------
;KEEP IN MIND THAT THIS PROGRAM HAS TO BE ASSEMBLED AS A COM FILE SO
;IT CAN PERFORM ACCORDING TO ITS SPECIFICATIONS WITH EXE2BIN
;-------------------------------------------------------------------


;------------------------
;MASM PSEUDO EQUIVALENCES
;------------------------

DOS_IO          EQU     09H
DOS_FUN         EQU     21H
DOS_TERM        EQU     27H
GET_VECTOR      EQU     35H
SET_VECTOR      EQU     25H
INTERRUPT_NUMBER        EQU     9
HOTKEY                  EQU     0C1FH; CONTROL "-"
BIG                     EQU     86
SMALLCASE                   EQU     118
CONTROL                 EQU     22
ALT                     EQU     0


ROM_BIOS_DATA   SEGMENT AT 40H  ;BIOS statuses held here, also keyboard buffer
        ORG     1AH
        HEAD DW      ?                  ;Unread chars go from Head to Tail
        TAIL DW      ?
        BUFFER       DW      16 DUP (?)         ;The buffer itself
        BUFFER_END   LABEL   WORD
ROM_BIOS_DATA   ENDS

CODE SEGMENT PUBLIC 'CODE'
        ORG     100H            ;ORG = 100H to make this into a .COM file
        ASSUME CS:CODE,ES:CODE,DS:ROM_BIOS_DATA
FIRST:  JMP     LOAD_PROG       ;First time through jump to initialize routine

        OLD_KEY_INT     LABEL   WORD
        OLD_KEYBOARD_INT        DD      ?       ;Location of old kbd interrupt
;------------------------------------------------------------
;FOLLOWING VARIABLES ARE USED BY THE GREEKTRANSLATE PROCEDURE
;-------------------------------------------------------------
        KBACT           DB        0             ;THEY SPEEK FOR THEMSELVES
        TOGGLE_FLAG     DB        0
        STRESS_FLAG     DB        0
        UMLAUT_FLAG     DB        0

;---------------------------------------------------------------------------
;THE FOLLOWING TABLE IS A SUBSET OF ASCII THAT REMAPS A STANDARD CHARACTER
;TO ITS NEW VALUE.FAST EFFICIENT AND ONLY 128 BYTES WIDE.CHARACTERS THAT
;WERE NOT SUPPOSED TO BE REMAPPED HAVE THEIR OLD VALUES SO THAT WE CAN AVOID
;RECKING HAVOC TO THE MACHINE BY ALTERING THE SPECIAL CONTROL CHARACTERS
;---------------------------------------------------------------------------

GREEK_TABLE     DB        0,   1,  2,  3,  4,  5,  6,  7,  8,  9,  10,  11, 12,
                DB       13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,
                DB       27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
                DB       41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54,
                DB       55, 56, 57, 58, 59, 60, 61, 62, 63, 64,128,129,150,131,
                DB      132,148,130,134,136,141,137,138,139,140,142,143,'<',144,
                DB      145,146,135,151,'S',149,147,133, 91, 92, 93, 94, 95, 96,
                DB      152,153,175,155,156,173,154,158,160,165,161,162,163,164,
                DB      166,167,'>',168,169,171,159,224,170,174,172,157,123,124,
                DB      125,126,127

GREEK_STRESS_TABLE DB   0, 1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13,14,
                  DB     15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
                  DB     29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42,
                  DB     43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56,
                  DB     57, 58, 59, 60, 61, 62, 63, 64,234,129,150,131,235,148,
                 DB      130,236,237,141,137,138,139,140,238,143,'<',144,145,146,
                 DB      135,240,'S',149,239,133, 91, 92, 93, 94, 95, 96,225,153,
                 DB     175,155,226,173,154,227,229,165,161,162,163,164,230,167,
                 DB     '>',168,169,171,159,233,170,174,231,157,123,124,125,126,
                 DB     127

;The keyboard interrupt will now come here.,
;Save the used registers for good form
proc prog far
        push    ax
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    DI
        PUSH    SI
        PUSH    DS
        PUSH    ES

        in al,060h
        PUSHF                   ;First, call old keyboard interrupt
        CALL    OLD_KEYBOARD_INT

        ASSUME  DS:ROM_BIOS_DATA        ;Examine the char just put in
        MOV     BX,ROM_BIOS_DATA
        MOV     DS,BX

        MOV     BX,DS:TAIL                 ;Point to current tail
        CMP     BX,DS:HEAD                 ;If at head, kbd int has deleted char
        JNE     GOPETE
        JMP     CS:EXIT                    ;So leave
GOPETE:
        SUB     BX,2                    ;Point to just read in character
        CMP     BX,OFFSET DS:BUFFER        ;Did we undershoot buffer?
        JAE     NO_WRAP                 ;Nope
        MOV     BX,OFFSET DS:BUFFER_END    ;Yes -- move to buffer top
        SUB     BX,2                    ;Point to just read in character 
NO_WRAP:MOV     DX,[DS:BX]                 ;Char in DX now
        
        STI                             ;ENABLE ALL OTHER INTERRUPTS
        CMP CS:KBACT,1                     ;HAVE WE BEEN ACTIVATED PREVIOUSLY?
        JNE XYZ                         ;NOPE CONTINUE
        JMP CS:EXIT                        ;YEP GET OUT OF HERE



; ----------TRANSLATION TABLE---------------------
; TAKES THE CHARACTER IN AX AND TRANSLATES TO THE
; GREEK EQUIVALENT.USES AN ASCII-LIKE LOOKUP TABLE
;--------------------------------------------------
xyz:     mov [cs:kbact],1
         MOV AX,DX
         CMP AX,0C1FH                   ;IS IT OUR TOGGLE KEY COMBINATION?
         JE  TOGGLE_SET                 ;GO TO THE TOGGLING FUNCTION
         CMP AL,';'                     ;IS IT OUR STRESS KEY COMBINATION?
         JE  STRESS_SET                 ;YES
         CMP AL,':'                     ;IS IT OUR UMLAUT KEY COMBINATION?
         JE  UMLAUT_SET                 ;YES
         JMP NORMAL                     ;NONE OF THE ABOVE JUST TRANSLATE


TOGGLE_SET:
         CMP CS:TOGGLE_FLAG,0               ;READJUST OUR TOGGLE STATUS
         JE  ZERO
         MOV CS:TOGGLE_FLAG,0
         MOV DS:TAIL,BX                    ;NO ECHO PLEASE
         JMP CS:EXIT                       ;GET READY FOR NEXT CHARACTER
 ZERO:   MOV CS:TOGGLE_FLAG,1
         MOV DS:TAIL,BX                    ;NO ECHO PLEASE
         JMP CS:EXIT                       ;GET READY FOR NEXT CHARACTER


STRESS_SET:
         CMP CS:TOGGLE_FLAG,1
         JE  STRESS_CONT
         JMP CS:EXIT
STRESS_CONT:
         CMP CS:STRESS_FLAG,1              ;IS THE FLAG ALREADY SET?
         JnE  ST_CONT
         MOV AL,';'                     ;SEND A STRESS
         MOV [DS:BX],AX
         MOV CS:STRESS_FLAG,0              ;RESET THE FLAG
         JMP CS:EXIT
ST_CONT:
         MOV CS:STRESS_FLAG,1              ;SET THE STRESS FLAG ON
         MOV DS:TAIL,BX                    ;SET NO ECHO
         JMP CS:EXIT                       ;GET OUT OF HERE


UMLAUT_SET:
         CMP CS:TOGGLE_FLAG,1
         JE  UMLAUT_CONT
         JMP CS:EXIT
UMLAUT_CONT:
         CMP CS:UMLAUT_FLAG,1              ;IS THE FLAG ALREADY ON?
         JnE UM_CONT
         MOV AL,':'                     ;SEND an UMLAUT
         MOV [DS:BX],AX
         MOV CS:UMLAUT_FLAG,0              ;RESET THE FLAG
         JMP CS:EXIT
UM_CONT:
         MOV CS:UMLAUT_FLAG,1              ;SET THE UMLAUT FLAG ON
         MOV DS:TAIL,BX                    ;NO ECHO PLEASE
         JMP CS:EXIT                       ;BYE


 NORMAL: CMP CS:TOGGLE_FLAG,0              ;ARE WE TOGGLED ON?
         JNE NOR                        ;YES
         JMP CS:EXIT                       ;NO    GET OUT
NOR:     CMP CS:STRESS_FLAG,1              ;IS THE STRESS FLAG ON?
         JE STRESS
         CMP CS:UMLAUT_FLAG,1              ;OR IS THE UMLAUT FLAG ON?
         JE  UMLAUT
         PUSH BX                           ;SAVE BX
         ASSUME  ES:CODE
        MOV BX,CS
        MOV ES,BX
        LEA BX,CS:GREEK_TABLE
         CMP AL,128
         JL  CONTY                      ;YES, NO TRANSLATION REQUIRED
         JMP CS:EXIT
CONTY:   XLAT [ES:BX]                   ;TRANSLATE PLEASE
         POP BX                         ;RESTORE BX
         MOV [DS:BX],AX
         JMP CS:EXIT

UMLAUT:  MOV CS:UMLAUT_FLAG,0              ;RESET THE UMLAUT FLAG
         CMP CS:STRESS_FLAG,1              ;DOUBLE CHECK AGAIN PLEASE
         JE  BOTH
         CMP AL,'i'
         JE  UIOTA
         CMP AL,'y'
         JE  UYPSILON
         MOV AL,':'                      ;NONE OF THE ABOVE print ":"
         MOV [DS:BX],AX
         JMP CS:EXIT                        ;GET OUT
UIOTA:   MOV AL,228
         MOV [DS:BX],AX
         JMP CS:EXIT
UYPSILON:MOV AL,232
         MOV [DS:BX],AX
         JMP CS:EXIT

STRESS:  MOV CS:STRESS_FLAG,0              ;RESET THE STRESS FLAG
         CMP CS:UMLAUT_FLAG,1              ;IS THE UMLAUT FLAG ON ALSO?
         JE  BOTH                       ;DO THE DOUBLE
        PUSH BX
        ASSUME  ES:CODE
        MOV BX,CS
        MOV ES,BX
        LEA  BX,CS:GREEK_STRESS_TABLE
        CMP AL,128
         JL  CONTY1                     ;YES, NO TRANSLATION REQUIRED
         JMP CS:EXIT
CONTY1:  XLAT [ES:BX]  ;NO, TRANSLATE CHARACTER AND LEAVE
        POP BX
         MOV [DS:BX],AX
         JMP CS:EXIT

BOTH:    MOV CS:UMLAUT_FLAG,0              ;RESET THE UMLAUT FLAG
         MOV CS:STRESS_FLAG,0              ;RESET THE STRESS FLAG
         CMP AL,'i'
         JE  BIOTA
         CMP AL,'y'
         JE  BYPSILON
         MOV DS:TAIL,BX                    ;NONE OF THE ABOVE
         JMP CS:EXIT                       ;GET OUT
BIOTA:   MOV AL,228
         MOV [DS:BX],AX
         JMP CS:EXIT
BYPSILON:
         MOV AL,232
         MOV [DS:BX],AX
         JMP CS:EXIT
         JMP CS:EXIT

;DO_OMEGA:
;        CMP AH,47               ;IS THE V KEY PRESSED ?
;        JNE EXIT                ; NOPE GET OUT
;        MOV AH,STATUS           ;READ STAT BYTE
;        TEST AH,01000000B       ;IS THE CAPS LOCK ON ?
;        JZ      NOCAPS          ;NOPE GET OUT
;        MOV AL,BIG              ;YES SET IT UP
;        MOV AH,47
;        JMP NORMAL
;NOCAPS:
;        TEST AH,00000010B       ;IS THE LEFT SHIFT ON ?
;        JZ      NOLEFT          ;NOPE GET OUT
;        MOV AL,BIG              ;YES SET IT UP
;        MOV AH,47
;        JMP NORMAL
;NOLEFT:
;        TEST AH,00000001B       ;IS THE RIGHT SHIFT ON ?
;        JZ      NORIGHT          ;NOPE GET OUT
;        MOV AL,BIG              ;YES SET IT UP
;        MOV AH,47
;        JMP NORMAL
;NORIGHT:
;        TEST AH,00001000B       ;IS THE ALT KEY ON ?
;        JZ      NOALT         ;NOPE GET OUT
;        MOV AL,ALT              ;YES SET IT UP
;        MOV AH,47
;        JMP NORMAL
;NOALT:
;        TEST AH,00000100B       ;IS THE CONTROL KEY ON ?
;        JZ      NOCTRL         ;NOPE GET OUT
;        MOV AL,CONTROL              ;YES SET IT UP
;        MOV AH,47
;        JMP NORMAL
;NOCTRL:
;        MOV AL,SMALLCASE            ;NONE OF THE ABOVE
;        MOV AH,47
;        JMP NORMAL
;
EXIT:   mov [cs:kbact],0
        mov al,020h     ;8259 eoi
        out 020h,al

        POP     ES      ;Having done Pushes, here are the Pops
        POP     DS
        POP     SI
        POP     DI
        POP     DX
        POP     CX
        POP     BX
        POP     AX     
        IRET                    ;An interrupt needs an IRET
PROG    ENDP

LOAD_PROG       PROC            ;This procedure intializes everything

        JMP MORE
; DATA NOT NEEDED DURING TSR OPERATION
Myname          db      'By Angelos Karageorgiou   (C) 1992 X.M.A.K. SYSTEMS INTERNATIONAL',10,13,'Sole Distributor for the U.S.,   M.I.S. of Norwalk Connecticut',10,13,'$'
MYTITLE         DB      'Greek / English Keyboard Driver',10,13,'$'
LOADED          DB      'ALREADY LOADED',10,13,'$'
GREETING        DB      'Use CONTROL "-" to switch between English and Greek',10,13,'$'

MORE:   MOV     BX,CS
        MOV     DS,BX

        MOV DX,OFFSET MYTITLE                   ;GIVE 'EM SOME TITLE
        MOV AH,09H
        INT 21H

        MOV DX,OFFSET MYNAME                      ;GIVE 'EM SOME NAME
        MOV AH,09H
        INT 21H



        CLD                                     ;SEE IF WE ARE ALREADY LOADED
        MOV     CX,0
        MOV     ES,CX
        mov     cx,cs
        mov     ds,cx
        MOV     DI,0024H
        LES     DI,ES:[DI]
        MOV     SI,OFFSET PROG
        MOV     CX,40h                          ;HOW MANY CHARACTERS TO LOOK FOR
        REPE    CMPSB                           ;COMPARE THE STRINGS
        JE      GOOD_EXIT                       ;ALREADY LOADED


        MOV DX,OFFSET GREETING                  ;GIVE 'EM SOME ADVICE
        MOV AH,09H
        INT 21H



        MOV     AH,35H          ;Get old vector into ES:BX
        MOV     AL,INTERRUPT_NUMBER     ;See EQU at beginning
        INT     21H

        MOV     OLD_KEY_INT,BX        ;Store old interrupt vector
        MOV     OLD_KEY_INT[2],ES

        MOV     AH,25H          ;Set new interrupt vector
        LEA     DX,PROG
        INT     21H
        
        MOV     DX,OFFSET LOAD_PROG     ;Set up everything but LOAD_PROG to
        INT     27H                     ;stay and attach itself to DOS

GOOD_EXIT:

        MOV DX,OFFSET LOADED                   ;GIVE 'EM SOME STUFF
        MOV AH,09H
        INT 21H

        MOV AH,4CH                                ;KILL ME
        INT 21h


LOAD_PROG        ENDP
CODE ENDS
        END     FIRST   ;END "FIRST" so 80x86 will go to FIRST first.

