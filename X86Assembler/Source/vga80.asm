TITLE 80.com	80 columns reset on vga screens by Angelos Karageorgiou
		; ------------------------
                ; | ANGELOS KARAGEORGIOU |
                ;        FEB 1992
                ; ------------------------

;-------------------------------------------------------------------
;KEEP IN MIND THAT THIS PROGRAM HAS TO BE ASSEMBLED AS A COM FILE SO
;IT CAN PERFORM ACCORDING TO ITS SPECIFICATIONS WITH EXE2BIN
;-------------------------------------------------------------------


CSEG    SEGMENT
	ASSUME	CS:CSEG,DS:CSEG,ES:CSEG,SS:CSEG
	ORG	0100h

START:
	 jmp doit
DOIT:	MOV	BX,040h 	; '@'
	MOV	ES,BX
	MOV	BL,BYTE PTR CSIZE
	MOV	BH,BYTE PTR ES:[0085h]
	PUSH	DX
	MOV	DX,WORD PTR ES:[0063h]
	PUSH	BX
	MOV	AX,01110h
	XOR	CX,CX
	INT	010h
	POP	BX
	MOV	AL,011h
	OUT	DX,AL
	INC	DX
	IN	AL,DX
	DEC	DX
	MOV	AH,AL
	MOV	AL,011h
	PUSH	AX
	AND	AH,07fh
	OUT	DX,AX
	MOV	SI,OFFSET CODE
	MOV	CX,7

AGAIN:  LODSW
        OUT     DX,AX
        LOOP    SHORT AGAIN
        POP     AX
        OUT     DX,AX
        POP     DX

	MOV	DX,03c4h
	mov	ax,0100h
	CLI
	OUT	DX,AX
	MOV	BX,1
	MOV	BX,0800h

	MOV	AH,BL
	MOV	AL,1
	OUT	DX,AX
	MOV	AX,0300h
	OUT	DX,AX
	STI
	MOV	BL,013h
	MOV	AX,01000h
	INT	010h
	MOV	AX,01000h
	MOV	BX,0f12h
;	 MOV	 BH,7
	INT	010h
	MOV	AX,02d0h
	DIV	BYTE PTR CSIZE
	MOV	BYTE PTR ES:[004Ah],AL

	MOV	AX,04c00h
	INT	021h


CSIZE	DB	  9
CODE	DB	     0,'_',  1,'O',  2,'P',  3,130,  4,'U',  5,129, 19,'('

CSEG    ENDS
	END	START
