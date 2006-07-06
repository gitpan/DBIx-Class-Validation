use strict;
use warnings;
use Test::More;

BEGIN {
    plan skip_all => 'needs FormValidator::Simple for testing'
        unless eval 'require FormValidator::Simple';

    plan skip_all => 'needs SQL::Translator for testing'
        unless eval 'require SQL::Translator';

    plan tests => 3;
}

use lib qw(t/lib);

use ValidationTest;
my $schema = ValidationTest->init_schema;
my $row;

my $profile = [
	name => [ 'NOT_BLANK', ['LENGTH', 4, 10] ],
];

ValidationTest::Schema::Test->validation_profile($profile);
Class::C3->reinitialize();

$row = eval{  $schema->resultset('Test')->create({name => ''}) };
isa_ok $@, 'FormValidator::Simple::Results', 'blank value not accepted';

$row = eval{ $schema->resultset('Test')->create({name => 'qwertyqwerty'}) };
isa_ok $@, 'FormValidator::Simple::Results', 'long string not accepted';

$row = eval{ $schema->resultset('Test')->create({name => 'qwerty'}) };
is $row->name, 'qwerty', 'valid data accepted';

1;
