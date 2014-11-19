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
  
  sub get_roles {
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
  
  sub get_linear_isa {
    my $self = shift;
    return mro::get_linear_isa($self->name);
  }
}

1;

=head1 NAME

mop::minus::class - class information

=head1 ATTRIBUTES

=head2 name

=head2 super_class_name

=head2 methods

=head2 attributes

=head2 role_names

=head1 METHODS

=head2 get_super_class
  
=head2 get_roles

=head2 get_linear_isa
