TITLE VGA RESETTER blocker

                ; ------------------------
                ; | ANGELOS KARAGEORGIOU |
                ;        FEB 1992
                ; ------------------------

;-------------------------------------------------------------------
;KEEP IN MIND THAT THIS PROGRAM HAS TO BE ASSEMBLED AS A COM FILE SO
;IT CAN PERFORM ACCORDING TO ITS SPECIFICATIONS WITH EXE2BIN
;-------------------------------------------------------------------



CSEG    SEGMENT WORD 'CSEG'
        ASSUME CS:CSEG,DS:CSEG
        ORG     100H

START:  JMP     INITIALIZE              ;MAKE THE PROGRAM TSR

MYTITLE         DB      'VGA Greek/English 50 Line Mode. Beware not all programs can handle it ',10,13,'$'
Myname          db      'By Angelos Karageorgiou   (C) 1992 X.M.A.K. SYSTEMS SYSTEMS INTERNATIONAL',10,13,'Sole Distributor for the U.S.,   M.I.S. of Norwalk Connecticut',10,13,'$'

INITIALIZE:

        MOV     BX,CS
        MOV     DS,BX



        MOV AH,05H                      ;VGA INT
        mov ch,47
        mov cl,118
        int 16h

        MOV AH,05H                      ;VGA INT
        mov ch,38
        mov cl,108
        int 16h

        MOV AH,05H                      ;VGA INT
        mov ch,36
        mov cl,106
        int 16h

        MOV AH,05H                      ;VGA INT
        mov ch,28
        mov cl,13
        int 16h

        MOV AH,05H                      ;VGA INT
        mov ch,30
        mov cl,97
        int 16h

        MOV AH,05H                      ;VGA INT
        mov ch,32
        mov cl,0
        int 16h

        MOV AH,05H                      ;VGA INT
        mov ch,28
        mov cl,13
        int 16h

        MOV AH,05H                      ;VGA INT
        mov ch,28
        mov cl,13
        int 16h

        MOV AH,05H                      ;VGA INT
        mov ch,28
        mov cl,13
        int 16h

        MOV AH,05H                      ;VGA INT
        mov ch,1
        mov cl,27
        int 16h
        MOV AH,05H                      ;VGA INT
        mov ch,1
        mov cl,27
        int 16h
        MOV AH,05H                      ;VGA INT
        mov ch,1
        mov cl,27
        int 16h
        MOV AH,05H                      ;VGA INT
        mov ch,46
        mov cl,3
        int 16h


        MOV AH,4CH                                ;KILL ME
        INT 21h

CSEG ENDS                                         ;END OF CODE SECTION

        END START                                 ;TOTAL END



