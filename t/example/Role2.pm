package Role2 {
  use mop::minus;
  
  # will be "method bar { ... }"
  sub bar : Method {
    return 'bar';
  }
}

1;
