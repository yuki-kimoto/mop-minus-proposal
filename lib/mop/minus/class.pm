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
  
  sub get_super_class {
    my $self = shift;
    
    return mop::minus::meta($self->super_class_name);
  }

  sub role_ids {
    my $self = shift;
    
    if (@_) {
      $self->{role_ids} = $_[0];
      
      return $self;
    }
    
    return $self->{role_ids} ||= [];
  }
  
  sub get_roles {
    my $self = shift;
    
    my $roles = [];
    for my $role_id (@{$self->role_ids}) {
      push @$roles, mop::minus::meta("mop::minus::role::id$role_id");
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
  
  sub get_linear_isa {
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

=head2 role_ids

  my $role_ids = $class->role_ids;
  $class->role_ids($role_ids);

Role ids.

=head1 METHODS

=head2 get_super_class

  my $super_class = $class->get_super_class;

Get super class.
  
=head2 get_roles

  my $roles = $class->get_roles;

Get roles.

=head2 get_linear_isa

  my $linear_isa = $class->get_linear_isa;

Get linear isa.
