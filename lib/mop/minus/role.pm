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
  
  sub methods {
    my $self = shift;
    
    if (@_) {
      $self->{methods} = $_[0];
      
      return $self;
    }
    
    return $self->{methods} || {};
  }

  sub attributes {
    my $self = shift;
    
    if (@_) {
      $self->{attributes} = $_[0];
      
      return $self;
    }
    
    return $self->{attributes} ||= {};
  }

  sub get_original_name {
    my $self = shift;
    
    my $name = $self->name;
    return unless defined $name;
    
    my $name_original = $name;
    $name_original =~ s/^mop::minus::role::id[0-9]+:://;
    
    return $name_original;
  }
}

1;
