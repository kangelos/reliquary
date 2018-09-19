PARAMETER CO
FS75ID='23'
*******************
define window cinfo from 8,5 to 12,67 color SCHEME (CO) double  shadow in screen
activate window cinfo
@ 1,15 say 'Please enter ID number' get fs75id picture replicate('X',10) size 1,10
read
deactivate window cinfo
release window cinfo
return
