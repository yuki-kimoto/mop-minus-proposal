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

=head1 NAME

mop::minus::attribute - Attribute

=head1 ATTRIBUTES

=head2 name

  my $name = $attribute->name;
  $attribute->name($name);

Attribute name.

=head2 default

  my $default = $attribute->default;
  $attributes->default($default);
  
Default value.

=head2 exists_default

  my $exists_default = $attribute->exists_default;
  $attribute->exists_default($exists_default);

Default value is exists or not.

