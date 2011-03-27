package Trac::RPC::System;

=encoding UTF-8
=cut

=head1 NAME

Trac::RPC::Wiki - access to Trac System methods via Trac XML-RPC Plugin

=cut

use strict;
use warnings;

use base qw(Trac::RPC::Base);

=head1 GENERAL FUNCTIONS
=cut

=head2 list_methods 
 
 * Get: -
 * Return: 1) ref to the array with list of all avaliable methods via XML::RPC

=cut

sub list_methods {
    my ($self) = @_;

    return $self->call('system.listMethods');
}

1;
