use strict;
use warnings;

package mop::minus::object {
  sub new {
    my $class = shift;
    bless @_ ? @_ > 1 ? {@_} : {%{$_[0]}} : {}, ref $class || $class;
  }
}

1;

=head1 NAME

mop::minus::object - base object

