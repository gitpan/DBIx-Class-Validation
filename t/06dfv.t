use strict;
use warnings;
use Test::More;

BEGIN {
    plan skip_all => 'needs Data::FormValidator for testing'
        unless eval 'require Data::FormValidator';

    plan skip_all => 'needs SQL::Translator for testing'
        unless eval 'require SQL::Translator';

    plan tests => 5;
}

use lib qw(t/lib);

use ValidationTest;
use Data::FormValidator::Constraints qw(:closures);

my $schema = ValidationTest->init_schema;
my $row;

my $profile = {
	field_filters => { 
    	name => [qw/ ucfirst /],
 	},
	required 	=> [qw/ name /],
	optional 	=> [qw/ email /],
	constraint_methods => {
        email => email(),
    },
};

ValidationTest::Schema::Test->validation_module("Data::FormValidator");
ValidationTest::Schema::Test->validation_profile($profile);
Class::C3->reinitialize();

$row = eval{  $schema->resultset('Test')->create({email => 'test@test.org'}) };
isa_ok $@, 'Data::FormValidator::Results', 'required fields missing';

$row = eval{ $schema->resultset('Test')->create({name => 'test', email => 'qwerty'}) };
isa_ok $@, 'Data::FormValidator::Results', 'invalid email address not accepted';

$row = eval{ $schema->resultset('Test')->create({name => 'test', email => 'test@test.org'}) };
is $row->email, 'test@test.org', 'valid data accepted';

ValidationTest::Schema::Test->validation_filter(1);
Class::C3->reinitialize();
$row = eval{ $schema->resultset('Test')->create({name => 'test', email => 'test@test.org'}) };
is $row->name, 'Test', 'filters applied';

ValidationTest::Schema::Test->validation_filter(0);
Class::C3->reinitialize();
$row = eval{ $schema->resultset('Test')->create({name => 'test', email => 'test@test.org'}) };
is $row->name, 'test', 'no filters applied';


1;
