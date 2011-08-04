use warnings;
use strict;

use Test::More tests => 8;

use File::Open;

ok defined &File::Open::fopen;
ok defined &File::Open::fopen_nothrow;
ok defined &File::Open::fsysopen;
ok defined &File::Open::fsysopen_nothrow;

ok !exists &fopen;
ok !exists &fopen_nothrow;
ok !exists &fsysopen;
ok !exists &fsysopen_nothrow;

