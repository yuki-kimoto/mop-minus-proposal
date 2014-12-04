package T1 {
  use mop::minus;

  has m1;
  has m2 = sub { 9 };
  has m3 = 5;
  has m4 = sub ($self) { $self->m3 };
  
  sub T1_method1 {
    ...
  }
}
