package Role1 {
  use mop::minus;
  
  # will be "method role1_method1 { ... }
  sub role1_method1 : Method {
    return 'role1_method1';
  }

  # will be "method same_method1 { ... }
  sub same_method1 : Method {
    return 'role1_same_method1';
  }
}

1;
