#!perl -wT
# $Id: /mirror/trunk/DBIx-Class-Validation/t/pod_syntax.t 3237 2007-05-05T16:24:35.775054Z claco  $
use strict;
use warnings;

BEGIN {
    use lib 't/lib';
    use DBIC::Test;

    plan skip_all => 'set TEST_AUTHOR to enable this test' unless $ENV{TEST_AUTHOR};

    eval 'use Test::Pod 1.00';
    plan skip_all => 'Test::Pod 1.00 not installed' if $@;
};

all_pod_files_ok();
