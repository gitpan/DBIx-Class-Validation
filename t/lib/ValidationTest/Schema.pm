package # hide from PAUSE 
    ValidationTest::Schema;

use base qw/DBIx::Class::Schema/;

no warnings qw/qw/;

__PACKAGE__->load_classes(qw/ Test /);

1;
