set exclusive on
set talk off
clear
set reprocess to 1
wait window "Opening control files" nowait


         if !used('SYSTEM')
            SELECT 25
            USE SYSTEM ALIAS SYSTEM
         ELSE
            SELECT SYSTEM
         ENDIF

users=getusers()
mallowed=system.allowed
if !file("exnames.mem")
   mallowed=0
else
    restore from exnames.mem additive
    if mallowed<>totusers
       mallowed=0
    endif
endif

wait window "Cleaning up" nowait

=putusers()
return

***************************************************************************
*                        get new account number
***************************************************************************
function getusers
private file,line,i,j,k,number

oldalias=alias()
if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif

go top

do while lock('1','system')=.f.
enddo

number=system.users
number=number+1
replace system.users with number
unlock in system

if len(alltrim(oldalias))>0
   select &oldalias
endif
return number


***************************************************************************
*                        get new account number
***************************************************************************
function putusers
private file,line,i,j,k,number

if !used('system.dbf')
   select 25
   use system alias system
else
    select system
endif

go top

do while lock('1','system')=.f.
enddo

number=0
replace system.users with number
unlock in system
return number
