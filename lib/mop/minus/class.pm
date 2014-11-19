package mop::minus::class {
  use mop::minus;
  
  has name;
  has super_class;
  has roles = sub { [] };
}

1;
