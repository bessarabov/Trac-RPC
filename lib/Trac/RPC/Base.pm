package Trac::RPC::Base;

=encoding UTF-8
=cut

=head1 NAME

Trac::RPC::Base - abstract class for Trac::RPC classes

=cut

use strict;
use warnings;

use Data::Dumper;
use RPC::XML::Client;
use Trac::RPC::Exception;
binmode STDOUT, ":utf8"; 

=head1 GENERAL FUNCTIONS
=cut

=head2 new
 
 * Get: 1) hash with connection information 
 * Return: 1) object 

Sub creates an object

=cut

sub new {
    my ($class, $params) = @_;
    my $self  = {};

    $self->{realm} = $params->{realm};
    $self->{user} = $params->{user};
    $self->{password} = $params->{password};
    $self->{host} = $params->{host};

    $RPC::XML::ENCODING = "utf-8";
    $self->{rxc} = RPC::XML::Client->new(
        $self->{host},
        error_handler => sub {error($self, @_)},
        fault_handler => sub {error($self, @_)},
    );

    if ( $self->{realm} && $self->{user} && $self->{password} ) { 
        $self->{rxc}->credentials($self->{realm}, $self->{user}, $self->{password});
    }

    bless($self, $class);
    return $self;
}

=head2 call 
 
 * Get: 1) @ with params to send to trac's xml rpc interface
 * Return: 1) scalar with some data recived from trac 

Sending request to trac and returns the answer. 

    $self->call(
        'wiki.putPage',
        RPC::XML::string->new($page),
        RPC::XML::string->new($content),
        RPC::XML::struct->new()
    );

=cut

sub call {
    my ($self, @params) = @_;

    my $req = RPC::XML::request->new(@params);
    my $res = $self->{rxc}->send_request($req);

    return $res->value;
}

=head2 error 

Handler that checks for different types of erros and throws exceptions.

=cut

sub error {
    my $self = shift @_;

    if (ref $_[0]) {
        if( $_[0]->as_string =~ /Unknown method/) {
            TracExceptionUnknownMethod->throw( error =>
                "Could not perform method\n"
                . "Got error\n"
                . Dumper($_[0])
            );
        } elsif( $_[0]->as_string =~ /Wiki page .* does not exist/) {
            TracExceptionNoWikiPage->throw( error =>
                "Wiki page not found\n"
                . "Got error\n"
                . Dumper($_[0])
            );
        } else {
            TracException->throw( error =>
                "Got some unknown error while trying to access '$self->{host}'\n"
                . "Got error: \n"
                . Dumper ($_[0])
                . "\n"
            );
        }
    } else {
        if ($_[0] =~ /connect: Connection refused/) {
            TracExceptionConnectionRefused->throw( error =>
                "Could not access '$self->{host}'\n"
                . "Got error '$_[0]'\n"
            );
        } elsif ($_[0] =~ /Not Found/) {
            TracExceptionNotFound->throw( error =>
                "Could not access '$self->{host}'\n"
                . "Got error '$_[0]'\n"
            );
        } elsif( $_[0] =~ /Authorization Required/) {
            TracExceptionAuthProblem->throw( error =>
                "Could not auth to '$self->{host}'\n"
                . "You specified login '$self->{user}' and " . ($self->{password} ? "some" : "no") . " password\n"
                . "Got error '$_[0]'\n"
            );
        } else {
            die "Got error: '$_[0]'\n";
        }

    }
}

1;
