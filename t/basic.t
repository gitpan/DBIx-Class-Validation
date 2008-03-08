#!perl -wT
# $Id: /local/DBIx-Class-Validation/t/basic.t 1303 2007-05-05T16:23:08.974445Z claco  $
use strict;
use warnings;

BEGIN {
    use lib 't/lib';
    use DBIC::Test tests => 1;

    use_ok('DBIx::Class::Validation');
};
