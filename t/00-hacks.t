#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 8;

BEGIN {
	use File::Spec::Functions qw< rel2abs >;
	use File::Basename;
	chdir Cwd::abs_path(File::Spec->rel2abs("..", dirname(__FILE__)));
}

sub run {
	(my $script) = shift;
	$script =~ s/^\t+//gm;
	return `node -e '$script'`;
}

# Test 1: Replacing an existing definition
like(run(<<'JAVASCRIPT'), qr/^Foo Bar\nBar Foo\n$/);
	"use strict";
	const {hackMethod} = require("./index.js");
	global.it = (...words) => console.log(words.join(" "));
	it("Foo", "Bar");
	hackMethod(global, "it", (fn, ...args) => fn(...args.reverse()));
	it("Foo", "Bar");
JAVASCRIPT


# Test 2: Trigger replacement upon synchronous method definition
like(run(<<'JAVASCRIPT'), qr/^undefined\nDoing stuff!\n$/);
	"use strict";
	const {hackMethod} = require("./index.js");
	console.log(global.doStuff);
	hackMethod(global, "doStuff", fn => console.log("Doing stuff!"));
	global.doStuff = () => console.log("Not doing stuff");
	doStuff();
JAVASCRIPT


# Test 3: Trigger replacement upon asynchronous definition
like(run(<<'JAVASCRIPT'), qr/^undefined\nFoo\n$/);
	"use strict";
	const {hackMethod} = require("./index.js");
	hackMethod(global, "doStuff", () => console.log("Foo"));
	console.log(global.doStuff);
	setTimeout(() => {
		global.doStuff = () => console.log("Bar");
		global.doStuff();
	}, 1000);
JAVASCRIPT


# Test 4: Ignoring non-function assignments while waiting to trigger
like(run(<<'JAVASCRIPT'), qr/^undefined\nFoo\nBar\nCalled it!\n$/);
	"use strict";
	const {hackMethod} = require("./index.js");
	hackMethod(global, "someMethod", () => console.log("Called it!"));
	console.log(global.someMethod);
	
	global.someMethod = "Foo"; console.log(global.someMethod);
	global.someMethod = "Bar"; console.log(global.someMethod);
	global.someMethod = () => console.log("Original function");
	global.someMethod();
JAVASCRIPT


# Test 5: Preventing redefinition after replacement
like(run(<<'JAVASCRIPT'), qr/^undefined\nFoo\nFoo\n$/);
	"use strict";
	const {hackMethod} = require("./index.js");
	console.log(global.doStuff);
	hackMethod(global, "doStuff", () => console.log("Foo"));
	global.doStuff = () => console.log("Bar"); global.doStuff();
	global.doStuff = () => console.log("Qux"); global.doStuff();
JAVASCRIPT


# Test 6: Storing reference to original method
like(run(<<'JAVASCRIPT'), qr/^Foo\nBar\nFoo\n$/);
	"use strict";
	const {hackMethod, OriginalMethod} = require("./index.js");
	const fn = () => console.log("Foo");
	global.doStuff = fn;
	global.doStuff();
	hackMethod(global, "doStuff", () => console.log("Bar"));
	global.doStuff();
	global.doStuff[OriginalMethod]();
	require("assert").strictEqual(fn, global.doStuff[OriginalMethod]);
JAVASCRIPT


# Test 7: Providing access to context and argument list
like(run(<<'JAVASCRIPT'), qr/^FOO\n18\n$/);
	"use strict";
	const {hackMethod} = require("./index.js");
	const subject = {
		name: "foo",
		exec(a, b){ return a * b; },
	};
	hackMethod(subject, "exec", function(oldFn, ...args){
		console.log(this.name.toUpperCase());
		console.log(oldFn(...args));
	});
	subject.exec(6, 3);
JAVASCRIPT


# Test 8: Copying across enumerable properties
like(run(<<'JAVASCRIPT'), qr/^Foo\n55\nBar\nBaz\n$/);
	"use strict";
	const {hackMethod} = require("./index.js");
	const obj = {};
	global.doStuff = () => true;
	global.doStuff.int = 55;
	global.doStuff.str = "Bar";
	global.doStuff.obj = obj;
	global.doStuff.fun = () => console.log("Baz");
	hackMethod(global, "doStuff", () => console.log("Foo"));
	global.doStuff();
	console.log(global.doStuff.int);
	console.log(global.doStuff.str);
	global.doStuff.fun();
	require("assert").strictEqual(obj, global.doStuff.obj);
JAVASCRIPT
