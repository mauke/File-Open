use warnings;
use strict;

use Test::More tests => 4;

use Test::Fatal;

use File::Open qw(fsysopen_nothrow fopen_nothrow fsysopen fopen);

my $evil = __FILE__ . "\0";

like $_, qr/\Q: $evil: / for
	exception { fopen $evil, 'r' },
	exception { fsysopen $evil, 'r' },
;

is $_, undef for
	fopen_nothrow($evil, 'r'),
	fsysopen_nothrow($evil, 'r'),
;
