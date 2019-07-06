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
	const {
		addComma      = false,
		lowercaseWhen = false,
		lowercaseIt   = true,
	} = options;

	hackMethod(global, "it", function(oldFn, ...args){
		if(!/^\s*it(?:\s|[’`´'](?:ll|[ds]))/i.test(args[0]))
			args[0] = `${lowercaseIt ? "i": "I"}t ${args[0].trim()}`;
		return oldFn.call(this, ...args);
	});

	global.when = Object.assign(function(text, ...args){
		if(!/^\s*When\s/i.test(text))
			text = `${lowercaseWhen ? "w" : "W"}hen ${text.trim()}${addComma ? "," : ""}`;
		return global.describe.call(this, text, ...args);
	}, global.describe);
};


/**
 * @const {Symbol} MochaWhen.OriginalMethod
 * @summary Symbol for referencing the original version of a replaced global.
 */
const OriginalMethod = Symbol.for("MochaWhen.OriginalMethod");


/**
 * Monkey-patch an object's method once it becomes available.
 *
 * NOTE: Synchronous execution is needed, so we can't rely on Promises.
 *
 * @param {Object} subject
 * @param {String} name
 * @param {Function} fn
 * @internal
 */
function hackMethod(subject, name, fn){
	const replace = () => {
		const oldFn = subject[name];
		if(OriginalMethod in oldFn) return;
		
		const newFn = Object.assign(function(...args){
			return fn.call(this, oldFn, ...args);
		}, oldFn, {[OriginalMethod]: oldFn});
		
		Object.defineProperty(subject, name, {
			configurable: false,
			enumerable: true,
			get: () => newFn,
			set: () => newFn,
		});
	};
	
	if("function" === typeof subject[name])
		replace();
	else{
		let value = subject[name];
		Object.defineProperty(subject, name, {
			configurable: true,
			get: () => value,
			set: to => {
				if("function" === typeof to){
					delete subject[name];
					subject[name] = to;
					replace();
				}
				else value = to;
			},
		});
	}
}

Object.assign(module.exports, {hackMethod, OriginalMethod});
