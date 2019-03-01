"use strict";

module.exports = ({preferLowercase: false, noComma: false} = {}) => {
	let lastIt;

	Object.defineProperty(global, "it", {
		get: () => lastIt,
		set: to => {
			if(to === lastIt) return;
			if("function" === typeof to)
				lastIt = Object.assign(function(...args){
					if(!/^it(?:\s|[’`´'](?:ll|[ds]))/i.test(args[0]))
						args[0] = `It ${args[0].trim()}`;
					return to.call(this, ...args);
				}, to);
			else lastIt = to;
		},
	});

	global.when = function when(text, ...args){
		return describe.call(this, `When ${text},`, ...args);
	};
};
