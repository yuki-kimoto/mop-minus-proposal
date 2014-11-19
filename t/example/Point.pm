package Point {
  use mop::minus;
  
  my $x_default = 0;
  
  has x = sub { $x_default };
  has y;

  sub clear ($self) {
    $self->x(0);
    $self->y(0);
  }
}

1;
