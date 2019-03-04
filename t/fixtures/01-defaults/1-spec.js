"use strict";

describe("Defaults", () => {
	when("this suite runs", () => {
		it("should print a prefixed title", () => true);
		it("should prefix this title, too", () => true);
	});
	
	when("another suite runs", () => {
		it("still prefixes its tests", () => true);
		
		when("a nested suite runs", () => {
			it("prefixes its tests as well", () => true);
		});
	});
	
	when("skipping a test", () => {
		it.skip("still prefixes the title", () => {});
	});
	
	when("when a title already begins with a prefix", () => {
		it("it isn't duplicated", () => true);
		it("it'll not be repeated for similar words", () => true);
		it("IT'S NOT CASE-SENSITIVE", () => true);
		it("It'd be nice if it wasn't a hack", () => true);
	});
	
	when("   titles contain leading/trailing whitespace   ", () => {
		it("   trims that crap   ", () => true);
	});
});
