package # hide from PAUSE 
    ValidationTest;

use strict;
use warnings;
use ValidationTest::Schema;

sub init_schema {
    my $self = shift;
    my $db_file = "t/var/ValidationTest.db";

    unlink($db_file) if -e $db_file;
    unlink($db_file . "-journal") if -e $db_file . "-journal";
    mkdir("t/var") unless -d "t/var";

    my $dsn = "dbi:SQLite:${db_file}";
    
    my $schema = ValidationTest::Schema->compose_connection('ValidationTest' => $dsn);
    $schema->deploy();
    
    return $schema;
}

1;
