use strict;
use warnings;
use ExtUtils::MakeMaker 6.56;

WriteMakefile(
    NAME                 => 'File::Open',
    AUTHOR               => q{Lukas Mai <l.mai@web.de>},
    VERSION_FROM         => 'lib/File/Open.pm',
    ABSTRACT_FROM        => 'lib/File/Open.pm',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '6.56',
    },
    LICENSE => 'perl',
    PL_FILES => {},
    BUILD_REQUIRES => {
        'File::Spec' => 0,
        'File::Temp' => '0.19',
        'IO::Handle' => 0,
        'Test::Fatal' => 0,
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Carp' => 0,
        'Errno' => 0,
        'Exporter' => 0,
        'Fcntl' => 0,
        'File::Basename' => 0,
        'strict' => 0,
        'warnings' => 0,
    },
    META_MERGE => {
        resources => {
            repository => {
                url => 'git://github.com/mauke/File-Open.git',
                web => 'https://github.com/mauke/File-Open',
                type => 'git',
            },
        },
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'File-Open-*' },
);
