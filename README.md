[![Build Status: TravisCI](https://travis-ci.org/Alhadis/Mocha-When.svg?branch=master)](https://travis-ci.org/Alhadis/Mocha-When)
[![Latest package version](https://img.shields.io/npm/v/mocha-when.svg?colorB=brightgreen)](https://github.com/Alhadis/Mocha-When/releases/latest)

“What's this?”
--------------
This is a drop-in enhancement for [Mocha's BDD interface](https://mochajs.org/#bdd),
which adds two small but tangible improvements:


<a name="when"></a>
### A `when()` global
This is the same calling `describe()`, but the description you give is automatically prefixed by `"When "`:

~~~js
when("this test is run", () => {
	it('gets prepended with the word "When"', …);
});
~~~

Which is a shorter, clearer way of writing:

~~~js
describe("when this test is run", () => …);
~~~


<a name="it"></a>
### Tests specified by `it()` actually start with `"It "`
Mocha makes idiomatic tests fun to write ...

~~~js
describe("when the app starts", () => {
	it("activates successfully", () => …);
	it("connects to the server", () => …);
	it("receives a valid payload", () => …);
});
~~~

... but not as fun to read:

	when the app starts
	  ✓ activates successfully
	  ✓ connects to the server
	  ✓ receives a valid payload
	  ✓ displays the result

This module fixes such broken language by automatically prefixing each test:

	when the app starts
	  ✓ it activates successfully
	  ✓ it connects to the server
	  ✓ it receives a valid payload
	  ✓ it displays the result

If a test (or suite) description already includes the expected prefix, it won't be modified.
So you needn't worry about stuff like this:

	when When the prefix is included
	  ✓ it it won't repeat the word "it"
	  ✓ it it'll check for contractions too



Usage
-----
1.	Add `mocha-when` to your project's dependencies:
		~~~sh
		# Using NPM:
		npm install --save-dev mocha-when

		# Or with Yarn:
		yarn add mocha-when
		~~~

2.	Activate it by calling the function it exports:
	~~~js
	require("mocha-when")();
	~~~
	Or simply pass `mocha-when/register` to [Mocha's `require` option](https://mochajs.org/#-require-module-r-module):
	~~~js
	// In your `.mocharc.js` file:
	module.exports = {
		require: [
			"mocha-when/register",
		]
	};
	~~~


Caveats
-------
* ESLint won't recognise the `when()` global, so add it to your [`globals` list](https://eslint.org/docs/user-guide/configuring#specifying-globals).
* Mocha's [`ui`](https://mochajs.org/#-ui-name-u-name) option is assumed to be `bdd` (the default).
* Tests can be declared without an `it` prefix using `specify()`.
* The enhancements applied by this module are persistent and irrevocable.
