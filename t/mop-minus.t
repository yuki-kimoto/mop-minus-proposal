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

