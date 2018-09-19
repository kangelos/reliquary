TITLE VGA font steeler

                ; ------------------------
                ; | ANGELOS KARAGEORGIOU |
                ;        FEB 1992
                ; ------------------------

CSEG    SEGMENT WORD 'CSEG'
        ASSUME CS:CSEG,DS:CSEG
        ORG     100H
START:  JMP     INITIALIZE              ;MAKE THE PROGRAM TSR

bigfont         db      1000H   dup (?)
bigfile         dw      0
bigname         db      'set8x16.fnt',0
errors          db      'File cannot be created',10,13,'Either disk full or something',10,13,'$'
errors2         db      'File cannot be written',10,13,'chances are that the disk is full',10,13,'$'
Myname          db      'By Angelos Karageorgiou   (C) 1992 X.M.A.K. SYSTEMS INTERNATIONAL',10,13,'Sole Distributor for the U.S.,   M.I.S. of Norwalk Connecticut','$'
mYtitle         db      'VGA 8X16 font stealer',10,13,'$'

INITIALIZE:

        MOV     BX,CS
        MOV     DS,BX

        MOV DX,OFFSET MYTITLE                   ;GIVE 'EM SOME TITLE
        MOV AH,09H
        INT 21H

        MOV DX,OFFSET MYNAME                    ;GIVE 'EM SOME NAME
        MOV AH,09H
        INT 21H

                ;CREATE THE FILE
        MOV DX,OFFSET BIGNAME                   ;FILENAME
        MOV AH,03CH                             ;CREATE FILE
        XOR CX,CX                               ;CLEAR CARRY FLAG NORM ATTRIBS
        INT 21H                                 ;CREATE THE FILE
        JC ERROR                                ;ANY PROBLEMS ?
        MOV [BIGFILE],AX                        ;HANDLE

                ;STEAL THE FONT
        MOV AH,11H                              ; VGA INT
        MOV AL,30H                              ; GET INFO
        MOV BH,06H                              ; GET 8X16 FONT INFO
        INT 10H                                 ; DO IT

                ;COPY IT OVER FOR FURTHER USE

        MOV CX,1000H                            ;HOW MANY CHARACTERS
        MOV DI,OFFSET BIGFONT
HERE:
        MOV AL,[ES:BP]                               ;SET UP DS
        MOV [DS:DI],AL
        inc BP
        INC DI
        LOOP HERE                               ;REPEAT 1000H TIMES

        MOV CX,1000H
        MOV BX,[BIGFILE]                        ;HANDLE
        MOV AH,40H                              ;WRITE FILE
        MOV DX,OFFSET BIGFONT                   ;WHAT TO WRITE
        INT 21H                                 ;WRITE THE DATA
        JC ERROR2                               ;PROBLEMS ?

        JMP EXIT                                ;ALL SET

ERROR:  MOV DX,OFFSET ERRORS                    ;GIVE 'EM SOME ERRORS
        MOV AH,09H
        INT 21H
        JMP EXIT

ERROR2:  MOV DX,OFFSET ERRORS2                    ;GIVE 'EM SOME ERRORS
        MOV AH,09H
        INT 21H
        JMP EXIT

EXIT:   MOV AH,4CH                                ;KILL ME
        INT 21h

CSEG ENDS                                         ;END OF CODE SECTION

        END START                                 ;TOTAL END



