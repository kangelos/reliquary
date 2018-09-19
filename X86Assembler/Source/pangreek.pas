
{COPYRIGHT ANGELOS KARAGEORGIOU FEB 1990
 CAPITAL GREEK LETTERS FOR PANASONIC KXP 1091
 THIS PROGRAM WILL DOWNLOAD THE PRINTER WITH GREEK CAPITAL LETTERS
 STARTING AT LOCATION 128 DECIMAL IN THE ASCII CHART. SMALL CASE
 LETTERS MISSING BECAUSE PANASONIC CAN ONLY DOWNLOAD 40 CHARS}

PROGRAM DOWNLOAD_PANASONIC_GREEK_CAPITALS;
USES PRINTER,crt;
VAR PRINT:text;
    i:integer;
BEGIN

 ASSIGN(PRINT,'PRN');
 REWRITE(PRINT);
 Writeln('Make sure printer is ok and press any key');
 repeat until keypressed;

{DOWNLOAD THE CHARACTERS ONE AT A TIME }
Write(PRINT,Chr(27),Chr(Ord('y')),Chr(128),
Chr(30),Chr(32),Chr(72),Chr(128),Chr(72),Chr(32),Chr(30),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(129),
Chr(254),Chr(0),Chr(146),Chr(0),Chr(146),Chr(0),Chr(146),Chr(108),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(130),
Chr(254),Chr(0),Chr(128),Chr(0),Chr(128),Chr(0),Chr(128),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(131),
Chr(30),Chr(32),Chr(66),Chr(128),Chr(66),Chr(32),Chr(30),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(132),
Chr(254),Chr(0),Chr(146),Chr(0),Chr(146),Chr(0),Chr(130),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(133),
Chr(130),Chr(4),Chr(138),Chr(16),Chr(162),Chr(64),Chr(130),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(134),
Chr(254),Chr(0),Chr(16),Chr(0),Chr(16),Chr(0),Chr(254),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(135),
Chr(124),Chr(130),Chr(16),Chr(130),Chr(16),Chr(130),Chr(124),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(136),
Chr(0),Chr(0),Chr(130),Chr(124),Chr(130),Chr(0),Chr(0),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(137),
Chr(254),Chr(0),Chr(16),Chr(40),Chr(68),Chr(130),Chr(0),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(138),
Chr(30),Chr(32),Chr(64),Chr(128),Chr(64),Chr(32),Chr(30),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(139),
Chr(254),Chr(0),Chr(64),Chr(32),Chr(64),Chr(0),Chr(254),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(140),
Chr(254),Chr(0),Chr(64),Chr(32),Chr(16),Chr(0),Chr(254),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(141),
Chr(198),Chr(16),Chr(130),Chr(16),Chr(130),Chr(16),Chr(198),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(142),
Chr(124),Chr(130),Chr(0),Chr(130),Chr(0),Chr(130),Chr(124),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(143),
Chr(128),Chr(126),Chr(128),Chr(0),Chr(128),Chr(126),Chr(128),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(144),
Chr(254),Chr(0),Chr(144),Chr(0),Chr(144),Chr(0),Chr(96),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(145),
Chr(130),Chr(68),Chr(170),Chr(16),Chr(130),Chr(0),Chr(130),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(146),
Chr(128),Chr(0),Chr(128),Chr(126),Chr(128),Chr(0),Chr(128),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(147),
Chr(128),Chr(64),Chr(32),Chr(30),Chr(32),Chr(64),Chr(128),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(148),
Chr(112),Chr(136),Chr(0),Chr(254),Chr(0),Chr(136),Chr(112),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(149),
Chr(130),Chr(68),Chr(40),Chr(16),Chr(40),Chr(68),Chr(130),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(150),
Chr(224),Chr(16),Chr(0),Chr(254),Chr(0),Chr(16),Chr(224),Chr(0),Chr(0));

Write(PRINT,Chr(27),Chr(Ord('y')),Chr(151),
Chr(114),Chr(140),Chr(0),Chr(128),Chr(0),Chr(140),Chr(114),Chr(0),Chr(0));


{OK EVERYTHING DOWNLOADED. NOW MAKE SURE THAT THE PRINTER'S GOT THEM
 PRINT OUT THE SET FOR THE USER TO SEE}

for i:=128 to 255 do
write (print,i,' ',chr(i),' ');
close(print);
END.  {THAT'S ALL FOLKS}

