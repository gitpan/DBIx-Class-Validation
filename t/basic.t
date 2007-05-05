#!perl -wT
# $Id: basic.t 3235 2007-05-05 16:23:08Z claco $
use strict;
use warnings;

BEGIN {
    use lib 't/lib';
    use DBIC::Test tests => 1;

    use_ok('DBIx::Class::Validation');
};
