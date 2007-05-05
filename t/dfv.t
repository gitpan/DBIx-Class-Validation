#!perl -wT
# $Id: dfv.t 3235 2007-05-05 16:23:08Z claco $
use strict;
use warnings;

BEGIN {
    use lib 't/lib';
    use DBIC::Test;

    plan skip_all => 'Data::FormValidator not installed'
        unless eval 'require Data::FormValidator';

    plan tests => 5;
};

use Data::FormValidator::Constraints qw(:closures);
my $schema = DBIC::Test->init_schema;
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

DBIC::Test::Schema::Test->validation_module("Data::FormValidator");
DBIC::Test::Schema::Test->validation_profile($profile);
Class::C3->reinitialize();

$row = eval{  $schema->resultset('Test')->create({email => 'test@test.org'}) };
isa_ok $@, 'Data::FormValidator::Results', 'required fields missing';

$row = eval{ $schema->resultset('Test')->create({name => 'test', email => 'qwerty'}) };
isa_ok $@, 'Data::FormValidator::Results', 'invalid email address not accepted';

$row = eval{ $schema->resultset('Test')->create({name => 'test', email => 'test@test.org'}) };
is $row->email, 'test@test.org', 'valid data accepted';

DBIC::Test::Schema::Test->validation_filter(1);
Class::C3->reinitialize();
$row = eval{ $schema->resultset('Test')->create({name => 'test', email => 'test@test.org'}) };
is $row->name, 'Test', 'filters applied';

DBIC::Test::Schema::Test->validation_filter(0);
Class::C3->reinitialize();
$row = eval{ $schema->resultset('Test')->create({name => 'test', email => 'test@test.org'}) };
is $row->name, 'test', 'no filters applied';
