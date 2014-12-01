use Test::More 'no_plan';
use strict;
use warnings;

use lib 't/mop-minus';

# role
{
  # role - extends and with
  {
    package T9 {
      use mop::minus;
      
      extends T2;
      with Role1, Role2;
    }
    
    {
      my $o = T9->new;
      is($o->x, 1);
      is($o->role1_method1, 'role1_method1');
    }
  }
  
  # role - call super class method
  {
    package T8 {
      use mop::minus;
      
      with Role1, Role2;
      
      # will be "method role1_method1 { ... }"
      sub role1_method1 ($self) {
        
        return 'a ' . $self->SUPER::role1_method1();
      }
    }
    
    {
      my $o = T8->new;
      is($o->role1_method1, 'a role1_method1');
    }
  }

  # role - after role is high privilage
  {
    package T7 {
      use mop::minus;
      
      with Role1, Role2;
    }
    
    {
      my $o = T7->new;
      is($o->same_method1, 'role2_same_method1');
    }
  }
  
  # role - include two role
  {
    package T6 {
      use mop::minus;
      
      with Role1, Role2;
    }
    
    {
      my $o = T6->new;
      is($o->role1_method1, 'role1_method1');
      is($o->role2_method1, 'role2_method1');
    }
  }
  
  # role - include one role
  {
    package T5 {
      use mop::minus;
      
      with Role1;
    }
    
    {
      my $o = T5->new;
      is($o->role1_method1, 'role1_method1');
    }
  }
}

# extends
{
  {
    use T2;
    my $o = T2->new;
    is($o->x, 1);
    is($o->y, 2);
  }
  
  {
    use T3;
    my $o = T3->new;
    is($o->x, 1);
    is($o->y, 2);
    is($o->z, 3);
  }
  
  package T4 {
    use mop::minus;
    
    extends T3;
  }
  
  {
    my $o = T4->new;
    is($o->x, 1);
    is($o->y, 2);
    is($o->z, 3);
  }

  package T4_2 {
    use mop::minus;
    
    extends T3_2;
  }
  
  {
    my $o = T4_2->new;
    is($o->x, 1);
    is($o->y, 2);
    is($o->z, 3);
  }
}

my $o;

# new();
use T1;

$o = T1->new(m1 => 1);
is_deeply($o, {m1 => 1});
isa_ok($o, 'T1');

$o = T1->new({m1 => 1});
is_deeply($o, {m1 => 1});
isa_ok($o, 'T1');

$o = T1->new;
is_deeply($o, {});


# accessor;
$o = T1->new;
$o->m1(1);
is($o->m1, 1);

# constructor;
$o = T1->new(m1 => 1);
is($o->m1, 1);

$o = T1->new({m1 => 2});
is($o->m1, 2);


# default option;
$o = T1->new;
is($o->m2, 9);

# array and default;
is($o->m3, 5);

# Normal accessor;
$o = T1->new;
$o->m1(1);
is($o->m1, 1);
is($o->m1(1), $o);

# Normal accessor with default;
$o = T1->new;
$o = T1->new;
is($o->m2, 9);

# new();
$o = T1->new(m1 => 1);
isa_ok($o, 'T1');
is($o->m1, 1);

$o = T1->new({m1 => 1});
isa_ok($o, 'T1');
is($o->m1, 1);

$o = $o->new(m1 => 1);
isa_ok($o, 'T1');
is($o->m1, 1);

$o = $o->new({m1 => 1});
isa_ok($o, 'T1');
is($o->m1, 1);

# default;
$o = T1->new;
is($o->m4, 5);

# meta class
{
  # meta class - pass class name
  is(mop::minus::meta('T1')->name, 'T1');
  
  # meta class - pass object
  my $t1 = T1->new;
  is(mop::minus::meta($t1)->name, 'T1');
  
  # meta class - super_class_name
  is(mop::minus::meta('T9')->super_class_name, 'T2');

  # meta class - super_class
  is(mop::minus::meta('T9')->super_class->name, 'T2');

  # meta class - attribute
  is(mop::minus::meta('T1')->attributes->{m1}->name, 'm1');

  # meta class - attributes
  is_deeply(
    [sort keys %{mop::minus::meta('T1')->attributes}],
    ['m1', 'm2', 'm3', 'm4']
  );
  
  # meta class - role_names
  like(mop::minus::meta('T9')->role_names->[0], qr/mop::minus::role::id[0-9]+/);
  like(mop::minus::meta('T9')->role_names->[1], qr/mop::minus::role::id[0-9]+/);

  # meta class - roles
  like(mop::minus::meta('T9')->roles->[0]->name, qr/mop::minus::role::id[0-9]+/);
  like(mop::minus::meta('T9')->roles->[1]->name, qr/mop::minus::role::id[0-9]+/);
  
  # meta class - linear_isa
  is(mop::minus::meta('T9')->linear_isa->[0], 'T9');
  like(mop::minus::meta('T9')->linear_isa->[1], qr/mop::minus::role::id[0-9]+$/);
  like(mop::minus::meta('T9')->linear_isa->[2], qr/mop::minus::role::id[0-9]+$/);
  is(mop::minus::meta('T9')->linear_isa->[3], 'T2');
}

# meta role
{
  # meta role - name
  {
    my $role_name = mop::minus::meta('T9')->role_names->[0];
    like(mop::minus::meta($role_name)->name, qr/^mop::minus::role::id[0-9]+$/);
  }
  
  # meta role - original_name
  {
    my $role_name = mop::minus::meta('T9')->role_names->[0];
    is(mop::minus::meta($role_name)->original_name, 'Role1');
  }

  # meta role - attributes
  {
    my $role_name = mop::minus::meta('T9')->role_names->[0];
    is_deeply(
      [sort keys %{mop::minus::meta($role_name)->attributes}],
      ['Role1_attr1']
    );
  }
}

# meta attributes
{
  # meta attributes - default
  ok(!mop::minus::meta('T1')->attributes->{m1}->exists_default);
  ok(!defined mop::minus::meta('T1')->attributes->{m1}->default);
  ok(mop::minus::meta('T1')->attributes->{m3}->exists_default);
  is(mop::minus::meta('T1')->attributes->{m3}->default, 5);
}

# Error
{
  eval {
    package T10 {
      use mop::minus;
      with RoleError1;
    }
  };
  like($@, qr/Can't extends super class in role/);

  eval {
    package T11 {
      use mop::minus;
      with RoleError2;
    }
  };
  like($@, qr/Can't inculde roles in role/);
}
