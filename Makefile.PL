use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'aliased',
    VERSION_FROM      => 'lib/aliased.pm',
    PREREQ_PM         => {
        'Test::Simple' => 0.50,
    }, 
    ($] >= 5.005 
        ?  ( AUTHOR => 'Curtis Poe <eop_divo_sitruc@yahoo.com>') 
        : ()),
);

# reverse the name to email me
