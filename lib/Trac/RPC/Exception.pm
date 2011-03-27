package Trac::RPC::Exception;

=encoding UTF-8
=cut

=head1 NAME

Trac::RPC::Exception - exceptions for Trac::RPC classes

=head1 DESCRIPTION

=head1 SYNOPSIS

=cut

use strict;
use warnings;

use Exception::Class (
    'TracException',
    'TracExceptionConnectionRefused' => { isa => 'TracException' },
    'TracExceptionNotFound' => { isa => 'TracException' },
    'TracExceptionAuthProblem' => { isa => 'TracException' },
    'TracExceptionUnknownMethod' => { isa => 'TracException' },
    'TracExceptionNoWikiPage' => { isa => 'TracException' },
);

1;
