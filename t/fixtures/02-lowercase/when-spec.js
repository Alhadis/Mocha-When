"use strict";

require("../../../index.js")({lowercaseWhen: true});

describe("Lowercased `when`", () => {
	when("the lowercaseWhen option is enabled", () => {
		it("prints the suite's prefix in lowercase", () => true);
	});
});
