

moptopt=0
LK=0
do while  (moptopt<5 and LK#27)
    deactivate window what
    release window what
    *set color to
    set color to w+/g,w+/bg
    define window what from 2,20 to 14,40 title "[ Commisions Menu ]" float shadow
*    color gr+/b,gr+/b, gr+/b , gr+/b, gr+/b, gr+/b, gr+/b, gr+/b, gr+/b, gr+/b
    activate window what
    clear
    set color to w+/g,w+/bg
    *@ 1,1 prompt  ' Enter Commisions'
    @ 1,1 prompt   '  Quick  Report  '
    @ 3,1 prompt   ' List by  Policy '
    @ 5,1 prompt   'List by Company  '
    @ 7,1 prompt   'Unpaid Commisions'
    @ 9,1 prompt   '      Quit       '

    LK=0
    menu to moptopt
    LK=LASTKEY()
    do case

    *  case moptopt=1
    *       wait window "Not Implemented Yet" nowait
       case moptopt=1
            DEACT WINDOW WHAT
            DO REPORTS WITH 14
       case moptopt=2
            DEACT WINDOW WHAT
            DO REPORTS WITH 10
       case moptopt=3
            DEACT WINDOW WHAT
            DO REPORTS WITH 11
       case moptopt=4
            DEACT WINDOW WHAT
            DO REPORTS WITH 15
      otherwise
         deactivate window what
                    facctno=0
    endcase
enddo

deactivate window what
release window what
set topic to "FILING"
return


