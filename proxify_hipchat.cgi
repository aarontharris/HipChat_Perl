#!/usr/bin/perl

use ATH::ATH;
use HipChat::HipChat;

use strict;
use CGI;
use Data::Dumper;


&main();
sub main { 

  # HipChat posts json to our server for us to examine and handle so lets get it
  my $cgi = new CGI;
  my $vars = $cgi->Vars();
  my $postData = $vars->{POSTDATA};

  # Parse the jsonString postData into our HipRecv
  my $hipRecv = new HipRecv($postData);

  # Build our response
  my $hipResp = new HipResp($hipRecv);

  # Default message
  my $message = "You said: " . $hipRecv->getMessageBodyNoCmd();

  # Respond to a particular message "what time is it"
  if ( $hipRecv->getMessageBodyNoCmd() =~ /what time is it/ ) {
    $message = "time to get a watch";
  }

  # Set our message and respond
  $hipResp->setMessage($message);
  $hipResp->respond();
}

sub debug {
  my $msg = shift;
  print STDERR $msg;
}
