parameter moselection

set exclusive off
date1={  /  /  }
date2={  /  /  }

do case
   case moselection =1
        save screen to repsc
        do getdate
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif
*       SET INDEX TO inact
        set order to tag acctno
       set relation to acctno into client
*                   browse nomodify

        outp=spf()
        go top
        do case
           case outp=1
                =setpglen()

                do preview with "daypay","(invoice.idate>={"+dtoc(date1)+"} and invoice.idate<={"+dtoc(date2)+"})"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                =setpglen()
                report form daypay for (idate>=date1 and idate<=date2) to print noconsole
        endcase
        restore screen from repsc
        set relation to
*        SET INDEX TO INVOICE
         set order to tag acctno
   case moselection =2
        save screen to repsc

*        do getdate
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
        outp=spf()
        go top
        do case
           case outp=1
                =setpglen()

                do preview with "clients",""
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                =setpglen()
                report form clients to print noconsole
        endcase
        restore screen from repsc
   case moselection=3
        save screen to repsc
        if !used('policy')
           select e
           use policy index policy alias policy
        else
          select policy
        endif
        outp=spf()
        go top
        do case
           case outp=1
                =setpglen()
*                report form nonumber for ((effdate<=date()-30) and (policyno=space(30) or policyno='UNASSIGNED')) preview

                do preview with "nonumber","(policyno=space(30) or policyno='UNASSIGNED')"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                =setpglen()
                report form nonumber for (policyno=space(30) or policyno='UNASSIGNED') to print noconsole
        endcase
        restore screen from repsc
   case moselection=4
        save screen to repsc
        if !used('policy')
           select e
           use policy index policy alias policy
        else
          select policy
        endif
        outp=spf()
        go top
        do case
           case outp=1
                =setpglen()

                do preview with "unassign","(inumber>990) "
*                report form unassign for (effdate<=date()-30 and inumber>990) preview
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                =setpglen()
                report form unassign for (inumber>990) to print noconsole
        endcase
*        report form unassign for (effdate<=date()-30 and inumber>990) preview

*      do preview with "unassign","(inumber>990) "
        restore screen from repsc
   case moselection=5
        save screen to repsc
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
        do labels
        restore screen from repsc
   case moselection=6
        save screen to repsc
        do getdate
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         if !used('activity')
            SELECT 24
            USE ACTIVITY index activity,DATE ALIAS ACTIVITY
         ELSE
            SELECT ACTIVITY
         ENDIF
         set order to tag acctno
         set relation to dacctno into client
*                   browse nomodify
        outp=spf()
        go top
        do case
           case outp=1
                =setpglen()

                do preview with "clihist1","(Ddate>={"+dtoc(date1)+"} and Ddate<={"+dtoc(date2)+"})"
          case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                =setpglen()
                report form clihist1 for (Ddate>=date1 and Ddate<=date2)  to print noconsole
        endcase

        restore screen from repsc
        set relation to
*        save screen to repsc
*        deactivate window moreport
*        do moreports
*        restore screen from repsc
   CASE MOSELECTION=7
     save screen to REPSC
     if !used('icompany')
        select d
        use icompany index icompany alias icompany
     else
        select icompany
     endif
     set order to iname

     outp=spf()
     go top
     do case
        case outp=1
             =setpglen()

              do preview with "inslist",""
        case outp=2
             do prnchoic
             wait window "Now Printing" nowait
             =setpglen()
             report form inslist to print noconsole
     endcase
     restore screen from REPSC
   case moselection=8
     save screen to REPSC
     do getdate
     if !used('documents')
        select 14
        use documents index polid alias document
     else
        select document
     endif
     save screen to q
     outp=spf()
     go top
     do case
        case outp=1
             =setpglen()

              do preview with "doclist1","(SENDATE>={"+dtoc(date1)+"} and SENDATE<={"+dtoc(date2)+"})"
       case outp=2
             do prnchoic
             wait window "Now Printing" nowait
             =setpglen()
             report form doclist1 for (SENDATE>=date1 and SENDATE<=date2) to print noconsole
     endcase
     restore screen from REPSC
   CASE MOSELECTION=9
        SAVE SCREEN TO W
        DO CODREP
        RESTORE SCREEN FROM W
   case moselection=10
        do getdate
         if !used('installm')
            select 11
            use installm index install alias installment
         else
            select installment
         endif

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
*         set index to polcid
          set order to tag dpid

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         select installmen
         set relation to dpid into policy
         set relation to dacctno into client additive
         save screen to REPSC
         outp=spf()
         go top
         do case
            case outp=1
                  =setpglen()
                  do preview with "ginstall","(installmen.ddate>={"+dtoc(date1)+"} and installmen.ddate<={"+dtoc(date2)+"})"
           case outp=2
                 do prnchoic
                 wait window "Now Printing" nowait
                 =setpglen()
                 report form ginstall for (installmen.ddate>=date1 and installmen.ddate<=date2) to print noconsole
         endcase
         restore screen from REPSC
         select installmen
         set relation to
         select policy
*         set index to policy
          set order to tag acctno
   otherwise
        cont=.f.
endcase
return



***************************************************************************
*                  which day
***************************************************************************
procedure getdate

set color to
save screen to wm
*@ 0,0 to 0,79 clear
*center(0,"Please enter the Report's Date")
define window dates from 3,30 to 8,50 Title ' Date ' shadow float
activate window dates

lk=27
do while lk = 27
      =center(0,'Start Date Please')
      start=date()
      @1,5 get start picture '@d'
      =center(2,'End Date Please')
      end=date()
      @3,5 get end picture '@d'
      read
      lk=lastkey()
enddo
deactivate window dates
release window dates
restore screen from wm
date1=start
date2=end
return

