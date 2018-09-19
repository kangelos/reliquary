TITLE VGA 28

                ; ------------------------
                ; | ANGELOS KARAGEORGIOU |
                ;        FEB 1992
                ; ------------------------

CSEG    SEGMENT WORD 'CSEG'
        ASSUME CS:CSEG,DS:CSEG
        ORG     100H

START:  JMP     INITIALIZE              ;MAKE THE PROGRAM TSR


INITIALIZE:

        MOV     BX,CS
        MOV     DS,BX

        MOV AH,11H                      ;VGA INT
	MOV AL,11H			;SELECT GENERATOR
        mov bl,0
        INT 10H                         ;DO IT

        MOV AH,4CH                                ;KILL ME
        INT 21h

CSEG ENDS                                         ;END OF CODE SECTION

        END START                                 ;TOTAL END



