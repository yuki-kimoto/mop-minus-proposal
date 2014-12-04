use Test::More 'no_plan';

use_ok('mop::minus::class');

# Construct
{
  my $class_meta = mop::minus::class->new;
  is(ref $class_meta, 'mop::minus::class');
}

my $class_meta = mop::minus::class->new;

# name
{
  $class_meta->name('T1');
  is($class_meta->name, 'T1');
}
