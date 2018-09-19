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
        ideal
        MODEL small


segment ROM_BIOS_DATA  AT 40H  ;BIOS statuses held here, also keyboard buffer
        org     17h
        status  db ?
        ORG     1AH
        HEAD DW      ?                  ;Unread chars go from [ES:HEAD] to [ES:TAIL]
        TAIL DW      ?
        BUFFER       DW      16 DUP (?)         ;The buffer itself
        LABEL BUFFER_END   WORD
ENDS

CODESEG
segment code public 'code'
        ORG     100H            ;ORG = 100H to make this into a .COM file
        assume cs:code
        assume es:code
        assume ds:rom_bios_data
FIRST:  JMP CS:LOAD_PROG       ;First time through jump to initialize routine

        label OLD_KEY_INT    DWORD
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

PROC   prog                  ;The keyboard interrupt will now come here.
        PUSH    AX              ;Save the used registers for good form
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    DI
        PUSH    SI
        PUSH    DS
        PUSH    ES
        assume cs:code
        CMP [KBACT],1                     ;HAVE WE BEEN ACTIVATED PREVIOUSLY?
        JNE XYZB                         ;NOPE CONTINUE
        JMP near cs:EXIT                        ;YEP GET OUT OF HERE
xyzb:
        mov ax,cs
        mov es,ax
        assume es:code
        STI                             ;ENABLE ALL OTHER INTERRUPTS
        PUSHF                   ;First, call old keyboard interrupt
        CALL    [OLD_KEYBOARD_INT]
                ;-------------------------------------------------
                ;now go into the keyboard buffer and get some data
                ;-------------------------------------------------
        ASSUME  dS:ROM_BIOS_DATA        ;Examine the char just put in
        MOV     BX,ROM_BIOS_DATA
        MOV     dS,BX

        MOV     BX,[TAIL]                 ;Point to current [ES:TAIL]
        CMP     BX,[HEAD]                 ;If at [ES:HEAD], kbd int has deleted char
        JNE     GOPETE
        JMP near cs:EXIT                    ;So leave
GOPETE:
        SUB     BX,2                    ;Point to just read in character
        CMP     BX,OFFSET BUFFER        ;Did we undershoot buffer?
        JAE     NO_WRAP                 ;Nope
        MOV     BX,OFFSET BUFFER_END    ;Yes -- move to buffer top
        SUB     BX,2                    ;Point to just read in character 
NO_WRAP:MOV     AX,[BX]                 ;Char in DX now
        

         CMP AX,0C1FH                   ;IS IT OUR TOGGLE KEY COMBINATION?
         JE  TOGGLE_SET                 ;GO TO THE TOGGLING FUNCTION
         CMP AL,';'                     ;IS IT OUR STRESS KEY COMBINATION?
         JE  STRESS_SET                 ;YES
         CMP AL,':'                     ;IS IT OUR UMLAUT KEY COMBINATION?
         JE  UMLAUT_SET                 ;YES
         JMP near cs:NORMAL                     ;NONE OF THE ABOVE JUST TRANSLATE
TOGGLE_SET:
         CMP [TOGGLE_FLAG],0               ;READJUST OUR TOGGLE STATUS
         JE  ZERO
         MOV [TOGGLE_FLAG],0
         MOV [TAIL],BX                    ;NO ECHO PLEASE
         JMP near cs:EXIT                       ;GET READY FOR NEXT CHARACTER
 ZERO:
         MOV [TOGGLE_FLAG],1
         MOV [TAIL],BX                    ;NO ECHO PLEASE
         JMP near cs:EXIT                       ;GET READY FOR NEXT CHARACTER
STRESS_SET:
         CMP [TOGGLE_FLAG],1
         JE  STRESS_CONT
         JMP near cs:EXIT
STRESS_CONT:
         CMP [STRESS_FLAG],1              ;IS THE FLAG ALREADY SET?
         JnE  ST_CONT
         MOV AL,';'                     ;SEND A STRESS
         MOV [BX],AX
         MOV [STRESS_FLAG],0              ;RESET THE FLAG
         JMP near cs:EXIT
ST_CONT:
         MOV [STRESS_FLAG],1              ;SET THE STRESS FLAG ON
         MOV [TAIL],BX                    ;SET NO ECHO
         JMP near cs:EXIT                       ;GET OUT OF HERE
UMLAUT_SET:
         CMP [TOGGLE_FLAG],1
         JE  UMLAUT_CONT
         JMP near cs:EXIT
UMLAUT_CONT:
         CMP [UMLAUT_FLAG],1              ;IS THE FLAG ALREADY ON?
         JnE UM_CONT
         MOV AL,':'                     ;SEND an UMLAUT
         MOV [BX],AX
         MOV [UMLAUT_FLAG],0              ;RESET THE FLAG
         JMP near cs:EXIT
UM_CONT:
         MOV [UMLAUT_FLAG],1              ;SET THE UMLAUT FLAG ON
         MOV [TAIL],BX                    ;NO ECHO PLEASE
         JMP near cs:EXIT                       ;BYE

NORMAL: CMP [TOGGLE_FLAG],0              ;ARE WE TOGGLED ON?
         JNE NOR                        ;YES
         JMP near cs:EXIT                       ;NO    GET OUT
NOR:     CMP [STRESS_FLAG],1              ;IS THE STRESS FLAG ON?
         JnE mornor
         JMP near cs:STRESS
mornor:
         CMP [UMLAUT_FLAG],1              ;OR IS THE UMLAUT FLAG ON?
         JnE  moUMLAUT
         JMP near cs:umlaut
moumlaut:
CONTY:
        cmp ah,47
        jne notv1
        mov ah,0
notv1:
        CMP AL,65
        JNE NOT65
        MOV AL,128
        JMP near cs:PUTCHAR
NOT65:
        CMP AL,66
        JNE NOT66
        MOV AL,129
        JMP near cs:PUTCHAR
NOT66:
        CMP AL,67
        JNE NOT67
        MOV AL,150
        JMP near cs:PUTCHAR
NOT67:
        CMP AL,68
        JNE NOT68
        MOV AL,131
        JMP near cs:PUTCHAR
NOT68:
        CMP AL,69
        JNE NOT69
        MOV AL,132
        JMP near cs:PUTCHAR
NOT69:
        CMP AL,70
        JNE NOT70
        MOV AL,148
        JMP near cs:PUTCHAR
NOT70:
        CMP AL,71
        JNE NOT71
        MOV AL,130
        JMP near cs:PUTCHAR
NOT71:
        CMP AL,72
        JNE NOT72
        MOV AL,134
        JMP near cs:PUTCHAR
NOT72:
        CMP AL,73
        JNE NOT73
        MOV AL,136
        JMP near cs:PUTCHAR
NOT73:
        CMP AL,74
        JNE NOT74
        MOV AL,141
        JMP near cs:PUTCHAR
NOT74:
        CMP AL,75
        JNE NOT75
        MOV AL,137
        JMP near cs:PUTCHAR
NOT75:
        CMP AL,76
        JNE NOT76
        MOV AL,138
        JMP near cs:PUTCHAR
NOT76:
        CMP AL,77
        JNE NOT77
        MOV AL,139
        JMP near cs:PUTCHAR
NOT77:
        CMP AL,78
        JNE NOT78
        MOV AL,140
        JMP near cs:PUTCHAR
NOT78:
        CMP AL,79
        JNE NOT79
        MOV AL,142
        JMP near cs:PUTCHAR
NOT79:
        CMP AL,80
        JNE NOT80
        MOV AL,143
        JMP near cs:PUTCHAR
NOT80:
        CMP AL,81
        JNE NOT81
        MOV AL,60
        JMP near cs:PUTCHAR
NOT81:
        CMP AL,82
        JNE NOT82
        MOV AL,144
        JMP near cs:PUTCHAR
NOT82:
        CMP AL,83
        JNE NOT83
        MOV AL,145
        JMP near cs:PUTCHAR
NOT83:
        CMP AL,84
        JNE NOT84
        MOV AL,146
        JMP near cs:PUTCHAR
NOT84:
        CMP AL,85
        JNE NOT85
        MOV AL,135
        JMP near cs:PUTCHAR
NOT85:
        CMP AL,86
        JNE NOT86
        MOV AL,151
        JMP near cs:PUTCHAR
NOT86:
        CMP AL,87
        JNE NOT87
        MOV AL,83
        JMP near cs:PUTCHAR
NOT87:
        CMP AL,88
        JNE NOT88
        MOV AL,149
        JMP near cs:PUTCHAR
NOT88:
        CMP AL,89
        JNE NOT89
        MOV AL,147
        JMP near cs:PUTCHAR
NOT89:
        CMP AL,90
        JNE NOT90
        MOV AL,133
        JMP near cs:PUTCHAR
NOT90:
        CMP AL,97
        JNE NOT97
        MOV AL,152
        JMP near cs:PUTCHAR
NOT97:
        CMP AL,98
        JNE NOT98
        MOV AL,153
        JMP near cs:PUTCHAR
NOT98:
        CMP AL,99
        JNE NOT99
        MOV AL,175
        JMP near cs:PUTCHAR
NOT99:
        CMP AL,100
        JNE NOT100
        MOV AL,155
        JMP near cs:PUTCHAR
NOT100:
        CMP AL,101
        JNE NOT101
        MOV AL,156
        JMP near cs:PUTCHAR
NOT101:
        CMP AL,102
        JNE NOT102
        MOV AL,173
        JMP near cs:PUTCHAR
NOT102:
        CMP AL,103
        JNE NOT103
        MOV AL,154
        JMP near cs:PUTCHAR
NOT103:
        CMP AL,104
        JNE NOT104
        MOV AL,158
        JMP near cs:PUTCHAR
NOT104:
        CMP AL,105
        JNE NOT105
        MOV AL,160
        JMP near cs:PUTCHAR
NOT105:
        CMP AL,106
        JNE NOT106
        MOV AL,165
        JMP near cs:PUTCHAR
NOT106:
        CMP AL,107
        JNE NOT107
        MOV AL,161
        JMP near cs:PUTCHAR
NOT107:
        CMP AL,108
        JNE NOT108
        MOV AL,162
        JMP near cs:PUTCHAR
NOT108:
        CMP AL,109
        JNE NOT109
        MOV AL,163
        JMP near cs:PUTCHAR
NOT109:
        CMP AL,110
        JNE NOT110
        MOV AL,164
        JMP near cs:PUTCHAR
NOT110:
        CMP AL,111
        JNE NOT111
        MOV AL,166
        JMP near cs:PUTCHAR
NOT111:
        CMP AL,112
        JNE NOT112
        MOV AL,167
        JMP near cs:PUTCHAR
NOT112:
        CMP AL,113
        JNE NOT113
        MOV AL,62
        JMP near cs:PUTCHAR
NOT113:
        CMP AL,114
        JNE NOT114
        MOV AL,168
        JMP near cs:PUTCHAR
NOT114:
        CMP AL,115
        JNE NOT115
        MOV AL,169
        JMP near cs:PUTCHAR
NOT115:
        CMP AL,116
        JNE NOT116
        MOV AL,171
        JMP near cs:PUTCHAR
NOT116:
        CMP AL,117
        JNE NOT117
        MOV AL,159
        JMP near cs:PUTCHAR
NOT117:
        CMP AL,118
        JNE NOT118
        MOV AL,224
        JMP near cs:PUTCHAR
NOT118:
        CMP AL,119
        JNE NOT119
        MOV AL,170
        JMP near cs:PUTCHAR
NOT119:
        CMP AL,120
        JNE NOT120
        MOV AL,174
        JMP near cs:PUTCHAR
NOT120:
        CMP AL,121
        JNE NOT121
        MOV AL,172
        JMP near cs:PUTCHAR
NOT121:
        CMP AL,122
        JNE NOT122
        MOV AL,157
        JMP near cs:PUTCHAR
NOT122:
        JMP near cs:exit

UMLAUT:  MOV [UMLAUT_FLAG],0              ;RESET THE UMLAUT FLAG
         CMP [STRESS_FLAG],1              ;DOUBLE CHECK AGAIN PLEASE
         JnE  neither
         JMP near cs:BOTH
neither:
         CMP AL,'i'
         JE  UIOTA
         CMP AL,'y'
         JE  UYPSILON
         MOV AL,':'                      ;NONE OF THE ABOVE print ":"
         JMP near cs:putchar
UIOTA:   MOV AL,228
         JMP near cs:putchar
UYPSILON:MOV AL,232
        JMP near cs:putchar

STRESS:  MOV [STRESS_FLAG],0              ;RESET THE STRESS FLAG
         CMP [UMLAUT_FLAG],1              ;IS THE UMLAUT FLAG ON ALSO?
         JnE  neither2
         JMP near cs:BOTH                       ;DO THE DOUBLE
neither2:
;    STRESSED  GREEK
        cmp ah,47
        jne notv
        mov ah,0
notv:
        CMP AL,65
        JNE NOTS65
        MOV AL,234
        JMP near cs:PUTCHAR
NOTS65:
        CMP AL,66
        JNE NOTS66
        MOV AL,129
        JMP near cs:PUTCHAR
NOTS66:
        CMP AL,67
        JNE NOTS67
        MOV AL,150
        JMP near cs:PUTCHAR
NOTS67:
        CMP AL,68
        JNE NOTS68
        MOV AL,131
        JMP near cs:PUTCHAR
NOTS68:
        CMP AL,69
        JNE NOTS69
        MOV AL,235
        JMP near cs:PUTCHAR
NOTS69:
        CMP AL,70
        JNE NOTS70
        MOV AL,148
        JMP near cs:PUTCHAR
NOTS70:
        CMP AL,71
        JNE NOTS71
        MOV AL,130
        JMP near cs:PUTCHAR
NOTS71:
        CMP AL,72
        JNE NOTS72
        MOV AL,236
        JMP near cs:PUTCHAR
NOTS72:
        CMP AL,73
        JNE NOTS73
        MOV AL,237
        JMP near cs:PUTCHAR
NOTS73:
        CMP AL,74
        JNE NOTS74
        MOV AL,141
        JMP near cs:PUTCHAR
NOTS74:
        CMP AL,75
        JNE NOTS75
        MOV AL,137
        JMP near cs:PUTCHAR
NOTS75:
        CMP AL,76
        JNE NOTS76
        MOV AL,138
        JMP near cs:PUTCHAR
NOTS76:
        CMP AL,77
        JNE NOTS77
        MOV AL,139
        JMP near cs:PUTCHAR
NOTS77:
        CMP AL,78
        JNE NOTS78
        MOV AL,140
        JMP near cs:PUTCHAR
NOTS78:
        CMP AL,79
        JNE NOTS79
        MOV AL,238
        JMP near cs:PUTCHAR
NOTS79:
        CMP AL,80
        JNE NOTS80
        MOV AL,143
        JMP near cs:PUTCHAR
NOTS80:
        CMP AL,81
        JNE NOTS81
        MOV AL,60
        JMP near cs:PUTCHAR
NOTS81:
        CMP AL,82
        JNE NOTS82
        MOV AL,144
        JMP near cs:PUTCHAR
NOTS82:
        CMP AL,83
        JNE NOTS83
        MOV AL,145
        JMP near cs:PUTCHAR
NOTS83:
        CMP AL,84
        JNE NOTS84
        MOV AL,146
        JMP near cs:PUTCHAR
NOTS84:
        CMP AL,85
        JNE NOTS85
        MOV AL,135
        JMP near cs:PUTCHAR
NOTS85:
        CMP AL,86
        JNE NOTS86
        MOV AL,240
        JMP near cs:PUTCHAR
NOTS86:
        CMP AL,87
        JNE NOTS87
        MOV AL,83
        JMP near cs:PUTCHAR
NOTS87:
        CMP AL,88
        JNE NOTS88
        MOV AL,149
        JMP near cs:PUTCHAR
NOTS88:
        CMP AL,89
        JNE NOTS89
        MOV AL,239
        JMP near cs:PUTCHAR
NOTS89:
        CMP AL,90
        JNE NOTS90
        MOV AL,133
        JMP near cs:PUTCHAR
NOTS90:
        CMP AL,97
        JNE NOTS97
        MOV AL,225
        JMP near cs:PUTCHAR
NOTS97:
        CMP AL,98
        JNE NOTS98
        MOV AL,153
        JMP near cs:PUTCHAR
NOTS98:
        CMP AL,99
        JNE NOTS99
        MOV AL,175
        JMP near cs:PUTCHAR
NOTS99:
        CMP AL,100
        JNE NOTS100
        MOV AL,155
        JMP near cs:PUTCHAR
NOTS100:
        CMP AL,101
        JNE NOTS101
        MOV AL,226
        JMP near cs:PUTCHAR
NOTS101:
        CMP AL,102
        JNE NOTS102
        MOV AL,173
        JMP near cs:PUTCHAR
NOTS102:
        CMP AL,103
        JNE NOTS103
        MOV AL,154
        JMP near cs:PUTCHAR
NOTS103:
        CMP AL,104
        JNE NOTS104
        MOV AL,227
        JMP near cs:PUTCHAR
NOTS104:
        CMP AL,105
        JNE NOTS105
        MOV AL,229
        JMP near cs:PUTCHAR
NOTS105:
        CMP AL,106
        JNE NOTS106
        MOV AL,165
        JMP near cs:PUTCHAR
NOTS106:
        CMP AL,107
        JNE NOTS107
        MOV AL,161
        JMP near cs:PUTCHAR
NOTS107:
        CMP AL,108
        JNE NOTS108
        MOV AL,162
        JMP near cs:PUTCHAR
NOTS108:
        CMP AL,109
        JNE NOTS109
        MOV AL,163
        JMP near cs:PUTCHAR
NOTS109:
        CMP AL,110
        JNE NOTS110
        MOV AL,164
        JMP near cs:PUTCHAR
NOTS110:
        CMP AL,111
        JNE NOTS111
        MOV AL,230
        JMP near cs:PUTCHAR
NOTS111:
        CMP AL,112
        JNE NOTS112
        MOV AL,167
        JMP near cs:PUTCHAR
NOTS112:
        CMP AL,113
        JNE NOTS113
        MOV AL,62
        JMP near cs:PUTCHAR
NOTS113:
        CMP AL,114
        JNE NOTS114
        MOV AL,168
        JMP near cs:PUTCHAR
NOTS114:
        CMP AL,115
        JNE NOTS115
        MOV AL,169
        JMP near cs:PUTCHAR
NOTS115:
        CMP AL,116
        JNE NOTS116
        MOV AL,171
        JMP near cs:PUTCHAR
NOTS116:
        CMP AL,117
        JNE NOTS117
        MOV AL,159
        JMP near cs:PUTCHAR
NOTS117:
        CMP AL,118
        JNE NOTS118
        MOV AL,233
        JMP near cs:PUTCHAR
NOTS118:
        CMP AL,119
        JNE NOTS119
        MOV AL,170
        JMP near cs:PUTCHAR
NOTS119:
        CMP AL,120
        JNE NOTS120
        MOV AL,174
        JMP near cs:PUTCHAR
NOTS120:
        CMP AL,121
        JNE NOTS121
        MOV AL,231
        JMP near cs:PUTCHAR
NOTS121:
        CMP AL,122
        JNE NOTS122
        MOV AL,157
        JMP near cs:PUTCHAR
NOTS122:
        JMP near cs:exit

BOTH:    MOV [UMLAUT_FLAG],0              ;RESET THE UMLAUT FLAG
         MOV [STRESS_FLAG],0              ;RESET THE STRESS FLAG
         CMP AL,'i'
         JE  BIOTA
         CMP AL,'y'
         JE  BYPSILON
         MOV [tAIL],BX                    ;NONE OF THE ABOVE
         JMP near cs:EXIT                       ;GET OUT
BIOTA:   MOV AL,228
         JMP near cs:putchar
BYPSILON:
         MOV AL,232
         JMP near cs:PUTCHAR

        JMP near cs:exit


putchar:
        mov [bx],ax
        
EXIT:
   ;mov al,020h
        ;out 020h,al
        mov [kbact],0
        POP     ES      ;Having done Pushes, here are the Pops
        POP     DS
        POP     SI
        POP     DI
        POP     DX
        POP     CX
        POP     BX
        POP     AX     
        IRET                    ;An interrupt needs an IRET
ENDP

LOAD_PROG:                   ;This procedure intializes everything

        JMP near MORE
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
        LES     DI,[ES:DI]
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

        mov     si,offset old_key_int
        MOV     [si],BX        ;Store old interrupt vector
        MOV     [si + 2],ES

        MOV     AH,25H          ;Set new interrupt vector
        mov     DX,offset PROG
        INT     21H
        
        MOV     DX,OFFSET LOAD_PROG     ;Set up everything but LOAD_PROG to
        INT     27H                     ;stay and attach itself to DOS

GOOD_EXIT:

        MOV DX,OFFSET LOADED                   ;GIVE 'EM SOME STUFF
        MOV AH,09H
        INT 21H

        MOV AH,4CH                                ;KILL ME
        INT 21h


ends
        END     FIRST   ;END "FIRST" so 80x86 will go to FIRST first.
