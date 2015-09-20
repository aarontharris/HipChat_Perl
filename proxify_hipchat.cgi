#!/usr/bin/perl

use strict;
use ATH::ATH;
use HipChat::HipChat;
use CGI;
use Data::Dumper;

my $cgi = new CGI;
my $vars = $cgi->Vars();

&main();
sub main {
  my $postData = $vars->{POSTDATA};
  my $hipRecv = new HipRecv($postData);
  &debug( Dumper( $hipRecv->getRequestData() ) );
  &debug( "Message = " . $hipRecv->getMessageBody() );

  my $hipResp = new HipResp($hipRecv);
  my $message = "You said: " . $hipRecv->getMessageBodyNoCmd();
  if ( $hipRecv->getMessageBody() =~ /what time is it/ ) {
    #$message = "time to get a watch";
    my $time = `date`;
    chomp($time);
    $message = "Time: $time";
  }

  $hipResp->setMessage($message);
  $hipResp->respond();
}

sub respond {
  print $cgi->header("application/json");
}

sub post {
  my $url = "https://api.hipchat.com/v2/room/1535857/notification?auth_token=ecSDPAo34RwIuYGjRjr3G59Fp3iyKVyre40z66la";
  my $postData = qq|{"color": "green", "message": "My first notification (yey)", "notify": false, "message_format": "text"}|;
  #my $request = POST( $url, $postData );
  #my $content = $ua->request($request)->as_string(); 
  #print STDERR $content
}

sub getResponseUrl {
  my $roomId = shift;
  my $url = "https://api.hipchat.com/v2/room/1535857/notification?auth_token=ecSDPAo34RwIuYGjRjr3G59Fp3iyKVyre40z66la";
  return $url;
}

sub debug {
  my $msg = shift;
  print STDERR $msg;
}
