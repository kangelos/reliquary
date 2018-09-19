
         if !used('codes')
            select g
            use codes index codenum alias codes
         else
             select codes
         endif
*         if !used('adj')
*            select h
*            use adj index adjnum alias adjustment
*         else
*             select adjustment
*         endif

         if !used('paycode')
            select i
            use paycode index paynum alias paycode
         else
             select paycode
         endif
set procedure to "various"
wait window "Please wait gathering Data" nowait
a=fname("codtemp.dbf")
if file(a)
   delete file (a)
endif
*select 20
create table &a (code n(6,0), name c(30),type c(15))
select paycode
go top
do while !eof('paycode')
select codtemp
append blank
replace code with val(paycode.dtype),;
        name with paycode.dpayname,;
        type with "PAYMENT"
select paycode
skip
enddo

*select adjustment
*go top
*do while !eof('adjustment')
*select codtemp
*append blank
*replace code with adjustment.dadjnum,;
*        name with adjustment.dadjname,;
*        type with "ADJUSTMENT"
*select adjustment
*skip
*enddo

select codes
go top
do while !eof('codes')
select codtemp
append blank
replace code with codes.dcdnum,;
        name with codes.dcdname,;
        type with "PRIVATE"
select codes
skip
enddo

wait clear

select codtemp
go top
*browse
*MODI REP CODES
SELECT codtemp
GO TOP
outp=spf()
       do case
          case outp=1
               do preview with "codes",""
          case outp=2
               do prnchoic
               wait window "Now Printing" nowait
               report form codes to print noconsole
          case outp=3
                DO LASER WITH "CODES",""
       endcase
wait clear

select codtemp
use
*delete file &a
return

