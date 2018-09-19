title cga hires

		; ------------------------
                ; | ANGELOS KARAGEORGIOU |
                ;        FEB 1992
                ; ------------------------

;-------------------------------------------------------------------
;KEEP IN MIND THAT THIS PROGRAM HAS TO BE ASSEMBLED AS A COM FILE SO
;IT CAN PERFORM ACCORDING TO ITS SPECIFICATIONS WITH EXE2BIN
;-------------------------------------------------------------------


rom_da segment at 40h
        org 10h
eq_flag dw ?
rom_da ends


prog segment
assume cs:prog,ds:rom_da
        org 100h
start:  mov ax, offset rom_da
        mov ds,ax
        mov ax,eq_flag
        and ax,11001111b
        or  ax,00110000b
        mov eq_flag,ax
        mov al,6
        mov ah,0
        int 10h
        mov ah,4ch
        int 21h
prog ends
end start
