* more reports are located in
* clihist
* polmenu
* codes
* insmenu



parameter moselection
set century on
date1={  /  /    }
date2={  /  /    }
set procedure to 'various'
close databases
set delete on
do repselect with moselection
close databases
set deleted off
return


***************************************************************************
*                        final reports
***************************************************************************
procedure finalreps
parameter moselection,date1,date2,outp
do case
   case moselection =1
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif
       set order to tag ACCTNO

       SELECT CLIENT
       set relation to acctno into INVOICE
       SET SKIP TO INVOICE
       set order to tag lastn
        go top
        do case
           case outp=1
                do preview with "daypay","(invoice.idate>={"+dtoc(date1)+"} and invoice.idate<={"+dtoc(date2)+"} and invoice.dinvno=0)"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form daypay for (invoice.idate>=date1 and invoice.idate<=date2 and invoice.dinvno=0) to print noconsole
                wait clear
*           CASE OUTP=3
*                DO LASER WITH "daypay","(invoice->idate>={"+dtoc(date1)+"} .and. invoice->idate<={"+dtoc(date2)+"} .and. invoice->dinvno=0)"
        endcase
        set relation to
        SET SKIP TO
*        SET INDEX TO INVOICE
         set order to tag acctno
   case moselection =2
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag lastn
         set filter to acctno>0
        go top
        do case
           case outp=1
                do preview with "clients",""
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form clients to print noconsole
                wait clear
*           CASE OUTP=3
*                DO LASER WITH "CLIENTS",""
        endcase
   case moselection=3
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

        if !used('policy')
           select e
           use policy index policy alias policy
        else
          select policy
        endif
         set order to tag acctno

         select client
         set relation to acctno into policy
         set skip to policy
         set order to tag lastn

        go top
        do case
           case outp=1
                do preview with "nonumber","(policy.policyno=space(30) or policy.policyno='UNASSIGNED')"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form nonumber for (policy.policyno=space(30) or policy.policyno='UNASSIGNED') to print noconsole
                wait clear
*           CASE OUTP=3
*                DO LASER WITH "nonumber","(policy->policyno=space(30) .or. policy->policyno='UNASSIGNED')"
        endcase
   case moselection=4
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

        if !used('policy')
           select e
           use policy index policy alias policy
        else
          select policy
        endif
        set order to tag acctno

        select client
        set relation to acctno into policy
        set skip to policy
        set order to tag lastn

        go top
        do case
           case outp=1
                do preview with "unassign","(alltrim(policy.iidno)='999') "
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form unassign for (alltrim(policy.iidno)='999') to print noconsole
                wait clear
*            CASE OUTP=3
*                do LASER with "unassign","(trim(policy->iidno)='999') "
        endcase

   case moselection=5
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag lastn
         set filter to acctno>0

        do labels
   case moselection=6
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

         if !used('activity')
            SELECT 24
            USE ACTIVITY index activity,date ALIAS ACTIVITY
         ELSE
            SELECT ACTIVITY
         ENDIF
         set order to tag ACCTNO

         SELECT client
         set relation to acctno into activity
         set skip to activity
         set order to tag lastn
        go top
        do case
           case outp=1
                do preview with "clihist1","(activity.ddate>={"+dtoc(date1)+"} and activity.ddate<={"+dtoc(date2)+"})"
          case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form clihist1 for (activity.ddate>=date1 and activity.ddate<=date2)  to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "clihist1","(activity.ddate>={"+dtoc(date1)+"} and activity.ddate<={"+dtoc(date2)+"})"
        endcase

        set relation to
        SET SKIP TO
   CASE MOSELECTION=7
     if !used('icompany')
        select d
        use icompany index icompany alias icompany
     else
        select icompany
     endif
     set order to iname

     go top
     do case
        case outp=1
              do preview with "inslist",""
        case outp=2
             do prnchoic
             wait window "Now Printing" nowait
             report form inslist to print noconsole
             wait clear
*        CASE OUTP=3
*              do LASER with "inslist",""
     endcase
   case moselection=8
         if !used('document')
            select 14
            use document index polid alias document
         else
            select document
         endif
         set order to tag dpid

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag dpid
*         set filter to dcanceled=.t.

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

         IF !USED('icompany')
            select d
            use icompany index icompany alias icompany
         else
           select icompany
         endif
         set order to tag iidno

         select client
         set relation to acctno into policy
         set skip to policy

         select policy
         set relation to iidno  into icompany
*         select document
*         set relation to dpid into policy
          set relation to dpid into document additive
          set skip to document
          set order to tag acctno

select client
set order to tag lastn
GO TOP
*browse fields client.acctno,policy.acctno,policy.dpid,policy.iidno,icompany.iidno ,document.dpid

        go top
        do case
           case outp=1
                do preview with "doclist1","(document.recdate>={"+dtoc(date1)+"} and document.recdate<={"+dtoc(date2)+"} )"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form doclist1 for (document.recdate>=date1 and document.recdate<=date2) to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "cancel","(document->recdate>={"+dtoc(date1)+"} .and. document->recdate<={"+dtoc(date2)+"} .and. document->doctype='*CANCEL*')"
        endcase
        set relation to
        set filter to

   CASE MOSELECTION=9
        DO CODREP
   case moselection=10 && comisions by policy id

         if !used('comision')
            select 12
            use comision index comision alias comision
         else
            select comision
         endif
         set order to tag dpid

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag dpid
*         set relation to dpid into comision
*         set skip to comision

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

*         select comision
*         set relation to dpid into policy
*         set relation to acctno into client additive
*        select client
*        set relation to acctno into policy
*        set skip to policy

*        select policy
*        set relation to dpid into comision
*        set skip to comision

        select policy
        set relation to dpid into comision
        set relation to acctno into client additive
        set skip to comision
        set order to tag dpid

         go top
         do case
            case outp=1
                  a=fname('temp.txt')
                  do preview with "compay","(comision.date>={"+dtoc(date1)+"} and comision.date<={"+dtoc(date2)+"})"
           case outp=2
                 do prnchoic
                 wait window "Now Printing" nowait
                 report form compay for (comision.date>=date1 and comision.date<=date2) to print noconsole
                 wait cLEAR
*            CASE OUTP=3
*                  do LASER with "compay","(comision->date>={"+dtoc(date1)+"} .and. comision->date<={"+dtoc(date2)+"})"
         endcase
         select comision
         set relation to
         select policy
         set order to tag policyno
   case moselection=11  && comisions by insurance company
         if !used('comision')
            select 12
            use comision index comision alias comision
         else
            select comision
         endif
         set order to tag dpid

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag iidno

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

         IF !USED('icompany')
            select d
            use icompany index icompany alias icompany
         else
           select icompany
         endif
         set order to tag iidno

*         select comision
*         set relation to dpid into policy
*         set relation to acctno into client additive
*         set relation to iidno into icompany additive

		select policy
		set relation to dpid into comision
                set relation to acctno into client additive
                set relation to iidno into icompany additive
                set skip to comision
		set order to tag iidno
          
*browse fields policy.dpid,policy.iidno,comision.dpid,COMISION.COMMENT

         go top
         do case
            case outp=1
                  do preview with "totcom","(comision.date>={"+dtoc(date1)+"} and comision.date<={"+dtoc(date2)+"})"
*                  do preview with "totcom",""
           case outp=2
                 do prnchoic
                 wait window "Now Printing" nowait
                 report form totcom for (comision.date>=date1 and comision.date<=date2) to print noconsole
                 wait clear
*            CASE OUTP=3
*                  do LASER with "totcom","(comision->date>={"+dtoc(date1)+"} .and. comision->date<={"+dtoc(date2)+"})"
         endcase
         select comision
         set relation to
         select policy
*         set index to policy
         set order to tag policyno
   case moselection=12
         if !used('installm')
            select 11
            use installm index install alias installment
         else
            select installment
         endif
         SET ORDER TO TAG DPID

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
         set order to tag acctno
         set filter to acctno>0

         select POLICY
         set relation to dpid into INSTALLMEN
         set relation to acctno into client additive
         SET SKIP TO INSTALLMEN
         go top
         do case
            case outp=1
                  do preview with "ginstall","(installmen.ddate>={"+dtoc(date1)+"} and installmen.ddate<={"+dtoc(date2)+"})"
           case outp=2
                 do prnchoic
                 wait window "Now Printing" nowait
                 report form ginstall for (installmen.ddate>=date1 and installmen.ddate<=date2) to print noconsole
                 wait cleAR
*            CASE OUTP=3
*                  do LASER with "ginstall","(installmen->ddate>={"+dtoc(date1)+"} .and. installmen->ddate<={"+dtoc(date2)+"})"
         endcase
         select installmen
         set relation to
         select policy
*         set index to policy
         set order to tag policyno
   case moselection=13
         if !used('installm')
            select 11
            use installm index install alias installment
         else
            select installment
         endif
         SET ORDER TO TAG DPID

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
         set order to tag acctno
         set filter to acctno>0

         select POLICY
         set relation to dpid into INSTALLMEN
         set relation to acctno into client additive
         SET SKIP TO INSTALLMEN
         go top
         do case
            case outp=1
                  do preview with "ginstall","(installmen.ddate>={"+dtoc(date1)+"} and installmen.ddate<={"+dtoc(date2)+"} .and. (installmen.dtype=' '))"
           case outp=2
                 do prnchoic
                 wait window "Now Printing" nowait
                 report form ginstall for (installmen.ddate>=date1 and installmen.ddate<=date2 and installmen.dtype=' ' ) to print noconsole
                 wait clear
*            CASE OUTP=3
*                  do LASER with "ginstall","(installmen->ddate>={"+dtoc(date1)+"} .and. installmen->ddate<={"+dtoc(date2)+"} .and. (installmen->dtype=' ')"
           endcase

  case moselection=14 && Quick Comision Report

         if !used('comision')
            select 12
            use comision index comision alias comision
         else
            select comision
         endif
         set order to tag dpid

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
         set filter to acctno>0

*         select comision
*         set relation to dpid into policy
*         set relation to acctno into client additive
          select policy
          set relation to dpid into comision
          set relation to acctno into client additive
          set skip to comision


         go top
         do case
            case outp=1
                  a=fname('temp.txt')
                  do preview with "comquick","(comision.date>={"+dtoc(date1)+"} and comision.date<={"+dtoc(date2)+"})"
           case outp=2
                 do prnchoic
                 wait window "Now Printing" nowait
                 report form comquick for (comision.date>=date1 and comision.date<=date2) to print noconsole
                 wait clear
*            CASE OUTP=3
*                  do LASER with "comquick","(comision->date>={"+dtoc(date1)+"} .and. comision->date<={"+dtoc(date2)+"})"
         endcase
         select policy
         set order to tag policyno
         set relation to
  case moselection=15 && Quick Comision Report
*         if !used('comision')
*            select 12
*            use comision index comision alias comision
*         else
*            select comision
*         endif
*         set order to tag dpid

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag dpid
*         set filter to renewed=.f. .and. dcanceled=.f.
         set filter to dcanceled=.f.


         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

         select policy
         set relation to acctno into client
*         set relation to dpid into comision additive
*         set skip to comision
         go top
         do case
            case outp=1
                  a=fname('temp.txt')
                  do preview with "comunp","policy.dtotcomrec<policy.dtotcom .and. policy.dcanceled=.f."
           case outp=2
                 do prnchoic
                 wait window "Now Printing" nowait
                 report form comunp for (policy.dtotcomrec<policy.dtotcom .and. policy.dcanceled=.f.) to print noconsole
                 wait clear
*            CASE OUTP=3
*                  do LASER with "comunp","policy->dtotcomrec < policy->dtotcom"
         endcase
         select policy
         set order to tag policyno
         set relation to
   case moselection=16


         IF !USED('icompany')
            select d
            use icompany index icompany alias icompany
         else
           select icompany
         endif
         set order to tag iidno

         if !used('installm')
            select 11
            use installm index install alias installment
         else
            select installment
         endif
         set order to tag dpid
*         set filter to ddate>=date1 and ddate<=date2 and dtype=' '

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
          set order to tag dpid
*          set filter to (dcanceled=.f. .and. dpid>0)

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
*         set filter to acctno>0

         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
*         SET RELATION TO ACCTNO INTO CLIENT ADDITIVE
         set order to tag dvehid
*         select * from vehicle a,client b where a.acctno=b.acctno into ctemp.dbf noconsole

         IF !USED('coverage')
            select c
            use coverage index coverage alias coverage
         else
           select coverage
         endif
*         set relation to dvehid into vehicle additive
*         set order to tag dpid
*         set skip to vehicle

   select distinct a.add,a.city,a.zip,a.aptno,a.state,a.firstn,a.lastn,a.salut,a.mi,a.acctno,;
        b.duse,b.dvehid;
        from client a,vehicle b;
        where (a.acctno=b.acctno ) into table xtemp noconsole

   select distinct a.add,a.city,a.zip,a.aptno,a.state,a.firstn,a.lastn,a.salut,a.mi,a.acctno,;
        a.duse,a.dvehid,c.dpid;
        from xtemp a,coverage c where ;
        (a.dvehid=c.dvehid ) into table ctemp noconsole

*          select ctemp
*          index on dpid tag dpid of ctemp compact
*          index on acctno tag acctno of ctemp compact
*         set order to tag dpid

*         select installmen
*         set relation to dpid into policy
*         set relation to acctno into client additive
*         set relation to dpid into coverage additive
*         select installmen

*         SELECT POLICY
*         SET RELATION TO DPID INTO INSTALLMEN ADDITIVE
*         SET RELATION TO IIDNO INTO ICOMPANY ADDITIVE
*         SET RELATION TO DPID INTO ctemp additive
*         SET RELATION TO ACCTNO INTO CLIENT ADDITIVE
*         SET SKIP TO installmen,ctemp
*         SET SKIP TO  installmen
*         SET ORDER TO TAG ACCTNO
*         SET ORDER TO TAG POLICYNO

     select distinct e.acctno,e.dpid,e.policyno,e.from,e.to,k.ddate,k.dreason,k.dpayment,;
            d.iname;
      from policy e,installm k,icompany d;
       where ( e.dpid=k.dpid .and. len(alltrim(k.comments))=0 .and. e.iidno=d.iidno .AND. E.DCANCELED=.F. ) into table dtemp noconsole


   select distinct a.add,a.city,a.zip,a.aptno,a.state,a.firstn,;
                   a.lastn,a.salut,a.mi,a.acctno,;
                   a.duse,e.dpid,e.iname,;
                   e.policyno,e.from,e.to,e.ddate,e.dreason,e.dpayment;
        from ctemp a,dtemp e where ;
        (a.dpid=e.dpid .and. a.acctno=e.acctno );
         into table ztemp noconsole

          index on lastn tag lastn of ztemp compact
          set order to tag lastn

*         SELECT CLIENT
*         set order to tag acctno
*         SET RELATION TO ACCTNO INTO POLICY additive
*         SET RELATION TO ACCTNO INTO VEHICLE additive
*         SET SKIP TO policy,installmen,coverage,VEHICLE
*         set order to tag lastn

close databases
use ztemp
set order to tag lastn
* browse fields lastn,duse,acctno,dpid,Dreason for ddate>=date1+10 and ddate<=date2+10
*CANCEL

         go top
         RESTORE FROM COMEM ADDITIVE
         do case
            case outp=1
                 do preview with "igINSTAL","(ddate>={"+dtoc(date1+10)+"} and ddate<={"+dtoc(date2+10)+"})"
           case outp=2
                 do prnchoic
                 wait window "Now Printing" nowait

                report form iginstal for ( (ddate>=date1+10) and (ddate<=date2+10) ) to print noconsole
                 wait clear
*            CASE OUTP=3
*                  do LASER with "iginstal","(installmen->ddate>={"+dtoc(date1+10)+"} .and. installmen->ddate<={"+dtoc(date2+10)+"} .and. (installmen->dtype=' '))"
           endcase
    case moselection=17
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif
       set order to tag acctno
       select client
       set relation to acctno into invoice
       set skip to invoice
        go top
        do case
           case outp=1
                do preview with "daypay","(invoice.idate>={"+dtoc(date1)+"} and invoice.idate<={"+dtoc(date2)+"} and invoice.dinvno<>0)"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form daypay for (invoice.idate>=date1 and invoice.idate<=date2 and invoice.dinvno<>0) to print noconsole
                wait clear
*           CASE OUTP=3
*                do  LASER with "daypay","(invoice->idate>={"+dtoc(date1)+"} .and. invoice->idate<={"+dtoc(date2)+"} .and. invoice->dinvno<>0)"
        endcase
        set relation to
        set skip to
*        SET INDEX TO INVOICE
         set order to tag acctno
   case moselection=18
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif
       set order to tag code
       set relation to acctno into client
        go top
        do case
           case outp=1
                do preview with "codeinv","(invoice.idate>={"+dtoc(date1)+"} and invoice.idate<={"+dtoc(date2)+"})"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form codeinv for (invoice.idate>=date1 and invoice.idate<=date2) to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "codeinv","(invoice->idate>={"+dtoc(date1)+"} .and. invoice->idate<={"+dtoc(date2)+"})"
        endcase
        set relation to
   case moselection =19
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif
       set order to tag idate
       set relation to acctno into client
        go top
        do case
           case outp=1
                do preview with "quickinv","(invoice.idate>={"+dtoc(date1)+"} and invoice.idate<={"+dtoc(date2)+"} and invoice.dinvno>0)"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form quickinv for (invoice.idate>=date1 and invoice.idate<=date2 and invoice.dinvno>0) to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "quickinv","(invoice->idate>={"+dtoc(date1)+"} .and. invoice->idate<={"+dtoc(date2)+"} .and. invoice->dinvno>0)"
        endcase
        set relation to
*        SET INDEX TO INVOICE
         set order to tag acctno
   case moselection=20
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif
       set order to tag code
       set relation to acctno into client
        go top
        do case
           case outp=1
                do preview with "qcodeinv","(invoice.idate>={"+dtoc(date1)+"} and invoice.idate<={"+dtoc(date2)+"})"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form qcodeinv for (invoice.idate>=date1 and invoice.idate<=date2) to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "qcodeinv","(invoice->idate>={"+dtoc(date1)+"} .and. invoice->idate<={"+dtoc(date2)+"})"
       endcase
       set relation to
   case moselection=21
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0


         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
       set order to tag dpid
       set relation to acctno into client
        go top
        do case
           case outp=1
                do preview with "exppol","(ctod(policy.to)>={"+dtoc(date1)+"} and ctod(policy.to)<={"+dtoc(date2)+"} .and. policy.renewed=.f.)"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form exppol for (ctod(policy.to)>=date1 and ctod(policy.to)<=date2 and policy.renewed=.f.) to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "exppol","(ctod(policy->to)>={"+dtoc(date1)+"} .and. ctod(policy->to)<={"+dtoc(date2)+"} .and. policy->renewed=.f.)"
        endcase
        set relation to
   case moselection=22
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0


         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
       set order to tag dpid
       set relation to acctno into client
        go top
        do case
           case outp=1
                do preview with "renpol","(ctod(policy.to)>={"+dtoc(date1)+"} and ctod(policy.to)<={"+dtoc(date2)+"} .and. policy.renewed=.t.)"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form renpol for (ctod(policy.to)>=date1 and ctod(policy.to)<=date2 and policy.renewed=.t.) to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "renpol","(ctod(policy->to)>={"+dtoc(date1)+"} .and. ctod(policy->to)<={"+dtoc(date2)+"} .and. policy->renewed=.t.)"
        endcase
        set relation to
   case moselection=23

         if !used('document')
            select 14
            use document index polid alias document
         else
            select document
         endif
         set order to tag dpid

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag dpid
*        set filter to dcanceled=.t.

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

         IF !USED('icompany')
            select d
            use icompany index icompany alias icompany
         else
           select icompany
         endif
         set order to tag iidno

         select client
         set relation to acctno into policy
         set skip to policy

         select policy
         set relation to iidno  into icompany
*         select document
*         set relation to dpid into policy
          set relation to dpid into document additive
          set skip to document
          set order to tag acctno

select client
set order to tag lastn
set skip to policy,document

GO TOP
*browse fields client.acctno,policy.acctno,policy.dpid,policy.iidno,icompany.iidno ,document.dpid
        go top
        do case
           case outp=1
                do preview with "cancel","(document.recdate>={"+dtoc(date1)+"} and document.recdate<={"+dtoc(date2)+"} and ('CANCEL' $ alltrim(upper(document.doctype))))"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form cancel for (document.recdate>=date1 and document.recdate<=date2 and ('CANCEL' $ alltrim(upper(document.doctype)))) to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "cancel","(document->recdate>={"+dtoc(date1)+"} .and. document->recdate<={"+dtoc(date2)+"} .and. document->doctype='*CANCEL*')"
        endcase
        set relation to
        set filter to
   case moselection=24

        RESTORE FROM COMEM ADDITIVE
         if !used('document')
            select 14
            use document index polid alias document
         else
            select document
         endif
         set order to tag dpid

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
         set filter to acctno>0

         select policy
         set relation to acctno into client
         select document
         set relation to dpid into policy
        go top
        do case
           case outp=1
                do preview with "canlettr","(document.recdate>={"+dtoc(date1+5)+"} and document.recdate<={"+dtoc(date2+5)+"} and ('CANCEL' $ alltrim(upper(document.doctype))))"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form canlettr for (document.recdate>=date1+5 and document.recdate<=date2+5 and ('CANCEL' $ alltrim(upper(document.doctype)))) to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "canlettr",'(document->recdate>={'+dtoc(date1)+5+'} .and. document->recdate<={'+dtoc(date2)+5+'} .and. document->doctype="*CANCEL*")'
        endcase
        set relation to
   case moselection=25

         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
         set order TO tag combyvin

        go top
        do case
           case outp=1
                do preview with "Vehicles",""
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form vehicles to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "vehicles",''
        endcase
        set relation to
   case moselection=26
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag lastn
         set filter to acctno>0

        go top
        do case
           case outp=1
                do preview with "balance","dbalance>0"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form balance to print noconsole for dbalance>0
                wait clear
*           CASE OUTP=3
*                do LASER with "balance",'dbalance>0'
        endcase

   case moselection=27
        RESTORE FROM COMEM ADDITIVE
         if !used('document')
            select 14
            use document index polid alias document
         else
            select document
         endif
         set order to tag dpid

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
         set filter to acctno>0

         select policy
         set relation to acctno into client
         select document
         set relation to dpid into policy
        go top
        do case
           case outp=1
                do preview with "canltrg","(document.recdate>={"+dtoc(date1)+"} and document.recdate<={"+dtoc(date2)+"} and ('CANCEL' $ alltrim(upper(document.doctype))))"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form canltrg for (document.recdate>=date1 and document.recdate<=date2 and ('CANCEL' $ alltrim(upper(document.doctype)))) to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "canltrg",'(document->recdate>={'+dtoc(date1)+'} .and. document->recdate<={'+dtoc(date2)+'} .and. document->doctype="*CANCEL*")'
        endcase
        set relation to
   case moselection=28
         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
         set order TO tag combyvin

        go top
        do case
           case outp=1
                do preview with "Vehicles","vehicle.duse='P'"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form vehicles for vehicle.duse='P' to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "vehicles","vehicle.duse='P'"
        endcase
        set relation to
   case moselection=29
         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
         set order TO tag combyvin

        go top
        do case
           case outp=1
                do preview with "Vehicles","vehicle.duse='B'"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form vehicles for vehicle.duse='B' to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "vehicles","vehicle.duse='B'"
        endcase
        set relation to

   case moselection=30
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag ref_no
         set filter to acctno>0

       if !used('reffer')
          select 15
          use reffer index reffer alias refferance
       else
          select refferance
       endif
       set order to tag ref_no
       set relation to ref_no into client
       set skip to client

*       SET FILTER TO CLIENT.REF_NO > 0
*       browse fields ref_no,ref_name,client.lastn,client.firstn for client.ref_no>0

        go top
        do case
           case outp=1
                do preview with "Reffer","CLIENT.REF_NO>0"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form reffer FOR CLIENT.REF_NO>0 to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "reffer","CLIENT.REF_NO>0"
        endcase
        set relation to

case moselection=31
         if !used('comision')
            select 12
            use comision index comision alias comision
         else
            select comision
         endif
         set order to tag dpid

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag acctno

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

         select client
         set relation to acctno into policy
*         set skip to policy
         select policy
         set relation to dpid into comision
*         set skip to comision
         select client
         set order to tag lastn
         set skip to policy,comision
*set order to tag lastn
*browse fields client.acctno,policy.acctno,policy.dpid,comision.dpid

         go top
         do case
            case outp=1
                  a=fname('temp.txt')
                  do preview with "comcli","(comision.date>={"+dtoc(date1)+"} and comision.date<={"+dtoc(date2)+"})"
           case outp=2
                 do prnchoic
                 wait window "Now Printing" nowait
                 report form comcli for (comision.date>=date1 and comision.date<=date2) to print noconsole
                 wait clear
         endcase
         select policy
         set order to tag policyno
         set relation to
         select client
         set order to tag acctno
         set relation to
         set filter to

   case moselection=32

         if !used('driver')
            select f
            use driver index driver alias driver
         else
             select driver
         endif
         set order to tag dpid

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag acctno

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0


         select policy
         set order to tag dpid
         set relation to dpid into driver
         set skip to driver
         set order to tag acctno


         select client
         set relation to acctno into policy
         set skip to policy,driver
select client
set order to tag lastn
GO TOP
*rowse fields client.acctno,policy.acctno,policy.dpid,driver.dpid,driver.Dlastn
        go top
        do case
           case outp=1
                do preview with "driver","len(alltrim(driver.dlastn))>0"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form driver for len(alltrim(driver.dlastn))>0 to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "driver",""
        endcase
        set relation to
        set filter to
   case moselection=33

*         if !used('document')
*            select 14
*            use document index polid alias document
*         else
*            select document
*         endif
*         set order to tag dpid

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag iidno
         set filter to dcanceled=.t.

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

         IF !USED('icompany')
            select d
            use icompany index icompany alias icompany
         else
           select icompany
         endif
         set order to tag iidno

         select client
         set relation to acctno into policy
         set skip to policy

         select policy
         SET ORDER TO TAG IIDNO
         set relation to iidno  into icompany
*         select document
*         set relation to dpid into policy
*          set relation to dpid into document additive
*          set skip to document
          set order to tag acctno

select client
*set order to tag lastn
set skip to policy,icompany

GO TOP
*browse fields client.acctno,policy.acctno,policy.dpid,policy.iidno,icompany.iidno,ICOMPANY.INAME
        go top
        do case
           case outp=1
                do preview with "canclp","(CTOD(POLICY.FROM)>={"+DTOC(date1)+"} and CTOD(POLICY.FROM)<={"+DTOC(date2)+"})"
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                report form canclp for (CTOD(POLICY.FROM)>=date1 and CTOD(POLICY.FROM)<=date2) to print noconsole
                wait clear
*           CASE OUTP=3
*                do LASER with "cancel","(document->recdate>={"+dtoc(date1)+"} .and. document->recdate<={"+dtoc(date2)+"} .and. document->doctype='*CANCEL*')"
        endcase
        set relation to
        set filter to

   case moselection=34

         IF !USED('icompany')
            select d
            use icompany index icompany alias icompany
         else
           select icompany
         endif
         set order to tag iidno

         if !used('comision')
            select 12
            use comision index comision alias comision
         else
            select comision
         endif
         set order to tag dpid
         SET FILTER TO CODE<>2

         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif
         set order to tag iidno

         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno
         set filter to acctno>0

*         select client
*         set relation to acctno into policy
**         set skip to policy
*         select policy
*         set relation to dpid into comision
**         set skip to comision
*         select client
*         set order to tag lastn
*         set skip to policy,comision
*set order to tag lastn

        select icompany
        set relation to iidno into policy

        select policy
        set order to tag dpid
        set relation to dpid into comision
        set order to tag acctno
        set relation to acctno into client additive
        set skip to comision
        set order to tag iidno

        select icompany
        set skip to policy,comision
        set order to tag iname


         go top
*browse fields icompany.iname,icompany.iidno,policy.iidno,policy.acctno,client.acctno,client.lastn,policy.dpid,comision.dpid
         do case
            case outp=1
                  a=fname('temp.txt')
                  do preview with "comco","(comision.date>={"+dtoc(date1)+"} and comision.date<={"+dtoc(date2)+"})"
           case outp=2
                 do prnchoic
                 wait window "Now Printing" nowait
                 report form comco for (comision.date>=date1 and comision.date<=date2) to print noconsole
                 wait clear
         endcase
         select policy
         set order to tag policyno
         set relation to
         select client
         set order to tag acctno
         set relation to
         set filter to
   otherwise
   		?? chr(7)
   		Wait window "There is no report #"+alltrim(str(moselection)) nowait     
endcase
set printer to lpt1:
close databases
return




***************************************************************************
*                  report preamble
***************************************************************************
procedure repselect
parameter moselection
do case
   case moselection=1
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=2
          save screen to repsc
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=3
          save screen to repsc
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=4
          save screen to repsc
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=5
          save screen to repsc
*          outp=spf()
*          if outp<1 or outp>4
*             return
*          endif
          wait window "One Moment" nowait
          outp=1
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=6
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=7
          save screen to repsc
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=8
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=9
          save screen to repsc
*          outp=spf()
*          if outp<1 or outp>4
*             return
*          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,1
   case moselection=10
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=11
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=12
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=13
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=14 && comisions quick reports
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=15
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=16
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=17
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=18
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=19
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=20
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=21
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=22
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=23
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=24
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=25
          save screen to repsc
*          do getdate
           date1={  /  /  }
           date2={  /  /  }
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=26
          save screen to repsc
*          do getdate
           date1={  /  /  }
           date2={  /  /  }
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=27
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=28
          save screen to repsc
*          do getdate
           date1={  /  /  }
           date2={  /  /  }
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=29
          save screen to repsc
*          do getdate
           date1={  /  /  }
           date2={  /  /  }
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=30
          save screen to repsc
*          do getdate
           date1={  /  /  }
           date2={  /  /  }
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=31
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=32
          save screen to repsc
*          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=33
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   case moselection=34
          save screen to repsc
          do getdate
          outp=spf()
          if outp<1 or outp>4
             return
          endif
          wait window "One Moment" nowait
          do finalreps with moselection,date1,date2,outp
          wait clear
          restore screen from repsc
   otherwise
   		?? chr(7)
                Wait window "There is no report #"+alltrim(str(moselection)) nowait
endcase
return

