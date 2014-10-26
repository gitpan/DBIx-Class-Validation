#!perl -wT
# $Id: /local/DBIx-Class-Validation/t/pod_coverage.t 1648 2007-05-05T16:24:35.775054Z claco  $
use strict;
use warnings;

BEGIN {
    use lib 't/lib';
    use DBIC::Test;

    plan skip_all => 'set TEST_AUTHOR to enable this test' unless $ENV{TEST_AUTHOR};

    eval 'use Test::Pod::Coverage 1.04';
    plan skip_all => 'Test::Pod::Coverage 1.04' if $@;

    eval 'use Pod::Coverage 0.14';
    plan skip_all => 'Pod::Coverage 0.14 not installed' if $@;
};

my $trustme = {
    trustme => [qr/^(g|s)et_component_class$/]
};

all_pod_coverage_ok($trustme);
