parameter style
set procedure to various


*?? chr(7)
*wait window "If YOU don't KNOW what YOU are doing, don't touch this" timeout 3
*?? chr(7)
*wait window "You can DAMAGE the databases from in here" timeout 3



close databases
minvno=0
set color to gr+/r
@ 23,0 say space(80)
@ 24,0 say space(80)
=center(23,"Press <F9> to Toggle Invoice Isolation, <F10> to Print Copy")
=CENTER(24,"Codes Between 1 and 8 are PAYMENTS, anything else is a CHARGE")
on key label F9 keyboard "{ctrl+q}"
on key label F10 keyboard "{ctrl+end}"

      do case
         case style=1

       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif
       set order to tag acctno
	
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno


         select client
         set relation to acctno into invoice
         set skip to invoice
         set order to tag lastn

            if wexist('browsewin')
               release window browsewin
            endif
            define window browsewin at 2,2 size 20,80 in desktop system FLOAT SHADOW COLOR SCHEME 10;
            	font "Arial",11 Title "Invoice List by Name" 
            ?? chr (7)
            wait window "Press <ESC> when done" nowait
            lastk=1
            do while lastk<>27
               browse fields client->acctno:R:h="Acct",;
                          client->lastn:R:15:h="Last Name",;
                          invoice->dinvno:R:4:h="Invoice #",;
                          invoice->idate:h="Date",;
                          invoice->dcode:v=(dcode>0):h="Code",;
                          invoice->dprice:8:h="Amount",;
                          invoice->descript:17:h="Description";
                          nomodify nomenu window browsewin
               lastk=lastkey()
               DO CASE
               CASE lastk=17
                  IF LEN(ALLTRIM(FILTER('INVOICE')))=0
                  	 	 select invoice
                         minvno=invoice->dinvno
                         set filter to invoice->dinvno=minvno
                  ELSE
                  	   select invoice
                       SET FILTER TO
                       select client
                       set filter to                      	
                  ENDIF
               CASE lastk=23
                  do printinvoice
                  lastk=27
               ENDCASE
            enddo


case style=2
       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif
       set order to tag acctno
	
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif
         set order to tag acctno


         select invoice
         set relation to acctno into client
*         set relation to acctno into invoice
*         set skip to invoice

         select invoice
         set order to tag invno
         SET SKIP TO CLIENT

            if wexist('browsewin')
               release window browsewin
            endif
            define window browsewin at 2,2 size  20,80 system FLOAT SHADOW COLOR SCHEME 10;
            	Font "Arial",11 title "Invpice List by Number" in desktop
            ?? chr (7)
            wait window "Press <ESC> when done" nowait
            lastk=1
            do while lastk<>27
               browse fields invoice->dinvno:R:h="Invoice #",;
                          invoice->idate:h="Date",;
                          invoice->dcode:v=(dcode>0):h="Code",;
                          invoice->dprice:8:h="Amount",;
                          invoice->descript:17:h="Description",;
                          client->acctno:R:4:h="Acct",;
                          client->lastn:R:15:h="Last Name";
                          nomodify nomenu window browsewin
               lastk=lastkey()
               DO CASE
               CASE LASTK=17
                  IF LEN(ALLTRIM(FILTER('INVOICE')))=0
                         minvno=invoice->dinvno
                         set filter to invoice->dinvno=minvno
                  ELSE
                      SET FILTER TO
                  ENDIF
               CASE lastk=23
                  do printinvoice
                  lastk=27
               ENDCASE
            enddo
        endcase
on key label f9
on key label f10
close databases
return

***************************************************************************
*                        Procedure printinvoice
***************************************************************************
procedure printinvoice
wait clear
outp=spf()

SELECT INVOICE
minvno=invoice->dinvno
restore from comem.mem additive
        do case
           case outp=1
                do preview with "inv1","invoice->dinvno="+str(minvno)
           case outp=2
                do prnchoic
                wait window "Now Printing" nowait
                REPORT FORM INV1 FOR DINVNO=MINVNO TO PRINT NOCONSOLE
                wait clear
           case outp=1
                do LASER with "inv1","invoice->dinvno="+str(minvno)
        endcase
wait clear
return

