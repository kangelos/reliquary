!mode com2: baud=2400 parity=n data=8 stop=1 > nul:
set talk window
lastk=0
string2=space(50)
string=' '
port=fopen("COM2",12)
wait window "Handle"+str(port) NOWAIT
do while lastk<>27
   clear
   string2=space(50)
   @ 10,2 get string2
   read
   string2=alltrim(string2)
   lastk=lastkey()
   IF LASTK<>27
*   =fputs(port,alltrim(string2))
   FOR I=1 TO LEN(STRING2)
       =FWRITE(PORT,SUBSTR(STRING2,I,1))
       string=fREAD(port,1)
       ?? string
   ENDFOR
       =fwrite(port,chr(13))
       string=fREAD(port,1)
       ?? string
*   string=''
*   ? string
*   do while len(string) <> 0
*    string=fgets(port)
*    ?? string
*    string=fgets(port)
*    ?? string
*     FOR I=1 TO 100
*     ENDFOR
*        STRING=' '
    DO WHILE !feof(port)
       string=fREAD(port,1)
       ?? string
    ENDDO

*   enddo
   ENDIF
enddo
=fclose(port)
