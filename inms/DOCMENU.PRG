parameter pid
set procedure to 'various'
set exclusive off
mnumber=policy.acctno
mrecipient=.f.
msender=.f.
msendate={  /  /  }
mrecdate={  /  /  }
mcmnt=space(70)
mcmnt2=space(70)
mcmnt3=space(70)
mdoctype=space(20)
mdsender=space(40)

define window wdrv at 1,1 size 25,81 in desktop float shadow grow noclose ;
	color scheme 10 Title "Drivers Section" font "FixedSys",9
	
activate window wdrv	
set color to 
clear

if !used('document')
   select 14
   use document index polid alias document
else
   select document
endif
set order to tag dpid
go top
seek pid
if !found()
   ?? chr(7)
   wait window "No Documents found for this policy" timeout 1
   wait window "Press any key to add one"
   set color to 
   clear
   tf=adddoc()
   if !tf
      return
   endif
endif

set color to 
clear
set filter to dpid=pid


go bottom

do ddpislay
do docoptions
set filter to
deactivate window wdrv	
return


******************************************************************************
*                    Procedure Document options
******************************************************************************
Procedure docoptions
  DEACTIVATE  MENU docmenu
  DEFINE MENU docmenu BAR AT LINE 1 COLOR SCHEME 4
  DEFINE PAD Add        OF docmenu  PROMPT '\<Add'
*  DEFINE PAD Find       OF docmenu  PROMPT 'F\<ind'
  DEFINE PAD Options    OF docmenu  PROMPT '\<Options'
  DEFINE PAD First      OF docmenu  PROMPT '\<First'
  DEFINE PAD Previous   OF docmenu  PROMPT '\<Previous'
  DEFINE PAD Next       OF docmenu  PROMPT '\<Next'
  DEFINE PAD Last       OF docmenu  PROMPT '\<Last'
  DEFINE PAD Edit       OF docmenu  PROMPT '\<Edit'
  DEFINE PAD Delete     OF docmenu  PROMPT '\<Delete'
  DEFINE PAD Undelete   OF docmenu  PROMPT '\<UnDelete'
  DEFINE PAD Quit       OF docmenu  PROMPT '\<Quit'

  ON SELECTION MENU docmenu DO imenu with dresult

dresult=-1
do while dresult<>0
  mpad=icurrentpad(dresult)
  ACTIVATE MENU docmenu pad (mpad)
  mpad=icurrentpad(dresult)
  show MENU docmenu pad (mpad)
  if lastkey()=27
     dresult=-1
  endif
    do case
     case dresult=1
          skip -1
          if bof('document')
             Wait window 'This is the FIRST Document' nowait
             go top
          endif
          do ddpislay
     case dresult=2
           skip
           if eof('document')
              wait window 'This is the LAST Document' nowait
              go bottom
           endif
           do ddpislay
     case dresult=3
          ilocked=docedit()
          select document
          if ( (ilocked=.t.) and (lastkey() # 27) )
                 do putdocdata
          endif
          unlock in document
          do ddpislay
     case dresult=4
            rec=recno()
            do docoptmenu
            goto rec
            do ddpislay
     case dresult=5
          tf=acertain('DELETE REALLY?',.f.)
          if ( (tf=.t.) and !recused('document',recno()) )
             delete
             unlock in document

     * Activity posting
     MINVOICENO=0
     MACCTNO   =mnumber
     MTRANCODE =9903
     MQTY      =1
     MPRICE    =0
     MTOTAL    =0
     MDATE     =date()
     MCLERK    =''
     MDESCRIPT ="Document Deleted"
     MPOSTED   =.f.
     MBILLED   =.f.
     MCHECKNO  =''
     DVID      ="00"

             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )
          select document
          endif
          do ddpislay
     case dresult=6
          recall
          do ddpislay
     case dresult=7
          go top
          do ddpislay
     case dresult=8
          go bottom
          do ddpislay
     case dresult=9
          do adddoc
          do ddpislay
     case dresult=10
            rec=recno()
            tf=findit()
            if tf=.f.
               goto rec
            endif
            do ddpislay
     case dresult=-1
*	   wait window 'Watch It' nowait
  endcase
enddo
hide menu docmenu
DEACTIVATE MENU docmenu
RELEASE MENU docmenu
return



******************************************************************************
*                    Procedure findit
******************************************************************************
function findit
private tf,indata
indata=space(20)
tf=.f.

set color to
define window cinfo from 8,5 to 12,67 color scheme 1 double float shadow in desktop
activate window cinfo
@ 1,5 say 'Please enter Insurance Name' get indata picture replicate('X',25) size 1,25
read
set exact off
locate for iname=alltrim(upper(indata))
set exact on
if found()
   tf=.t.
else
    wait window "No such document" nowait
endif
deactivate window cinfo
release window cinfo
return tf

******************************************************************************
*                    Procedure document Display
******************************************************************************
procedure ddpislay
set color to gr+/b
clear

mrecipient=recipient
msender=sender
msendate=sendate
mrecdate=recdate

mcmnt=stuff(mcmnt, 1,len(comment), comment)
mcmnt2=stuff(mcmnt2,1,len(comment2),comment2)
mcmnt3=stuff(mcmnt3,1,len(comment3),comment3)

mdoctype=doctype
mdsender=dsender

*@ 4,4 TO 20,74 DOUBLE
@ 14,11 SAY "Comment:"
@ 8,16 SAY "Date in Effect:"
@ 8,42 SAY "Date in Effect:"
@ 5,42 SAY "Recipient:"
@ 5,19 SAY "Sender:"
@ 12,23 SAY "Document type:"
@ 13,12 Say "Sender:" get mdsender disabled 
set color to
@ 5,30 GET msender DEFAULT .F.  PICTURE "@L Y;N" when mrecipient=.f. disabled 
@ 5,54 GET mrecipient DEFAULT .F.  PICTURE "@L Y;N" when msender=.f.  disabled 
@ 8,30 GET msendate  SIZE 1,10 DEFAULT {  /  /  } when msender=.t.    disabled 
@ 8,57 GET mrecdate sIZE 1,10  DEFAULT {  /  /  } when mrecipient=.t. disabled 
@ 12,38 GET mdoctype SIZE 1,20  default " "  disabled 
@ 15,5 GET mcmnt disabled 
@ 16,5 GET mcmnt2 disabled 
@ 17,5 GET mcmnt3 disabled 
clear gets

set color to gr+/b
@ 0,0 say space(80)
=center(0,"DOCUMENT INFORMATION")
set color to r+/b
if deleted('document')
  ??chr(7)
  set color to 
  =center(3,"WARNING! This Record has been marked for deletion")
else
  SET COLOR TO gr+/b
  @ 3,0 say space(80)
endif

set reprocess to 1
if lock(alltrim(str(recno())),'document')=.f.
   ?? chr(7)
   wait window 'This Company is edited by Another User' timeout 1
   ?? chr(7)
   wait window 'The Information in this Record might Change' timeout 1
endif
unlock in document
set reprocess to 1
return






******************************************************************************
*                    Procedure Document Add
******************************************************************************
function adddoc
set color to 

tf=.t.
set color to gr+/n
@ 0,0 say space(80)
=center(0,"ADDING DOCUMENT")
set color to 
@ 23,0 say space(80)
@ 24,0 say space(80)
=center(24,"Press F10 to Accept Entry")

set color to gr+/b, w/bg+
@ 5,5 to 16,73 clear
on key label f10 keyboard "{CTRL+w}"
mrecipient=.f.
msender=.f.
msendate={  /  /  }
mrecdate={  /  /  }
mcmnt='Non payment of $'+space(54)
mdoctype='CANCELLATION'
mdsender=space(40)
mdsender=left(ALLTRIM(icompany->iname),40)

*@ 4,4 TO 20,74 DOUBLE
@ 14,11 SAY "Comment:"
@ 5,30 GET msender      DEFAULT .F.  PICTURE "@L Y;N" when mrecipient=.f.
@ 5,54 GET mrecipient  DEFAULT .F.  PICTURE "@L Y;N" when msender=.f.
@ 8,16 SAY "Date in Effect:"
@ 8,30 GET msendate  SIZE 1,10 DEFAULT {  /  /  } when msender=.t.
@ 8,42 SAY "Date in Effect:"
@ 8,57 GET mrecdate sIZE 1,10  DEFAULT {  /  /  } when mrecipient=.t.
@ 5,42 SAY "Recipient:"
@ 5,19 SAY "Sender:"
@ 12,23 SAY "Document type:"
@ 12,38 GET mdoctype SIZE 1,20  DEFAULT " "
@ 13,12 Say "Sender:" get mdsender
@ 15,5 GET mcmnt
@ 16,5 GET mcmnt2
@ 17,5 GET mcmnt3
read cycle
if msender=.f.
   msendate={  /  /  }
endif
if  mrecipient=.f.
    mrecdate={  /  /  }
endif
on key label f10

tf=.f.
if lastkey() # 27
   TF=ACERTAIN('ACCEPT  THIS  ENTRY?',.t.)
   IF TF=.T.
      append blank
      rec=recno()
      if !lock(alltrim(str(rec)),'document')
          wait window 'Fatal: Cannot lock new record for Insurance'
          ?? chr(7)
          cancel
          tf=.f.
      endif
     set color to 

replace dpid with pid,;
        recipient with   mrecipient,;
        sender    with   msender,;
        sendate   with   msendate,;
        recdate   with   mrecdate ,;
        comment   with   alltrim(upper(mcmnt)),;
        comment2   with   alltrim(upper(mcmnt2)),;
        comment3   with   alltrim(upper(mcmnt3)),;
        doctype   with   alltrim(upper(mdoctype)),;
        dsender   with   alltrim(upper(mdsender))
     unlock in document


     * Activity posting
     MINVOICENO=0
     MACCTNO   =mnumber
     MTRANCODE =6700
     MQTY      =1
     MPRICE    =0
     MTOTAL    =0
     MDATE     =date()
     MCLERK    =''
     MDESCRIPT ="Document Added"
     MPOSTED   =.f.
     MBILLED   =.f.
     MCHECKNO  =''
     DVID      ="00"

             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )
     select document
   ENDIF
endif
return tf




******************************************************************************
*                    Procedure Insurance Edit
******************************************************************************
function docedit
set color to 

ilocked=.f.
if lock(alltrim(str(recno())),'document')=.f.
   wait window 'This Account is edited by Another User Try Again Later'
   ilocked =.f.
   return ilocked
else
   ilocked=.t.
endif

set color to gr+/b
clear
@ 0,0 say space(80)
=center(0,"EDITING DOCUMENT")
@ 23,0 say space(80)
@ 24,0 say space(80)
=center(24,"Press F10 to Accept Entry")

on key label f10 keyboard "{CTRL+w }"

mrecipient=recipient
msender=sender
msendate=sendate
mrecdate=recdate
 mcmnt=stuff(mcmnt, 1,len(comment), comment)
mcmnt2=stuff(mcmnt2,1,len(comment2),comment2)
mcmnt3=stuff(mcmnt3,1,len(comment3),comment3)
mdoctype=doctype
mdsender=dsender

*@ 4,4 TO 20,74 DOUBLE
@ 14,11 SAY "Comment:"
@ 8,16 SAY "Date in Effect:"
@ 8,42 SAY "Date in effect:"
@ 5,42 SAY "Recipient:"
@ 5,19 SAY "Sender:"
@ 12,23 SAY "Document type:"
@ 13,12 Say "Sender:" get mdsender
set color to
@ 5,30 GET msender      DEFAULT .F.  PICTURE "@L Y;N" when mrecipient=.f.
@ 5,54 GET mrecipient  DEFAULT .F.  PICTURE "@L Y;N"  when msender=.f.
@ 8,30 GET msendate  SIZE 1,10 DEFAULT {  /  /  } when msender=.t.
@ 8,57 GET mrecdate sIZE 1,10  DEFAULT {  /  /  } when mrecipient=.t.
@ 12,38 GET mdoctype SIZE 1,20  DEFAULT " "
@ 15,5 GET mcmnt
@ 16,5 GET mcmnt2
@ 17,5 GET mcmnt3
read cycle
if msender=.f.
   msendate={  /  /  }
endif
if  mrecipient=.f.
    mrecdate={  /  /  }
endif
on key label f10
set color to gr+/b
return ilocked






******************************************************************************
*                    Procedure Insurance Options
******************************************************************************

procedure docoptmenu

define window docoption from 8,15 to 24,60 double in desktop ;
       title 'AVAILLABLE OPTIONS';
       color gr+/b,gr+/b,gr+/b,gr+/b ,gr+/b ,gr+/b ,gr+/b ,gr+/b ;
       shadow float
activate window docoption
private optopt

optopt=0
do while optopt # 7
set color to 
@  1,4 prompt ' A. List Documents on Screen '
@  3,4 prompt ' B. List Documents to Printer'
@  5,4 prompt ' C. Choose Printer Device    '
@  7,4 prompt ' D. Selection D              '
@  9,4 prompt ' E. Selection E              '
@ 11,4 prompt ' F. Selection F              '
@ 13,4 prompt ' Q. Quit Options Menu        '

menu to optopt
if lastkey()=27
   deactivate window docoption
   release window docoption
   return
endif

do case
   case optopt=1
        =setpglen()
*        report form doclist preview
        do preview with "doclist",""
   case optopt=2
        define window patient from 8,20 to 10,70 TItle ' WORKING ' ;
               color w/rb+,w/rb+,w/rb+,w/rb+,w/rb+,w/rb+,w/rb+,w/rb+,w/rb+,w/rb+ ;
               float shadow
        activate window patient
        =center(0,'Please be patient PRINTING in Progress')
        =setpglen()
        report form doclist to print noconsole
        ?? chr(7)
        wait window 'Printing is done' nowait
        deactivate window patient
        release window patient
   case optopt=3
         do prnchoic
   case optopt=4
         WAIT WINDOW 'Selection D'
   case optopt=5
         WAIT WINDOW 'Selection E'
   case optopt=6
         WAIT WINDOW 'Selection F'
endcase
enddo
deactivate window docoption
release window docoption
return

return







******************************************************************************
*                    Procedure Put Document Data
******************************************************************************
procedure putdocdata

if !used('document')
   select 14
   use document index polid alias document
else
   select document
endif
replace dpid with pid,;
        recipient with   mrecipient,;
        sender    with   msender,;
        sendate   with   msendate,;
        recdate   with   mrecdate ,;
        comment   with   alltrim(Upper(mcmnt)),;
        comment2   with   alltrim(Upper(mcmnt2)),;
        comment3   with   alltrim(Upper(mcmnt3)),;
        doctype   with   alltrim(Upper(mdoctype)),;
        dsender   with   alltrim(upper(mdsender))

             * Activity posting
     MINVOICENO=0
     MACCTNO   =mnumber
     MTRANCODE =6702
     MQTY      =1
     MPRICE    =0
     MTOTAL    =0
     MDATE     =date()
     MCLERK    =''
     MDESCRIPT ="Document Edited"
     MPOSTED   =.f.
     MBILLED   =.f.
     MCHECKNO  =''
     DVID      ="00"

             =POST_ACT(MINVOICENo,MACCTNO,MTRANCODE,MQTY,MPRICE,MTOTAL,;
                       MDATE,MCLERK,MDESCRIPT,MPOSTED,MBILLED,MCHECKNO,DVID )

     select document
return


******************************************************************************
*                    function iCurrentPad
******************************************************************************
Function icurrentpad
parameter dresult
private mpad,tf

do case
   case      dresult=1
             mpad='PREVIOUS'
   case      dresult=2
             mpad='NEXT'
   case      dresult=3
             mpad='EDIT'
   case      dresult=4
             mpad='OPTIONS'
   case      dresult=5
             mpad='DELETE'
   case      dresult=6
             mpad='UNDELETE'
   case      dresult=0
             mpad='QUIT'
   case      dresult=7
             mpad='FIRST'
   case      dresult=8
             mpad='LAST'
   case      dresult=9
             mpad='ADD'
   case      dresult=10
             mpad='FIND'
   case      dresult=-1
             mpad='Repeat'
endcase
RETURN mpad


******************************************************************************
*                    Procedure imenu
******************************************************************************
Procedure imenu
parameter dresult
private mpad,tf

   mpad=space(4)
   mpad=pad()
     result=-1
   if mpad='PREVIOUS'
           dresult=1
   endif
   if mpad='NEXT'
           dresult=2
   endif
   if mpad='EDIT'
           dresult=3
   endif

   if mpad='OPTIONS'
           dresult=4
   endif
   if mpad='DELETE'
           dresult=5
   endif
   if mpad='UNDELETE'
           dresult=6
   endif
   if mpad='QUIT'
           dresult=0
   endif
   if mpad='FIRST'
           dresult=7
   endif
   if mpad='LAST'
           dresult=8
   endif
   if mpad='ADD'
           dresult=9
   endif
   if mpad='FIND'
           dresult=10
   endif
   if lastkey()=27
      dresult=-1
   endif
RETURN



