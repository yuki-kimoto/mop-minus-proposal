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

mop::minus::role - role information

=head1 ATTRIBUTES

=head2 name

=head2 methods

=head2 attributes

=head1 METHODS

=head2 get_original_name
