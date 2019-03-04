"use strict";

require("../../../index.js")({lowercaseIt: false});

describe("Lowercased `it`", () => {
	when("the lowercaseIt option is disabled", () => {
		it("capitalises the test's prefix", () => true);
	});
});
