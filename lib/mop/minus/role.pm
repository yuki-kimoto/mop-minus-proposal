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

mop::minus::role - role information

=head1 ATTRIBUTES

=head2 name

=head2 methods

=head2 attributes

=head1 METHODS

=head2 get_original_name
