package Role1 {
  use mop::minus;
  
  has Role1_attr1;
  
  # will be "method role1_method1 { ... }
  sub role1_method1 {
    return 'role1_method1';
  }

  # will be "method same_method1 { ... }
  sub same_method1 {
    return 'role1_same_method1';
  }
}
