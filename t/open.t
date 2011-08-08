use warnings;
use strict;

use Test::More tests => 89;

use File::Spec;
use Test::Fatal;

use File::Open qw(fsysopen_nothrow fopen_nothrow fsysopen fopen);

my $DIR = File::Spec->tmpdir;
sub scratch {
	File::Spec->catfile($DIR, $_[0])
}

my $stem = 'IeXomCsu';
my $nofile;
while (-e ($nofile = scratch "$stem.txt")) {
	$stem++;
}

like $_, qr/\Q: $nofile: / for
	exception { fopen $nofile },
	exception { fopen $nofile, 'r' },
	exception { fopen $nofile, 'r+' },
	exception { fopen $nofile, '<' },
	exception { fopen $nofile, '+<' },
	exception { fopen $nofile, 'rb' },
	exception { fopen $nofile, 'r+b' },
	exception { fopen $nofile, '<b' },
	exception { fopen $nofile, '+<b' },
	exception { fsysopen $nofile, 'r' },
	exception { fsysopen $nofile, 'w' },
	exception { fsysopen $nofile, 'rw' },
;

is $_, undef for
	fopen_nothrow($nofile),
	fopen_nothrow($nofile, 'r'),
	fopen_nothrow($nofile, 'r+'),
	fopen_nothrow($nofile, '<'),
	fopen_nothrow($nofile, '+<'),
	fopen_nothrow($nofile, 'rb'),
	fopen_nothrow($nofile, 'r+b'),
	fopen_nothrow($nofile, '<b'),
	fopen_nothrow($nofile, '+<b'),
	fsysopen_nothrow($nofile, 'r'),
	fsysopen_nothrow($nofile, 'w'),
	fsysopen_nothrow($nofile, 'rw'),
;

my $scratch = scratch 'SCRATCH.AAA';
unlink $scratch;

my $token = "${\rand}-$$";

{
	my $fh = fopen $scratch, 'w';
	ok print $fh "$$ ${\rand}\n";
	ok close $fh;
} {
	my $fh = fopen $scratch, 'w';
	ok print $fh "$nofile\n";
	ok close $fh;
} {
	my $fh = fopen $scratch, 'a';
	ok print $fh "$token\n$scratch\n";
	ok close $fh;
} {
	my $fh = fopen $scratch;
	my $data = do {local $/; readline $fh};
	is $data, "$nofile\n$token\n$scratch\n";
	ok close $fh;
}
unlink $scratch;

{
	my $fh = fopen $scratch, 'wb';
	ok print $fh "$$ ${\rand}\n";
	ok close $fh;
} {
	my $fh = fopen $scratch, 'wb';
	ok print $fh "$nofile\n";
	ok close $fh;
} {
	my $fh = fopen $scratch, 'ab';
	ok print $fh "$token\n$scratch\n";
	ok close $fh;
} {
	my $fh = fopen $scratch, 'rb';
	my $data = do {local $/; readline $fh};
	is $data, "$nofile\n$token\n$scratch\n";
	ok close $fh;
}
unlink $scratch;

{
	my $fh = fopen_nothrow $scratch, 'w';
	ok $fh;
	ok print $fh "$$ ${\rand}\n";
	ok close $fh;
} {
	my $fh = fopen_nothrow $scratch, 'w';
	ok $fh;
	ok print $fh "$nofile\n";
	ok close $fh;
} {
	my $fh = fopen_nothrow $scratch, 'a';
	ok $fh;
	ok print $fh "$token\n$scratch\n";
	ok close $fh;
} {
	my $fh = fopen_nothrow $scratch;
	ok $fh;
	my $data = do {local $/; readline $fh};
	is $data, "$nofile\n$token\n$scratch\n";
	ok close $fh;
}
unlink $scratch;

{
	my $fh = fopen_nothrow $scratch, 'wb';
	ok $fh;
	ok print $fh "$$ ${\rand}\n";
	ok close $fh;
} {
	my $fh = fopen_nothrow $scratch, 'wb';
	ok $fh;
	ok print $fh "$nofile\n";
	ok close $fh;
} {
	my $fh = fopen_nothrow $scratch, 'ab';
	ok $fh;
	ok print $fh "$token\n$scratch\n";
	ok close $fh;
} {
	my $fh = fopen_nothrow $scratch, 'rb';
	ok $fh;
	my $data = do {local $/; readline $fh};
	is $data, "$nofile\n$token\n$scratch\n";
	ok close $fh;
}
unlink $scratch;

{
	my $fh = fsysopen $scratch, 'w', {creat => 0666, trunc => 1, excl => 1};
	ok print $fh "$$ ${\rand}\n";
	ok close $fh;
} {
	my $fh = fsysopen $scratch, 'w', {creat => 0, trunc => 1};
	ok print $fh "$nofile\n";
	ok close $fh;
} {
	my $fh = fsysopen $scratch, 'w';
	ok close $fh;
} {
	like exception { fsysopen $scratch, 'w', {creat => 0666, excl => 1} }, qr/\Q: $scratch: /;
} {
	my $fh = fsysopen $scratch, 'w', {creat => 0, append => 1};
	ok print $fh "$token\n$scratch\n";
	ok close $fh;
} {
	my $fh = fsysopen $scratch, 'r';
	my $data = do {local $/; readline $fh};
	is $data, "$nofile\n$token\n$scratch\n";
	ok close $fh;
}
unlink $scratch;

{
	my $fh = fsysopen_nothrow $scratch, 'w', {creat => 0666, trunc => 1, excl => 1};
	ok $fh;
	ok print $fh "$$ ${\rand}\n";
	ok close $fh;
} {
	my $fh = fsysopen_nothrow $scratch, 'w', {creat => 0, trunc => 1};
	ok $fh;
	ok print $fh "$nofile\n";
	ok close $fh;
} {
	my $fh = fsysopen_nothrow $scratch, 'w';
	ok $fh;
	ok close $fh;
} {
	ok !fsysopen_nothrow $scratch, 'w', {creat => 0666, excl => 1};
} {
	my $fh = fsysopen_nothrow $scratch, 'w', {creat => 0, append => 1};
	ok $fh;
	ok print $fh "$token\n$scratch\n";
	ok close $fh;
} {
	my $fh = fsysopen_nothrow $scratch, 'r';
	ok $fh;
	my $data = do {local $/; readline $fh};
	is $data, "$nofile\n$token\n$scratch\n";
	ok close $fh;
}
unlink $scratch;
