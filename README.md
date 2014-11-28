# Perl 5 mop minus proposal

This is Perl 5 mop minus proposal.

## Purpose

1. Provide simple and writable object system to Perl 5.
2. mop is improvement of Perl 5 object system, not new one.
3. Core change is as small as possible or there are no core change.

## Installation

    curl -L https://github.com/yuki-kimoto/mop-minus-proposal/archive/latest.tar.gz > mop-minus-latest.tar.gz
    cpanm mop-minus-latest.tar.gz

## Example

    # Point.pm
    package Point {
      use mop::minus;
      
      has x = 0;
      has y = 0;
      
      # will be "method clear { ... }"
      sub clear ($self) {
        $self->x(0);
        $self->y(0);
      }
    }
    
    1;

    # Point3D.pm
    package Point3D {
      use mop::minus;
      
      extends Point;
      with Role1, Role2;
      
      has z = 0;
      
      # will be "method clear { ... }"
      sub clear ($self) {
        $self->z(0);
      }
    }
    
    1;
    
    # Role1.pm
    package Role1 {
      use mop::minus;
      
      # will be "method foo { ... }"
      sub foo {
        return 'foo';
      }
    }
    
    1;

    # Role2.pm
    package Role1 {
      use mop::minus;
      
      # will be "method bar { ... }"
      sub bar {
        return 'bar';
      }
    }
    
    1;

    # main.pl
    use Point3D;
    my $point = Point3D->new;
    print $point->x(0);
    my $x = $point->x;

## mop minus specification

### use mop - define class.

A. using mop::minus module define class

    # Define class
    package MyClass {
      use mop::minus;
      
      ...
    }

This class inherit mop::minus::object.

    package mop::minus::object;
    sub new {
      my $class = shift;
      bless @_
        ? @_ > 1
          ? {@_}
          : {%{$_[0]}}
        : {},
      ref $class || $class;
    }

mop::minus::object is base class of all class.

B. mop::minus::object is hash-based object.

    my $my_obj = MyClass->new;
    $my_obj->{x} = 1;
    Scalar::Util::weaken $my_obj->{x};

C. mop::minus::object new method can receive hash and hash reference.

    my $my_obj = MyClass->new(x => 1, y => 2);
    my $my_obj = MyClass->new({x => 1, y = 2});

### extends keyword - extends base class.

    package MyClass {
      use mop::minus;
      extends BaseClass;
      ...
    }

A. extends keyword only allow single inheritance.

### with keyword - include role

    package MyClass {
      use mop::minus;
      with SomeRole;
      ...
    }

A. Role is class. Role inheritance structure is ignored.

    package SomeRole {
      use mop::minus;
      
      has p;
      
      method role_some_method {
        ...
      }
    }
w2
B. The way to include role is the following mechanism.

**1** Role class is cloned and renamed to mop::minus::role::idxxxxxx
    
    # SomeRole
    pckage mop::minus::role::idxxxxxx {
      use mop::minus;
      
      has p;
      
      method role_some_method {
        ...
      }
    }
    
**2** Role class is cloned and it extends base class of MyClass if exists.
    
    # SomeRole
    package mop::minus::role::idxxxxxx {
      use mop::minus;
      extends BaseClass;
      
      has p;
      
      method role_some_method {
        ...
      }
    }

**3** MyClass extends role class
    
    package MyClass {
      use mop::minus;
      
      # SomeRole
      extends mop::minus::role::idxxxxxx;
      
      ...
    }
    
The following new single inheritance structure is created. Role id xxxxxx is incremented after a role is created.

    BaseClass
    |
    mop::minus::role::idxxxxxx(SomeRole)
    |
    MyClass

C. If more than one role, after one is parent of MyClass

    package MyClass {
      use mop::minus;
      with SomeRole1, SomeRole2;
      
      ...
    }

The following single inheritance structuure is created.

    BaseClass
    |
    mop::minus::role::idxxxxxx(SomeRole1)
    |
    mop::minus::role::idxxxxxx(SomeRole2)
    |
    MyClass

### method keyword - define method (this is not yet implemented in Perl core)

    package MyClass {
      use mop::minus;
      
      method my_method ($arg) {

      }
    }

method keyword define method, this is same as the following one.

    sub my_method($arg) {
      my $self = shift;
    }

### has keyword - create read-write-accessor

    package MyClass {
      use mop::minus;
      
      has x;
    }

A. has keyword create read-write-accessor.

    my $my_obj = MyClass->new;
    $my_obj->x(1);
    my $x = $my_obj->x;

B. write-accessor can be chained.

    $my_obj->x(1)->y(2);

C. = VALUE - define default value(number and string)

    package MyClass {
      use mop::minus;
      
      has x = 0; # number or string
    }

This change read-write accessor to the following one.

    method x {
      if (@_) {
        $self->{x} = $_[0];
        
        return $self;
      }
      
      return exists $self->{x} ? $self->{x} : $self->{x} = $default;
    }

D. = sub { VALUE } - defined default value(using subroutine result).

    package MyClass {
      use mop::minus;
      
      has x = sub { [1, 2, 3] };
    }

This change read-write-accessor to the following one.

    method x {
      if (@_) {
        $self->{x} = $_[0];

        return $self;
      }
      
      return exists $self->{x} ? $self->{x} : $self->{x} = $default->();
    }

### SUPER pseud class always work well

    method new {
      my $self = $self->SUPER::new(@_);
      ...
    }

    method my_method {
      $self->SUPER::my_method();
    }

### DESTROY method always work well.

    method DESTORY {
      ...
    }

## About Meta Object Protocol

Currently mop::minus implement class meta information utility in class, attribute, role except methods.
    
    my $class = mop::minus::meta('MyClass');
    my $attributes = mop::minus::meta('MyClass')->attributes;
    my $roles = mop::minus::meta('MyClass')->role_names;
    
    # will be
    # my $methods = mop::minus::meta('MyClass')->methods;

In detail, see mop::minus::class, mop::minus::attribute, mop::minus::role.

### Why we can't get method information easily in current Perl

A. Perl don't distinguish subroutine and method

Perl have symbol table. Symbol table contain method name, but in Perl, subroutine and method is equal. so we can't get methods information only.

And Per can't distinguish the methods which belong to own class and the methods which is imported methods.

B. Code attribute handler is one way to resolve this, but the implementation is not clean.

Perl can set handler when subroutine is defined and the subroutine have code attribute.
We can register method information by using this feature.
    
    use Sub::Util 'subname';
    sub MODIFY_CODE_ATTRIBUTES{
      my($class, $code_ref, $attr_name) = @_;
      my $method_name = subname $code_ref;
      
      # Register method
      # ...
    }
    
    # "Method" is code attribute
    sub foo : Method {
      
    }

But I think this implementation is a little urgy.

C. How to resolve this?

My idea is that Perl core implement method keyword and save method imformation to some variable.
