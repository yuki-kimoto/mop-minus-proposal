package mop::minus::role {
  use base 'mop::minus::object';

  sub name {
    my $self = shift;
    
    if (@_) {
      $self->{name} = $_[0];
      
      return $self;
    }
    
    return $self->{name};
  }
  
  sub attributes {
    my $self = shift;
    
    if (@_) {
      $self->{attributes} = $_[0];
      
      return $self;
    }
    
    return $self->{attributes} ||= {};
  }

  sub original_name {
    my $self = shift;
    
    if (@_) {
      $self->{original_name} = $_[0];
      
      return $self;
    }
    
    return $self->{original_name} ||= {};
  }
}

1;

=head1 NAME

mop::minus::role - Role

=head1 ATTRIBUTES

=head2 name

  my $name = $role->name;
  $role->name($name);

=head2 original_name

  my $original_name = $role->original_name;
  $role->original_name($original_name);

=head2 attributes

  my $attributes = $role->attributes;
  $role->attributes($attributes);
