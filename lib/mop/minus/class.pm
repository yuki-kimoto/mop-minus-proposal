package mop::minus::class {
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

  sub role_names {
    my $self = shift;
    
    if (@_) {
      $self->{roles} = $_[0];
      
      return $self;
    }
    
    return $self->{roles} || [];
  }

  sub attributes {
    my $self = shift;
    
    if (@_) {
      $self->{attributes} = $_[0];
      
      return $self;
    }
    
    return $self->{attributes} ||= {};
  }

}

1;
