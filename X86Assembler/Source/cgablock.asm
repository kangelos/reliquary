TITLE CGA JUST IN CASE loader

                ; ------------------------
                ; | ANGELOS KARAGEORGIOU |
                ;        FEB 1992
                ; ------------------------
                ;int 1FH loader
;-------------------------------------------------------------------
;KEEP IN MIND THAT THIS PROGRAM HAS TO BE ASSEMBLED AS A COM FILE SO
;IT CAN PERFORM ACCORDING TO ITS SPECIFICATIONS WITH EXE2BIN
;-------------------------------------------------------------------


;------------------------
;MASM PSEUDO EQUIVALENCES
;------------------------


DOS_IO          EQU     1fH
DOS_FUN         EQU     21H
DOS_TERM        EQU     27H
GET_VECTOR      EQU     35H
SET_VECTOR      EQU     25H


CSEG    SEGMENT WORD 'CSEG'
        ASSUME CS:CSEG,DS:CSEG
        ORG     100H
START:  JMP     INITIALIZE              ;MAKE THE PROGRAM TSR

smallfont       db      400h   dup (?) ;only this part should tsr

INITIALIZE: JMP MORE

SMALLfile         dw      0
smallname       db      'gr8x8.fnt',0
errors          db      'File not found: GR8X8.FNT is missing',10,13,'$'
errors1         db      'ERROR while reading the 8 x 8 font',10,13,'$'
Myname          db      'By Angelos Karageorgiou   (C) 1992 X.M.A.K. SYSTEMS SYSTEMS INTERNATIONAL',10,13,'Sole Distributor for the U.S.,   M.I.S. of Norwalk Connecticut',10,13,'$'
mYtitle 	db	'CGA Greek Graphics Character Set font loader.Replaces GRAPHICS.COM',10,13,'$'
loaded          db      'ALREADY LOADED',10,13,'$'

more:
        MOV     BX,CS
        MOV     DS,BX

        MOV DX,OFFSET MYTITLE                   ;GIVE 'EM SOME TITLE
        MOV AH,09H
        INT 21H

        MOV DX,OFFSET MYNAME                    ;GIVE 'EM SOME NAME
        MOV AH,09H
        INT 21H

        ;READ THE CONTENTS OF THE 8X8 FILE

        MOV DX,OFFSET SMALLNAME                 ;THE 8X8 FILENAME
        MOV AH,03DH                             ;OPEN FILE
        MOV AL,0                                ;READ ONLY
        INT 21H                                 ;DOIT
        JC ERROR                                ;IS THERE AN ERROR ?
        MOV [SMALLFILE],AX                      ;SAVE THE HANDLE

                ;read the first 128 characters
        MOV AH,3FH                              ;DOS READ FILE
        MOV BX,[SMALLFILE]                      ;HANDLE SET UP
        MOV CX,400H                            ;READ 128 CHARS
        MOV DX,OFFSET SMALLFONT                 ;WHERE TO SAVE THEM
        INT 21H
        JC ERROR1

                ;read the last 128 characters
        MOV AH,3FH                              ;DOS READ FILE
        MOV BX,[SMALLFILE]                      ;HANDLE SET UP
        MOV CX,400H                            ;READ 128 CHARS
        MOV DX,OFFSET SMALLFONT                 ;WHERE TO SAVE THEM
        INT 21H
        JC ERROR1

        MOV BX,[SMALLFILE]                      ;SMALL FILE 8X8 FONT
        MOV AH,03EH                             ;DOS CLOSE FILE
        INT 21H                                 ;DO IT

        MOV     BX,CS                           ;set up ds
        MOV     DS,BX

                ;set up tsr
        CLD                                     ;SEE IF WE ARE ALREADY LOADED
        MOV     CX,0
        MOV     ES,CX
        MOV     DI,07CH                         ;WHERE INT1F IS
        LES     DI,ES:[DI]                      ;1F hex * 4
        MOV     SI,OFFSET SMALLFONT       ;WHERE THE LOCAL STRING IS
        MOV     CX,400h                         ;HOW MANY CHARACTERS TO LOOK FOR
        REPE    CMPSB                           ;COMPARE THE STRINGS
        JE      GOOD_EXIT                       ;ALREADY LOADED


        MOV     DX,OFFSET smallfont   ;SET THE NEW VALUES
        MOV     AL,DOS_IO
        MOV     AH,SET_VECTOR
        INT     DOS_FUN

        MOV     DX,OFFSET INITIALIZE
        INT     DOS_TERM                          ;MAKE THE PROGRAM TSR

GOOD_EXIT:

        MOV DX,OFFSET LOADED                   ;GIVE 'EM SOME STUFF
        MOV AH,09H
        INT 21H
        JMP EXIT

ERROR: MOV DX,OFFSET ERRORS                    ;ERROR
        MOV AH,09H
        INT 21H
        JMP EXIT
ERROR1: MOV DX,OFFSET ERRORS1                    ;ERROR
        MOV AH,09H
        INT 21H
EXIT:   MOV AH,4CH                                ;KILL ME
        INT 21h

CSEG ENDS                                         ;END OF CODE SECTION

        END START                                 ;TOTAL END



