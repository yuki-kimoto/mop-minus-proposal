use Test::More 'no_plan';

use_ok('mop::minus::attribute');

my $class = mop::minus::attribute->new;

is(ref $class, 'mop::minus::attribute');
