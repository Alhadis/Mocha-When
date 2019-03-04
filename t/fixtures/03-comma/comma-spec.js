"use strict";

require("../../../index.js")({addComma: true});

describe("Comma insertion", () => {
	when("the addComma option is enabled", () => {
		it("appends a trailing comma to each `when` line", () => true);
		it("doesn't append it to test lines, though",      () => true);
	});
});
