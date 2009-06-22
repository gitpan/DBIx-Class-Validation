# $Id: /mirror/trunk/DBIx-Class-Validation/Makefile.PL 6760 2009-06-22T12:52:54.917872Z ribasushi  $
use strict;
use warnings;
use inc::Module::Install 0.65;

name 'DBIx-Class-Validation';
license 'perl';
perl_version '5.008001';
all_from 'lib/DBIx/Class/Validation.pm';

requires 'DBIx::Class'           => '0.07005';
requires 'FormValidator::Simple' => '0.17';

build_requires 'DBD::SQLite'     => '1.11';
build_requires 'DateTime::Format::SQLite';

feature 'Data::FormValidator support',
    recommends
        'Data::FormValidator';

tests 't/*.t';
clean_files "DBIx-Class-Validation-* t/var";

eval {
    system 'pod2text lib/DBIx/Class/Validation.pm > README';
};

auto_install;

WriteMakefile;
