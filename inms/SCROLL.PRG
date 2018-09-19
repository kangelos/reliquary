*** A program example of popup MENUS ***
SET STATUS OFF
SET ECHO OFF
SET TALK OFF
SET MESSAGE TO 24
*** Initialize the array for the menu bar ***
DIMENSION TOP(3,2)
TOP(1,1) = '  FILE  '
TOP(2,1) = '  EDIT  '       
TOP(3,1) = '  DATA  ' 
TOP(1,2) = 'FILE SELECTIONS'
TOP(2,2) = 'EDIT SELECTIONS'      
TOP(3,2) = 'DATA SELECTIONS' 
*** Dimension and initialize an array for the File menu ***
DIMENSION M_FILE(7)
M_FILE(1) = '\<NEW'
M_FILE(2) = '\<OPEN'
M_FILE(3) = '\<CLOSE'
M_FILE(4) = '\-'					&& Insert a line between items
M_FILE(5) = '\<SAVE'
M_FILE(6) = '\<PRINT'
M_FILE(7) = '\<QUIT'

*** Dimension and initialize an array  for the Edit menu ***
DIMENSION M_EDIT(5)
M_EDIT(1) = '\<COPY'
M_EDIT(2) = '\<FIND'
M_EDIT(3) = '\<REPLACE'
M_EDIT(4) = '\<UNDO'
M_EDIT(5) = 'C\<LEAR'
*** Dimension and initialize an array for the Data menu ***
DIMENSION M_DATA(9)
M_DATA(1) = '\<BROWSE' 
M_DATA(2) = '\<APPEND' 
M_DATA(3) = '\<SORT' 
M_DATA(4) = '\<JOIN'
M_DATA(5) = '\-'					&& Insert a line between menu items
M_DATA(6) = '\<TOTAL'
M_DATA(7) = 'A\<VERAGE'
M_DATA(8) = '\<COUNT'
M_DATA(9) = 'S\<UM'

*** Install the pull-down menu system 
MENU BAR TOP,3					&& Install menu bar
MENU 1,M_FILE,7,7				&& Install file menu into menu bar
MENU 2,M_EDIT,5,5				&& Install edit menu into menu bar
MENU 3,M_DATA,9,9				&& Install data menu into menu bar
*** Initialize the placement of the menu option ***
COL = 1
ROW = 1
*** Activate the pull-down menu system ***
READ MENU BAR TO COL, ROW SAVE 
CLEAR


