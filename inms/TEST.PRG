
for i =1 to 100
	=msgbox(str(i),"Test",i)
endfor	


set color to
define window sa at 4,5 size 10,30  title "What now" shadow float system grow font "TimesRoman" ,13 Style "B"
Activate window sa
lk=27
if lastkey()=27
   c=2
else
    c=3
endif
*do while lk=27
*   @ 1,1 prompt "   Save and Exit   "
*   @ 3,1 prompt "Exit without Saving"
*   @ 5,1 prompt "  Save and  print  "
*   menu to c
   ok=1
   @ 1,4 get c function '*R Save and Exit;Exit without Saving;Save and  Print' size 2,20
   @ 8,7 get ok Function '* OK' size 2,14
   read cycle   
*enddo


if !used('reffer')
     select 15
	use reffer index reffer alias refferance
else
      select refferance
endif
set order to tag ref_no
count to refsize
go top
dimension refarray[refsize,2]
select distinct ref_no,ref_name_from reffer into array refarray
go top

@ 2,1 get ref picture '@^' from refarray

STORE 0 TO mchoice
ACTIVATE SCREEN
CLEAR
@ 2,2  SAY REPLICATE(CHR(3),2)  && Hearts
@ 3,2  SAY REPLICATE(CHR(3),2)
@ 2,10 SAY REPLICATE(CHR(4),2)  && Diamonds
@ 3,10 SAY REPLICATE(CHR(4),2)
@ 2,18 SAY REPLICATE(CHR(5),2)  && Clubs
@ 3,18 SAY REPLICATE(CHR(5),2)
@ 2,26 SAY REPLICATE(CHR(6),2)  && Spades
@ 3,26 SAY REPLICATE(CHR(6),2)
@ 1,1,4,4    BOX
@ 1,9,4,12   BOX
@ 1,17,4,20  BOX
@ 1,25,4,28  BOX
*** The next line creates four invisible buttons and ***
*** executes the procedure SHOWCARD when a button is chosen. ***
@ 1,1 GET mchoice PICTURE '@*IH ;;;' SIZE 4, 4, 4 VALID SHOWCARD( ) MESSAGE 'Pick a card, any card!' ;
	COLOR ,,,,,R/W
READ CYCLE

PROCEDURE SHOWCARD   && procedure executed when a button is chosen
@ 6,1 CLEAR
DO CASE
	CASE _CUROBJ = 1		&& First button chosen
		@ 6,1 SAY 'Hearts'
	CASE _CUROBJ = 2		&& Second button chosen
		@ 6,9 SAY 'Diamonds'
	CASE _CUROBJ = 3		&& Third  button chosen
		@ 6,17 SAY 'Clubs'
	CASE _CUROBJ = 4		&& Fourth button chosen
		@ 6,25 SAY 'Spades'
ENDCASE
RETURN .T.



@ 2,27 GET okcancel PICTURE '@*HR \!OK;\?Cancel' SIZE 1,10,1 DEFAULT 0
read cycle






@ ... GETLists Example



SET TALK OFF
DEFINE WINDOW example FROM 4,3 TO 21,76 TITLE ' List Example ' ;
	FLOAT SHADOW SYSTEM COLOR SCHEME 8
*** Fill the array cityarray with city data ***
SELECT DISTINCT city FROM customer INTO ARRAY cityarray
SELECT customer
*** Define a popup that contains the structure of customer ***
DEFINE POPUP popstru PROMPT STRUCTURE SCROLL MARGIN MARK CHR(16)
*** Define a popup containing data from the company field ***
DEFINE POPUP popfield PROMPT FIELD company SCROLL MARGIN MARK CHR(16)
ACTIVATE WINDOW example
@ 1,3 SAY 'Structure Popup:'
*** Get information using predefined popstru popup ***
@ 2,2 GET liststructure POPUP popstru SIZE 11, 20;
	DEFAULT FIELD(1,'customer') WHEN refresh( );
	VALID dispitem(liststructure) COLOR SCHEME 9
@ 13,3 SAY liststructure SIZE 1, 18
@ 1,26 SAY 'Field Popup:'

*** Get information using predefined popfield popup ***
@ 2,25 GET listfield POPUP popfield SIZE 11, 20 ;
	DEFAULT company WHEN refresh( ) VALID dispitem(listfield) COLOR SCHEME 9
@ 13,26 SAY listfield SIZE 1, 18
@ 1,50 SAY 'Array of City Names:'
*** Get information using predefined array ***
@ 2,49 GET arrayitem FROM cityarray SIZE 11, 20 ;
	DEFAULT cityarray(1) WHEN refresh( ) VALID dispitem(arrayitem);
	COLOR SCHEME 9
@ 13,50 SAY arrayitem SIZE 1,18
@ 14,63 GET ok FUNCTION '*t \!OK' DEFAULT 1 SIZE 1, 6
READ CYCLE SHOW popshow( )  && Activate gets
RELEASE WINDOW example
RELEASE POPUPS popstru, popfield
FUNCTION refresh
*** Refresh window information without calling subroutine ***

SHOW GETS OFF
FUNCTION dispitem
*** Display which item has been chosen ***
PARAMETER item
WAIT WINDOW 'You have chosen: ' + ALLTRIM(item) NOWAIT
FUNCTION popshow
*** Display current items for each list ***
@ 13,3 SAY liststructure SIZE 1, 18
@ 13,26 SAY listfield SIZE 1, 18
@ 13,50 SAY arrayitem SIZE 1, 18



cancel
for i=1 to 10
    key=readkey()
    ? key
next

exit

         if !used('installm')
            select 11
            use installm index install alias installment
         else
            select installment
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

         if !used('VEHICLE')
            select B
            use VEHICLE index VEHICLE alias VEHICLE
         else
             select vehicle
         endif
         set order to tag dvehid


         IF !USED('coverage')
            select c
            use coverage index coverage alias coverage
         else
           select coverage
         endif
         set order to tag dvehid


select * from client a,policy b , coverage c , vehicle d , installm e ;
       where a.acctno=b.acctno
