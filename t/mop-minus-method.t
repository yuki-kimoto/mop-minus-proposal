use Test::More 'no_plan';

use_ok('mop::minus::method');

my $class = mop::minus::method->new;

is(ref $class, 'mop::minus::method');

1;
