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

        .MODEL SMALL
ROM_BIOS_DATA   SEGMENT AT 40H  ;BIOS statuses held here, also keyboard buffer

        ORG     1AH
        HEAD DW      ?                  ;Unread chars go from Head to Tail
        TAIL DW      ?
        BUFFER       DW      16 DUP (?)         ;The buffer itself
        BUFFER_END   LABEL   WORD
ROM_BIOS_DATA   ENDS

        .CODE
        ORG     100H            ;ORG = 100H to make this into a .COM file
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



PROG    PROC                    ;The keyboard interrupt will now come here.
        PUSH    AX              ;Save the used registers for good form
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    DI
        PUSH    SI
        PUSH    DS
        PUSH    ES
        cli
        in al,060h
        PUSHF                   ;First, call old keyboard interrupt
        CALL    OLD_KEYBOARD_INT
        sti
        mov ah,0ah
        int 10h

EXIT:   POP     ES      ;Having done Pushes, here are the Pops
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

        END     FIRST   ;END "FIRST" so 80x86 will go to FIRST first.
