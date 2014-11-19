package Point {
  use mop::minus;
  
  my $x_default = 0;
  
  has x = sub { $x_default };
  has y;
  
  # will be "method clear { ... }"
  sub clear : Method ($self) {
    $self->x(0);
    $self->y(0);
  }
}

1;
