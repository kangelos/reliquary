/*****************************************************
 * A ridiculously oversimplified SMTP Java mailer
 * written as my first foray into java programming 
 * Released under the GPLv3 license get a copy from http://gplv3.fsf.org
 *
 * May 2009 angelos@unix.gr
 * http://www.unix.gr
 ****************************************************/

package javatests;

import java.io.*;
import java.net.Socket;
import java.lang.System.*;


public class Main {
 
    static public String host="";
    static public String from="";
    static public String msgFile="";
    static public String toAddr="";
    static public String subject="";
    static public boolean verbose=false;
    static public boolean debug=false;
    

  public static void main(String[] args) throws Exception {

    String ENVhost=System.getenv("SMTP_HOST");
    String ENVfrom=System.getenv("SMTP_FROM");
    String ENVmsgFile=System.getenv("SMTP_MSGFILE");

    if ( ENVmsgFile != null )   { msgFile=ENVmsgFile; }
    if ( ENVfrom != null )      { from=ENVfrom; }
    if ( ENVhost != null )      { host=ENVhost; }

    boolean parsed=parseArgs(args);

    if ( verbose || debug ){
        System.out.println("Using smtp server:" + host );
        System.out.println("Setting Originator Address to:"+from);
        System.out.println("Setting Recipient Address to:"+ toAddr);
         System.out.println("Setting Message Subject to:\""+subject+"\"" );
         System.out.println("Setting Message File to:"+msgFile );
        System.out.println("************************************************************************");
    }

    if ( host.equals("") || from.equals("") || host.equals("") ||( ! parsed) ){
        Usage("Missing Some Parameters");
        return;
    }


    //************************************************************************
    //                     Network part
    //************************************************************************
    Socket servSocket = new Socket(host, 25);
    DataOutputStream os = new DataOutputStream(servSocket.getOutputStream());
    BufferedReader sd =  new BufferedReader (new
            InputStreamReader(
                    servSocket.getInputStream()
             )
     );


   
    if (servSocket != null && os != null && sd == null) {
        System.err.println("Network error");
        return;
    }


    if ( debug )
    System.out.println("Connected to "+servSocket.getInetAddress()+" on port "
        + servSocket.getPort()+" from port "+servSocket.getLocalPort()+" of "
        + servSocket.getLocalAddress());

      
      // Negotiation
      if ( ! sendlinereadresp("","220",os,sd) ) { return; }
      if ( ! sendlinereadresp("HELO RidOvJavMailer","250",os,sd) ) { return; }
      if ( ! sendlinereadresp("MAIL From: <" + from +">","250",os,sd)) { return; }
      String[] recipients=toAddr.split(",");
      for (String recipient: recipients) {
        if ( ! sendlinereadresp("RCPT To: <"+ recipient +">" ,"250", os,sd) ) { return ;}
      }
      
      if ( !sendlinereadresp("DATA", "354", os,sd))  { return; }

      // Header of the message Part
      sendline("X-Mailer: RidOvJavMailer",os);
      sendline("X-Author: angelos@unix.gr",os);
      sendline("X-web-Url: http://www.unix.gr",os);
      sendline("From:" + from,os);
      sendline("To:" + toAddr,os);
      sendline("Subject: " + subject ,os);
      sendline("Content-Type: text/plain; charset=UTF-8\r\n",os);



      // Body part
    if (!msgFile.equals("")){
        readMsgFileSendtoSock(msgFile,os);
    } else {
        readStdinSendtoSock(os);
    }

      // Requiem
      if ( ! sendlinereadresp("\r\n\r\n.","250", os,sd) ) { return ; }
      if ( ! sendlinereadresp("QUIT","221", os,sd) ) { return ; }
      
          System.out.println("Message sent!");
    }

     // *****************************************************
     // Send a line to the SMTP server
     // *****************************************************
  public static void sendline(String mytext, DataOutputStream os)
                                                    throws IOException {
         os.writeBytes(mytext);
         os.writeBytes("\r\n"); // always append that
         if (verbose)
            System.out.println("<" + mytext);
     }



    //*******************************************************************
    /* sends an SMTP strings expects certain result code */
    //*******************************************************************
     public static boolean sendlinereadresp(String mytext, String expectedCode,
                  DataOutputStream os,BufferedReader sd) throws IOException {

         if ( mytext.length() >0 ) {
            os.writeBytes(mytext);
            os.writeBytes("\r\n");
            if (verbose)
                System.out.println("<" + mytext);
         }

        String response= sd.readLine();
        if (response == null ) {
            System.err.println("SMTP timed out or protocol error");
            return (false);
        }
        if ( verbose)
            System.out.println(">" + response);
        
        String tokens[]=response.split("[ \t]");
        if (! tokens[0].equals(expectedCode)){
                System.err.println("Bad SMTP response:"+response);        
                return(false);
        }        
        return(true);
     }

/*****************************************************************************
 * Read and parse the command line arguments
 * @param args
 * @return none
 ****************************************************************************/
    static boolean parseArgs(String[] args){
        boolean ok=false;
        int i=0;
        while (i < args.length && args[i].startsWith("-")){
            ok=false;
                if (  args[i].equalsIgnoreCase("-verbose") || args[i].equalsIgnoreCase("-v") ){
                    verbose=true;                   
                    ok=true;
                }
            if (  args[i].equalsIgnoreCase("-debug") || args[i].equalsIgnoreCase("-d") ){
                    verbose=true;
                    ok=true;
                }
                if (  args[i].equalsIgnoreCase("-from") || args[i].equalsIgnoreCase("-f") ){
                    from=args[++i];
                    ok=true;
                }
                if (  args[i].equalsIgnoreCase("-to") || args[i].equalsIgnoreCase("-t") ){
                    toAddr=args[++i];
                    ok=true;
                }
                if (  args[i].equalsIgnoreCase("-host") || args[i].equalsIgnoreCase("-h") ){
                    host=args[++i];
                    ok=true;;
                }
                if (  args[i].equalsIgnoreCase("-subject") || args[i].equalsIgnoreCase("-s") ){
                    subject=args[++i];
                    ok=true;;
                }
                if (  args[i].equalsIgnoreCase("-msgfile") || args[i].equalsIgnoreCase("-m") ){
                    msgFile=args[++i];
                    ok=true;
                }        
        i++;
        }        
        return (ok);
    }

    static void Usage(String errmsg){
        System.err.println(errmsg);
        System.err.print("\n\nUsage:");
        System.err.println("-h[ost] <smtp server> -f[rom] <sender's email address> -t[o] <recipient's email address> -s[ubject] <\"The message's Subject Line\"> [-v[erbose]] [-d[ebug]]");
        System.err.println(
                "RidOvMailer honours the following environment variables if set:\n" +
                "SMTP_HOST SMTP_FROM SMTP_MSGFILE So you don't have to type them\n"+
                "The Command line args overwrite any Environment Vars if set");
    }



    static void readMsgFileSendtoSock(String msgFile,DataOutputStream os) throws IOException{
      BufferedReader in=null;
      try {
         in = new BufferedReader(new FileReader(msgFile));

            String line;
            int i=0;
            while ((line=in.readLine())!=null) {
                if (verbose)
                    System.out.println(line);
                sendline(line,os);
            }

        }   catch(Exception ex) {
            System.err.println("Could not read Message from file:"+msgFile);
            return;
        }finally {
                if (in!=null)
                    in.close();
        }
      }

    /**********************************************************************
     * Read from Std in and send to SMTP socket
     * @param os
     * @throws java.io.IOException
     **********************************************************************/
    static void readStdinSendtoSock(DataOutputStream os) throws IOException{
        System.out.println("-----------------------");
        System.out.println("Please type your message below, finish with (CTRL-D) on unix (CTRL-Z+ENTER) on windows");
        System.out.println("-----------------------");
    
        BufferedReader in=null;
      try {                  
        in = new BufferedReader(new InputStreamReader(System.in));         
            String line;           
            while ((line=in.readLine())!=null) {                
                sendline(line,os);
            }                  
        }   catch(Exception ex) {
            System.err.println("Could not read Message from file:"+msgFile);
            return;
        }finally {
                if (in!=null)
                    in.close();
        }
      }

} /* End class Main */
