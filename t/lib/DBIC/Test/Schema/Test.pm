# $Id: Test.pm 3236 2007-05-05 16:24:35Z claco $
package DBIC::Test::Schema::Test;
use strict;
use warnings;

BEGIN {
    use base qw/DBIx::Class::Core/;
};

__PACKAGE__->load_components(qw/Validation PK::Auto Core/);
__PACKAGE__->table('test');
__PACKAGE__->add_columns(
    'id' => {
        data_type => 'int',
        is_nullable => 0,
        is_auto_increment => 1,
    },
    'name' => {
        data_type => 'varchar',
        size => 100,
        is_nullable => 1,
    },
    'email' => {
        data_type => 'varchar',
        size => 100,
        is_nullable => 1,
    }
);

__PACKAGE__->set_primary_key('id');

1;
