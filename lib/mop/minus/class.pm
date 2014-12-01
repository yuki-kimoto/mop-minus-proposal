package mop::minus::class {
  require mop::minus;
  use mro ();
  use base 'mop::minus::object';
  
  sub name {
    my $self = shift;
    
    if (@_) {
      $self->{name} = $_[0];
      
      return $self;
    }
    
    return $self->{name};
  }
  
  sub super_class_name {
    my $self = shift;
    
    if (@_) {
      $self->{super_class_name} = $_[0];
      
      return $self;
    }
    
    return $self->{super_class_name};
  }
  
  sub super_class {
    my $self = shift;
    
    return mop::minus::meta($self->super_class_name);
  }

  sub methods {
    my $self = shift;
    
    if (@_) {
      $self->{methods} = $_[0];
      
      return $self;
    }
    
    return $self->{methods} ||= {};
  }

  sub role_names {
    my $self = shift;
    
    if (@_) {
      $self->{roles} = $_[0];
      
      return $self;
    }
    
    return $self->{roles} ||= [];
  }
  
  sub roles {
    my $self = shift;
    
    my $roles = [];
    for my $role_name (@{$self->role_names}) {
      push @$roles, mop::minus::meta($role_name);
    }
    
    return $roles;
  }

  sub attributes {
    my $self = shift;
    
    if (@_) {
      $self->{attributes} = $_[0];
      
      return $self;
    }
    
    return $self->{attributes} ||= {};
  }
  
  sub linear_isa {
    my $self = shift;
    return mro::get_linear_isa($self->name);
  }
}

1;

=head1 NAME

mop::minus::class - Class

=head1 ATTRIBUTES

=head2 name

  my $name = $class->name;
  $class->name($name);

Class name.

=head2 super_class_name

  my $super_class_name = $class->super_class_name;
  $class->super_class_name($super_class_name);

Super class name.

=head2 attributes

  my $attributes = $class->attributes;
  $class->attributes($attributes);

Attributes.

=head2 role_names

  my $role_names = $class->role_names;
  $class->role_names($role_names);

Role ids.

=head1 METHODS

=head2 super_class

  my $super_class = $class->super_class;

Get super class.
  
=head2 roles

  my $roles = $class->roles;

Get roles.

=head2 linear_isa

  my $linear_isa = $class->linear_isa;

Get linear isa.
