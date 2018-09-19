#!/usr/bin/perl -w

=head1 NAME

mimedump - dump out the contents of a parsed MIME message

=head1 DESCRIPTION

Read a MIME stream from the stdin, and dump its contents to the stdout.

=head1 SYNOPSIS

    mimedump < mime.msg

=head1 AUTHOR

Andreas Koenig suggested this, and wrote the original code.
Eryq perverted the hell out of it.

=cut

use MIME::Parser;

#------------------------------
#
# dump_entity ENTITY, NAME
#
# Recursive routine for dumping an entity.
#
sub dump_entity {
    my ($entity, $name) = @_;
    defined($name) or $name = "'anonymous'";
    my $IO;

    # Output the head:
#    print "\n", '=' x 60, "\n";
#    print "Message $name: ";
#    print "\n", '=' x 60, "\n\n";
#    print $entity->head->original_text;
     print "Sub Part  Name: <font color=maroon>",
                $name,
                "</font> Type: <font color=maroon>",
                scalar($entity->head->mime_type),
                "</font><br>\n"; 

    # Output the body:
    my @parts = $entity->parts;
    if (@parts) {                     # multipart...
	my $i;
	foreach $i (0 .. $#parts) {       # dump each part...
	    dump_entity($parts[$i], ("$name, part ".(1+$i)));
	}
    }
    else {                            # single part...	

	# Get MIME type, and display accordingly...
	my ($type, $subtype) = split('/', $entity->head->mime_type);
	my $body = $entity->bodyhandle;
	if ($type =~ /^(text|message)$/) {     # text: display it...
		print "<pre>"; 
	    if ($IO = $body->open("r")) {
		print $_ while (defined($_ = $IO->getline));
		$IO->close;
	    }
	    else {       # d'oh!
		print "$0: couldn't find/open '$name': $!";
	    }
	 print "</pre>"; 
	}
	else {                                 # binary: just summarize it...
	    my $path = $body->path;
	    my $size = ($path ? (-s $path) : '???');
#	    print ">>> This is a non-text message, $size bytes long.\n";
#	    print ">>> It is stored in ", ($path ? "'$path'" : 'core'),".\n\n";

        if ( scalar($entity->head->mime_type) =~ /image\/jpeg/ ) {
                print "<br><center>",
                        "<img src=\"/cgi-bin/tmpviewjpg?",
                        $path, "\">",
                        " </center>";
        }

        if ( scalar($entity->head->mime_type) =~ /image\/gif/ ) {
                print "<br><center>",
                        "<img src=\"/cgi-bin/tmpviewgif?",
                        $path, "\">",
                        " </center>";
        }                           
	}
    }
    1;
}

#------------------------------
#
# main
#
sub main {
    print STDERR "(reading from stdin)\n" if (-t STDIN);

    # Create a new MIME parser:
    my $parser = new MIME::Parser;
    
    # Create and set the output directory:
    (-d "/tmp/mimedump-tmp") or mkdir "mimedump-tmp",0755 or die "mkdir: $!";
    (-w "/tmp/mimedump-tmp") or die "can't write to directory";
    $parser->output_dir("/tmp/mimedump-tmp");
    
    # Read the MIME message:
    $entity = $parser->read(\*STDIN) or die "couldn't parse MIME stream";

    # Dump it out:
    dump_entity($entity);
}
exit(&main ? 0 : -1);

#------------------------------
1;



