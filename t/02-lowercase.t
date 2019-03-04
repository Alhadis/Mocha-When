#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;
use File::Spec;
use File::Basename;

BEGIN {
	chdir File::Spec->catdir(dirname(__FILE__), "fixtures/02-lowercase");
	my $output = `npx mocha when-spec.js`;
	like($output, qr/^\h*when the lowercaseWhen option is enabled\h*$/m);
}

# Test 2
{
	my $output = `npx mocha it-spec.js`;
	like($output, qr/^\h*When the lowercaseIt option is disabled\h*$/m);
	like($output, qr/^\h*It capitalises the test's prefix\h*$/m);
}
