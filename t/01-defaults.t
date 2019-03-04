#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 1;
use File::Spec;
use File::Basename;

BEGIN {
	chdir File::Spec->catdir(dirname(__FILE__), "fixtures/01-defaults");
	(my $expect = <<EOF) =~ s/\t//g;
	  Defaults
	    When this suite runs
	      ✓ it should print a prefixed title
	      ✓ it should prefix this title, too
	    When another suite runs
	      ✓ it still prefixes its tests
	      When a nested suite runs
	        ✓ it prefixes its tests as well
	    When skipping a test
	      - it still prefixes the title
	    when a title already begins with a prefix
	      ✓ it isn't duplicated
	      ✓ it'll not be repeated for similar words
	      ✓ IT'S NOT CASE-SENSITIVE
	      ✓ It'd be nice if it wasn't a hack
	    When titles contain leading/trailing whitespace
	      ✓ it trims that crap

	  Different file
	    When a suite runs in another file
	      ✓ it still prints titles with prefixes
EOF
	my $output = `npx mocha --require ../../../register.js .`;
	like($output, qr/$expect/);
}
