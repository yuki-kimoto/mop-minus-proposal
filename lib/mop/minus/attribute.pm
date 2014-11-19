package mop::minus::attribute {
  use base 'mop::minus::object';

  sub name {
    my $self = shift;
    
    if (@_) {
      $self->{name} = $_[0];
      
      return $self;
    }
    
    return $self->{name};
  }
  
  sub default {
    my $self = shift;
    
    if (@_) {
      $self->{default} = $_[0];
      
      return $self;
    }
    
    return $self->{default};
  }
  
  sub exists_default {
    my $self = shift;
    
    if (@_) {
      $self->{exists_default} = $_[0];
      
      return $self;
    }
    
    return $self->{exists_default};
  }
}

1;
