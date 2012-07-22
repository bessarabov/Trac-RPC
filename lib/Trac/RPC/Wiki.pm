package Trac::RPC::Wiki;

=encoding UTF-8
=cut

=head1 NAME

Trac::RPC::Wiki - access to Trac Wiki methods via Trac XML-RPC Plugin

=cut

use strict;
use warnings;

use base qw(Trac::RPC::Base);

=head1 GENERAL FUNCTIONS
=cut

=head2 get_page

B<Get:> 1) $self 2) scalar with page name

B<Return:> 1) scalar with page content

=cut

sub get_page {
    my ($self, $page) = @_;

    return $self->call(
        'wiki.getPage',
        RPC::XML::string->new($page)
    );
}

=head2 put_page

B<Get:> 1) $self 2) scalar with page name 3) scalar with page content

B<Return:> -

=cut

sub put_page {
    my ($self, $page, $content) = @_;

    $self->call(
        'wiki.putPage',
        RPC::XML::string->new($page),
        RPC::XML::string->new($content),
        RPC::XML::struct->new()
    );

    return ''
}

=head2 get_all_pages

B<Get:> 1) $self

B<Return:> 1) ref to the array with list of all wiki pages

=cut

sub get_all_pages {
    my ($self) = @_;

    return $self->call(
        'wiki.getAllPages'
    );
}

1;
