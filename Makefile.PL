use strict;
use warnings;
use ExtUtils::MakeMaker;


sub merge_key_into {
	my ($href, $target, $source) = @_;
	%{$href->{$target}} = (%{$href->{$target}}, %{delete $href->{$source}});
}

my %opt = (
	NAME          => 'File::Open',
	AUTHOR        => q{Lukas Mai <l.mai@web.de>},
	VERSION_FROM  => 'lib/File/Open.pm',
	ABSTRACT_FROM => 'lib/File/Open.pm',

	LICENSE => 'perl',
	PL_FILES => {},

	CONFIGURE_REQUIRES => {
		'strict' => 0,
		'warnings' => 0,
		'ExtUtils::MakeMaker' => '6.48',
	},
	BUILD_REQUIRES => {},
	TEST_REQUIRES => {
		'File::Spec'  => 0,
		'File::Temp'  => '0.19',
		'IO::Handle'  => 0,
		'Test::Fatal' => 0,
		'Test::More'  => 0,
		'open'        => 0,
	},
	PREREQ_PM => {
		'Carp'           => 0,
		'Errno'          => 0,
		'Exporter'       => 0,
		'Fcntl'          => 0,
		'File::Basename' => 0,
		'strict'         => 0,
		'warnings'       => 0,
	},

	dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	clean => { FILES    => 'File-Open-*' },

	META_MERGE => {
		'meta-spec' => { version => 2 },
		'resources' => {
			repository => {
				url  => 'git://github.com/mauke/File-Open.git',
				web  => 'https://github.com/mauke/File-Open',
				type => 'git',
			},
		},
	},
);

if ($] < 5.010) {
	delete $opt{TEST_REQUIRES}{'open'};
}

(my $mm_version = ExtUtils::MakeMaker->VERSION) =~ tr/_//d;

if ($mm_version < 6.67_04) {
	# Why? For the glory of satan, of course!
	no warnings qw(redefine);
	*ExtUtils::MM_Any::_add_requirements_to_meta_v1_4 = \&ExtUtils::MM_Any::_add_requirements_to_meta_v2;
}

if ($mm_version < 6.63_03) {
	merge_key_into \%opt, 'BUILD_REQUIRES', 'TEST_REQUIRES';
}

if ($mm_version < 6.55_01) {
	merge_key_into \%opt, 'CONFIGURE_REQUIRES', 'BUILD_REQUIRES';
}

if ($mm_version < 6.51_03) {
	merge_key_into \%opt, 'PREREQ_PM', 'CONFIGURE_REQUIRES';
}

WriteMakefile %opt;
