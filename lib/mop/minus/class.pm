package mop::minus::class {
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
