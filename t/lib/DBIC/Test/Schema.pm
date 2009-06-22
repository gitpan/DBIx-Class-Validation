# $Id: /mirror/trunk/DBIx-Class-Validation/t/lib/DBIC/Test/Schema.pm 3237 2007-05-05T16:24:35.775054Z claco  $
package DBIC::Test::Schema;
use strict;
use warnings;

BEGIN {
    use base qw/DBIx::Class::Schema/;
};
__PACKAGE__->load_classes;

sub dsn {
    return shift->storage->connect_info->[0];
};

1;
