#!/usr/bin/perl

package HipChat;
use strict;
use ATH;
use JsonParser;
use CGI;
use Data::Dumper;

# Used to send a new message to HipChat
# Note this is a new message, not a response to a HipRecv.
package HipSend; {

  # Not yet implemented

  ### public
  sub new {
    my $class = shift;
    my $this = {
    };
    bless $this, $class;
    die "Not yet Implemented";
    #return $this;
  }

}

# Used to respond to a HipRecv
package HipResp; {
  my $cgi = new CGI;

  ### public
  sub new {
    my $class = shift;
    my $this = {
      hipRecv => shift,
      resp => {
        color => 'green',
        message => '',
        notify => 'false',
        message_format => 'text'
      }
    };
    bless $this, $class;
    return $this;
  }

  sub setColor {
    my ($this,$color) = @_;
    $this->{resp}->{color} = $color;
  }

  sub setMessage {
    my ($this,$message) = @_;
    $this->{resp}->{message} = $message;
  }

  sub toJsonString {
    my ($this) = @_;
    my $parser = new JsonParser();
    my $jsonStr = $parser->toJsonString( $this->{resp} );
    return $jsonStr;
  }

  sub respond {
    my ($this) = @_;
    print $cgi->header("application/json");
    print $this->toJsonString();
  }
}

# This class represents a received HipChat Post
package HipRecv; {

  ### private
  my $parsePostData = sub {
    my $value = shift;
    my $parser = new JsonParser();
    return $parser->fromJsonString($value);
  };

  ### public
  sub new {
    my $class = shift;
    my $jsonString = shift;
    my $this = {
      reqdata => &{$parsePostData}($jsonString)
    };
    bless $this, $class;
    return $this;
  }

  sub getRequestData {
    my ($this, $value) = @_;
    return $this->{reqdata};
  }

  sub getRoomData {
    my ($this) = @_;
    return $this->{reqdata}->{item}->{room};
  }

  sub getRoomName {
    my ($this) = @_;
    return $this->getRoomData()->{name};
  }

  sub getRoomId {
    my ($this) = @_;
    return $this->getRoomData()->{id};
  }

  sub getMessageData {
    my ($this) = @_;
    return $this->{reqdata}->{item}->{message};
  }

  sub getMessageId {
    my ($this) = @_;
    return $this->getMessageData()->{id};
  }

  sub getMessageBodyNoCmd {
    my ($this) = @_;
    my @parts = split( " ", $this->getMessageBody(), 2 );
    if ( &ATH::size( \@parts ) == 2 ) {
      return $parts[1];
    }
    return "";
  }

  sub getMessageBody {
    my ($this) = @_;
    return $this->getMessageData()->{message};
  }

  sub getMessageDate {
    my ($this) = @_;
    return $this->getMessageData()->{date};
  }

  sub getSenderData {
    my ($this) = @_;
    return $this->getMessageData()->{from};
  }

  sub getSenderId {
    my ($this) = @_;
    return $this->getSenderData()->{id};
  }

  sub getSenderMentionName {
    my ($this) = @_;
    return $this->getSenderData()->{mention_name};
  }

  sub getSenderName {
    my ($this) = @_;
    return $this->getSenderData()->{name};
  }
}

package HipChat;

1;
