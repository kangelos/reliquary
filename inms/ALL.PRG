set exclusive on
set talk window
SET EXCLUSIVE ON
         if !used('client')
            select a
            use client index client alias client
         else
             select client
         endif

disp stru to file 'dbases.txt'
         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif

disp stru to file 'dbases.txt' additive
         IF !USED('coverage')
            select c
            use coverage index coverage alias coverage
         else
           select coverage
         endif

disp stru to file 'dbases.txt' additive
         IF !USED('icompany')
            select d
            use icompany index icompany alias icompany
         else
           select icompany
         endif

disp stru to file 'dbases.txt' additive
         if !used('POLICY')
            select e
            use POLICY index POLICY alias POLICY
         else
             select policy
         endif

disp stru to file 'dbases.txt' additive
         if !used('driver')
            select f
            use driver index driver alias driver
         else
             select driver
         endif

disp stru to file 'dbases.txt' additive
         if !used('codes')
            select g
            use codes index codenum alias codes
         else
             select codes
         endif

disp stru to file 'dbases.txt' additive
         if !used('adj')
            select h
            use adj index adjnum alias adjustment
         else
             select adjustment
         endif

disp stru to file 'dbases.txt' additive
         if !used('paycode')
            select i
            use paycode index paynum alias paycode
         else
             select paycode
         endif

disp stru to file 'dbases.txt' additive
         if !used('installm')
            select 11
            use installm index install alias installment
         else
            select installment
         endif

disp stru to file 'dbases.txt' additive
         if !used('documents')
            select 14
            use document index polid alias document
         else
            select document
         endif

disp stru to file 'dbases.txt' additive
         if !used('polhist')
            select 23
            use polhist
         else
             select polhist
         endif

disp stru to file 'dbases.txt' additive


         if !used('activity')
            SELECT 24
            USE ACTIVITY index activity,date ALIAS ACTIVITY
         ELSE
            SELECT ACTIVITY
         ENDIF

disp stru to file 'dbases.txt' additive
         if !used('SYSTEM')
            SELECT 25
            USE SYSTEM ALIAS SYSTEM
         ELSE
            SELECT SYSTEM
         ENDIF

disp stru to file 'dbases.txt' additive
         if !used('comision')
            select 12
            use comision index comision alias comision
         else
            select comision
         endif

disp stru to file 'dbases.txt' additive

       if !used('invoice')
          select 13
          use invoice index invoice alias invoice
       else
          select invoice
       endif


       if !used('reffer')
          select 15
          use reffer index reffer alias refferance
       else
          select refferance
       endif

disp stru to file 'dbases.txt' additive
