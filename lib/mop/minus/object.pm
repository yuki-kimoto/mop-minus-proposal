package mop::minus::object;

use strict;
use warnings;

no warnings 'redefine';

use Carp ();

my $role_id = 1;

sub import {
  my $class = shift;
  
  return unless @_;

  # Caller
  my $caller = caller;
  
  # No export syntax
  my $no_export_syntax;
  unless (grep { $_[0] eq $_ } qw/new attr/) {
    $no_export_syntax = 1;
  }
  
  # Inheritance and including role
  if ($no_export_syntax) {
    
    # Option
    my %opt;
    my $base_opt_name;
    if (@_ % 2 != 0) {
      my $base_opt_name = shift;
      if ($base_opt_name ne '-base') {
        Carp::croak "'$base_opt_name' is invalid option(mop::minus::object::import())";
      }
      $opt{-base} = undef;
    }
    %opt = (%opt, @_);
    
    # Base class
    my $base_class = delete $opt{-base};
    
    # Roles
    my $roles = delete $opt{with};
    if (defined $roles) {
      $roles = [$roles] if ref $roles ne 'ARRAY';
    }
    else {
      $roles = [];
    }
    
    # Check option
    for my $opt_name (keys %opt) {
      Carp::croak "'$opt_name' is invalid option(mop::minus::object::import())";
    }
    
    # Export has function
    no strict 'refs';
    no warnings 'redefine';
    *{"${caller}::has"} = sub { attr($caller, @_) };
    
    # Inheritance
    if ($base_class) {
      my $base_class_path = $base_class;
      $base_class_path =~ s/::|'/\//g;
      require "$base_class_path.pm";
      @{"${caller}::ISA"} = ($base_class);
    }
    else { @{"${caller}::ISA"} = ($class) }
    
    # Roles
    for my $role (@$roles) {
      
      my $role_file = $role;
      $role_file =~ s/::/\//g;
      $role_file .= ".pm";
      require $role_file;
      
      my $role_path = $INC{$role_file};
      open my $fh, '<', $role_path
        or Carp::croak "Can't open file $role_path: $!";
      
      my $role_content = do { local $/; <$fh> };
      my $role_for_file = "mop::minus::role::id${role_id}::$role";
      $role_id++;
      $INC{$role_for_file} = undef;
      
      my $role_for = $role_for_file;
      $role_for =~ s/\//::/g;
      $role_for =~ s/\.pm$//;
      
      my $role_for_content = $role_content;
      $role_for_content =~ s/package\s+([a-zA-Z0-9:]+)/package $role_for/;
      eval $role_for_content;
      Carp::croak $@ if $@;
      
      {
        no strict 'refs';
        my $parent = ${"${caller}::ISA"}[0];
        @{"${caller}::ISA"} = ($role_for);
        if ($parent) {
          @{"${role_for}::ISA"} = ($parent);
        }
      }
    }
  }
  
  # Export methods
  else {
    my @methods = @_;
  
    # Exports
    my %exports = map { $_ => 1 } qw/new attr class_attr dual_attr/;
    
    # Export methods
    for my $method (@methods) {
      
      # Can be Exported?
      Carp::croak("Cannot export '$method'.")
        unless $exports{$method};
      
      # Export
      no strict 'refs';
      *{"${caller}::$method"} = \&{"$method"};
    }
  }
}

sub new {
  my $class = shift;
  bless @_ ? @_ > 1 ? {@_} : {%{$_[0]}} : {}, ref $class || $class;
}

=head1 NAME

mop::minus::object - base object

