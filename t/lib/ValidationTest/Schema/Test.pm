package # hide from PAUSE 
    ValidationTest::Schema::Test;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components(qw/Validation PK::Auto Core/);
__PACKAGE__->table('test');
__PACKAGE__->add_columns(
  'id' => {
    data_type => 'int',
    is_nullable	=> 0,
    is_auto_increment => 1,
  },
  'name' => {
    data_type => 'varchar',
    size => 100,
    is_nullable	=> 1,
  },
  'email' => {
    data_type => 'varchar',
    size => 100,
    is_nullable	=> 1,
  },
);

__PACKAGE__->set_primary_key('id');

1;
__END__