use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'File::Open',
    AUTHOR              => q{Lukas Mai <l.mai@web.de>},
    VERSION_FROM        => 'lib/File/Open.pm',
    ABSTRACT_FROM       => 'lib/File/Open.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    MIN_PERL_VERSION => '5.006',
    PL_FILES            => {},
    CONFIGURE_REQUIRES => {
    	'ExtUtils::MakeMaker' => '6.5501',
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'Test::Fatal' => 0,
        'File::Spec' => 0,
    },
    PREREQ_PM => {
        'warnings' => 0,
        'strict' => 0,
        'Exporter' => 0,
        'File::Basename' => 0,
        'Carp' => 0,
        'Fcntl' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'File-Open-*' },
);
