use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More 'no_plan';
BEGIN { use_ok('mop::minus') };


use Point3D;
my $point = Point3D->new;

is($point->x, 0);
is($point->y, undef);
is($point->z, 2);
is($point->foo, 'foo');
is($point->bar, 'bar');

