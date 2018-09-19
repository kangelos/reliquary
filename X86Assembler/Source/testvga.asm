TITLE VGA font loader

                ; ------------------------
                ; | ANGELOS KARAGEORGIOU |
                ;        FEB 1992
                ; ------------------------

SMALLSIZE EQU 0800H     ; 8 X 256 = 2048 DEC
MEDSIZE   EQU 0E00H     ;14 X 256 = 3548 DEC
BIGSIZE   EQU 1000H     ;16 X 256 = 4096 DEC


CSEG    SEGMENT WORD 'CSEG'
        ASSUME CS:CSEG,DS:CSEG
        ORG     100H
START:  JMP     INITIALIZE


info			db		46 dup(?)
smallfont       db      SMALLSIZE   dup (?)
MEDFONT         DB      MEDSIZE     DUP (?)
bigfont         db      BIGSIZE     dup (?)
smallfile       dw      0
bigfile         dw      0
MEDFILE         DW      0
smallname       db      'gr8x8.fnt',0
bigname         db      'gr8x16.fnt',0
MEDNAME         DB      'GR8X14.FNT',0
errors          db      'File not found',10,13,'Either [GR8X8.fnt] or [GR8X14.FNT] OR [GR8X16.FNT] missing',10,13,'$'
errors1         db      'ERROR while reading the 8 x 8 font',10,13,'$'
errors3         db      'ERROR while reading the 8 x 16 font',10,13,'$'
errors4         db      'ERROR while reading the 8 x 14 font',10,13,'$'
Myname          db      'By Angelos Karageorgiou   (C) 1992 X.M.A.K. SYSTEMS SYSTEMS INTERNATIONAL',10,13,'Sole Distributor for the U.S.,   M.I.S. of Norwalk Connecticut',10,13,'$'
MYtitle         db      'VGA  Greek font loader/starter',10,13,'$'

INITIALIZE:

        MOV     BX,CS
        MOV     DS,BX

        MOV DX,OFFSET MYTITLE                   ;GIVE 'EM SOME TITLE
        MOV AH,09H
        INT 21H

        MOV DX,OFFSET MYNAME                    ;GIVE 'EM SOME NAME
        MOV AH,09H
        INT 21H



CONTINUE:
        ; O.K. EVERYTHING IS HERE

        MOV AX,CS                               ;ES SETUP
        MOV ES,AX
		mov di,offset info
		mov ah,01B
		int 10
		int 20
                                ;ENABLE 8 X 8 FONT
        MOV BP,OFFSET SMALLFONT                   ;BP SETUP
        MOV AH,11H                              ;FUNCTION
        MOV AL,10H                              ;LOAD FONT
        MOV CX,0FFH                             ;256 CHARACTERS
        MOV DX,0                                ;STARTING OFFSET
        MOV BH,8                                ;I SAID 8x '8'
        MOV BL,2                                ;GENERATOR #3
        INT 10H                                 ;DO IT


                        ;ENABLE 8 X 14 FONT
        MOV BP,OFFSET MEDFONT                   ;BP SETUP
        MOV AH,11H                              ;FUNCTION
        MOV AL,10H                              ;LOAD FONT
        MOV CX,0FFH                             ;256 CHARACTERS
        MOV DX,0                                ;STARTING OFFSET
        MOV BH,14                               ;I SAID 8x '14'
        MOV BL,1                                ;GENERATOR #2
        INT 10H                                 ;DO IT


                ;ENABLE 8 X 16 FONT
        MOV BP,OFFSET BIGFONT                   ;BP SETUP
        MOV AH,11H                              ;FUNCTION
        MOV AL,10H                              ;LOAD FONT
        MOV CX,0FFH                             ;256 CHARACTERS
        MOV DX,0                                ;STARTING OFFSET
        MOV BH,16                               ;I SAID 8x '16'
        MOV BL,0                                ;DEFAULT GENERATOR
        INT 10H                                 ;DO IT
                ; MAKE THE 8X16 FONT TO DISPLAY
        MOV AH,11H                              ;VGA INT
        MOV AL,03H                              ;SELECT GENERATOR
        MOV BL,0                                ;WHICH ONE
        INT 10H                                 ;DO IT


EXIT:   MOV AH,4CH                                ;KILL ME
        INT 21h

CSEG ENDS                                         ;END OF CODE SECTION

        END START                                 ;TOTAL END



