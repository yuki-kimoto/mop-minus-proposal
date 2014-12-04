package Role2 {
  use mop::minus;
  
  # will be "method role2_method1 { ... }"
  sub role2_method1 {
    return 'role2_method1';
  }
  
  # will be "method same_method1 { ... }"
  sub same_method1 {
    return 'role2_same_method1';
  }
}
