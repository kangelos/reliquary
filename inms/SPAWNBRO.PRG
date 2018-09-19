parameter selection


release window cinfo
close databases
do case

case selection=0
                             if !used('client')
                                select a
                                use client index client alias client
                             else
                                 select client
                             endif
                             set order to tag acctno

                             indata=space(25)
                             set color to w/rb+,w/bg+
                             clear gets
                             indata=space(25)
                             IF !WEXIST('CINFO')
                                define window cinfo from 9,1 to 14,77 color scheme 10 double shadow in desktop font "Arial",11 Title "Relationship Browser"
                             ENDIF
                             activate window cinfo
                             @ 1,5 say "Please enter Some Letters of the Clients' Last Name" get indata picture replicate('X',25) size 1,15 color ,w+/bg
                             read
                             deactivate window cinfo


                             if !used('VEHICLE')
                                select B
                                use VEHICLE index VEHICLE alias VEHICLE
                             else
                                 select vehicle
                             endif
                             set order to tag vin

                             IF !USED('coverage')
                                select c
                                use coverage index coverage alias coverage
                             else
                               select coverage
                             endif
                             set order to tag vin

                             select vehicle
                             set order to tag vin
                             set relation to vin into coverage additive
                             set skip to coverage

                             if !used('POLICY')
                                select e
                                use POLICY index POLICY alias POLICY
                             else
                                 select policy
                             endif
                             set order to tag acctno



                             select vehicle
                             set order to tag acctno
                             select client
                             set relation to acctno into vehicle
                             set skip to vehicle

                    select client
*                    set order to tag acctno
                    set relation to acctno into policy additive
                    set skip to vehicle,policy

*                    set
*                    cancel
                    if wexist('cli1')
                       release window browsewin
                    endif
                    if wexist('cli2')
                       release window browsewin
                    endif
                    if wexist('cli3')
                       release window browsewin
                    endif
                    if wexist('cli4')
                       release window browsewin
                    endif
                    define window cli1 from  1,0 to  6,79 system float grow close  COLOR SCHEME 10
                    define window cli2 from  6,0 to 12,79 system float grow close COLOR SCHEME 10
                    define window cli3 from 13,15 to 18,64 system float grow close COLOR SCHEME 10
                    define window cli4 from 19,0 to 23,79 system float grow close COLOR SCHEME 10
                    select vehicle
                    browse window cli2 nowait fields vehicle.year,;
                                                     vehicle.make,;
                                                     vehicle.plates,;
                                                     vehicle.vin,;
                                                     vehicle.modst:h="Style";
                                                     nomodify nomenu
                    select coverage
                    browse window cli3 nowait fields coverage.acctno,;
                                                     coverage.vin,;
                                                     coverage.dtotal;
                                                     nomodify nomenu
                    select policy
                    browse window cli4 nowait fields policyno,;
                                              from,;
                                              to,;
                                              dpremium;
                                                     nomodify nomenu
                    select client
                    set order to lastn
                    IF LEN(ALLTRIM(INDATA))>0
                    browse window cli1 fields acctno,lastn,firstn,;
                                  add:h='Address',;
                                  phoneh ;
                                                     nomodify nomenu;
                                  FOR upper(ALLTRIM(INDATA)) $ LASTN
                    ELSE
                    browse window cli1 fields acctno,lastn,firstn,;
                                  add:h='Address',;
                                  phoneh;
                                                     nomodify nomenu
                    ENDIF

release window cli1
release window cli2
release window cli3
release window cli4


case selection=1
                             if !used('client')
                                select a
                                use client index client alias client
                             else
                                 select client
                             endif
                             set order to tag acctno

                             if !used('VEHICLE')
                                select B
                                use VEHICLE index VEHICLE alias VEHICLE
                             else
                                 select vehicle
                             endif
                             set order to tag ACCTNO

                    select client
                    set relation to acctno into VEHICLE additive
                    set skip to vehicle
                    SET ORDER TO TAG LASTN

                    if wexist('browsewin')
                       release window browsewin
                    endif
                    define window browsewin from 2,4 to 22,74 system float grow close SHADOW COLOR SCHEME 10 in desktop font "Arial",11 Title "Relationship Browser"
                    ?? chr (7)
                    wait window "Press <ESC> when done" nowait
                       browse fields client->acctno:4:h="Acct",;
                                  client->lastn:15:h="Last Name",;
                                  vehicle->year:4:h= "Year"   ,;
                                  vehicle->make:10:h ="Car's Make",;
                                  vehicle->vin:h ="Vehicle ID Number",;
                                  vehicle->plates:h ="Plates";
                                  nomodify nomenu window browsewin;
                                  title "Vehicles Per Customer";
                                  color SCHEME 10
case selection=2
                             if !used('VEHICLE')
                                select B
                                use VEHICLE index VEHICLE alias VEHICLE
                             else
                                 select vehicle
                             endif
                             set order to tag vin

                             IF !USED('coverage')
                                select c
                                use coverage index coverage alias coverage
                             else
                               select coverage
                             endif
                             set order to tag vin

                    select vehicle
                    SET RELATION TO vin INTO COVERAGE ADDITIVE
                    set skip to coverage

                    if wexist('browsewin')
                       release window browsewin
                    endif
                    define window browsewin from 2,5 to 22,74 system float grow close SHADOW COLOR SCHEME 10 in desktop  font "Arial",11 Title "Relationship Browser"
                    ?? chr (7)
                    wait window "Press <ESC> when done" nowait
                       browse fields  vehicle->year:4:h= "Year"   ,;
                                  vehicle->make:10:h ="Car's Make",;
                                  vehicle->vin:h ="Vehicle ID Number",;
                                  vehicle->plates:h ="Plates",;
                                  coverage->dtotal:h="Premium",;
                                  coverage->iidno:h="Ins Co";
                                  nomodify nomenu window browsewin;
                                  title "Premiums Per Vehicle";
                                  color SCHEME 10
case selection=3
                             IF !USED('icompany')
                                select d
                                use icompany index icompany alias icompany
                             else
                               select icompany
                             endif
                             set order to tag iidno

                             IF !USED('coverage')
                                select c
                                use coverage index coverage alias coverage
                             else
                               select coverage
                             endif
                             set order to tag iidno

                    select icompany
                    SET RELATION TO iidno INTO COVERAGE ADDITIVE
                    set skip to coverage

                    if wexist('browsewin')
                       release window browsewin
                    endif
                    define window browsewin from 2,15 to 22,62 system float grow close SHADOW COLOR SCHEME 10 in desktop  font "Arial",11 Title "Relationship Browser"
                    ?? chr (7)
                    wait window "Press <ESC> when done" nowait
                       browse fields icompany->iidno:6:h="Co #",;
                                  icompany->iname:25:h="Company Name",;
                                  coverage->dtotal:h="Premium";
                                  nomodify nomenu window browsewin;
                                  title "Premiums Per Insurance Company";
                                  color SCHEME 10
case selection=4
                             IF !USED('icompany')
                                select d
                                use icompany index icompany alias icompany
                             else
                               select icompany
                             endif
                             set order to tag iidno

                             if !used('POLICY')
                                select e
                                use POLICY index POLICY alias POLICY
                             else
                                 select policy
                             endif
                             set order to tag iidno



                    select icompany
                    set relation to iidno into policy additive
                    set skip to policy

                    if wexist('browsewin')
                       release window browsewin
                    endif
                    define window browsewin from 2,7 to 22,70 system float grow close SHADOW COLOR SCHEME 10 in desktop  font "Arial",11 Title "Relationship Browser"
                    ?? chr (7)
                    wait window "Press <ESC> when done" nowait
                       browse fields icompany->iidno:6:h="Co #",;
                                  icompany->iname:25:h="Company Name",;
                                  policy->policyno:15:h="Policy Number",;
                                  policy->dpremium:h="Premium";
                                  nomodify nomenu window browsewin;
                                  title "Policies Per Insurance Company";
                                  color SCHEME 10
case selection=5
                             if !used('client')
                                select a
                                use client index client alias client
                             else
                                 select client
                             endif
                             set order to tag acctno

                             IF !USED('coverage')
                                select c
                                use coverage index coverage alias coverage
                             else
                               select coverage
                             endif
                             set order to tag ACCTNO

                    select client
                    SET RELATION TO acctno INTO COVERAGE ADDITIVE
                    set skip to coverage
                    SET ORDER TO TAG LASTN

                    if wexist('browsewin')
                       release window browsewin
                    endif
                    define window browsewin from 2,15 to 22,64 system float grow close SHADOW COLOR SCHEME 10 in desktop  font "Arial",11 Title "Relationship Browser"
                    ?? chr (7)
                    wait window "Press <ESC> when done" nowait
                       browse fields client->acctno:h="Acct",;
                                  client->lastn:15:h="Last Name",;
                                  coverage->dtotal:h="Premium",;
                                  coverage->iidno:h="Ins Co";
                                  nomodify nomenu window browsewin;
                                  title "Premiums Per Customer";
                                  color SCHEME 10
case selection=6
                             if !used('client')
                                select a
                                use client index client alias client
                             else
                                 select client
                             endif
                             set order to tag acctno

                             if !used('POLICY')
                                select e
                                use POLICY index POLICY alias POLICY
                             else
                                 select policy
                             endif
                             set order to tag acctno



                    select client
                    set relation to acctno into policy additive
                    set skip to policy
                    SET ORDER TO TAG LASTN

                    if wexist('browsewin')
                       release window browsewin
                    endif
                    define window browsewin from 2,4 to 22,74 system float grow close SHADOW COLOR SCHEME 10 in desktop  font "Arial",11 Title "Relationship Browser"
                    ?? chr (7)
                    wait window "Press <ESC> when done" nowait
                       browse fields client->acctno:4:h="Acct",;
                                  client->lastn:15:h="Last Name",;
                                  policy->policyno:15:h="Policy Number",;
                                  policy->dpremium:8:h="Premium",;
                                  policy->from:h="  From",;
                                  policy->to:h="     To";
                                  nomodify nomenu window browsewin;
                                  title "Policies Per Customer";
                                  color SCHEME 10
case selection=7
                             if !used('VEHICLE')
                                select B
                                use VEHICLE index VEHICLE alias VEHICLE
                             else
                                 select vehicle
                             endif
                             set order to tag vin

                             IF !USED('coverage')
                                select c
                                use coverage index coverage alias coverage
                             else
                               select coverage
                             endif
                             set order to tag dpid

                             if !used('POLICY')
                                select e
                                use POLICY index POLICY alias POLICY
                             else
                                 select policy
                             endif
                             set order to tag dpid


                    select coverage
                    set relation to vin into vehicle
                    select policy
                    SET RELATION TO dpid INTO COVERAGE ADDITIVE
                    set skip to coverage

                    if wexist('browsewin')
                       release window browsewin
                    endif
                    define window browsewin from 2,5 to 22,74 system float grow close SHADOW COLOR SCHEME 10 in desktop  font "Arial",11 Title "Relationship Browser"
                    ?? chr (7)
                    wait window "Press <ESC> when done" nowait
                       browse fields policy->policyno:19:h="Policy Number",;
                                     policy->from:h="   From",;
                                     policy->to:h="     TO",;
                                     coverage->dtotal:8:h="Premium",;
                                     vehicle->year:4:h= "Year"   ,;
                                     vehicle->make:10:h ="Car's Make";
                                  nomodify nomenu window browsewin;
                                  title "Premiums Per Policy";
                                  color SCHEME 10
endcase
close data
release window browsewin
return
