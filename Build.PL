use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'aliased',
    license             => 'perl',
    dist_author         => 'Curtis "Ovid" Poe <ovid@cpan.org>',
    dist_version_from   => 'lib/aliased.pm',
    perl                => 5.006,
    requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'aliased-*' ],
);

$builder->create_build_script();
