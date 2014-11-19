package Role1 {
  use mop::minus;
  
  # will be "method foo { ... }"
  sub foo : Method {
    return 'foo';
  }
}

1;
