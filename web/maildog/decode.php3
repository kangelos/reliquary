<?
function decode_mime_string ($string) {
   if (eregi("=?([A-Z,0-9,-]+)?([A-Z,0-9,-]+)?([A-Z,0-9,-,=,_]+)?=", $string)) {
      $coded_strings = explode('=?', $string);
      $counter = 1;
      $string = $coded_strings[0]; /* add non encoded text that is before the encoding */
      while ($counter < sizeof($coded_strings)) {
         $elements = explode('?', $coded_strings[$counter]); /* part 0 = charset */

         /* part 1 == encoding */
         /* part 2 == encoded part */
         /* part 3 == unencoded part beginning with a = */
         /* How can we use the charset information? */

         if (eregi("Q", $elements[1])) {
            $elements[2] = str_replace('_', ' ', $elements[2]);
            $elements[2] = eregi_replace("=([A-F,0-9]{2})", "%\\1", $elements[2]);
            $string .= urldecode($elements[2]);
         } else { /* we should check for B the only valid encoding other then Q */
            $elements[2] = str_replace('=', '', $elements[2]);
            if ($elements[2]) { $string .= base64_decode($elements[2]); }
         }

         if (isset($elements[3]) && $elements[3] != '') {
            $elements[3] = ereg_replace("^=", '', $elements[3]);
            $string .= $elements[3];
         }
	$string .= " ";
         $counter++;
      }
   }
   return $string;
}



function fill_paragraphs($text, $wrap=80, $break="\n", $delim='+') {

   $lines = explode("\n", $text);
   $lines_size = sizeof($lines);

   $i = 0;

   while ($i < $lines_size) {
      if (strlen($lines[$i]) <= $wrap) {
         $result[] = $lines[$i];
         $i++;
      } else {
	$result[]=substr($tempresult,0,($wrap-$wspace));
       $lines[$i] = $delim . substr($lines[$i], $wrap, strlen($lines[$i]) - $wrap);
      }
   }

   return implode($break, $result);
}


?>
