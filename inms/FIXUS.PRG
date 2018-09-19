set exclusive on
set talk window
clear
file=fopen('cosmo.ans',0)
if file<0
   ? 'File not found cosmo.ans'
   ? 'bye'
   cancel
endif
=fclose(file)

run type cosmo.ans

         if !used('SYSTEM')
            SELECT 25
            USE SYSTEM ALIAS SYSTEM
         ELSE
            SELECT SYSTEM
         ENDIF

replace users with 0
