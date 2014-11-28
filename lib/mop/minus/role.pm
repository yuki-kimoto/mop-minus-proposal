package mop::minus::role {
  use base 'mop::minus::object';

  sub id {
    my $self = shift;
    
    if (@_) {
      $self->{id} = $_[0];
      
      return $self;
    }
    
    return $self->{id};
  }
  
  sub attributes {
    my $self = shift;
    
    if (@_) {
      $self->{attributes} = $_[0];
      
      return $self;
    }
    
    return $self->{attributes} ||= {};
  }

  sub name {
    my $self = shift;
    
    if (@_) {
      $self->{name} = $_[0];
      
      return $self;
    }
    
    return $self->{name} ||= {};
  }
}

1;

=head1 NAME

mop::minus::role - Role

=head1 ATTRIBUTES

=head2 id

  my $id = $role->id;
  $role->id($id);

=head2 name

  my $name = $role->name;
  $role->name($name);

=head2 attributes

  my $attributes = $role->attributes;
  $role->attributes($attributes);
