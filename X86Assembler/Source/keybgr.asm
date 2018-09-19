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

DOS_IO          EQU     16H
DOS_FUN         EQU     21H
DOS_TERM        EQU     27H
GET_VECTOR      EQU     35H
SET_VECTOR      EQU     25H


CSEG    SEGMENT WORD 'CSEG'
        ASSUME CS:CSEG,DS:CSEG
        ORG     100H
START:  JMP     INITIALIZE              ;MAKE THE PROGRAM TSR

OLD_KB_IO       DD      ?               ;KEEP THE OLD INTERRUPT

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

GREEK_TABLE     DB        0       ;-------------------------
                DB        1       ;DON'T YOU DARE TOUCH THE
                DB        2       ;SPECIAL CHARACTERS
                DB        3       ;-------------------------
                DB        4
                DB        5
                DB        6
                DB        7
                DB        8
                DB        9
                DB       10
                DB       11
                DB       12
                DB       13
                DB       14
                DB       15
                DB       16
                DB       17
                DB       18
                DB       19
                DB       20
                DB       21
                DB       22
                DB       23
                DB       24
                DB       25
                DB       26
                DB       27
                DB       28
                DB       29
                DB       30
                DB       31
                DB       32
                DB       33
                DB       34
                DB       35
                DB       36
                DB       37
                DB       38
                DB       39
                DB       40
                DB       41
                DB       42
                DB       43
                DB       44
                DB       45
                DB       46
                DB       47
                DB       48
                DB       49
                DB       50
                DB       51
                DB       52
                DB       53
                DB       54
                DB       55
                DB       56
                DB       57
                DB       58
                DB       59
                DB       60
                DB       61
                DB       62       ;---------------
                DB       63       ;CAPITAL LETTERS
                DB       64       ;---------------
                DB      128       ;A
                DB      129       ;B
                DB      150       ;C
                DB      131       ;D
                DB      132       ;E
                DB      148       ;F
                DB      130       ;G
                DB      134       ;H
                DB      136       ;I
                DB      141       ;J
                DB      137       ;K
                DB      138       ;L
                DB      139       ;M
                DB      140       ;N
                DB      142       ;O
                DB      143       ;P
                DB      '<'       ;Q
                DB      144       ;R
                DB      145       ;S
                DB      146       ;T
                DB      135       ;U
                DB      151       ;V
                DB      'S'       ;W
                DB      149       ;X
                DB      147       ;Y
                DB      133       ;Z
                DB       91
                DB       92
                DB       93
                DB       94        ;------------------
                DB       95        ;SMALL CASE LETTERS
                DB       96        ;------------------
                DB      152        ;A
                DB      153        ;B
                DB      175        ;C
                DB      155        ;D
                DB      156        ;E
                DB      173        ;F
                DB      154        ;G
                DB      158        ;H
                DB      160        ;I
                DB      165        ;J
                DB      161        ;K
                DB      162        ;L
                DB      163        ;M
                DB      164        ;N
                DB      166        ;O
                DB      167        ;P
                DB      '>'        ;Q
                DB      168        ;R
                DB      169        ;S
                DB      171        ;T
                DB      159        ;U
                DB      224        ;V
                DB      170        ;W
                DB      174        ;X
                DB      172        ;Y
                DB      157        ;Z
                DB      123
                DB      124
                DB      125
                DB      126
                DB      127


GREEK_STRESS_TABLE DB        0       ;-------------------------
                DB        1          ;DON'T YOU DARE TOUCH THE
                DB        2          ;SPECIAL CHARACTERS
                DB        3          ;-------------------------
                DB        4
                DB        5
                DB        6
                DB        7
                DB        8
                DB        9
                DB       10
                DB       11
                DB       12
                DB       13
                DB       14
                DB       15
                DB       16
                DB       17
                DB       18
                DB       19
                DB       20
                DB       21
                DB       22
                DB       23
                DB       24
                DB       25
                DB       26
                DB       27
                DB       28
                DB       29
                DB       30
                DB       31
                DB       32
                DB       33
                DB       34
                DB       35
                DB       36
                DB       37
                DB       38
                DB       39
                DB       40
                DB       41
                DB       42
                DB       43
                DB       44
                DB       45
                DB       46
                DB       47
                DB       48
                DB       49
                DB       50
                DB       51
                DB       52
                DB       53
                DB       54
                DB       55
                DB       56
                DB       57
                DB       58
                DB       59
                DB       60
                DB       61
                DB       62       ;---------------
                DB       63       ;CAPITAL LETTERS
                DB       64       ;---------------
                DB      234       ;A
                DB      129       ;B
                DB      150       ;C
                DB      131       ;D
                DB      235       ;E
                DB      148       ;F
                DB      130       ;G
                DB      236       ;H
                DB      237       ;I
                DB      141       ;J
                DB      137       ;K
                DB      138       ;L
                DB      139       ;M
                DB      140       ;N
                DB      238       ;O
                DB      143       ;P
                DB      '<'       ;Q
                DB      144       ;R
                DB      145       ;S
                DB      146       ;T
                DB      135       ;U
                DB      240       ;V
                DB      'S'       ;W
                DB      149       ;X
                DB      239       ;Y
                DB      133       ;Z
                DB       91
                DB       92
                DB       93
                DB       94        ;------------------
                DB       95        ;SMALL CASE LETTERS
                DB       96        ;------------------
                DB      225        ;A
                DB      153        ;B
                DB      175        ;C
                DB      155        ;D
                DB      226        ;E
                DB      173        ;F
                DB      154        ;G
                DB      227        ;H
                DB      229        ;I
                DB      165        ;J
                DB      161        ;K
                DB      162        ;L
                DB      163        ;M
                DB      164        ;N
                DB      230        ;O
                DB      167        ;P
                DB      '>'        ;Q
                DB      168        ;R
                DB      169        ;S
                DB      171        ;T
                DB      159        ;U
                DB      233        ;V
                DB      170        ;W
                DB      174        ;X
                DB      231        ;Y
                DB      157        ;Z
                DB      123
                DB      124
                DB      125
                DB      126
                DB      127



;------------------------------------------------------------------------------
;THIS IS THE MAIN ROUTINE. IT REMAPS INT 16H SO THAT ANY REQUEST TO THE KEYBOARD
;PASSES THROUGH IT.IF THE TOGGLE IS ON IT THEN REMAPS ALL CHARACTERS TO THE ONES
;SPECIFIED IN THE PREVIOUS TABLE
;------------------------------------------------------------------------------

KEYBOARD_INTERCEPTOR    PROC FAR

        PUSH    DS                      ;SAVE OLD VALUES
        PUSH    BX
        PUSH    DX
        PUSH    SI
        MOV     BX,CS
        MOV     DS,BX
        CMP     AH,0                    ;CHECK AH
        JE      KEY                     ;O.K. DO YOUR WORK
        JMP     QUIT                    ;GET OUT OF HERE

KEY:    STI                             ;ENABLE ALL OTHER INTERRUPTS
        CMP KBACT,1                     ;HAVE WE BEEN ACTIVATED PREVIOUSLY?
        JNE XYZ                         ;NOPE CONTINUE
        JMP EXIT                        ;YEP GET OUT OF HERE

XYZ:    PUSHF                           ;GET READY
        ASSUME  DS:NOTHING
        CALL    OLD_KB_IO               ;CALL THE OLD GUY TO DO ITS WORK

; ----------TRANSLATION TABLE---------------------
; TAKES THE CHARACTER IN AX AND TRANSLATES TO THE
; GREEK EQUIVALENT.USES AN ASCII-LIKE LOOKUP TABLE
;--------------------------------------------------


         CMP AL,0H                      ;IS THIS A VALID ASCCI CODE?
         JNE KO2                        ;YES GO ON
         JMP EXIT                       ;NO TRANSLATION NEEDED ON SPECIAL KEYS
 KO2:    CMP AX,0C1FH                   ;IS IT OUR TOGGLE KEY COMBINATION?
         JE  TOGGLE_SET                 ;GO TO THE TOGGLING FUNCTION
         CMP AL,';'                     ;IS IT OUR STRESS KEY COMBINATION?
         JE  STRESS_SET                 ;YES
         CMP AL,':'                     ;IS IT OUR UMLAUT KEY COMBINATION?
         JE  UMLAUT_SET                 ;YES
         JMP NORMAL                     ;NONE OF THE ABOVE JUST TRANSLATE
TOGGLE_SET:CMP TOGGLE_FLAG,0            ;READJUST OUR TOGGLE STATUS
         JE  ZERO
         MOV TOGGLE_FLAG,0
         MOV AL,0                       ;NO ECHO PLEASE
         JMP EXIT                       ;GET READY FOR NEXT CHARACTER
 ZERO:   MOV TOGGLE_FLAG,1
         MOV AL,0                       ;NO ECHO PLEASE
         JMP EXIT                       ;GET READY FOR NEXT CHARACTER
STRESS_SET:
         CMP TOGGLE_FLAG,1
         JE  STRESS_CONT
         JMP EXIT
STRESS_CONT:
         CMP STRESS_FLAG,1              ;IS THE FLAG ALREADY SET?
         JnE  ST_CONT
         MOV AL,';'                     ;SEND A STRESS
         MOV STRESS_FLAG,0              ;RESET THE FLAG
         JMP EXIT
ST_CONT:
         MOV STRESS_FLAG,1              ;SET THE STRESS FLAG ON
         MOV AL,0                       ;SET NO ECHO
         JMP EXIT                       ;GET OUT OF HERE
UMLAUT_SET:
         CMP TOGGLE_FLAG,1
         JE  UMLAUT_CONT
         JMP EXIT
UMLAUT_CONT:
         CMP UMLAUT_FLAG,1              ;IS THE FLAG ALREADY ON?
         JnE UM_CONT
         MOV AL,':'                     ;SEND an UMLAUT
         MOV UMLAUT_FLAG,0              ;RESET THE FLAG
         JMP EXIT
UM_CONT:
         MOV UMLAUT_FLAG,1              ;SET THE UMLAUT FLAG ON
         MOV AL,0                       ;NO ECHO PLEASE
         JMP EXIT                       ;BYE
 NORMAL: CMP TOGGLE_FLAG,0              ;ARE WE TOGGLED ON?
         JNE NOR                        ;YES
         JMP EXIT                       ;NO    GET OUT
NOR:     CMP STRESS_FLAG,1              ;IS THE STRESS FLAG ON?
         JE STRESS
         CMP UMLAUT_FLAG,1              ;OR IS THE UMLAUT FLAG ON?
         JE  UMLAUT
         MOV BX,AX                      ;CONTINUE BY ADJUSTING SI
         MOV BH,0
         MOV SI,BX
         CMP SI,128                     ;ARE WE ABOVE 128?
         JL  CONTY                      ;YES, NO TRANSLATION REQUIRED
         JMP EXIT
CONTY:   MOV AL,GREEK_TABLE[SI]         ;NO, TRANSLATE CHARACTER AND LEAVE
         JMP EXIT

UMLAUT:  MOV UMLAUT_FLAG,0              ;RESET THE UMLAUT FLAG
         CMP STRESS_FLAG,1              ;DOUBLE CHECK AGAIN PLEASE
         JE  BOTH
         CMP AL,'i'
         JE  UIOTA
         CMP AL,'y'
         JE  UYPSILON
         MOV AL,':'                      ;NONE OF THE ABOVE print ":"
         JMP EXIT                        ;GET OUT
UIOTA:   MOV AL,228
         JMP EXIT
UYPSILON:MOV AL,232
         JMP EXIT

STRESS:  MOV STRESS_FLAG,0              ;RESET THE STRESS FLAG
         CMP UMLAUT_FLAG,1              ;IS THE UMLAUT FLAG ON ALSO?
         JE  BOTH                       ;DO THE DOUBLE
         MOV BX,AX                      ;CONTINUE BY ADJUSTING SI
         MOV BH,0
         MOV SI,BX
         CMP SI,128                     ;ARE WE ABOVE 128?
         JL  CONTY1                     ;YES, NO TRANSLATION REQUIRED
         JMP EXIT
CONTY1:  MOV AL,GREEK_STRESS_TABLE[SI]  ;NO, TRANSLATE CHARACTER AND LEAVE
         JMP EXIT

BOTH:    MOV UMLAUT_FLAG,0              ;RESET THE UMLAUT FLAG
         MOV STRESS_FLAG,0              ;RESET THE STRESS FLAG
         CMP AL,'i'
         JE  BIOTA
         CMP AL,'y'
         JE  BYPSILON
         MOV AL,0                       ;NONE OF THE ABOVE
         JMP EXIT                       ;GET OUT
BIOTA:   MOV AL,228
         JMP EXIT
BYPSILON:
         MOV AL,232
         JMP EXIT
EXIT:    CLI                             ;IGNORE OTHERS WHILE IN THE BATHROOM
         MOV KBACT,0                     ;NO ACTIVE ANYMORE
         POP     SI                      ;RESTORE PREVIOUS VALUES
         POP     DX
         POP     BX
         POP     DS

         IRET                            ;RETURN

QUIT:    CLI                             ;IGNORE OTHERS WHILE IN THE BATHROOM
         POP     SI                      ;RESTORE PREVIOUS VALUES
         POP     DX
         POP     BX
         POP     DS
         ASSUME  DS:NOTHING
         JMP     OLD_KB_IO               ;BRANCH

KEYBOARD_INTERCEPTOR    ENDP            ;THAT'S ALL FOLKS


INITIALIZE: JMP MORE
; DATA NOT NEEDED DURING TSR OPERATION
Myname          db      'By Angelos Karageorgiou   (C) 1992 X.M.A.K. SYSTEMS SYSTEMS INTERNATIONAL',10,13,'Sole Distributor for the U.S.,   M.I.S. of Norwalk Connecticut',10,13,'$'
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

        MOV     AL,16H                          ;GET THE OLD INTERRUPT VALUES
        MOV     AH,GET_VECTOR
        INT     DOS_FUN
        MOV     WORD PTR OLD_KB_IO[0],bx        ;KEEP THEM
        MOV     WORD PTR OLD_KB_IO[2],es        ; REVERSED ?!?!?!?!?!?!?!


        CLD                                     ;SEE IF WE ARE ALREADY LOADED
        MOV     CX,0
        MOV     ES,CX
        MOV     DI,0058H                        ;WHERE INT16 IS
        LES     DI,ES:[DI]                      ;16 * 4
        MOV     SI,OFFSET KEYBOARD_INTERCEPTOR  ;WHERE THE LOCAL STRING IS
        MOV     CX,40                           ;HOW MANY CHARACTERS TO LOOK FOR
        REPE    CMPSB                           ;COMPARE THE STRINGS
        JE      GOOD_EXIT                       ;ALREADY LOADED


        MOV DX,OFFSET GREETING                  ;GIVE 'EM SOME ADVICE
        MOV AH,09H
        INT 21H

        MOV     DX,OFFSET KEYBOARD_INTERCEPTOR   ;SET THE NEW VALUES
        MOV     AL,DOS_IO
        MOV     AH,SET_VECTOR
        INT     DOS_FUN

        MOV     DX,OFFSET INITIALIZE              ;KILL ALL AFTER INITIALIZE
        INT     DOS_TERM                          ;MAKE THE PROGRAM TSR

GOOD_EXIT:

        MOV DX,OFFSET LOADED                   ;GIVE 'EM SOME STUFF
        MOV AH,09H
        INT 21H

        MOV AH,4CH                                ;KILL ME
        INT 21h

CSEG ENDS                                         ;END OF CODE SECTION

        END START                                 ;TOTAL END



