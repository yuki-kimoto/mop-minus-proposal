use v5.20;

package mop::minus;

our $VERSION = '0.01';

use strict;
use warnings;

use Carp 'croak';

use feature ();

use Parse::Keyword {
  extends => \&extends_parser,
  with => \&with_parser,
  has => \&has_parser
};

sub import {
  my $class = shift;
  
  my $caller = caller;
  
  no strict 'refs';
  no warnings 'redefine';
  *{"${caller}::extends"} = \&extends;
  *{"${caller}::with"} = \&with;
  
  if ($] >= 5.020) {
    feature->import('signatures');
    warnings->unimport('experimental::signatures');
  }

  {
    my $code = "package $caller; use mop::minus::object -base;";
    eval $code;
    croak "Can't load $code:$@" if $@;
  }

  no strict 'refs';
  no warnings 'redefine';
  *{"${caller}::has"} = \&has;
}

sub has {
  my ($class, $name, $default_exists, $default_code) = @_;
  
  if ($default_exists) {
    $class->attr($name => $default_code->());
  }
  else {
    $class->attr($name);
  }
}

sub has_parser {
    my $caller = compiling_package;
    
    lex_read_space;

    my $name = parse_name('attribute');

    lex_read_space;
    
    my $default_exists;
    my $default;
    if (lex_peek eq '=') {
        $default_exists = 1;
        lex_read;
        lex_read_space;
        $default = parse_fullexpr;
    }

    lex_read_space;

    die "Couldn't parse attribute $name" unless lex_peek eq ';';
    lex_read;

    return (sub { ($caller, $name, $default_exists, $default) }, 1);
}

sub extends {
  my ($class_info) = @_;
  
  my $class = $class_info->{class};
  
  my @args;
  if (my $extends = $class_info->{extends}) {
    push @args, ('-base', '"' . $class_info->{extends} . '"');
  }

  my $args_str = join(',', @args);

  {
    my $code = "package $class; use mop::minus::object $args_str;";
    eval $code;
    croak "Can't load $code:$@" if $@;
  }

  no strict 'refs';
  no warnings 'redefine';
  *{"${class}::has"} = \&has;
  
  return 1;
}

sub extends_parser {

  my $caller = compiling_package;

  lex_read_space;
  
  my @extends;
  if (@extends = parse_multiple_values('extends')) {
    if (@extends > 1) {
      croak "Can't extends multiple classes(" . join(',', @extends) . ")";
    }
  }
  
  lex_read_space;
  
  my $class_info = {
    class      => $caller,
    extends   => $extends[0],
  };

  return (sub { $class_info }, 1);
}

sub with {
  my ($class_info) = @_;
  
  my $class = $class_info->{class};
  
  my @args;
  if (my $with = $class_info->{with}) {
    push @args, '"with"';
    my $with_values_str = '[';
    for my $w (@$with) {
      $with_values_str .= qq/"$w",/;
    }
    $with_values_str .= ']';
    push @args, $with_values_str;
  }

  my $args_str = join(',', @args);
  
  no strict 'refs';
  my $extends;
  if (@{"${class}::ISA"}) {
    $extends = ${"${class}::ISA"}[0];
  }

  {
    my $code;
    if ($extends) {
      $DB::single = 1;
      $code = qq/package $class; use mop::minus::object -base => "$extends", $args_str;/;
    }
    else {
      $code = "package $class; use mop::minus::object $args_str;";
    }

    eval $code;
    croak "Can't load $code:$@" if $@;
  }

  no strict 'refs';
  no warnings 'redefine';
  *{"${class}::has"} = \&has;
  
  return 1;
}

sub with_parser {
  
  my $caller = compiling_package;

  lex_read_space;
  
  my @with = parse_multiple_values('with');
  
  my $class_info = {
    class      => $caller,
    with      => \@with,
  };

  return (sub { $class_info }, 1);
}

sub parse_name {
  my ($what, $allow_package) = @_;
  my $name = '';

  # XXX this isn't quite right, i think, but probably close enough for now?
  my $start_rx = qr/^[\p{ID_Start}_]$/;
  my $cont_rx  = qr/^\p{ID_Continue}$/;

  my $char_rx = $start_rx;

  while (1) {
    my $char = lex_peek;
    last unless length $char;
    if ($char =~ $char_rx) {
      $name .= $char;
      lex_read;
      $char_rx = $cont_rx;
    }
    elsif ($allow_package && $char eq ':') {
      if (lex_peek(3) !~ /^::(?:[^:]|$)/) {
        my $invalid = $name . read_tokenish();
        die "Invalid identifier: $invalid";
      }
      $name .= '::';
      lex_read(2);
    }
    else {
      last;
    }
  }

  die read_tokenish() . " is not a valid $what name" unless length $name;

  return $name;
}

sub read_tokenish {
  my $token = '';
  if ((my $next = lex_peek) =~ /[\$\@\%]/) {
    $token .= $next;
    lex_read;
  }
  while ((my $next = lex_peek) =~ /\S/) {
    $token .= $next;
    lex_read;
    last if ($next . lex_peek) =~ /^\S\b/;
  }
  return $token;
}

sub parse_modifier_with_multiple_values {
  my ($modifier) = @_;

  my $modifier_length = length $modifier;

  return unless lex_peek($modifier_length + 1) =~ /^$modifier\b/;

  lex_read($modifier_length);
  lex_read_space;

  my @names;

  do {
    my $name = parse_name('role', 1);
    push @names, $name;
    lex_read_space;
  } while (lex_peek eq ',' && do { lex_read; lex_read_space; 1 });

  return @names;
}

sub parse_multiple_values {

  my @names;

  do {
    my $name = parse_name('role', 1);
    push @names, $name;
    lex_read_space;
  } while (lex_peek eq ',' && do { lex_read; lex_read_space; 1 });

  return @names;
}

1;

=head1 NAME

mop::minus - mop minus proposal

=head1 SYNOPSIS

  # main.pl
  use Point3D;
  my $point = Point3D->new;
  print $point->x(0);
  my $x = $point->x;
  
  # Point3D.pm
  package Point3D {
    use mop::minus;
    
    extends Point;
    with Role1, Role2;
    
    has z = 0;
    
    # will be "method clear { ... }"
    sub clear ($self) {
      $self->z(0);
    }
  }
  
  # Point.pm
  package Point {
    use mop::minus;
    
    has x = 0;
    has y = 0;
    
    # will be "method clear { ... }"
    sub clear ($self) {
      $self->x(0);
      $self->y(0);
    }
  }

  # Role1.pm
  package Role1 {
    use mop::minus;

    sub foo {
      return 'foo';
    }
  }

  # Role2.pm
  package Role1 {
    use mop::minus;

    sub bar {
      return 'bar';
    }
  }

=head1 DESCRIPTION

mop minus proposal

=head1 AUTHOR

Yuki Kimoto E<lt>kimoto.yuki@gmail.com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 Yuki Kimoto

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.20.1 or,
at your option, any later version of Perl 5 you may have available.

=cut
