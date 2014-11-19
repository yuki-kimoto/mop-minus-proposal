package mop::minus::method {
  use base 'mop::minus::object';

  sub name {
    my $self = shift;
    
    if (@_) {
      $self->{name} = $_[0];
      
      return $self;
    }
    
    return $self->{name};
  }
}

1;

=head1 NAME

mop::minus::method - method information

=head1 ATTRIBUTES

=head2 name

