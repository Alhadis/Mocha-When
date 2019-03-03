"use strict";

describe("Second", () => {
	when("this test runs", () => {
		it("should also print a prefixed title", () => {
			expect(global.it).to.be.a("function");
		});
	});
});
