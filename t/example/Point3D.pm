package Point3D {
  use mop::minus;
  
  extends Point;
  with Role1,Role2;
  
  has z = 2;
  
  # will be "method clear { ... }"
  sub clear ($self) {
    $self->z(0);
  }
}

1;
