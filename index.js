"use strict";

/**
 * Hack Mocha's BDD methods to provide more eloquent-looking feedback.
 *
 * @param {Object}  [options={}]                  - Additional settings
 * @param {Boolean} [options.addComma=false]      - Insert commas after each `when` line
 * @param {Boolean} [options.lowercaseWhen=false] - Don't capitalise `when` prefixes
 * @param {Boolean} [options.lowercaseIt=true]    - Don't capitalise `it` prefixes
 * @public
 */
module.exports = (options = {}) => {
	let lastIt = global.it;
	const {
		addComma      = false,
		lowercaseWhen = false,
		lowercaseIt   = true,
	} = options;

	Object.defineProperty(global, "it", {
		get: () => lastIt,
		set: to => {
			if(to === lastIt) return;
			if("function" === typeof to)
				lastIt = Object.assign(function(text, ...args){
					if(!/^\s*it(?:\s|[’`´'](?:ll|[ds]))/i.test(text))
						text = `${lowercaseIt ? "i": "I"}t ${text.trim()}`;
					return to.call(this, text, ...args);
				}, to);
			else lastIt = to;
		},
	});

	global.when = Object.assign(function(text, ...args){
		if(!/^\s*When\s/i.test(text))
			text = `${lowercaseWhen ? "w" : "W"}hen ${text.trim()}${addComma ? "," : ""}`;
		return global.describe.call(this, text, ...args);
	}, global.describe);
};
