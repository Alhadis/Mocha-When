#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 1;
use File::Spec;
use File::Basename;

BEGIN {
	chdir File::Spec->catdir(dirname(__FILE__), "fixtures/03-comma");
	my $output = `npx mocha comma-spec.js`;
	like($output, qr/^\h*When the addComma option is enabled,\h*$/m);
}
