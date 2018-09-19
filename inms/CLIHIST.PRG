

parameter macctno,repnum
set procedure to 'various'
set exclusive off
date1={  /  /  }
date2={  /  /  }
start={  /  /  }
end={  /  /  }

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag dpid

         if !used('comision')
            select 12
            use comision index comision alias comision
         else
            select comision
         endif
         set order to tag acctno

         if !used('activity')
            SELECT 24
            USE ACTIVITY index activity,DATE ALIAS ACTIVITY
         ELSE
            SELECT ACTIVITY
         ENDIF
         SET INDEX TO DATE

       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif
       set filter to
*       SET FILTER TO ACCTNO=MACCTNO
*       set index to inact
        set order to tag acctno

do getdate
do hismenu with repnum
*release window maininfo
set exclusive off
*deactivate window dates
release window dates
SELECT INVOICE
set filter to
return


***************************************************************************
*                  history menu
***************************************************************************
procedure hismenu
parameter selection
set color to w/rb+
private cont

*cont=.t.
*
*set color to w/rb+
*deactivate window hisort
*release window hisort
*
*set color to w/rb+,w/rb+, w/rb+, w/rb+, w/rb+, w/rb+, w/rb+, w/rb+, w/rb+, w/rb+
*define window hisort from 8,29 to 18,59 Title ' HISTORY ' double shadow float;
*    color  w/rb+,w/rb+, w/rb+, w/rb+, w/rb+, w/rb+, w/rb+, w/rb+, w/rb+, w/rb+
*activate window hisort
*
*do while cont=.t.
*set color to w/rb+,b/w
*@ 1,8  PROMPT 'Show Activity  Log'
*@ 3,8  prompt ' Transaction List '
*@ 5,8  prompt '     Commisions   '
*@ 7,8  prompt '        Quit      '
*menu to selection
*cont=.t.
do case
   case selection =1
            SELECT ACTIVITY
            go top
        save screen to hissc
        save screen to dtsc
        save screen to sc
        outp=spf()
        do case
           case outp=1
                =setpglen()
                wait window "Please Wait Coming UP" nowait
                 wait clear
                 do preview with "clihist","( (acctno=client.acctno) and (ddate >={"+DTOC(start)+"} ) and (ddate<={"+DTOC(end)+"}))"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                =setpglen()
                report form clihist to print noconsole for ( (acctno=client.acctno) and (ddate >= start ) and (ddate<=end))
           case outp=3
                 do laser with "clihist","( (activity->acctno="+alltrim(str(client.acctno))+") .and. (activity->ddate >={"+DTOC(start)+"} ) .and. (activity->ddate<={"+DTOC(end)+"}))"
           otherwise
                * do nothing
        endcase
        restore screen from sc
        restore screen from dtsc
        restore screen from hissc
   case selection=2
        SELECT INVOICE
         set order to tag acctno
        go top
        save screen to hissc
        save screen to dtsc
        save screen to sc
*         sum invoice.dprice for ((dinvno=0) and (acctno=macctno) and (idate >= start ) and (idate<=end)) to totpays
*         sum invoice.dprice for ((dinvno>0) and (acctno=macctno) and (idate >= start ) and (idate<=end)) to totinvs
*         dbalance=totinvs-totpays
          pastdue=0
        outp=spf()
        do case
           case outp=1
                wait window "Please Wait Coming UP" nowait
                =setpglen()
                  a=fname("temp.txt")
                  delete file &a
                  select invoice
                  DO PREVIEW WITH "clipay","( (acctno=macctno) and (idate >={"+DTOC( start)+"} ) and (idate<={"+DTOC(end)+"}))"
*                   report form clipay for ( (acctno=macctno) and (idate >=start) and (idate<=end)) to file (a) noconsole
* comision report
                       select policy
                       set order to tag dpid
                       select comision
                       set relation to dpid into policy
                       set filter to acctno=client.acctno
                       save screen to q
     *                  DO PREVIEW WITH  "icompay","( (acctno=macctno) and (date >={"+ DTOC(start)+"} ) and (date<={"+DTOC(ENd)+"}))"
* commissions report is separate now
*                        report form icompay for ( (acctno=macctno) and (date >+start) and (date<=ENd)) to file (a) additive noconsole
*                        if filesize(a)=0
*                           wait Window "This Report Is empty" timeout 1
*                        else
*                            !readme &a
*                             set color of scheme 8 to gr+/b,gr+/b,n/w
*                             modify file (a) noedit NOWAIT
*                             ZOOM WINDOW "TEMP.TXT" NORM FROM 0,0 TO 23,79
*                             modify file (A) noedit
*                        endif
*                        delete file &a
                       restore screen from q
                       select comision
                       set relation to
                       set filter to

                  select invoice
                 wait clear
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                =setpglen()
                report form  clipay to print noconsole for ( (acctno=client.acctno) and (idate >= start and idate<=end))
                select invoice
           case outp=3
                   do laser with "clipay","( (invoice->acctno="+alltrim(str(macctno))+") .and. (invoice->idate >={"+dtoc(start)+"}) .and. (invoice->idate<={"+dtoc(end)+"}))"
                   do laser with "icompay","( (comision->acctno="+alltrim(str(macctno))+") .and. (comision->date >={"+dtoc(start)+"}) .and. (comision->date<={"+dtoc(end)+"}))"
           otherwise
                * do nothing
        endcase
        restore screen from sc
        restore screen from dtsc
        restore screen from hissc
         set order to tag acctno
   case selection=3
        outp=spf()
        do case
           case outp=1
                =setpglen()
                wait window "Please Wait Coming UP" nowait
                  a=fname("temp.txt")
                  select policy
                  set order to tag dpid
                  delete file &a
                  select comision
                  set relation to dpid into policy
                  set filter to acctno=client.acctno
                  save screen to q
                  DO PREVIEW WITH  "icompay","( (acctno=macctno) and (date >={"+ DTOC(start)+"} ) and (date<={"+DTOC(ENd)+"}))"
                  restore screen from q
                 wait clear
                  select comision
                  set relation to
                  set filter to
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                =setpglen()
                  select policy
                  set order to tag dpid
                  select comision
                  set relation to dpid into policy
                  set filter to acctno=client.acctno
                report form icompay to print noCONsole   for ( (acctno=client.acctno) and (date >= start ) and (date<=end))
                  select comision
                  set relation to
                  set filter to
           case outp=3
                   do laser with "icompay","( (comision->acctno="+alltrim(str(macctno))+") .and. (comision->date >={"+dtoc(start)+"}) .and. (comision->date<={"+dtoc(end)+"}))"
           otherwise
                * do nothing
        endcase
   otherwise
        cont=.f.
endcase
return







