# Perl 5 mop minus proposal

This is Perl 5 mop minus proposal.

## Purpose

1. Provide simple and writable object system to Perl 5.
2. mop is improvement of Perl 5 object system, not new one.
3. Core change is as small as possible or there are no core change.

## Installation

    curl -L https://github.com/yuki-kimoto/mop-minus-proposal/archive/mop-minus-latest.tar.gz > mop-minus-latest.tar.gz
    cpanm mop-minus-latest.tar.gz

## Example

    # main.pl
    use Point3D;
    my $point = Point3D->new;
    print $point->x(0);
    my $x = $point->x;
    
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

    # Role1.pm
    package Role1 {
      use mop::minus;
      
      # will be "method foo { ... }"
      sub foo {
        return 'foo';
      }
    }

    # Role2.pm
    package Role1 {
      use mop::minus;
      
      # will be "method bar { ... }"
      sub bar {
        return 'bar';
      }
    }

## mop minus specification

### use mop - define class.

A. using mop::minus module define class

    # Define class
    package MyClass {
      use mop::minus;
      
      ...
    }

This class inherit mop::minus::object(In Currently implementaion, inherit Object::Simple).

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

B. The way to include role is the following mechanism.

**1** Role class is copied and renamed
      
    pckage mop::role_id_xxxxxx::SomeRole {
      use mop::minus;
      
      has p;
      
      method role_some_method {
        ...
      }
    }
    
**2** role class is copied and it extends base class of MyClass if exists.
    
    package mop::role_id_xxxxxx::SomeRole {
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
      extends mop::role_id_xxxxxx::SomeRole;
      
      ...
    }
    
The following new single inheritance structure is created. Role id xxxxxx is incremented after a role is created.

    BaseClass
    |
    mop::role_id_xxxxxx::SomeRole
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
    mop::role_id_xxxxxx::SomeRole1
    |
    mop::role_id_xxxxxx::SomeRole2
    |
    MyClass

### method keyword - define method (In current implementation, this is not implemented)

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
