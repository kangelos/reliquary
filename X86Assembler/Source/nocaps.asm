TITLE CAPS LOCK blocker

                ; ------------------------
                ; | ANGELOS KARAGEORGIOU |
                ;        MAR 1992
                ; ------------------------

;-------------------------------------------------------------------
;KEEP IN MIND THAT THIS PROGRAM HAS TO BE ASSEMBLED AS A COM FILE SO
;IT CAN PERFORM ACCORDING TO ITS SPECIFICATIONS WITH EXE2BIN
;-------------------------------------------------------------------


;------------------------
;MASM PSEUDO EQUIVALENCES
;------------------------


DOS_IO          EQU     15H
DOS_FUN         EQU     21H
DOS_TERM        EQU     27H
GET_VECTOR      EQU     35H
SET_VECTOR      EQU     25H

IDEAL
model small
segment CSEG    WORD 'CSEG'
        ASSUME CS:CSEG,DS:CSEG,ES:CSEG
        ORG     100H
START:  JMP     INITIALIZE              ;MAKE THE PROGRAM TSR

OLD_VGA_IO       DD      ?               ;KEEP THE OLD INTERRUPT
VGAACT           DB        0             ;THEY SPEEK FOR THEMSELVES
prscrn           db     0
pause           db 0
endprnscrn      db 0
endpause        db 0

;------------------------------------------------------------------------------
;THIS IS THE MAIN ROUTINE. IT REMAPS INT 10H SO THAT ANY REQUEST TO THE VGA
;PASSES THROUGH IT.
;------------------------------------------------------------------------------

proc VGA_INTERCEPTOR    far
        PUSH    BP
        PUSH    ES
        PUSH    DS                      ;SAVE OLD VALUES
        PUSH    SI
        push    ax
        push    bx
        push    cx
        push    dx

        sti
        push cs
        pop ds
        assume ds:cseg


        cmp [cs:vgaact],1
        jne contv
        jmp exit

contv:
        mov [cs:vgaact],1
        cmp ah,4fh
        je contx1

         cli
         MOV [CS:VGAACT],0                 ;NOT ACTIVE ANYMORE
         assume es:nothing
         assume ds:nothing
         pop     dx
         pop     cx
         pop     bx
         pop     ax
         POP     SI                      ;RESTORE PREVIOUS VALUES
         POP     DS
         POP     ES
         POP     BP
        jmp [old_vga_io]
contx1:

        cmp al,0e0h
        je couldstart
        cmp al,0e1h
        je couldend
        cmp al,46h
        je bad
        cmp al,03ah
        je bad
        cmp al,54h
        je bad
        cmp al,0d4h
        je bad
        cmp al,06ah
        je bad
        cmp al,0c6h
        je bad
        jmp good
couldstart:
bad:    clc
        jmp exit
good:   stc



EXIT:    CLI                             ;disable interrupts while cleaning up
         MOV [CS:VGAACT],0                 ;NOT ACTIVE ANYMORE
         pop     dx
         pop     cx
         pop     bx
         pop     ax
         POP     SI                      ;RESTORE PREVIOUS VALUES
         POP     DS
         POP     ES
         POP     BP
         retf 2
ENDP            ;THAT'S ALL FOLKS


INITIALIZE:jmp xmore
        ;DATA UNWANTED DURING TSR
crlf            db      10,13,'$'
MYTITLE         DB      'CAPS LOCK blocker',10,13,'$'
LOADED          DB      'ALREADY LOADED',10,13,'$'
Myname          db      'By Angelos Karageorgiou   (C) 1992 X.M.A.K. SYSTEMS INTERNATIONAL',10,13,'Sole Distributor for the U.S.,   M.I.S. of Norwalk Connecticut',10,13,'$'
isname            db      'Bohfmpt!Lbsbhfpshjpv',10,13,'$'
horror1          db      10,13,10,13,'           THIEF',10,13,10,13,10,13,10,13,'$'
horror2         db       '           HACK',10,13,10,13,10,13,10,13,'$'
horror3          db      '           MY PROGRAM',10,13,10,13,10,13,10,13,'$'
horror4         db       '           You are doomed',10,13,10,13,10,13,10,13,'$'

xmore:    MOV     BX,CS
         MOV     DS,BX
         ASSUME DS:CSEG
        MOV DX,OFFSET CRLF                   ;GIVE 'EM SOME TITLE
        MOV AH,09H
        INT 21H

        MOV DX,OFFSET MYTITLE                   ;GIVE 'EM SOME TITLE
        MOV AH,09H
        INT 21H


        MOV DX,OFFSET MYNAME                    ;GIVE 'EM SOME NAME
        MOV AH,09H
        INT 21H

        CLD                                     ;SEE IF WE ARE ALREADY LOADED
        MOV     CX,0
        MOV     ES,CX
        MOV     DI,054H                         ;WHERE INT10 IS
        LES     DI,[ES:DI]                      ;10 hex * 4
        MOV     SI,OFFSET VGA_INTERCEPTOR       ;WHERE THE LOCAL STRING IS
        MOV     CX,40                           ;HOW MANY CHARACTERS TO LOOK FOR
        REPE    CMPSB                           ;COMPARE THE STRINGS
        jne goon
        Jmp      GOOD_EXIT                       ;ALREADY LOADED
goon:
;     see if anyone has fooled with our names
        mov cx,cs
        mov es,cx
        assume es:cseg
        mov ds,cx
        assume ds:cseg
        mov cx,20
        mov bx,offset isname
here:   dec [byte bx]                           ;convert encrypted name to real
        inc bx
        loop here
                        ;    name is now decrypted
        mov cx,20
        cld
        mov si,offset myname
        add si,3
        mov di,offset isname
        repe cmpsb
        je keepgoing
        jmp gohorror
keepgoing:

        MOV     AL,15H                          ;GET THE OLD INTERRUPT VALUES
        MOV     AH,GET_VECTOR
        INT     DOS_FUN

        mov si,offset old_vga_io
        MOV     [si + 0],bx        ;KEEP THEM
        MOV     [si + 2],es

        mov     ax,cs
        mov      ds,ax

        MOV     DX,OFFSET VGA_INTERCEPTOR   ;SET THE NEW VALUES
        MOV     AL,DOS_IO
        MOV     AH,SET_VECTOR
        INT     DOS_FUN

         mov     ax,cs
        mov ds,ax

        MOV     DX,OFFSET INITIALIZE
        INT     DOS_TERM                          ;MAKE THE PROGRAM TSR

GOOD_EXIT:

        MOV DX,OFFSET LOADED                   ;GIVE 'EM SOME STUFF
        MOV AH,09H
        INT 21H

PROGOUT:
        MOV AH,4CH                                ;KILL ME
        INT 21h
gohorror:

        MOV DX,OFFSET Horror1                   ;GIVE 'EM SOME STUFF
        MOV AH,09H
        INT 21H
        MOV DX,OFFSET Horror2                   ;GIVE 'EM SOME STUFF
        MOV AH,09H
        INT 21H
        MOV DX,OFFSET Horror3                   ;GIVE 'EM SOME STUFF
        MOV AH,09H
        INT 21H

        MOV DX,OFFSET Horror4                   ;GIVE 'EM SOME STUFF
        MOV AH,09H
        INT 21H

        int 19h

ENDS                                         ;END OF CODE SECTION

        END START                                 ;TOTAL END



