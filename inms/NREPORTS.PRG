set procedure to 'various'
set exclusive off
*wait window 'No Reports availlable yet'
date1={  /  /  }
date2={  /  /  }

do morepmenu
release window maininfo
return


***************************************************************************
*                  report menu
***************************************************************************
procedure morepmenu
set color to w/rb+,r+/w
private cont

cont=.t.


set color to w/rb+,b/w
define window moreport from 2,35 to 17,71 Title ' REPORTS ' double shadow float
activate window moreport

do while cont=.t.
set color to w/rb+,b/w
@ 1,7  PROMPT  'Detailed Payment List'
@ 2,7  prompt  ' List all Customers  '
@ 3,7  prompt  ' Unassigned Policies '
@ 4,7  prompt  'Unassigned Companies '
@ 5,7  prompt  'Customer Adr. Labels '
@ 6,7  prompt  "  View Activity Log  "
@ 7,7  prompt  " Insurance Companies "
@ 8,7  prompt  " View Document List  "
@ 9,7  prompt  "    List all Codes   "
@10,7  prompt  "List all Installments"
@11,7  prompt  " Commision  Payments "
@12,7  prompt  '  Quit to Main menu  '



menu to moselection
cont=.t.
CLOSE DATABASES
do case
   case moselection =1
        save screen to repsc
        deactivate window moreport
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
       *SeT INDEX TO inact
       set order to tag idate
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
        activate window moreport
        restore screen from repsc
        set relation to
*        SET INDEX TO INVOICE
         set order to tag acctno
   case moselection =2
        save screen to repsc
        deactivate window moreport

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
        activate window moreport
        restore screen from repsc
   case moselection=3
        save screen to repsc
        deactivate window moreport
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
        activate window moreport
        restore screen from repsc
   case moselection=4
        save screen to repsc
        deactivate window moreport
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
        activate window moreport
        restore screen from repsc
   case moselection=5
        save screen to repsc
        deactivate window moreport
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
        do labels
        activate window moreport
        restore screen from repsc
   case moselection=6
        save screen to repsc
        deactivate window moreport
        do getdate
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         if !used('activity')
            SELECT 24
            USE ACTIVITY index activity,date ALIAS ACTIVITY
         ELSE
            SELECT ACTIVITY
         ENDIF
*         set order to tag ddate
          set index to date
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

        activate window moreport
        restore screen from repsc
        set relation to
*        save screen to repsc
*        deactivate window moreport
*        do moreports
*        activate window moreport
*        restore screen from repsc
   CASE MOSELECTION=7
     save screen to REPSC
     deactivate window moreport
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
     activate window moreport
     restore screen from REPSC
   case moselection=8
     save screen to REPSC
     deactivate window moreport
     do getdate
     if !used('documents')
        select 14
        use documents index polid alias document
     else
        select document
     endif
     save screen to q
     deactivate window moreport
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
     activate window moreport
     restore screen from REPSC
   CASE MOSELECTION=9
        SAVE SCREEN TO W
        deactivate window moreport
        DO CODREP
        activate window moreport
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
         deactivate window moreport
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
         activate window moreport
         restore screen from REPSC
         select installmen
         set relation to
         select policy
*         set index to policy
         set order to tag policyno
   case moselection=11
        do getdate

         if !used('comision')
            select 12
            use comision index comision alias comision
         else
            select comision
         endif

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag dpid

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno

         select comision
         set relation to dpid into policy
         set relation to acctno into client additive

         save screen to REPSC
         deactivate window moreport
         outp=spf()
         go top
         do case
            case outp=1
                  =setpglen()
                  do preview with "compay","(comision.date>={"+dtoc(date1)+"} and comision.date<={"+dtoc(date2)+"})"
           case outp=2
                 do prnchoic
                 wait window "Now Printing" nowait
                 =setpglen()
                 report form compay for (comision.date>=date1 and comision.date<=date2) to print noconsole
         endcase
         activate window moreport
         restore screen from REPSC
         select comision
         set relation to
         select policy
*         set index to policy
         set order to tag policyno
   otherwise
        cont=.f.
endcase
enddo
deactivate window moreport
release window moreport
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
      start={01/01/1980}
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

