CLEAR
DEFINE MENU mainmenu BAR AT LINE 1

DEFINE PAD invoices  OF mainmenu PROMPT '\<INVOICES' 
DEFINE PAD customers OF mainmenu PROMPT '\<CUSTOMERS' 
DEFINE PAD inventory OF mainmenu PROMPT 'I\<NVENTORY'
DEFINE PAD payments  OF mainmenu PROMPT '\<PAYMENTS'
DEFINE PAD quit OF   mainmenu PROMPT '\<QUIT'

on selection pad invoices  of mainmenu wait window "invoices"
on selection pad customers of mainmenu wait window "customers"
on selection pad inventory of mainmenu wait window "inventory"
on selection pad payments  of mainmenu wait window "payments"
on selection pad quit      of mainmenu do quit

activate menu mainmenu

proc quit
deac menu mainmenu
release menu mainmenu
return
