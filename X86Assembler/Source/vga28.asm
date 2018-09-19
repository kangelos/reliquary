TITLE VGA 28

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

START:
        MOV AH,11H                      ;VGA INT
	MOV AL,11H			;SELECT GENERATOR
        mov bl,0
        INT 10H                         ;DO IT

	int 20h
CSEG ENDS                                         ;END OF CODE SECTION

        END START                                 ;TOTAL END



