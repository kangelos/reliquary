code segment public 'code'
        ORG     100H            ;ORG = 100H to make this into a .COM file
        assume cs:code
FIRST:
        int 19h
code ends
        END     FIRST   ;END "FIRST" so 80x86 will go to FIRST first.
