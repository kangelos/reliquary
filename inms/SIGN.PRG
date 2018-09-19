FUNCTION Sign
PARAMETER Ln,Y,X, Sld, Tim
PRIVATE Cnt, M, N, MxRws, MxCol, Mxltr, Fl
*	Parameters are:
*	Ln - The string you want converted
*	Y - The vertical position (0-18)
*	X - The horizontal position (0-[79-9*len(Ln)])
*	Sld - Slide, (T)op, (B)ottom, (L)eft, (R)ight
*	Tim - Time delay (Seconds) between updates
*
*	Written by R.L. Coppedge
*	Copyright 1991 dbF Software Productions
*	By the way, dbF also has:
*	SysTrak		A Computer Hardware/Software Inventory System
*	Flags		A Flatfile Application Gen. for db3,4 and Fox
*	ClasAdz		A Classified/Notice system for Networks
*	FoxTails #1	A collection of FoxPro tools (like this one)
*	Contact dbF for more information.
*	dbF Software Productions
*	P.O. Box 37194
*	Cleve., Ohio 44137-0194
*	CIS: 72117,165
*	(216)491-4581
*
*
*	This code may be modified, but leave this original notice up
*	here intact, if ya don't mind.  (Add your own comments about
*	how much better you made it if you like)
MxRws = WROWS()
MxCol = WCOLS()
Mxltr = INT(MxCol/8)
Fl = .F.
IF TYPE('LN')<>"C"
	WAIT "Must be a character string!" WINDOW
   	Fl = .T.
ENDIF
IF EMPTY(Ln)
	WAIT "Empty string...no display generated" WINDOW
	Fl = .T.
ENDIF
IF LEN(Ln) > MxLtr
	WAIT "Too cotton-picking long!  Truncating to "+ALLTRIM(STR(Mxltr))+" chars" WINDOW
	Ln = LEFT(Ln,Mxltr)
ENDIF
IF Y> MxRws-6
	WAIT ALLTRIM(STR(Y))+" is too low a position" WINDOW
	Fl = .T.
ENDIF
IF X>MxCol-9*LEN(Ln)
	WAIT "Too far to the right for the string" WINDOW
	Fl = .T.
ENDIF
IF Fl
        DEFINE WINDOW Err FROM 5,5 TO 18,55 DOUBLE;
               float shadow
	ACTIVATE WINDOW Err
	@0,5 SAY "Height of active window (min=6): " + ALLTRIM(STR(MxRws))
	@1,5 SAY "Width of active window: " + ALLTRIM(STR(MxCol))
	@2,5 SAY "Maximum Letters for window: " + ALLTRIM(STR(MxLtr))
	@3,5 SAY "You Requested:"
	@4,5 SAY "Length of String: " + ALLTRIM(STR(LEN(Ln)))
	@5,5 SAY "At Row: " + ALLTRIM(STR(Y))
	@6,5 SAY "And Column: " + ALLTRIM(STR(X))
	@7,5 SAY "Which would allow " + ALLTRIM(STR(INT((MxCol-X)/9)))+ " letters"
	@8,5 SAY "To actually show..."
	@10,5 SAY "Think about it..."
	WAIT WINDOW
	DEACTIVATE WINDOW Err
	RELEASE WINDOW Err
	RETURN
ENDIF
*Ln = UPPER(Ln)          &&      We're lazy and didn't put the lower case in yet
Y=IIF(TYPE('Y')="L",2,Y)	&&	Set defaults, if not passed
X=IIF(TYPE('X')="L",5,X)
Sld=IIF(TYPE('Sld')="L"," ",Sld)
Tim=IIF(TYPE('Tim')="L",0,Tim)
SET TALK OFF
STORE "" TO Y0,Y1,Y2,Y3,Y4,Y5
FOR Cnt = 1 TO LEN(Ln)	&&	Loop for all characters in string Ln
	Char = SUBSTR(Ln,Cnt,1)		&&	This is the latest letter to translate
	DO CASE
	CASE Char = "A"
	X0 = "±€€€€€ ±±"
	X1 = "€ ±±±±€ ±"
	X2 = "€€€€€€€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€ ±±±±€ ±"


        CASE Char = "n"
        X2 = "€€€€€€ ±±"
        X3 = "€ ±±±±€ ±"
        X4 = "€ ±±±±€ ±"
        X5 = "€ ±±±±€ ±"
        X0 = "±±±±±±±±±"
        X1 = "±±±±±±±±±"

	CASE Char = "B"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€€€€€€€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€€€€€€€ ±"


	CASE Char = "C"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€ ±±±±±±±"
	X3 = "€ ±±±±±±±"
	X4 = "€ ±±±±€ ±"
	X5 = "€€€€€€€ ±"

	CASE Char = "D"
	X0 = "€€€€€€ ±±"
	X1 = "€ ±±±±€ ±"
	X2 = "€ ±±±±€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€€€€€€ ±±"

	CASE Char = "E"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±±±±"
	X2 = "€€€€€ ±±±"
	X3 = "€ ±±±±±±±"
	X4 = "€ ±±±±±±±"
        X5 = "€€€€€€€ ±"


	CASE Char = "F"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±±±±"
	X2 = "€€€€€ ±±±"
	X3 = "€ ±±±±±±±"
	X4 = "€ ±±±±±±±"
	X5 = "€ ±±±±±±±"

	CASE Char = "G"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€ ±±±±±±±"
	X3 = "€ ±±±€€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€€€€€€€ ±"

	CASE Char = "H"
	X0 = "€ ±±±±€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€€€€€€€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€ ±±±±€ ±"

	CASE Char = "I"
	X0 = "€€€€€€€ ±"
	X1 = "±±±€ ±±±±"
	X2 = "±±±€ ±±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±±€ ±±±±"
	X5 = "€€€€€€€ ±"

	CASE Char = "J"
	X0 = "€€€€€€€ ±"
	X1 = "±±±€ ±±±±"
	X2 = "±±±€ ±±±±"
	X3 = "±±±€ ±±±±"
	X4 = "€±±€ ±±±±"
	X5 = "€€€€ ±±±±"

	CASE Char = "K"
	X0 = "€ ±±€ ±±±"
	X1 = "€ €€ ±±±±"
	X2 = "€€€ ±±±±±"
	X3 = "€€€ ±±±±±"
	X4 = "€ ±€ ±±±±"
	X5 = "€ ±±€ ±±±"


	CASE Char = "L"
	X0 = "€ ±±±±±±±"
	X1 = "€ ±±±±±±±"
	X2 = "€ ±±±±±±±"
	X3 = "€ ±±±±±±±"
	X4 = "€ ±±±±±±±"
	X5 = "€€€€€€€ ±"

	CASE Char = "M"
	X0 = "€€ ±±€€ ±"
	X1 = "€ € € € ±"
	X2 = "€ ±€ ±€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€ ±±±±€ ±"

        CASE Char = "N"
	X0 = "€€ ±±±€ ±"
	X1 = "€ € ±±€ ±"
	X2 = "€ ±€ ±€ ±"
	X3 = "€ ±±€ € ±"
	X4 = "€ ±±±€€ ±"
	X5 = "€ ±±±±€ ±"

	CASE Char = "O"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€ ±±±±€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€€€€€€€ ±"

	CASE Char = "P"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€€€€€€€ ±"
	X3 = "€ ±±±±±±±"
	X4 = "€ ±±±±±±±"
	X5 = "€ ±±±±±±±"


	CASE Char = "Q"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€ ±±±±€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±€€ ±"
	X5 = "€€€€€€€ ±"

	CASE Char = "R"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€€€€€€€ ±"
	X3 = "€ ±±±€ ±±"
	X4 = "€ ±±±±€ ±"
	X5 = "€ ±±±±€ ±"

	CASE Char = "S"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±±±±"
	X2 = "€€€€€€€ ±"
	X3 = "±±±±±±€ ±"
	X4 = "±±±±±±€ ±"
	X5 = "€€€€€€€ ±"

	CASE Char = "T"
	X0 = "€€€€€€€ ±"
	X1 = "±±±€ ±±±±"
	X2 = "±±±€ ±±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±±€ ±±±±"
	X5 = "±±±€ ±±±±"


	CASE Char = "U"
	X0 = "€ ±±±±€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€ ±±±±€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€€€€€€€ ±"

	CASE Char = "V"
	X0 = "±€ ±±±±€ ±"
	X1 = "±€ ±±±±€ ±"
	X2 = "±€ ±±±±€ ±"
	X3 = "±±€ ±±€ ±±"
	X4 = "±±±€ € ±±±"
	X5 = "±±±€€€ ±±±"

	CASE Char = "W"
	X0 = "€ ±±±±€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€ ±€ ±€ ±"
	X3 = "€ € € € ±"
	X4 = "€€ ±±€€ ±"
	X5 = "€€ ±±€€ ±"

	CASE Char = "X"
	X0 = "€ ±±±±€ ±"
	X1 = "±€ ±±€ ±±"
	X2 = "±±€ € ±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±€ € ±±±"
	X5 = "€€ ±±€€ ±"
	

	CASE Char = "Y"
	X0 = "€ ±±±±€ ±"
	X1 = "±€ ±±€ ±±"
	X2 = "±±€ € ±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±±€ ±±±±"
	X5 = "±±±€ ±±±±"

	CASE Char = "Z"
	X0 = "€€€€€€€ ±"
	X1 = "±±±±±€€ ±"
	X2 = "±±±€€ ±±±"
	X3 = "±±€€ ±±±±"
	X4 = "€€€ ±±±±±"
	X5 = "€€€€€€€ ±"

******************************Greek Letters *********************************

        CASE Char = "Ä"
	X0 = "±€€€€€ ±±"
	X1 = "€ ±±±±€ ±"
	X2 = "€€€€€€€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€ ±±±±€ ±"


        CASE Char = "Å"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€€€€€€€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€€€€€€€ ±"

        CASE Char = "Ç"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€ ±±±±±±±"
	X3 = "€ ±±±±±±±"
        X4 = "€ ±±±±±±±"
        X5 = "€ ±±±±±±±"

        CASE Char = "É"
        X0 = "±±€€€ ±±±"
        X1 = "±€ ±±€ ±±"
        X2 = "€ ±±±±€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
        X5 = "€€€€€€€ ±"


        CASE Char = "Ñ"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±±±±"
	X2 = "€€€€€ ±±±"
	X3 = "€ ±±±±±±±"
	X4 = "€ ±±±±±±±"
        X5 = "€€€€€€€ ±"


        CASE Char = "Ö"
	X0 = "€€€€€€€ ±"
	X1 = "±±±±±€€ ±"
	X2 = "±±±€€ ±±±"
	X3 = "±±€€ ±±±±"
	X4 = "€€€ ±±±±±"
	X5 = "€€€€€€€ ±"

        CASE Char = "Ü"
	X0 = "€ ±±±±€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€€€€€€€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€ ±±±±€ ±"


        CASE Char = "á"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
        X2 = "€€€€€€€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€€€€€€€ ±"

        CASE Char = "à"
	X0 = "€€€€€€€ ±"
	X1 = "±±±€ ±±±±"
	X2 = "±±±€ ±±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±±€ ±±±±"
	X5 = "€€€€€€€ ±"

        CASE Char = "â"
	X0 = "€ ±±€ ±±±"
	X1 = "€ €€ ±±±±"
	X2 = "€€€ ±±±±±"
	X3 = "€€€ ±±±±±"
	X4 = "€ ±€ ±±±±"
	X5 = "€ ±±€ ±±±"

        CASE Char = "ä"
        X0 = "±±€€€ ±±±"
        X1 = "±€ ±±€ ±±"
        X2 = "€ ±±±±€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
        X5 = "€ ±±±±€ ±"

        CASE Char = "ã"
	X0 = "€€ ±±€€ ±"
	X1 = "€ € € € ±"
	X2 = "€ ±€ ±€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€ ±±±±€ ±"

        CASE Char = "å"
	X0 = "€€ ±±±€ ±"
	X1 = "€ € ±±€ ±"
	X2 = "€ ±€ ±€ ±"
	X3 = "€ ±±€ € ±"
	X4 = "€ ±±±€€ ±"
	X5 = "€ ±±±±€ ±"


        CASE Char = "ç"
	X0 = "€€€€€€€ ±"
        X1 = "±±±±±±±±±"
        X2 = "±€€€€€ ±±"
        X3 = "±±±±±±±±±"
        X4 = "±±±±±±±±±"
	X5 = "€€€€€€€ ±"

        CASE Char = "é"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€ ±±±±€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€€€€€€€ ±"

        CASE Char = "è"
	X0 = "€€€€€€€ ±"
        X1 = "€ ±±±±€ ±"
        X2 = "€ ±±±±€ ±"
        X3 = "€ ±±±±€ ±"
        X4 = "€ ±±±±€ ±"
        X5 = "€ ±±±±€ ±"


        CASE Char = "ê"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€€€€€€€ ±"
        X3 = "€ ±±±±±±±"
        X4 = "€ ±±±±±±±"
        X5 = "€ ±±±±±±±"


        CASE Char = "ë"
	X0 = "€€€€€€€ ±"
        X1 = "±±€±±±±±±"
        X2 = "±±±€€ ±±±"
        X3 = "±±€ ±±±±±"
        X4 = "±€ ±±±±±±"
        X5 = "€€€€€€€ ±"


        CASE Char = "í"
	X0 = "€€€€€€€ ±"
	X1 = "±±±€ ±±±±"
	X2 = "±±±€ ±±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±±€ ±±±±"
	X5 = "±±±€ ±±±±"


        CASE Char = "ì"
	X0 = "€ ±±±±€ ±"
	X1 = "±€ ±±€ ±±"
	X2 = "±±€ € ±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±±€ ±±±±"
	X5 = "±±±€ ±±±±"

        CASE Char = "î"
        X0 = "±±±€ ±±±±"
        X1 = "±€€€€€ ±±"
        X2 = "€ ±€ ±€ ±"
        X3 = "€ ±€ ±€ ±"
        X4 = "±€€€€€ ±±"
        X5 = "±±±€ ±±±±"

        CASE Char = "ï"
	X0 = "€ ±±±±€ ±"
	X1 = "±€ ±±€ ±±"
	X2 = "±±€ € ±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±€ € ±±±"
	X5 = "€€ ±±€€ ±"
	
        CASE Char = "ñ"
        X0 = "€ ±€ ±€ ±"
        X1 = "€ ±€ ±€ ±"
        X2 = "€ ±€ ±€ ±"
        X3 = "±€€€€€ ±±"
        X4 = "±±±€ ±±±±"
        X5 = "±±±€ ±±±±"

        CASE Char = "ó"
        X1 = "±€€€€€ ±±"
        X2 = "€ ±±±±€ ±"
        X3 = "€ ±±±±€ ±"
        X4 = "±€€€€€ ±±"
        X5 = "±±±±±±±±±"
        X5 = "€€€€€€€ ±"

	CASE Char = " "
	X0 = "±±±±±±±±±"
	X1 = "±±±±±±±±±"
	X2 = "±±±±±±±±±"
	X3 = "±±±±±±±±±"
	X4 = "±±±±±±±±±"
	X5 = "±±±±±±±±±"

	CASE Char = "0"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±€ € ±"
	X2 = "€ ±€ ±€ ±"
	X3 = "€ € ±±€ ±"
	X4 = "€€ ±±±€ ±"
	X5 = "€€€€€€€ ±"

	CASE Char = "1"
	X0 = "€€€€ ±±±±"
	X1 = "±±±€ ±±±±"
	X2 = "±±±€ ±±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±±€ ±±±±"
	X5 = "€€€€€€€ ±"

	CASE Char = "2"
	X0 = "€€€€€€€ ±"
	X1 = "±±±±±±€ ±"
	X2 = "€€€€€€€ ±"
	X3 = "€ ±±±±±±±"
	X4 = "€ ±±±±±±±"
	X5 = "€€€€€€€ ±"

	CASE Char = "3"
	X0 = "€€€€€€€ ±"
	X1 = "±±±±±±€ ±"
	X2 = "€€€€€€€ ±"
	X3 = "±±±±±±€ ±"
	X4 = "±±±±±±€ ±"
	X5 = "€€€€€€€ ±"

	CASE Char = "4"
	X0 = "€ ±±±±€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€€€€€€€ ±"
	X3 = "±±±±±±€ ±"
	X4 = "±±±±±±€ ±"
	X5 = "±±±±±±€ ±"

	CASE Char = "5"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±±±±"
	X2 = "€ ±±±±±±±"
	X3 = "€€€€€€€ ±"
	X4 = "±±±±±±€ ±"
	X5 = "€€€€€€€ ±"

	CASE Char = "6"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±±±±"
	X2 = "€€€€€€€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€€€€€€€ ±"

	CASE Char = "7"
	X0 = "€€€€€€€ ±"
	X1 = "±±±±±±€ ±"
	X2 = "±±±±±±€ ±"
	X3 = "±±±±±±€ ±"
	X4 = "±±±±±±€ ±"
	X5 = "±±±±±±€ ±"

	CASE Char = "8"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€€€€€€€ ±"
	X3 = "€ ±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€€€€€€€ ±"

	CASE Char = "9"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±±±±€ ±"
	X2 = "€€€€€€€ ±"
	X3 = "±±±±±±€ ±"
	X4 = "€ ±±±±€ ±"
	X5 = "€€€€€€€ ±"

	CASE Char = "!"
	X0 = "±±±€ ±±±±"
	X1 = "±±±€ ±±±±"
	X2 = "±±±€ ±±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±±±±±±±±"
	X5 = "±±±€ ±±±±"

	CASE Char = "."
	X0 = "±±±±±±±±±"
	X1 = "±±±±±±±±±"
	X2 = "±±±±±±±±±"
	X3 = "±±±±±±±±±"
	X4 = "±±±±±±±±±"
	X5 = "±±±€ ±±±±"

	CASE Char = ","
	X0 = "±±±±±±±±±"
	X1 = "±±±±±±±±±"
	X2 = "±±±±±±±±±"
	X3 = "±±±±±±±±±"
	X4 = "±±±€ ±±±±"
	X5 = "±±€€ ±±±±"

	CASE Char = ";"
	X0 = "±±±±±±±±±"
	X1 = "±±±±±±±±±"
	X2 = "±±±€ ±±±±"
	X3 = "±±±±±±±±±"
	X4 = "±±±€ ±±±±"
	X5 = "±±€€ ±±±±"


	CASE Char = ":"
	X0 = "±±±±±±±±±"
	X1 = "±±±±±±±±±"
	X2 = "±±±€ ±±±±"
	X3 = "±±±±±±±±±"
	X4 = "±±±€ ±±±±"
	X5 = "±±±±±±±±±"

	CASE Char = "="
	X0 = "±±±±±±±±±"
	X1 = "±±±±±±±±±"
	X2 = "±€€€€€€ ±"
	X3 = "±±±±±±±±±"
	X4 = "±€€€€€€ ±"
	X5 = "±±±±±±±±±"

	CASE Char = "'"
	X0 = "±±±±±±±±±"
	X1 = "±±±€€ ±±±"
	X2 = "±±±±€ ±±±"
	X3 = "±±±±±±±±±"
	X4 = "±±±±±±±±±"
	X5 = "±±±±±±±±±"

	CASE Char = '"'
	X0 = "±±±±±±±±±"
	X1 = "±€€ ±€€ ±"
	X2 = "±±€ ±±€ ±"
	X3 = "±±±±±±±±±"
	X4 = "±±±±±±±±±"
	X5 = "±±±±±±±±±"

	CASE Char = "?"
	X0 = "±€€€€€€ ±"
	X1 = "±±±±±±€ ±"
	X2 = "±±±€€€€ ±"
	X3 = "±±±€ ±±±±"
	X4 = "±±±±±±±±±"
	X5 = "±±±€ ±±±±"

	CASE Char = "$"
	X0 = "€€€€€€€ ±"
	X1 = "€ ±€ ±±±±"
	X2 = "€€€€€€€ ±"
	X3 = "±±±€ ±€ ±"
	X4 = "±±±€ ±€ ±"
	X5 = "€€€€€€€ ±"

	CASE Char = "^"
	X0 = "±±±±€ ±±±"
	X1 = "±±±€ € ±±"
	X2 = "±±€ ±±€ ±"
	X3 = "±±±±±±±±±"
	X4 = "±±±±±±±±±"
	X5 = "±±±±±±±±±"

	CASE Char = "|"
	X0 = "±±±€ ±±±±"
	X1 = "±±±€ ±±±±"
	X2 = "±±±±±±±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±±€ ±±±±"
	X5 = "±±±±±±±±±"

	CASE Char = "+"
	X0 = "±±±€ ±±±±"
	X1 = "±±±€ ±±±±"
	X2 = "±€€€€€ ±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±±€ ±±±±"
	X5 = "±±±±±±±±±"

	CASE Char = "-"
	X0 = "±±±±±±±±±"
	X1 = "±±±±±±±±±"
	X2 = "±€€€€€ ±±"
	X3 = "±±±±±±±±±"
	X4 = "±±±±±±±±±"
	X5 = "±±±±±±±±±"

	CASE Char = "\"
	X0 = "€ ±±±±±±±"
	X1 = "±€ ±±±±±±"
	X2 = "±±€ ±±±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±±±€ ±±±"
	X5 = "±±±±±€ ±±"
	
	CASE Char = "/"
	X0 = "±±±±±±€ ±"
	X1 = "±±±±±€ ±±"
	X2 = "±±±±€ ±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±€ ±±±±±"
	X5 = "±€ ±±±±±±"
	
	CASE Char = "%"
	X0 = "±±±±±±€ ±"
	X1 = "±€ ±±€ ±±"
	X2 = "±±±±€ ±±±"
	X3 = "±±±€ ±±±±"
	X4 = "±±€ ±±€ ±"
	X5 = "±€ ±±±±±±"
	
	CASE Char = "`"
	X0 = "±±±±±±±±±"
	X1 = "±±±±€€ ±±"
	X2 = "±±±±€ ±±±"
	X3 = "±±±±±±±±±"
	X4 = "±±±±±±±±±"
	X5 = "±±±±±±±±±"

	CASE Char = "_"
	X0 = "±±±±±±±±±"
	X1 = "±±±±±±±±±"
	X2 = "±±±±±±±±±"
	X3 = "±±±±±±±±±"
	X4 = "±±±±±±±±±"
	X5 = "€€€€€€€ ±"

	CASE Char $ "[{("
	X0 = "±±€€€€€ ±"
	X1 = "±±€ ±±±±±"
	X2 = "±±€ ±±±±±"
	X3 = "±±€ ±±±±±"
	X4 = "±±€ ±±±±±"
	X5 = "±±€€€€€ ±"

	CASE Char $ "]})"
	X0 = "±±€€€€€ ±"
	X1 = "±±±±±±€ ±"
	X2 = "±±±±±±€ ±"
	X3 = "±±±±±±€ ±"
	X4 = "±±±±±±€ ±"
	X5 = "±±€€€€€ ±"

	CASE Char $ "#"
	X0 = "±±€ ±±€ ±±"
	X1 = "±€€€€€€€ ±"
	X2 = "±±€ ±±€ ±±"
	X3 = "±€€€€€€€ ±"
	X4 = "±±€ ±±€ ±±"
	X5 = "±±€ ±±€ ±±"


	ENDCASE
	Y0 = Y0 + X0
	Y1 = Y1 + X1
	Y2 = Y2 + X2
	Y3 = Y3 + X3
	Y4 = Y4 + X4
	Y5 = Y5 + X5
ENDFOR
*	Now we've built all 6 strings....it's display time!
DO CASE
	CASE UPPER(Sld) = "R"
	FOR N = 1 TO LEN(Y0)
		@ Y,X+(LEN(Y0)-N-1) SAY LEFT(Y0,N)
		@ Y+1,X+(LEN(Y0)-N-1) SAY LEFT(Y1,N)
		@ Y+2,X+(LEN(Y0)-N-1) SAY LEFT(Y2,N)
		@ Y+3,X+(LEN(Y0)-N-1) SAY LEFT(Y3,N)
		@ Y+4,X+(LEN(Y0)-N-1) SAY LEFT(Y4,N)
		@ Y+5,X+(LEN(Y0)-N-1) SAY LEFT(Y5,N)
*                for wai=1 to 500
*                endfor
	ENDFOR

	CASE UPPER(Sld) = "L"
	FOR N = 1 TO LEN(Y0)
		@ Y,X-1 SAY RIGHT(Y0,N)
		@ Y+1,X-1 SAY RIGHT(Y1,N)
		@ Y+2,X-1 SAY RIGHT(Y2,N)
		@ Y+3,X-1 SAY RIGHT(Y3,N)
		@ Y+4,X-1 SAY RIGHT(Y4,N)
		@ Y+5,X-1 SAY RIGHT(Y5,N)
*                 for wai=1 to 500
*                 endfor
	ENDFOR

	CASE UPPER(Sld) = "B"
	FOR N = 5 TO 0 STEP -1
		Nn = ALLTRIM(STR(N))
		@ Y+N,X SAY Y&Nn.
*                 for wai=1 to 500
*                 endfor
	ENDFOR

	CASE UPPER(Sld) = "T"
	FOR N = 0 TO 5
		Nn = ALLTRIM(STR(N))
		@ Y+N,X SAY Y&Nn.
*                 for wai=1 to 500
*                 endfor
	ENDFOR

	OTHERWISE
	@ Y,X SAY Y0
	@ Y+1,X SAY Y1
	@ Y+2,X SAY Y2
	@ Y+3,X SAY Y3
	@ Y+4,X SAY Y4
	@ Y+5,X SAY Y5
ENDCASE
RETURN
