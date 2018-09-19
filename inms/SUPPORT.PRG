
set procedure to 'various'
set exclusive off
do suppmenu
return


***************************************************************************
*                  suppTENANCE menu
***************************************************************************
procedure suppmenu
set color to w/g+
private cont

cont=.t.

define window support from 3,49 to 18,75 Title ' SUPPORT ' shadow
activate window support


do while cont=.t.
set color to w/g+,b/w
tf=getautopol()
if !tf
   return
endif
   @ 1,3 PROMPT 'Auto Rating Program'
   @ 3,3 PROMPT 'Moto Rating Program'
   @ 5,5 PROMPT 'DMV Connection'
   @ 7,5 prompt 'Edit Text File'
   @ 9,4 prompt 'Print Text File'
   @ 11,3 pROMPT 'Execute DOS Command'
   @ 13,10 prompt 'Quit'
menu to selection

cont=.t.
do case
   case selection =1
        A=FNAME('SUP1.WIN')
        delete file &A
        save WINDOW SUPPORT to &A
        DEACTIVATE WINDOW SUPPORT
        SAVE SCREEN TO SUPSC
             a=fname('sup.mem')
        DELETE FILE &a
        SAVE TO &a
        CLEAR ALL
        A=FNAME('SCREEN.TXT')
        IF FILE(A)
            WAIT WINDOW "Auto Rater in use. Please try again in a while" nowait
         else
             a=getenv('InMSname')
             do dosupport with 1,"none"
        endif
           set default to
        a=fname('sup.mem')
        a=fname('sup.mem')
        RESTORE FROM &a
        RESTORE SCREEN FROM SUPSC
        a=fname('sup1.win')
        restore WINDOW SUPPORT from &A
        ACTIVATE WINDOW SUPPORT
   case selection =2
        A=FNAME('SUP1.WIN')
        delete file &A
        save WINDOW SUPPORT to &A
        DEACTIVATE WINDOW SUPPORT
        SAVE SCREEN TO SUPSC
             a=fname('sup.mem')
        DELETE FILE &a
        SAVE TO &a
        CLEAR ALL
        A=FNAME('SCREEN.TXT')
        IF FILE(A)
            WAIT WINDOW "Auto Rater in use. Please try again in a while" nowait
         else
             a=getenv('InMSname')
             do dosupport with 2,"none"
        endif
           set default to
        a=fname('sup.mem')
        a=fname('sup.mem')
        RESTORE FROM &a
        RESTORE SCREEN FROM SUPSC
        a=fname('sup1.win')
        restore WINDOW SUPPORT from &A
        ACTIVATE WINDOW SUPPORT
        cont=.t.
   CASE SELECTION =3
        a=fname('sup1.win')
        delete file &a
        save WINDOW SUPPORT TO &a
        DEACTIVATE WINDOW SUPPORT
        SAVE SCREEN TO SUPSC
             a=fname('sup.mem')
        DELETE FILE &a
        SAVE TO &a
        CLEAR ALL
*        set default to "albany"
*         run "pcplus"
*        set default to ".."
         a=fname("data.ins")
         if file( a )
            wait window "Somebody else Is using the modem" nowait
        else
*            run "mv.bat"
             do dosupport with 3,"none"
        endif
        dirn=getenv("INMSROOT")
        if LEN(dirn)>0
*           set default to (dirn)
           set default to
        endif
        a=fname('sup.mem')
        RESTORE FROM &a
        RESTORE SCREEN FROM SUPSC
        a=fname('sup1.win')
        restore window SUPPORT from &a
        ACTIVATE WINDOW SUPPORT
        cont=.t.
   case selection=4
        do dosupport with 4,"none"
        cont=.t.
   CASE SELECTION=5
       filename=space(80)
       if wexist('cv1data')
          release window cv1data
       endif
       set color to w+/g,b/w
       define window cV1DATA from 9,21 to 11,79 title '[ Filename ]' ;
              shadow double float color w+/g,w+/g,w+/g,w+/g,w+/g,w+/g,;
                            w+/g,w+/g,w+/g,w+/g
       activate window cV1DATA IN SCREEN
       set color to w+/g,b/w
       @ 0,2 say "Please Enter Filename" get filename size 1,30
       read
       deactivate window cv1data
       if (len(alltrim(filename))=0) .or. lastkey()=27
          cont=.f.
          exit
       endif
       do dosupport with 5,filename
   CASE SELECTION=6
       command=space(80)
       if wexist('cv1data')
          release window cv1data
       endif
 *      set color to gr+/b,b/w
       set color to w+/g,b/w
       define window cV1DATA from 9,21 to 11,79 title '[ Dos Command ]' ;
              shadow double float color w+/g,w+/g,w+/g,w+/g,w+/g,w+/g,;
                            w+/g,w+/g,w+/g,w+/g
*               color gr+/b,gr+/b,gr+/b,gr+/b,gr+/b,;
                                        gr+/b,gr+/b,gr+/b,gr+/b,gr+/b
       activate window cV1DATA IN SCREEN
*       set color to gr+/b,b/w
       set color to w+/g,b/w
       @ 0,2 say "Please Enter Command" get command size 1,30
       read
       deactivate window cv1data
       if (len(alltrim(command))=0) .or. lastkey()=27
          cont=.f.
          exit
       endif
       name=fname('command.mem')
       save all like command to &name
        a=fname('sup1.win')
        delete file &a
        save WINDOW SUPPORT to &a
        DEACTIVATE WINDOW SUPPORT
        SAVE SCREEN TO SUPSC
        a=fname('sup.mem')
        DELETE FILE &a
        SAVE TO &a
        CLEAR ALL
         set color to w/n
         for i=1 to 25
             scroll 0,0,24,79,1,0
         endfor
       name=fname('command.mem')
       restore from  &name additive
       do dosupport with 6,alltrim(command)
       wait window "Press any key to return to program" timeout 5
         clear all
        dirn=getenv("INMSROOT")
        if LEN(dirn)>0
           set default to
        endif
         set color to gr+/b,b/w
         a=fname('sup.mem')
        RESTORE FROM &a
        RESTORE SCREEN FROM SUPSC
                a=fname('sup1.win')
        restore WINDOW SUPPORT from &a
        ACTIVATE WINDOW SUPPORT
        cont=.t.
   otherwise
        deactivate window support
        release window support
        cont=.f.
endcase
enddo
deactivate window support
release window support
return

