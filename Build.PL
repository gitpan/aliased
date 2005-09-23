#!/usr/bin/perl -w

use strict;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'aliased',
    license           => 'perl',
    dist_author       => 'Curtis "Ovid" Poe <moc.oohay@eop_divo_sitruc>',
    dist_version_from => 'lib/aliased.pm',
    requires          => {},
    build_requires => {
        'Test::More'      => 0.6,
    },
    add_to_cleanup     => ['aliased-*'],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();

