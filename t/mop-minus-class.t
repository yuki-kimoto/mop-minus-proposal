use Test::More 'no_plan';

use_ok('mop::minus::class');

my $class = mop::minus::class->new;

is(ref $class, 'mop::minus::class');

1;
