use Test::More 'no_plan';

use_ok('mop::minus::role');

my $class = mop::minus::role->new;

is(ref $class, 'mop::minus::role');

1;
