// Apply Node polyfills as necessary.
var window = {
  Date: Date,
  addEventListener: function () {},
  removeEventListener: function () {},
};

var location = {
  href: '',
  host: '',
  hostname: '',
  protocol: '',
  origin: '',
  port: '',
  pathname: '',
  search: '',
  hash: '',
  username: '',
  password: '',
};
var document = { body: {}, createTextNode: function () {}, location: location };

if (typeof FileList === 'undefined') {
  FileList = function () {};
}

if (typeof File === 'undefined') {
  File = function () {};
}

if (typeof XMLHttpRequest === 'undefined') {
  XMLHttpRequest = function () {
    return {
      addEventListener: function () {},
      open: function () {},
      send: function () {},
    };
  };

  var oldConsoleWarn = console.warn;
  console.warn = function () {
    if (
      arguments.length === 1 &&
      arguments[0].indexOf('Compiled in DEV mode') === 0
    )
      return;
    return oldConsoleWarn.apply(console, arguments);
  };
}

if (typeof FormData === 'undefined') {
  FormData = function () {
    this._data = [];
  };
  FormData.prototype.append = function () {
    this._data.push(Array.prototype.slice.call(arguments));
  };
}

var Elm = (function(module) {
var __elmTestSymbol = Symbol("elmTestSymbol");
(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}

console.warn('Compiled in DEV mode. Follow the advice at https://elm-lang.org/0.19.1/optimize for better performance and smaller assets.');


var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log_UNUSED = F2(function(tag, value)
{
	return value;
});

var _Debug_log = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString_UNUSED(value)
{
	return '<internals>';
}

function _Debug_toString(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File !== 'undefined' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[36m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash_UNUSED(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.start.line === region.end.line)
	{
		return 'on line ' + region.start.line;
	}
	return 'on lines ' + region.start.line + ' through ' + region.end.line;
}



// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	/**/
	if (x.$ === 'Set_elm_builtin')
	{
		x = $elm$core$Set$toList(x);
		y = $elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	/**_UNUSED/
	if (x.$ < 0)
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**_UNUSED/
	if (typeof x.$ === 'undefined')
	//*/
	/**/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0_UNUSED = 0;
var _Utils_Tuple0 = { $: '#0' };

function _Utils_Tuple2_UNUSED(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3_UNUSED(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr_UNUSED(c) { return c; }
function _Utils_chr(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



var _List_Nil_UNUSED = { $: 0 };
var _List_Nil = { $: '[]' };

function _List_Cons_UNUSED(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === $elm$core$Basics$EQ ? 0 : ord === $elm$core$Basics$LT ? -1 : 1;
	}));
});



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return !isNaN(word)
		? $elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: $elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return $elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? $elm$core$Maybe$Nothing
		: $elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return $elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? $elm$core$Maybe$Just(n) : $elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}



function _Url_percentEncode(string)
{
	return encodeURIComponent(string);
}

function _Url_percentDecode(string)
{
	try
	{
		return $elm$core$Maybe$Just(decodeURIComponent(string));
	}
	catch (e)
	{
		return $elm$core$Maybe$Nothing;
	}
}


function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**/
function _Json_errorToString(error)
{
	return $elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? $elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? $elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return $elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? $elm$core$Result$Ok(value)
		: (value instanceof String)
			? $elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? $elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (value.hasOwnProperty(key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!$elm$core$Result$isOk(result))
					{
						return $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return $elm$core$Result$Ok($elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!$elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return $elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!$elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if ($elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return $elm$core$Result$Err($elm$json$Json$Decode$OneOf($elm$core$List$reverse(errors)));

		case 1:
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return $elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!$elm$core$Result$isOk(result))
		{
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return $elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2($elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap(value) { return { $: 0, a: value }; }
function _Json_unwrap(value) { return value.a; }

function _Json_wrap_UNUSED(value) { return value; }
function _Json_unwrap_UNUSED(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	object[key] = _Json_unwrap(value);
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



var _Bitwise_and = F2(function(a, b)
{
	return a & b;
});

var _Bitwise_or = F2(function(a, b)
{
	return a | b;
});

var _Bitwise_xor = F2(function(a, b)
{
	return a ^ b;
});

function _Bitwise_complement(a)
{
	return ~a;
};

var _Bitwise_shiftLeftBy = F2(function(offset, a)
{
	return a << offset;
});

var _Bitwise_shiftRightBy = F2(function(offset, a)
{
	return a >> offset;
});

var _Bitwise_shiftRightZfBy = F2(function(offset, a)
{
	return a >>> offset;
});



function _Test_runThunk(thunk)
{
  try {
    // Attempt to run the thunk as normal.
    return $elm$core$Result$Ok(thunk(_Utils_Tuple0));
  } catch (err) {
    // If it throws, return an error instead of crashing.
    return $elm$core$Result$Err(err.toString());
  }
}



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.init,
		impl.update,
		impl.subscriptions,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	$elm$core$Result$isOk(result) || _Debug_crash(2 /**/, _Json_errorToString(result.a) /**/);
	var managers = {};
	var initPair = init(result.a);
	var model = initPair.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		var pair = A2(update, msg, model);
		stepper(model = pair.a, viewMetadata);
		_Platform_enqueueEffects(managers, pair.b, subscriptions(model));
	}

	_Platform_enqueueEffects(managers, initPair.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS
//
// Effects must be queued!
//
// Say your init contains a synchronous command, like Time.now or Time.here
//
//   - This will produce a batch of effects (FX_1)
//   - The synchronous task triggers the subsequent `update` call
//   - This will produce a batch of effects (FX_2)
//
// If we just start dispatching FX_2, subscriptions from FX_2 can be processed
// before subscriptions from FX_1. No good! Earlier versions of this code had
// this problem, leading to these reports:
//
//   https://github.com/elm/core/issues/980
//   https://github.com/elm/core/pull/981
//   https://github.com/elm/compiler/issues/1776
//
// The queue is necessary to avoid ordering issues for synchronous commands.


// Why use true/false here? Why not just check the length of the queue?
// The goal is to detect "are we currently dispatching effects?" If we
// are, we need to bail and let the ongoing while loop handle things.
//
// Now say the queue has 1 element. When we dequeue the final element,
// the queue will be empty, but we are still actively dispatching effects.
// So you could get queue jumping in a really tricky category of cases.
//
var _Platform_effectsQueue = [];
var _Platform_effectsActive = false;


function _Platform_enqueueEffects(managers, cmdBag, subBag)
{
	_Platform_effectsQueue.push({ p: managers, q: cmdBag, r: subBag });

	if (_Platform_effectsActive) return;

	_Platform_effectsActive = true;
	for (var fx; fx = _Platform_effectsQueue.shift(); )
	{
		_Platform_dispatchEffects(fx.p, fx.q, fx.r);
	}
	_Platform_effectsActive = false;
}


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				s: bag.n,
				t: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.t)
		{
			x = temp.s(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		u: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		u: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		$elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}



function _Time_now(millisToPosix)
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(millisToPosix(Date.now())));
	});
}

var _Time_setInterval = F2(function(interval, task)
{
	return _Scheduler_binding(function(callback)
	{
		var id = setInterval(function() { _Scheduler_rawSpawn(task); }, interval);
		return function() { clearInterval(id); };
	});
});

function _Time_here()
{
	return _Scheduler_binding(function(callback)
	{
		callback(_Scheduler_succeed(
			A2($elm$time$Time$customZone, -(new Date().getTimezoneOffset()), _List_Nil)
		));
	});
}


function _Time_getZoneName()
{
	return _Scheduler_binding(function(callback)
	{
		try
		{
			var name = $elm$time$Time$Name(Intl.DateTimeFormat().resolvedOptions().timeZone);
		}
		catch (e)
		{
			var name = $elm$time$Time$Offset(new Date().getTimezoneOffset());
		}
		callback(_Scheduler_succeed(name));
	});
}


// CREATE

var _Regex_never = /.^/;

var _Regex_fromStringWith = F2(function(options, string)
{
	var flags = 'g';
	if (options.multiline) { flags += 'm'; }
	if (options.caseInsensitive) { flags += 'i'; }

	try
	{
		return $elm$core$Maybe$Just(new RegExp(string, flags));
	}
	catch(error)
	{
		return $elm$core$Maybe$Nothing;
	}
});


// USE

var _Regex_contains = F2(function(re, string)
{
	return string.match(re) !== null;
});


var _Regex_findAtMost = F3(function(n, re, str)
{
	var out = [];
	var number = 0;
	var string = str;
	var lastIndex = re.lastIndex;
	var prevLastIndex = -1;
	var result;
	while (number++ < n && (result = re.exec(string)))
	{
		if (prevLastIndex == re.lastIndex) break;
		var i = result.length - 1;
		var subs = new Array(i);
		while (i > 0)
		{
			var submatch = result[i];
			subs[--i] = submatch
				? $elm$core$Maybe$Just(submatch)
				: $elm$core$Maybe$Nothing;
		}
		out.push(A4($elm$regex$Regex$Match, result[0], result.index, number, _List_fromArray(subs)));
		prevLastIndex = re.lastIndex;
	}
	re.lastIndex = lastIndex;
	return _List_fromArray(out);
});


var _Regex_replaceAtMost = F4(function(n, re, replacer, string)
{
	var count = 0;
	function jsReplacer(match)
	{
		if (count++ >= n)
		{
			return match;
		}
		var i = arguments.length - 3;
		var submatches = new Array(i);
		while (i > 0)
		{
			var submatch = arguments[i];
			submatches[--i] = submatch
				? $elm$core$Maybe$Just(submatch)
				: $elm$core$Maybe$Nothing;
		}
		return replacer(A4($elm$regex$Regex$Match, match, arguments[arguments.length - 2], count, _List_fromArray(submatches)));
	}
	return string.replace(re, jsReplacer);
});

var _Regex_splitAtMost = F3(function(n, re, str)
{
	var string = str;
	var out = [];
	var start = re.lastIndex;
	var restoreLastIndex = re.lastIndex;
	while (n--)
	{
		var result = re.exec(string);
		if (!result) break;
		out.push(string.slice(start, result.index));
		start = re.lastIndex;
	}
	out.push(string.slice(start));
	re.lastIndex = restoreLastIndex;
	return _List_fromArray(out);
});

var _Regex_infinity = Infinity;
var $elm$core$List$cons = _List_cons;
var $elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var $elm$core$Array$foldr = F3(
	function (func, baseCase, _v0) {
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = F2(
			function (node, acc) {
				if (node.$ === 'SubTree') {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3($elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			$elm$core$Elm$JsArray$foldr,
			helper,
			A3($elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var $elm$core$Array$toList = function (array) {
	return A3($elm$core$Array$foldr, $elm$core$List$cons, _List_Nil, array);
};
var $elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === 'RBEmpty_elm_builtin') {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var $elm$core$Dict$toList = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Dict$keys = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2($elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Set$toList = function (_v0) {
	var dict = _v0.a;
	return $elm$core$Dict$keys(dict);
};
var $elm$core$Basics$EQ = {$: 'EQ'};
var $elm$core$Basics$GT = {$: 'GT'};
var $elm$core$Basics$LT = {$: 'LT'};
var $author$project$Test$Reporter$Reporter$ConsoleReport = function (a) {
	return {$: 'ConsoleReport', a: a};
};
var $author$project$Console$Text$UseColor = {$: 'UseColor'};
var $author$project$Code$Workspace$WorkspaceItem$Loading = function (a) {
	return {$: 'Loading', a: a};
};
var $author$project$Code$Definition$Reference$TermReference = function (a) {
	return {$: 'TermReference', a: a};
};
var $elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var $author$project$Code$HashQualified$HashOnly = function (a) {
	return {$: 'HashOnly', a: a};
};
var $author$project$Code$HashQualified$NameOnly = function (a) {
	return {$: 'NameOnly', a: a};
};
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $author$project$Code$FullyQualifiedName$FQN = function (a) {
	return {$: 'FQN', a: a};
};
var $elm$core$Basics$composeR = F3(
	function (f, g, x) {
		return g(
			f(x));
	});
var $elm$core$Basics$add = _Basics_add;
var $elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var $elm$core$Basics$gt = _Utils_gt;
var $elm$core$List$reverse = function (list) {
	return A3($elm$core$List$foldl, $elm$core$List$cons, _List_Nil, list);
};
var $elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							$elm$core$List$foldl,
							fn,
							acc,
							$elm$core$List$reverse(r4)) : A4($elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var $elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4($elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var $elm$core$List$filter = F2(
	function (isGood, list) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, xs) {
					return isGood(x) ? A2($elm$core$List$cons, x, xs) : xs;
				}),
			_List_Nil,
			list);
	});
var $mgold$elm_nonempty_list$List$Nonempty$Nonempty = F2(
	function (a, b) {
		return {$: 'Nonempty', a: a, b: b};
	});
var $mgold$elm_nonempty_list$List$Nonempty$singleton = function (x) {
	return A2($mgold$elm_nonempty_list$List$Nonempty$Nonempty, x, _List_Nil);
};
var $mgold$elm_nonempty_list$List$Nonempty$fromElement = $mgold$elm_nonempty_list$List$Nonempty$singleton;
var $elm$core$Maybe$Just = function (a) {
	return {$: 'Just', a: a};
};
var $elm$core$Maybe$Nothing = {$: 'Nothing'};
var $mgold$elm_nonempty_list$List$Nonempty$fromList = function (ys) {
	if (ys.b) {
		var x = ys.a;
		var xs = ys.b;
		return $elm$core$Maybe$Just(
			A2($mgold$elm_nonempty_list$List$Nonempty$Nonempty, x, xs));
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $elm$core$Basics$eq = _Utils_equal;
var $elm$core$String$isEmpty = function (string) {
	return string === '';
};
var $elm$core$List$map = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			F2(
				function (x, acc) {
					return A2(
						$elm$core$List$cons,
						f(x),
						acc);
				}),
			_List_Nil,
			xs);
	});
var $elm$core$Basics$not = _Basics_not;
var $elm$core$String$trim = _String_trim;
var $elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var $author$project$Code$FullyQualifiedName$fromList = function (segments_) {
	return $author$project$Code$FullyQualifiedName$FQN(
		A2(
			$elm$core$Maybe$withDefault,
			$mgold$elm_nonempty_list$List$Nonempty$fromElement('.'),
			$mgold$elm_nonempty_list$List$Nonempty$fromList(
				A2(
					$elm$core$List$filter,
					A2($elm$core$Basics$composeR, $elm$core$String$isEmpty, $elm$core$Basics$not),
					A2($elm$core$List$map, $elm$core$String$trim, segments_)))));
};
var $elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var $author$project$Code$FullyQualifiedName$fromString = function (rawFqn) {
	var go = function (s) {
		go:
		while (true) {
			if (!s.b) {
				return _List_Nil;
			} else {
				if (s.a === '') {
					if (s.b.b && (s.b.a === '')) {
						var _v1 = s.b;
						var z = _v1.b;
						return A2(
							$elm$core$List$cons,
							'.',
							go(z));
					} else {
						var z = s.b;
						var $temp$s = z;
						s = $temp$s;
						continue go;
					}
				} else {
					var x = s.a;
					var y = s.b;
					return A2(
						$elm$core$List$cons,
						x,
						go(y));
				}
			}
		}
	};
	return $author$project$Code$FullyQualifiedName$fromList(
		go(
			A2($elm$core$String$split, '.', rawFqn)));
};
var $author$project$Code$Hash$Hash = function (a) {
	return {$: 'Hash', a: a};
};
var $author$project$Code$Hash$prefix = '#';
var $elm$core$String$startsWith = _String_startsWith;
var $author$project$Code$Hash$fromString = function (raw) {
	return A2($elm$core$String$startsWith, $author$project$Code$Hash$prefix, raw) ? $elm$core$Maybe$Just(
		$author$project$Code$Hash$Hash(raw)) : $elm$core$Maybe$Nothing;
};
var $author$project$Code$HashQualified$HashQualified = F2(
	function (a, b) {
		return {$: 'HashQualified', a: a, b: b};
	});
var $elm$core$Basics$append = _Utils_append;
var $elm$core$Basics$and = _Basics_and;
var $elm$core$String$contains = _String_contains;
var $elm$core$Basics$or = _Basics_or;
var $author$project$Code$Hash$urlPrefix = '@';
var $author$project$Code$Hash$isRawHash = function (str) {
	return A2($elm$core$String$startsWith, $author$project$Code$Hash$prefix, str) || A2($elm$core$String$startsWith, $author$project$Code$Hash$urlPrefix, str);
};
var $author$project$Code$HashQualified$isRawHashQualified = function (str) {
	return (!$author$project$Code$Hash$isRawHash(str)) && A2($elm$core$String$contains, $author$project$Code$Hash$urlPrefix, str);
};
var $elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (maybe.$ === 'Just') {
			var value = maybe.a;
			return $elm$core$Maybe$Just(
				f(value));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$Code$HashQualified$hashQualifiedFromString = F3(
	function (toFQN, sep, str) {
		if ($author$project$Code$HashQualified$isRawHashQualified(str)) {
			var parts = A2($elm$core$String$split, sep, str);
			if (!parts.b) {
				return $elm$core$Maybe$Nothing;
			} else {
				if (parts.a === '') {
					if (!parts.b.b) {
						return $elm$core$Maybe$Nothing;
					} else {
						return $elm$core$Maybe$Nothing;
					}
				} else {
					if (parts.b.b && (!parts.b.b.b)) {
						var name_ = parts.a;
						var _v1 = parts.b;
						var unprefixedHash = _v1.a;
						return A2(
							$elm$core$Maybe$map,
							$author$project$Code$HashQualified$HashQualified(
								toFQN(name_)),
							$author$project$Code$Hash$fromString(
								_Utils_ap($author$project$Code$Hash$prefix, unprefixedHash)));
					} else {
						return $elm$core$Maybe$Nothing;
					}
				}
			}
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $elm_community$maybe_extra$Maybe$Extra$orElse = F2(
	function (ma, mb) {
		if (mb.$ === 'Nothing') {
			return ma;
		} else {
			return mb;
		}
	});
var $author$project$Code$HashQualified$fromString = function (str) {
	return A2(
		$elm$core$Maybe$withDefault,
		$author$project$Code$HashQualified$NameOnly(
			$author$project$Code$FullyQualifiedName$fromString(str)),
		A2(
			$elm_community$maybe_extra$Maybe$Extra$orElse,
			A3($author$project$Code$HashQualified$hashQualifiedFromString, $author$project$Code$FullyQualifiedName$fromString, $author$project$Code$Hash$prefix, str),
			A2(
				$elm$core$Maybe$map,
				$author$project$Code$HashQualified$HashOnly,
				$author$project$Code$Hash$fromString(str))));
};
var $author$project$Code$Definition$Reference$fromString = F2(
	function (toRef, str) {
		return toRef(
			$author$project$Code$HashQualified$fromString(str));
	});
var $author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr = function (str) {
	return A2($author$project$Code$Definition$Reference$fromString, $author$project$Code$Definition$Reference$TermReference, str);
};
var $author$project$Code$Workspace$WorkspaceItemsTests$after = _List_fromArray(
	[
		$author$project$Code$Workspace$WorkspaceItem$Loading(
		$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#c')),
		$author$project$Code$Workspace$WorkspaceItem$Loading(
		$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#d'))
	]);
var $elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var $mgold$elm_nonempty_list$List$Nonempty$append = F2(
	function (_v0, _v1) {
		var x = _v0.a;
		var xs = _v0.b;
		var y = _v1.a;
		var ys = _v1.b;
		return A2(
			$mgold$elm_nonempty_list$List$Nonempty$Nonempty,
			x,
			_Utils_ap(
				xs,
				A2($elm$core$List$cons, y, ys)));
	});
var $author$project$Code$FullyQualifiedName$append = F2(
	function (_v0, _v1) {
		var a = _v0.a;
		var b = _v1.a;
		return $author$project$Code$FullyQualifiedName$FQN(
			A2($mgold$elm_nonempty_list$List$Nonempty$append, a, b));
	});
var $elm_explorations$test$Test$Runner$Failure$BadDescription = {$: 'BadDescription'};
var $elm_explorations$test$Test$Internal$Batch = function (a) {
	return {__elmTestSymbol: __elmTestSymbol, $: 'Batch', a: a};
};
var $elm_explorations$test$Test$Runner$Failure$DuplicatedName = {$: 'DuplicatedName'};
var $elm_explorations$test$Test$Runner$Failure$EmptyList = {$: 'EmptyList'};
var $elm_explorations$test$Test$Runner$Failure$Invalid = function (a) {
	return {$: 'Invalid', a: a};
};
var $elm_explorations$test$Test$Internal$Labeled = F2(
	function (a, b) {
		return {__elmTestSymbol: __elmTestSymbol, $: 'Labeled', a: a, b: b};
	});
var $elm$core$Result$Err = function (a) {
	return {$: 'Err', a: a};
};
var $elm$core$Result$Ok = function (a) {
	return {$: 'Ok', a: a};
};
var $elm$core$Result$andThen = F2(
	function (callback, result) {
		if (result.$ === 'Ok') {
			var value = result.a;
			return callback(value);
		} else {
			var msg = result.a;
			return $elm$core$Result$Err(msg);
		}
	});
var $elm$core$List$append = F2(
	function (xs, ys) {
		if (!ys.b) {
			return xs;
		} else {
			return A3($elm$core$List$foldr, $elm$core$List$cons, ys, xs);
		}
	});
var $elm$core$List$concat = function (lists) {
	return A3($elm$core$List$foldr, $elm$core$List$append, _List_Nil, lists);
};
var $elm$core$List$concatMap = F2(
	function (f, list) {
		return $elm$core$List$concat(
			A2($elm$core$List$map, f, list));
	});
var $elm$core$Set$Set_elm_builtin = function (a) {
	return {$: 'Set_elm_builtin', a: a};
};
var $elm$core$Dict$RBEmpty_elm_builtin = {$: 'RBEmpty_elm_builtin'};
var $elm$core$Dict$empty = $elm$core$Dict$RBEmpty_elm_builtin;
var $elm$core$Set$empty = $elm$core$Set$Set_elm_builtin($elm$core$Dict$empty);
var $elm$core$Dict$Black = {$: 'Black'};
var $elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: 'RBNode_elm_builtin', a: a, b: b, c: c, d: d, e: e};
	});
var $elm$core$Dict$Red = {$: 'Red'};
var $elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Red')) {
			var _v1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
				var _v3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					key,
					value,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) && (left.d.$ === 'RBNode_elm_builtin')) && (left.d.a.$ === 'Red')) {
				var _v5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _v6 = left.d;
				var _v7 = _v6.a;
				var llK = _v6.b;
				var llV = _v6.c;
				var llLeft = _v6.d;
				var llRight = _v6.e;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Red,
					lK,
					lV,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, key, value, lRight, right));
			} else {
				return A5($elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var $elm$core$Basics$compare = _Utils_compare;
var $elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _v1 = A2($elm$core$Basics$compare, key, nKey);
			switch (_v1.$) {
				case 'LT':
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3($elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 'EQ':
					return A5($elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3($elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var $elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _v0 = A3($elm$core$Dict$insertHelp, key, value, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Set$insert = F2(
	function (key, _v0) {
		var dict = _v0.a;
		return $elm$core$Set$Set_elm_builtin(
			A3($elm$core$Dict$insert, key, _Utils_Tuple0, dict));
	});
var $elm$core$Basics$False = {$: 'False'};
var $elm$core$Basics$True = {$: 'True'};
var $elm$core$Dict$get = F2(
	function (targetKey, dict) {
		get:
		while (true) {
			if (dict.$ === 'RBEmpty_elm_builtin') {
				return $elm$core$Maybe$Nothing;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var _v1 = A2($elm$core$Basics$compare, targetKey, key);
				switch (_v1.$) {
					case 'LT':
						var $temp$targetKey = targetKey,
							$temp$dict = left;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
					case 'EQ':
						return $elm$core$Maybe$Just(value);
					default:
						var $temp$targetKey = targetKey,
							$temp$dict = right;
						targetKey = $temp$targetKey;
						dict = $temp$dict;
						continue get;
				}
			}
		}
	});
var $elm$core$Dict$member = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$get, key, dict);
		if (_v0.$ === 'Just') {
			return true;
		} else {
			return false;
		}
	});
var $elm$core$Set$member = F2(
	function (key, _v0) {
		var dict = _v0.a;
		return A2($elm$core$Dict$member, key, dict);
	});
var $elm_explorations$test$Test$Internal$duplicatedName = function () {
	var names = function (test) {
		names:
		while (true) {
			switch (test.$) {
				case 'Labeled':
					var str = test.a;
					return _List_fromArray(
						[str]);
				case 'Batch':
					var subtests = test.a;
					return A2($elm$core$List$concatMap, names, subtests);
				case 'UnitTest':
					return _List_Nil;
				case 'FuzzTest':
					return _List_Nil;
				case 'Skipped':
					var subTest = test.a;
					var $temp$test = subTest;
					test = $temp$test;
					continue names;
				default:
					var subTest = test.a;
					var $temp$test = subTest;
					test = $temp$test;
					continue names;
			}
		}
	};
	var insertOrFail = function (newName) {
		return $elm$core$Result$andThen(
			function (oldNames) {
				return A2($elm$core$Set$member, newName, oldNames) ? $elm$core$Result$Err(newName) : $elm$core$Result$Ok(
					A2($elm$core$Set$insert, newName, oldNames));
			});
	};
	return A2(
		$elm$core$Basics$composeR,
		$elm$core$List$concatMap(names),
		A2(
			$elm$core$List$foldl,
			insertOrFail,
			$elm$core$Result$Ok($elm$core$Set$empty)));
}();
var $elm_explorations$test$Test$Internal$UnitTest = function (a) {
	return {__elmTestSymbol: __elmTestSymbol, $: 'UnitTest', a: a};
};
var $elm_explorations$test$Test$Expectation$Fail = function (a) {
	return {$: 'Fail', a: a};
};
var $elm_explorations$test$Test$Expectation$fail = function (_v0) {
	var description = _v0.description;
	var reason = _v0.reason;
	return $elm_explorations$test$Test$Expectation$Fail(
		{description: description, given: $elm$core$Maybe$Nothing, reason: reason});
};
var $elm_explorations$test$Test$Internal$failNow = function (record) {
	return $elm_explorations$test$Test$Internal$UnitTest(
		function (_v0) {
			return _List_fromArray(
				[
					$elm_explorations$test$Test$Expectation$fail(record)
				]);
		});
};
var $elm$core$List$isEmpty = function (xs) {
	if (!xs.b) {
		return true;
	} else {
		return false;
	}
};
var $elm_explorations$test$Test$describe = F2(
	function (untrimmedDesc, tests) {
		var desc = $elm$core$String$trim(untrimmedDesc);
		if ($elm$core$String$isEmpty(desc)) {
			return $elm_explorations$test$Test$Internal$failNow(
				{
					description: 'This `describe` has a blank description. Let\'s give it a useful one!',
					reason: $elm_explorations$test$Test$Runner$Failure$Invalid($elm_explorations$test$Test$Runner$Failure$BadDescription)
				});
		} else {
			if ($elm$core$List$isEmpty(tests)) {
				return $elm_explorations$test$Test$Internal$failNow(
					{
						description: 'This `describe ' + (desc + '` has no tests in it. Let\'s give it some!'),
						reason: $elm_explorations$test$Test$Runner$Failure$Invalid($elm_explorations$test$Test$Runner$Failure$EmptyList)
					});
			} else {
				var _v0 = $elm_explorations$test$Test$Internal$duplicatedName(tests);
				if (_v0.$ === 'Err') {
					var duped = _v0.a;
					return $elm_explorations$test$Test$Internal$failNow(
						{
							description: 'The tests \'' + (desc + ('\' contain multiple tests named \'' + (duped + '\'. Let\'s rename them so we know which is which.'))),
							reason: $elm_explorations$test$Test$Runner$Failure$Invalid($elm_explorations$test$Test$Runner$Failure$DuplicatedName)
						});
				} else {
					var childrenNames = _v0.a;
					return A2($elm$core$Set$member, desc, childrenNames) ? $elm_explorations$test$Test$Internal$failNow(
						{
							description: 'The test \'' + (desc + '\' contains a child test of the same name. Let\'s rename them so we know which is which.'),
							reason: $elm_explorations$test$Test$Runner$Failure$Invalid($elm_explorations$test$Test$Runner$Failure$DuplicatedName)
						}) : A2(
						$elm_explorations$test$Test$Internal$Labeled,
						desc,
						$elm_explorations$test$Test$Internal$Batch(tests));
				}
			}
		}
	});
var $elm_explorations$test$Test$Runner$Failure$Equality = F2(
	function (a, b) {
		return {$: 'Equality', a: a, b: b};
	});
var $elm_explorations$test$Test$Runner$Failure$Custom = {$: 'Custom'};
var $elm_explorations$test$Expect$fail = function (str) {
	return $elm_explorations$test$Test$Expectation$fail(
		{description: str, reason: $elm_explorations$test$Test$Runner$Failure$Custom});
};
var $elm_explorations$test$Test$Expectation$Pass = {$: 'Pass'};
var $elm_explorations$test$Expect$pass = $elm_explorations$test$Test$Expectation$Pass;
var $elm_explorations$test$Test$Internal$toString = _Debug_toString;
var $elm_explorations$test$Expect$testWith = F5(
	function (makeReason, label, runTest, expected, actual) {
		return A2(runTest, actual, expected) ? $elm_explorations$test$Expect$pass : $elm_explorations$test$Test$Expectation$fail(
			{
				description: label,
				reason: A2(
					makeReason,
					$elm_explorations$test$Test$Internal$toString(expected),
					$elm_explorations$test$Test$Internal$toString(actual))
			});
	});
var $elm$core$String$toFloat = _String_toFloat;
var $elm$core$String$toInt = _String_toInt;
var $elm_explorations$test$Expect$equateWith = F4(
	function (reason, comparison, b, a) {
		var isJust = function (x) {
			if (x.$ === 'Just') {
				return true;
			} else {
				return false;
			}
		};
		var isFloat = function (x) {
			return isJust(
				$elm$core$String$toFloat(x)) && (!isJust(
				$elm$core$String$toInt(x)));
		};
		var usesFloats = isFloat(
			$elm_explorations$test$Test$Internal$toString(a)) || isFloat(
			$elm_explorations$test$Test$Internal$toString(b));
		var floatError = A2($elm$core$String$contains, reason, 'not') ? 'Do not use Expect.notEqual with floats. Use Float.notWithin instead.' : 'Do not use Expect.equal with floats. Use Float.within instead.';
		return usesFloats ? $elm_explorations$test$Expect$fail(floatError) : A5($elm_explorations$test$Expect$testWith, $elm_explorations$test$Test$Runner$Failure$Equality, reason, comparison, b, a);
	});
var $elm_explorations$test$Expect$equal = A2($elm_explorations$test$Expect$equateWith, 'Expect.equal', $elm$core$Basics$eq);
var $author$project$Code$FullyQualifiedName$segments = function (_v0) {
	var segments_ = _v0.a;
	return segments_;
};
var $mgold$elm_nonempty_list$List$Nonempty$toList = function (_v0) {
	var x = _v0.a;
	var xs = _v0.b;
	return A2($elm$core$List$cons, x, xs);
};
var $author$project$Code$FullyQualifiedNameTests$segments = A2($elm$core$Basics$composeR, $author$project$Code$FullyQualifiedName$segments, $mgold$elm_nonempty_list$List$Nonempty$toList);
var $elm_explorations$test$Test$Internal$blankDescriptionFailure = $elm_explorations$test$Test$Internal$failNow(
	{
		description: 'This test has a blank description. Let\'s give it a useful one!',
		reason: $elm_explorations$test$Test$Runner$Failure$Invalid($elm_explorations$test$Test$Runner$Failure$BadDescription)
	});
var $elm_explorations$test$Test$test = F2(
	function (untrimmedDesc, thunk) {
		var desc = $elm$core$String$trim(untrimmedDesc);
		return $elm$core$String$isEmpty(desc) ? $elm_explorations$test$Test$Internal$blankDescriptionFailure : A2(
			$elm_explorations$test$Test$Internal$Labeled,
			desc,
			$elm_explorations$test$Test$Internal$UnitTest(
				function (_v0) {
					return _List_fromArray(
						[
							thunk(_Utils_Tuple0)
						]);
				}));
	});
var $author$project$Code$FullyQualifiedNameTests$append = A2(
	$elm_explorations$test$Test$describe,
	'FullyQualifiedName.append',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Appends 2 FQNs',
			function (_v0) {
				var b = $author$project$Code$FullyQualifiedName$fromString('List');
				var a = $author$project$Code$FullyQualifiedName$fromString('base');
				return A2(
					$elm_explorations$test$Expect$equal,
					_List_fromArray(
						['base', 'List']),
					$author$project$Code$FullyQualifiedNameTests$segments(
						A2($author$project$Code$FullyQualifiedName$append, a, b)));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Appending doesn\'t attempt to dedupe',
			function (_v1) {
				var b = $author$project$Code$FullyQualifiedName$fromString('base.List');
				var a = $author$project$Code$FullyQualifiedName$fromString('base');
				return A2(
					$elm_explorations$test$Expect$equal,
					_List_fromArray(
						['base', 'base', 'List']),
					$author$project$Code$FullyQualifiedNameTests$segments(
						A2($author$project$Code$FullyQualifiedName$append, a, b)));
			})
		]));
var $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems = function (a) {
	return {$: 'WorkspaceItems', a: a};
};
var $author$project$Code$Workspace$WorkspaceItems$toList = function (wItems) {
	if (wItems.$ === 'Empty') {
		return _List_Nil;
	} else {
		var items = wItems.a;
		return _Utils_ap(
			items.before,
			A2($elm$core$List$cons, items.focus, items.after));
	}
};
var $author$project$Code$Workspace$WorkspaceItems$appendWithFocus = F2(
	function (items, item) {
		return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
			{
				after: _List_Nil,
				before: $author$project$Code$Workspace$WorkspaceItems$toList(items),
				focus: item
			});
	});
var $author$project$Code$Workspace$WorkspaceItems$Empty = {$: 'Empty'};
var $author$project$Code$Workspace$WorkspaceItems$empty = $author$project$Code$Workspace$WorkspaceItems$Empty;
var $author$project$Code$Workspace$WorkspaceItems$focus = function (items) {
	if (items.$ === 'Empty') {
		return $elm$core$Maybe$Nothing;
	} else {
		var data = items.a;
		return $elm$core$Maybe$Just(data.focus);
	}
};
var $author$project$Code$Workspace$WorkspaceItem$reference = function (item) {
	switch (item.$) {
		case 'Loading':
			var r = item.a;
			return r;
		case 'Failure':
			var r = item.a;
			return r;
		default:
			var r = item.a;
			return r;
	}
};
var $author$project$Code$Workspace$WorkspaceItems$focusedReference = function (items) {
	return A2(
		$elm$core$Maybe$map,
		$author$project$Code$Workspace$WorkspaceItem$reference,
		$author$project$Code$Workspace$WorkspaceItems$focus(items));
};
var $elm_community$list_extra$List$Extra$last = function (items) {
	last:
	while (true) {
		if (!items.b) {
			return $elm$core$Maybe$Nothing;
		} else {
			if (!items.b.b) {
				var x = items.a;
				return $elm$core$Maybe$Just(x);
			} else {
				var rest = items.b;
				var $temp$items = rest;
				items = $temp$items;
				continue last;
			}
		}
	}
};
var $author$project$Code$Workspace$WorkspaceItems$last = function (items) {
	return $elm_community$list_extra$List$Extra$last(
		$author$project$Code$Workspace$WorkspaceItems$toList(items));
};
var $author$project$Code$Workspace$WorkspaceItemsTests$hashQualified = $author$project$Code$HashQualified$fromString('#testhash');
var $author$project$Code$Workspace$WorkspaceItemsTests$termRef = $author$project$Code$Definition$Reference$TermReference($author$project$Code$Workspace$WorkspaceItemsTests$hashQualified);
var $author$project$Code$Workspace$WorkspaceItemsTests$term = $author$project$Code$Workspace$WorkspaceItem$Loading($author$project$Code$Workspace$WorkspaceItemsTests$termRef);
var $elm_explorations$test$Expect$true = F2(
	function (message, bool) {
		return bool ? $elm_explorations$test$Expect$pass : $elm_explorations$test$Expect$fail(message);
	});
var $author$project$Code$Workspace$WorkspaceItemsTests$appendWithFocus = function () {
	var result = A2($author$project$Code$Workspace$WorkspaceItems$appendWithFocus, $author$project$Code$Workspace$WorkspaceItems$empty, $author$project$Code$Workspace$WorkspaceItemsTests$term);
	var currentFocusedRef = $author$project$Code$Workspace$WorkspaceItems$focusedReference(result);
	return A2(
		$elm_explorations$test$Test$describe,
		'WorkspaceItems.appendWithFocus',
		_List_fromArray(
			[
				A2(
				$elm_explorations$test$Test$test,
				'Appends the term',
				function (_v0) {
					return A2(
						$elm_explorations$test$Expect$equal,
						$elm$core$Maybe$Just($author$project$Code$Workspace$WorkspaceItemsTests$term),
						$author$project$Code$Workspace$WorkspaceItems$last(result));
				}),
				A2(
				$elm_explorations$test$Test$test,
				'Sets focus',
				function (_v1) {
					return A2(
						$elm_explorations$test$Expect$true,
						'Has focus',
						A2(
							$elm$core$Maybe$withDefault,
							false,
							A2(
								$elm$core$Maybe$map,
								function (r) {
									return _Utils_eq(r, $author$project$Code$Workspace$WorkspaceItemsTests$termRef);
								},
								currentFocusedRef)));
				})
			]));
}();
var $author$project$Code$Workspace$WorkspaceItemsTests$before = _List_fromArray(
	[
		$author$project$Code$Workspace$WorkspaceItem$Loading(
		$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a')),
		$author$project$Code$Workspace$WorkspaceItem$Loading(
		$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b'))
	]);
var $elm$core$Debug$todo = _Debug_todo;
var $author$project$Test$Runner$Node$checkHelperReplaceMe___ = function (_v0) {
	return _Debug_todo(
		'Test.Runner.Node',
		{
			start: {line: 362, column: 5},
			end: {line: 362, column: 15}
		})('The regex for replacing this Debug.todo with some real code must have failed since you see this message!\n\nPlease report this bug: https://github.com/rtfeldman/node-test-runner/issues/new\n');
};
var $author$project$Test$Runner$Node$check = value => value && value.__elmTestSymbol === __elmTestSymbol ? $elm$core$Maybe$Just(value) : $elm$core$Maybe$Nothing;
var $author$project$Code$Perspective$Root = function (a) {
	return {$: 'Root', a: a};
};
var $author$project$Code$Finder$SearchOptionsTests$codebasePerspective = A2(
	$elm$core$Maybe$map,
	$author$project$Code$Perspective$Root,
	$author$project$Code$Hash$fromString('#testhash'));
var $mgold$elm_nonempty_list$List$Nonempty$cons = F2(
	function (y, _v0) {
		var x = _v0.a;
		var xs = _v0.b;
		return A2(
			$mgold$elm_nonempty_list$List$Nonempty$Nonempty,
			y,
			A2($elm$core$List$cons, x, xs));
	});
var $author$project$Code$FullyQualifiedName$cons = F2(
	function (s, _v0) {
		var segments_ = _v0.a;
		return $author$project$Code$FullyQualifiedName$FQN(
			A2($mgold$elm_nonempty_list$List$Nonempty$cons, s, segments_));
	});
var $author$project$Code$FullyQualifiedNameTests$cons = A2(
	$elm_explorations$test$Test$describe,
	'FullyQualifiedName.cons',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'cons a String to the front of the FQN segments',
			function (_v0) {
				var list = $author$project$Code$FullyQualifiedName$fromString('List');
				return A2(
					$elm_explorations$test$Expect$equal,
					_List_fromArray(
						['base', 'List']),
					$author$project$Code$FullyQualifiedNameTests$segments(
						A2($author$project$Code$FullyQualifiedName$cons, 'base', list)));
			})
		]));
var $author$project$Code$Hash$equals = F2(
	function (_v0, _v1) {
		var a = _v0.a;
		var b = _v1.a;
		return _Utils_eq(a, b);
	});
var $elm_explorations$test$Expect$false = F2(
	function (message, bool) {
		return bool ? $elm_explorations$test$Expect$fail(message) : $elm_explorations$test$Expect$pass;
	});
var $elm$core$Maybe$map2 = F3(
	function (func, ma, mb) {
		if (ma.$ === 'Nothing') {
			return $elm$core$Maybe$Nothing;
		} else {
			var a = ma.a;
			if (mb.$ === 'Nothing') {
				return $elm$core$Maybe$Nothing;
			} else {
				var b = mb.a;
				return $elm$core$Maybe$Just(
					A2(func, a, b));
			}
		}
	});
var $author$project$Code$HashTests$equals = A2(
	$elm_explorations$test$Test$describe,
	'Hash.equals',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Returns True when equal',
			function (_v0) {
				return A2(
					$elm_explorations$test$Expect$true,
					'Expected Hash \"#foo\" and Hash \"#foo\" to be equal',
					A2(
						$elm$core$Maybe$withDefault,
						false,
						A3(
							$elm$core$Maybe$map2,
							$author$project$Code$Hash$equals,
							$author$project$Code$Hash$fromString('#foo'),
							$author$project$Code$Hash$fromString('#foo'))));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Returns False when not equal',
			function (_v1) {
				return A2(
					$elm_explorations$test$Expect$false,
					'Expected Hash \"#foo\" and Hash \"#bar\" to *not* be equal',
					A2(
						$elm$core$Maybe$withDefault,
						false,
						A3(
							$elm$core$Maybe$map2,
							$author$project$Code$Hash$equals,
							$author$project$Code$Hash$fromString('#foo'),
							$author$project$Code$Hash$fromString('#bar'))));
			})
		]));
var $author$project$Code$Workspace$WorkspaceItemsTests$focused = $author$project$Code$Workspace$WorkspaceItem$Loading(
	$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus'));
var $elm$core$String$length = _String_length;
var $elm$core$Basics$lt = _Utils_lt;
var $elm$core$String$slice = _String_slice;
var $elm$core$String$dropLeft = F2(
	function (n, string) {
		return (n < 1) ? string : A3(
			$elm$core$String$slice,
			n,
			$elm$core$String$length(string),
			string);
	});
var $elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var $author$project$Code$FullyQualifiedName$toString = function (_v0) {
	var nameParts = _v0.a;
	var trimLeadingDot = function (str) {
		return A2($elm$core$String$startsWith, '..', str) ? A2($elm$core$String$dropLeft, 1, str) : str;
	};
	return trimLeadingDot(
		A2(
			$elm$core$String$join,
			'.',
			$mgold$elm_nonempty_list$List$Nonempty$toList(nameParts)));
};
var $author$project$Code$Hash$toString = function (_v0) {
	var raw = _v0.a;
	return raw;
};
var $author$project$Code$HashQualified$toString = function (hq) {
	switch (hq.$) {
		case 'NameOnly':
			var fqn = hq.a;
			return $author$project$Code$FullyQualifiedName$toString(fqn);
		case 'HashOnly':
			var hash_ = hq.a;
			return $author$project$Code$Hash$toString(hash_);
		default:
			var fqn = hq.a;
			var hash_ = hq.b;
			return _Utils_ap(
				$author$project$Code$FullyQualifiedName$toString(fqn),
				$author$project$Code$Hash$toString(hash_));
	}
};
var $author$project$Code$Definition$Reference$toString = function (ref) {
	switch (ref.$) {
		case 'TermReference':
			var hq = ref.a;
			return 'term__' + $author$project$Code$HashQualified$toString(hq);
		case 'TypeReference':
			var hq = ref.a;
			return 'type__' + $author$project$Code$HashQualified$toString(hq);
		case 'AbilityConstructorReference':
			var hq = ref.a;
			return 'ability_constructor__' + $author$project$Code$HashQualified$toString(hq);
		default:
			var hq = ref.a;
			return 'data_constructor__' + $author$project$Code$HashQualified$toString(hq);
	}
};
var $author$project$Code$Workspace$WorkspaceItems$fromItems = F3(
	function (before, focus_, after) {
		return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
			{after: after, before: before, focus: focus_});
	});
var $author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems = A3($author$project$Code$Workspace$WorkspaceItems$fromItems, $author$project$Code$Workspace$WorkspaceItemsTests$before, $author$project$Code$Workspace$WorkspaceItemsTests$focused, $author$project$Code$Workspace$WorkspaceItemsTests$after);
var $author$project$Code$Workspace$WorkspaceItemsTests$focusedReference = A2(
	$elm_explorations$test$Test$describe,
	'WorkspaceItems.focusedReference',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'return the reference of the focused item when one exists',
			function (_v0) {
				var result = A2(
					$elm$core$Maybe$map,
					$author$project$Code$Definition$Reference$toString,
					$author$project$Code$Workspace$WorkspaceItems$focusedReference($author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems));
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('term__#focus'),
					result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'returns Nothing when Empty',
			function (_v1) {
				var result = $author$project$Code$Workspace$WorkspaceItems$focusedReference($author$project$Code$Workspace$WorkspaceItems$empty);
				return A2($elm_explorations$test$Expect$equal, $elm$core$Maybe$Nothing, result);
			})
		]));
var $author$project$Lib$SearchResults$Empty = {$: 'Empty'};
var $author$project$Lib$SearchResults$Matches = function (a) {
	return {$: 'Matches', a: a};
};
var $author$project$Lib$SearchResults$SearchResults = function (a) {
	return {$: 'SearchResults', a: a};
};
var $wernerdegroot$listzipper$List$Zipper$Zipper = F3(
	function (a, b, c) {
		return {$: 'Zipper', a: a, b: b, c: c};
	});
var $wernerdegroot$listzipper$List$Zipper$fromList = function (xs) {
	if (!xs.b) {
		return $elm$core$Maybe$Nothing;
	} else {
		var y = xs.a;
		var ys = xs.b;
		return $elm$core$Maybe$Just(
			A3($wernerdegroot$listzipper$List$Zipper$Zipper, _List_Nil, y, ys));
	}
};
var $elm_community$maybe_extra$Maybe$Extra$unwrap = F3(
	function (_default, f, m) {
		if (m.$ === 'Nothing') {
			return _default;
		} else {
			var a = m.a;
			return f(a);
		}
	});
var $author$project$Lib$SearchResults$fromList = function (data) {
	return A3(
		$elm_community$maybe_extra$Maybe$Extra$unwrap,
		$author$project$Lib$SearchResults$Empty,
		A2($elm$core$Basics$composeR, $author$project$Lib$SearchResults$Matches, $author$project$Lib$SearchResults$SearchResults),
		$wernerdegroot$listzipper$List$Zipper$fromList(data));
};
var $wernerdegroot$listzipper$List$Zipper$after = function (_v0) {
	var rs = _v0.c;
	return rs;
};
var $wernerdegroot$listzipper$List$Zipper$before = function (_v0) {
	var ls = _v0.a;
	return $elm$core$List$reverse(ls);
};
var $wernerdegroot$listzipper$List$Zipper$current = function (_v0) {
	var x = _v0.b;
	return x;
};
var $wernerdegroot$listzipper$List$Zipper$toList = function (z) {
	return _Utils_ap(
		$wernerdegroot$listzipper$List$Zipper$before(z),
		_Utils_ap(
			_List_fromArray(
				[
					$wernerdegroot$listzipper$List$Zipper$current(z)
				]),
			$wernerdegroot$listzipper$List$Zipper$after(z)));
};
var $author$project$Lib$SearchResults$matchesToList = function (_v0) {
	var data = _v0.a;
	return $wernerdegroot$listzipper$List$Zipper$toList(data);
};
var $author$project$Lib$SearchResults$toList = function (results) {
	if (results.$ === 'Empty') {
		return _List_Nil;
	} else {
		var matches = results.a;
		return $author$project$Lib$SearchResults$matchesToList(matches);
	}
};
var $author$project$Lib$SearchResultsTests$fromList = A2(
	$elm_explorations$test$Test$describe,
	'SearchResults.fromList',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Returns Empty for empty list',
			function (_v0) {
				var result = $author$project$Lib$SearchResults$fromList(_List_Nil);
				return A2($elm_explorations$test$Expect$equal, $author$project$Lib$SearchResults$Empty, result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Includes all matches',
			function (_v1) {
				var result = $author$project$Lib$SearchResults$toList(
					$author$project$Lib$SearchResults$fromList(
						_List_fromArray(
							['a', 'b', 'c'])));
				return A2(
					$elm_explorations$test$Expect$equal,
					_List_fromArray(
						['a', 'b', 'c']),
					result);
			})
		]));
var $author$project$Code$FullyQualifiedName$fromParent = F2(
	function (_v0, childName) {
		var parentParts = _v0.a;
		return $author$project$Code$FullyQualifiedName$FQN(
			A2(
				$mgold$elm_nonempty_list$List$Nonempty$append,
				parentParts,
				$mgold$elm_nonempty_list$List$Nonempty$fromElement(childName)));
	});
var $author$project$Code$FullyQualifiedNameTests$fromParent = A2(
	$elm_explorations$test$Test$describe,
	'FullyQualifiedName.fromParent',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Combines a name and parent FQN',
			function (_v0) {
				return A2(
					$elm_explorations$test$Expect$equal,
					'foo.bar.baz',
					$author$project$Code$FullyQualifiedName$toString(
						A2(
							$author$project$Code$FullyQualifiedName$fromParent,
							$author$project$Code$FullyQualifiedName$fromString('foo.bar'),
							'baz')));
			})
		]));
var $author$project$Code$FullyQualifiedNameTests$fromString = A2(
	$elm_explorations$test$Test$describe,
	'FullyQualifiedName.fromString',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Creates an FQN from a string',
			function (_v0) {
				return A2(
					$elm_explorations$test$Expect$equal,
					_List_fromArray(
						['a', 'b', 'c']),
					$author$project$Code$FullyQualifiedNameTests$segments(
						$author$project$Code$FullyQualifiedName$fromString('a.b.c')));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Creates an FQN from a string where a segment includes a dot (like the composition operatory)',
			function (_v1) {
				return A2(
					$elm_explorations$test$Expect$equal,
					_List_fromArray(
						['base', '.']),
					$author$project$Code$FullyQualifiedNameTests$segments(
						$author$project$Code$FullyQualifiedName$fromString('base..')));
			}),
			A2(
			$elm_explorations$test$Test$describe,
			'Root',
			_List_fromArray(
				[
					A2(
					$elm_explorations$test$Test$test,
					'Creates a root FQN from \"\"',
					function (_v2) {
						return A2(
							$elm_explorations$test$Expect$equal,
							_List_fromArray(
								['.']),
							$author$project$Code$FullyQualifiedNameTests$segments(
								$author$project$Code$FullyQualifiedName$fromString('')));
					}),
					A2(
					$elm_explorations$test$Test$test,
					'Creates a root FQN from \" \"',
					function (_v3) {
						return A2(
							$elm_explorations$test$Expect$equal,
							_List_fromArray(
								['.']),
							$author$project$Code$FullyQualifiedNameTests$segments(
								$author$project$Code$FullyQualifiedName$fromString(' ')));
					}),
					A2(
					$elm_explorations$test$Test$test,
					'Creates a root FQN from \".\"',
					function (_v4) {
						return A2(
							$elm_explorations$test$Expect$equal,
							_List_fromArray(
								['.']),
							$author$project$Code$FullyQualifiedNameTests$segments(
								$author$project$Code$FullyQualifiedName$fromString('.')));
					})
				]))
		]));
var $author$project$Code$HashTests$fromString = A2(
	$elm_explorations$test$Test$describe,
	'Hash.fromString',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Creates a Hash with a valid prefixed raw hash',
			function (_v0) {
				var hash = $author$project$Code$Hash$fromString('#foo');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('#foo'),
					A2($elm$core$Maybe$map, $author$project$Code$Hash$toString, hash));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Fails to create a hash with an incorrect prefix',
			function (_v1) {
				var hash = $author$project$Code$Hash$fromString('$foo');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Nothing,
					A2($elm$core$Maybe$map, $author$project$Code$Hash$toString, hash));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Fails to create a hash with an @ symbol prefix',
			function (_v2) {
				var hash = $author$project$Code$Hash$fromString('@foo');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Nothing,
					A2($elm$core$Maybe$map, $author$project$Code$Hash$toString, hash));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Fails to create a hash with no symbol prefix',
			function (_v3) {
				var hash = $author$project$Code$Hash$fromString('foo');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Nothing,
					A2($elm$core$Maybe$map, $author$project$Code$Hash$toString, hash));
			})
		]));
var $elm$url$Url$percentDecode = _Url_percentDecode;
var $author$project$Code$FullyQualifiedName$urlDecodeSegmentDot = function (s) {
	return (s === ';.') ? '.' : s;
};
var $author$project$Code$FullyQualifiedName$fromUrlList = function (segments_) {
	var urlDecode = function (s) {
		return A2(
			$elm$core$Maybe$withDefault,
			s,
			$elm$url$Url$percentDecode(s));
	};
	return $author$project$Code$FullyQualifiedName$fromList(
		A2(
			$elm$core$List$map,
			A2($elm$core$Basics$composeR, urlDecode, $author$project$Code$FullyQualifiedName$urlDecodeSegmentDot),
			segments_));
};
var $author$project$Code$FullyQualifiedName$fromUrlString = function (str) {
	return $author$project$Code$FullyQualifiedName$fromUrlList(
		A2($elm$core$String$split, '/', str));
};
var $author$project$Code$FullyQualifiedNameTests$fromUrlString = A2(
	$elm_explorations$test$Test$describe,
	'FullyQualifiedName.fromUrlString',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Creates an FQN from a URL string (segments separate by /)',
			function (_v0) {
				return A2(
					$elm_explorations$test$Expect$equal,
					_List_fromArray(
						['a', 'b', 'c']),
					$author$project$Code$FullyQualifiedNameTests$segments(
						$author$project$Code$FullyQualifiedName$fromUrlString('a/b/c')));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Supports . in segments (compose)',
			function (_v1) {
				return A2(
					$elm_explorations$test$Expect$equal,
					_List_fromArray(
						['a', 'b', '.']),
					$author$project$Code$FullyQualifiedNameTests$segments(
						$author$project$Code$FullyQualifiedName$fromUrlString('a/b/.')));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Supports special characters n segments',
			function (_v2) {
				var results = _List_fromArray(
					[
						$author$project$Code$FullyQualifiedNameTests$segments(
						$author$project$Code$FullyQualifiedName$fromUrlString('a/b/+')),
						$author$project$Code$FullyQualifiedNameTests$segments(
						$author$project$Code$FullyQualifiedName$fromUrlString('a/b/*')),
						$author$project$Code$FullyQualifiedNameTests$segments(
						$author$project$Code$FullyQualifiedName$fromUrlString('a/b/%2F')),
						$author$project$Code$FullyQualifiedNameTests$segments(
						$author$project$Code$FullyQualifiedName$fromUrlString('a/b/%25')),
						$author$project$Code$FullyQualifiedNameTests$segments(
						$author$project$Code$FullyQualifiedName$fromUrlString('a/b/!')),
						$author$project$Code$FullyQualifiedNameTests$segments(
						$author$project$Code$FullyQualifiedName$fromUrlString('a/b/-')),
						$author$project$Code$FullyQualifiedNameTests$segments(
						$author$project$Code$FullyQualifiedName$fromUrlString('a/b/=='))
					]);
				var expects = _List_fromArray(
					[
						_List_fromArray(
						['a', 'b', '+']),
						_List_fromArray(
						['a', 'b', '*']),
						_List_fromArray(
						['a', 'b', '/']),
						_List_fromArray(
						['a', 'b', '%']),
						_List_fromArray(
						['a', 'b', '!']),
						_List_fromArray(
						['a', 'b', '-']),
						_List_fromArray(
						['a', 'b', '=='])
					]);
				return A2($elm_explorations$test$Expect$equal, expects, results);
			}),
			A2(
			$elm_explorations$test$Test$describe,
			'Root',
			_List_fromArray(
				[
					A2(
					$elm_explorations$test$Test$test,
					'Creates a root FQN from \"\"',
					function (_v3) {
						return A2(
							$elm_explorations$test$Expect$equal,
							_List_fromArray(
								['.']),
							$author$project$Code$FullyQualifiedNameTests$segments(
								$author$project$Code$FullyQualifiedName$fromUrlString('')));
					}),
					A2(
					$elm_explorations$test$Test$test,
					'Creates a root FQN from \" \"',
					function (_v4) {
						return A2(
							$elm_explorations$test$Expect$equal,
							_List_fromArray(
								['.']),
							$author$project$Code$FullyQualifiedNameTests$segments(
								$author$project$Code$FullyQualifiedName$fromUrlString(' ')));
					}),
					A2(
					$elm_explorations$test$Test$test,
					'Creates a root FQN from \"/\"',
					function (_v5) {
						return A2(
							$elm_explorations$test$Expect$equal,
							_List_fromArray(
								['.']),
							$author$project$Code$FullyQualifiedNameTests$segments(
								$author$project$Code$FullyQualifiedName$fromUrlString('/')));
					})
				]))
		]));
var $elm$core$String$replace = F3(
	function (before, after, string) {
		return A2(
			$elm$core$String$join,
			after,
			A2($elm$core$String$split, before, string));
	});
var $author$project$Code$Hash$fromUrlString = function (str) {
	return A2($elm$core$String$startsWith, $author$project$Code$Hash$urlPrefix, str) ? $author$project$Code$Hash$fromString(
		A3($elm$core$String$replace, $author$project$Code$Hash$urlPrefix, $author$project$Code$Hash$prefix, str)) : $elm$core$Maybe$Nothing;
};
var $author$project$Code$HashQualified$fromUrlString = function (str) {
	return A2(
		$elm$core$Maybe$withDefault,
		$author$project$Code$HashQualified$NameOnly(
			$author$project$Code$FullyQualifiedName$fromUrlString(str)),
		A2(
			$elm_community$maybe_extra$Maybe$Extra$orElse,
			A3($author$project$Code$HashQualified$hashQualifiedFromString, $author$project$Code$FullyQualifiedName$fromUrlString, $author$project$Code$Hash$urlPrefix, str),
			A2(
				$elm$core$Maybe$map,
				$author$project$Code$HashQualified$HashOnly,
				$author$project$Code$Hash$fromUrlString(str))));
};
var $author$project$Code$HashQualifiedTests$hash_ = $author$project$Code$Hash$fromString('#testhash');
var $author$project$Code$HashQualifiedTests$urlName_ = $author$project$Code$FullyQualifiedName$fromString('test...name');
var $author$project$Code$HashQualifiedTests$fromUrlString = A2(
	$elm_explorations$test$Test$describe,
	'HashQualified.fromUrlString',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'HashOnly when called with a raw hash',
			function (_v0) {
				var expected = A2($elm$core$Maybe$map, $author$project$Code$HashQualified$HashOnly, $author$project$Code$HashQualifiedTests$hash_);
				return A2(
					$elm_explorations$test$Expect$equal,
					expected,
					$elm$core$Maybe$Just(
						$author$project$Code$HashQualified$fromUrlString('@testhash')));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'HashQualified when called with a name and hash',
			function (_v1) {
				var expected = A2(
					$elm$core$Maybe$map,
					$author$project$Code$HashQualified$HashQualified($author$project$Code$HashQualifiedTests$urlName_),
					$author$project$Code$HashQualifiedTests$hash_);
				return A2(
					$elm_explorations$test$Expect$equal,
					expected,
					$elm$core$Maybe$Just(
						$author$project$Code$HashQualified$fromUrlString('/test/;./name/@testhash')));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'NameOnly when called with a name',
			function (_v2) {
				var expected = $author$project$Code$HashQualified$NameOnly($author$project$Code$HashQualifiedTests$urlName_);
				return A2(
					$elm_explorations$test$Expect$equal,
					expected,
					$author$project$Code$HashQualified$fromUrlString('test/;./name'));
			})
		]));
var $author$project$Code$HashTests$fromUrlString = A2(
	$elm_explorations$test$Test$describe,
	'Hash.fromUrlString',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Creates a Hash with a valid URL prefixed raw hash',
			function (_v0) {
				var hash = $author$project$Code$Hash$fromUrlString('@foo');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('#foo'),
					A2($elm$core$Maybe$map, $author$project$Code$Hash$toString, hash));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Fails to create a hash with an incorrect prefix',
			function (_v1) {
				var hash = $author$project$Code$Hash$fromUrlString('$foo');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Nothing,
					A2($elm$core$Maybe$map, $author$project$Code$Hash$toString, hash));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Fails to create a hash with an # symbol prefix',
			function (_v2) {
				var hash = $author$project$Code$Hash$fromUrlString('#foo');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Nothing,
					A2($elm$core$Maybe$map, $author$project$Code$Hash$toString, hash));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Fails to create a hash with no symbol prefix',
			function (_v3) {
				var hash = $author$project$Code$Hash$fromUrlString('foo');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Nothing,
					A2($elm$core$Maybe$map, $author$project$Code$Hash$toString, hash));
			})
		]));
var $elm$core$Basics$le = _Utils_le;
var $elm$core$Basics$sub = _Basics_sub;
var $elm$core$List$drop = F2(
	function (n, list) {
		drop:
		while (true) {
			if (n <= 0) {
				return list;
			} else {
				if (!list.b) {
					return list;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs;
					n = $temp$n;
					list = $temp$list;
					continue drop;
				}
			}
		}
	});
var $elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(x);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $elm_community$list_extra$List$Extra$getAt = F2(
	function (idx, xs) {
		return (idx < 0) ? $elm$core$Maybe$Nothing : $elm$core$List$head(
			A2($elm$core$List$drop, idx, xs));
	});
var $author$project$Lib$SearchResults$getAt = F2(
	function (index, results) {
		return A2(
			$elm_community$list_extra$List$Extra$getAt,
			index,
			$author$project$Lib$SearchResults$toList(results));
	});
var $author$project$Lib$SearchResultsTests$getAt = A2(
	$elm_explorations$test$Test$describe,
	'SearchResults.getAt',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'When there are no results it returns Nothing',
			function (_v0) {
				var result = A2(
					$author$project$Lib$SearchResults$getAt,
					3,
					$author$project$Lib$SearchResults$fromList(_List_Nil));
				return A2($elm_explorations$test$Expect$equal, $elm$core$Maybe$Nothing, result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'When there the index is out of bounds it returns Nothing',
			function (_v1) {
				var result = A2(
					$author$project$Lib$SearchResults$getAt,
					10,
					$author$project$Lib$SearchResults$fromList(
						_List_fromArray(
							['foo', 'bar', 'baz'])));
				return A2($elm_explorations$test$Expect$equal, $elm$core$Maybe$Nothing, result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'When there is an item at the index it returns Just of that item',
			function (_v2) {
				var result = A2(
					$author$project$Lib$SearchResults$getAt,
					1,
					$author$project$Lib$SearchResults$fromList(
						_List_fromArray(
							['foo', 'bar', 'baz'])));
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('bar'),
					result);
			})
		]));
var $elm$core$Maybe$andThen = F2(
	function (callback, maybeValue) {
		if (maybeValue.$ === 'Just') {
			var value = maybeValue.a;
			return callback(value);
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $author$project$Code$HashQualified$hash = function (hq) {
	switch (hq.$) {
		case 'NameOnly':
			return $elm$core$Maybe$Nothing;
		case 'HashOnly':
			var h = hq.a;
			return $elm$core$Maybe$Just(h);
		default:
			var h = hq.b;
			return $elm$core$Maybe$Just(h);
	}
};
var $author$project$Code$HashQualifiedTests$name_ = $author$project$Code$FullyQualifiedName$fromString('test.name');
var $author$project$Code$HashQualifiedTests$hash = A2(
	$elm_explorations$test$Test$describe,
	'HashQualified.hash',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Returns Nothing when NameOnly',
			function (_v0) {
				var hq = $author$project$Code$HashQualified$NameOnly($author$project$Code$HashQualifiedTests$name_);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Nothing,
					$author$project$Code$HashQualified$hash(hq));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Returns Just hash when HashOnly',
			function (_v1) {
				var hq = A2($elm$core$Maybe$map, $author$project$Code$HashQualified$HashOnly, $author$project$Code$HashQualifiedTests$hash_);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('#testhash'),
					A2(
						$elm$core$Maybe$map,
						$author$project$Code$Hash$toString,
						A2($elm$core$Maybe$andThen, $author$project$Code$HashQualified$hash, hq)));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Returns Just hash when HashQualified',
			function (_v2) {
				var hq = A2(
					$elm$core$Maybe$map,
					$author$project$Code$HashQualified$HashQualified($author$project$Code$HashQualifiedTests$name_),
					$author$project$Code$HashQualifiedTests$hash_);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('#testhash'),
					A2(
						$elm$core$Maybe$map,
						$author$project$Code$Hash$toString,
						A2($elm$core$Maybe$andThen, $author$project$Code$HashQualified$hash, hq)));
			})
		]));
var $author$project$Code$Definition$Doc$FoldId = function (a) {
	return {$: 'FoldId', a: a};
};
var $author$project$Lib$TreePath$ListIndex = function (a) {
	return {$: 'ListIndex', a: a};
};
var $author$project$Lib$TreePath$VariantIndex = function (a) {
	return {$: 'VariantIndex', a: a};
};
var $author$project$Code$Definition$DocTests$id = $author$project$Code$Definition$Doc$FoldId(
	_List_fromArray(
		[
			$author$project$Lib$TreePath$VariantIndex(0),
			$author$project$Lib$TreePath$ListIndex(3)
		]));
var $author$project$Code$Finder$SearchOptions$AllNamespaces = {$: 'AllNamespaces'};
var $author$project$Code$Finder$SearchOptions$SearchOptions = function (a) {
	return {$: 'SearchOptions', a: a};
};
var $author$project$Code$Finder$SearchOptions$WithinNamespace = function (a) {
	return {$: 'WithinNamespace', a: a};
};
var $author$project$Code$Finder$SearchOptions$WithinNamespacePerspective = function (a) {
	return {$: 'WithinNamespacePerspective', a: a};
};
var $author$project$Code$Finder$SearchOptions$init = F2(
	function (perspective, mfqn) {
		var _v0 = _Utils_Tuple2(perspective, mfqn);
		if (_v0.b.$ === 'Nothing') {
			if (_v0.a.$ === 'Namespace') {
				var fqn = _v0.a.a.fqn;
				var _v1 = _v0.b;
				return $author$project$Code$Finder$SearchOptions$SearchOptions(
					$author$project$Code$Finder$SearchOptions$WithinNamespacePerspective(fqn));
			} else {
				return $author$project$Code$Finder$SearchOptions$SearchOptions($author$project$Code$Finder$SearchOptions$AllNamespaces);
			}
		} else {
			var fqn = _v0.b.a;
			return $author$project$Code$Finder$SearchOptions$SearchOptions(
				$author$project$Code$Finder$SearchOptions$WithinNamespace(fqn));
		}
	});
var $author$project$Code$Finder$SearchOptionsTests$namespaceFqn = $author$project$Code$FullyQualifiedName$fromString('namespace.FQN');
var $author$project$Code$Perspective$Namespace = function (a) {
	return {$: 'Namespace', a: a};
};
var $krisajenkins$remotedata$RemoteData$NotAsked = {$: 'NotAsked'};
var $author$project$Code$Finder$SearchOptionsTests$perspectiveFqn = $author$project$Code$FullyQualifiedName$fromString('perspective.FQN');
var $author$project$Code$Finder$SearchOptionsTests$namespacePerspective = A2(
	$elm$core$Maybe$map,
	function (h) {
		return $author$project$Code$Perspective$Namespace(
			{details: $krisajenkins$remotedata$RemoteData$NotAsked, fqn: $author$project$Code$Finder$SearchOptionsTests$perspectiveFqn, rootHash: h});
	},
	$author$project$Code$Hash$fromString('#testhash'));
var $author$project$Code$Finder$SearchOptionsTests$init = A2(
	$elm_explorations$test$Test$describe,
	'Finder.SearchOptions.init',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'with an FQN and the Root Perspective it returns the WithinNamespace WithinOption',
			function (_v0) {
				var result = A2(
					$elm$core$Maybe$map,
					function (p) {
						return A2(
							$author$project$Code$Finder$SearchOptions$init,
							p,
							$elm$core$Maybe$Just($author$project$Code$Finder$SearchOptionsTests$namespaceFqn));
					},
					$author$project$Code$Finder$SearchOptionsTests$codebasePerspective);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just(
						$author$project$Code$Finder$SearchOptions$SearchOptions(
							$author$project$Code$Finder$SearchOptions$WithinNamespace($author$project$Code$Finder$SearchOptionsTests$namespaceFqn))),
					result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'with an FQN and the Namespace Perspective it returns the WithinNamespace WithinOption',
			function (_v1) {
				var result = A2(
					$elm$core$Maybe$map,
					function (p) {
						return A2(
							$author$project$Code$Finder$SearchOptions$init,
							p,
							$elm$core$Maybe$Just($author$project$Code$Finder$SearchOptionsTests$namespaceFqn));
					},
					$author$project$Code$Finder$SearchOptionsTests$namespacePerspective);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just(
						$author$project$Code$Finder$SearchOptions$SearchOptions(
							$author$project$Code$Finder$SearchOptions$WithinNamespace($author$project$Code$Finder$SearchOptionsTests$namespaceFqn))),
					result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'without an FQN and the Root Perspective it returns the AllNamespaces WithinOption',
			function (_v2) {
				var result = A2(
					$elm$core$Maybe$map,
					function (p) {
						return A2($author$project$Code$Finder$SearchOptions$init, p, $elm$core$Maybe$Nothing);
					},
					$author$project$Code$Finder$SearchOptionsTests$codebasePerspective);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just(
						$author$project$Code$Finder$SearchOptions$SearchOptions($author$project$Code$Finder$SearchOptions$AllNamespaces)),
					result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'without an FQN and the Namespace Perspective it returns the WithinNamespacePerspective WithinOption',
			function (_v3) {
				var result = A2(
					$elm$core$Maybe$map,
					function (p) {
						return A2($author$project$Code$Finder$SearchOptions$init, p, $elm$core$Maybe$Nothing);
					},
					$author$project$Code$Finder$SearchOptionsTests$namespacePerspective);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just(
						$author$project$Code$Finder$SearchOptions$SearchOptions(
							$author$project$Code$Finder$SearchOptions$WithinNamespacePerspective($author$project$Code$Finder$SearchOptionsTests$perspectiveFqn))),
					result);
			})
		]));
var $author$project$Code$Workspace$WorkspaceItem$isSameByReference = F2(
	function (a, b) {
		return _Utils_eq(
			$author$project$Code$Workspace$WorkspaceItem$reference(a),
			$author$project$Code$Workspace$WorkspaceItem$reference(b));
	});
var $author$project$Code$Workspace$WorkspaceItem$isSameReference = F2(
	function (item, ref) {
		return _Utils_eq(
			$author$project$Code$Workspace$WorkspaceItem$reference(item),
			ref);
	});
var $elm$core$List$any = F2(
	function (isOkay, list) {
		any:
		while (true) {
			if (!list.b) {
				return false;
			} else {
				var x = list.a;
				var xs = list.b;
				if (isOkay(x)) {
					return true;
				} else {
					var $temp$isOkay = isOkay,
						$temp$list = xs;
					isOkay = $temp$isOkay;
					list = $temp$list;
					continue any;
				}
			}
		}
	});
var $elm$core$List$member = F2(
	function (x, xs) {
		return A2(
			$elm$core$List$any,
			function (a) {
				return _Utils_eq(a, x);
			},
			xs);
	});
var $author$project$Code$Workspace$WorkspaceItems$references = function (items) {
	return A2(
		$elm$core$List$map,
		$author$project$Code$Workspace$WorkspaceItem$reference,
		$author$project$Code$Workspace$WorkspaceItems$toList(items));
};
var $author$project$Code$Workspace$WorkspaceItems$member = F2(
	function (items, ref) {
		return A2(
			$elm$core$List$member,
			ref,
			$author$project$Code$Workspace$WorkspaceItems$references(items));
	});
var $author$project$Code$Workspace$WorkspaceItems$singleton = function (item) {
	return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
		{after: _List_Nil, before: _List_Nil, focus: item});
};
var $elm_community$list_extra$List$Extra$findIndexHelp = F3(
	function (index, predicate, list) {
		findIndexHelp:
		while (true) {
			if (!list.b) {
				return $elm$core$Maybe$Nothing;
			} else {
				var x = list.a;
				var xs = list.b;
				if (predicate(x)) {
					return $elm$core$Maybe$Just(index);
				} else {
					var $temp$index = index + 1,
						$temp$predicate = predicate,
						$temp$list = xs;
					index = $temp$index;
					predicate = $temp$predicate;
					list = $temp$list;
					continue findIndexHelp;
				}
			}
		}
	});
var $elm_community$list_extra$List$Extra$findIndex = $elm_community$list_extra$List$Extra$findIndexHelp(0);
var $elm$core$List$takeReverse = F3(
	function (n, list, kept) {
		takeReverse:
		while (true) {
			if (n <= 0) {
				return kept;
			} else {
				if (!list.b) {
					return kept;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs,
						$temp$kept = A2($elm$core$List$cons, x, kept);
					n = $temp$n;
					list = $temp$list;
					kept = $temp$kept;
					continue takeReverse;
				}
			}
		}
	});
var $elm$core$List$takeTailRec = F2(
	function (n, list) {
		return $elm$core$List$reverse(
			A3($elm$core$List$takeReverse, n, list, _List_Nil));
	});
var $elm$core$List$takeFast = F3(
	function (ctr, n, list) {
		if (n <= 0) {
			return _List_Nil;
		} else {
			var _v0 = _Utils_Tuple2(n, list);
			_v0$1:
			while (true) {
				_v0$5:
				while (true) {
					if (!_v0.b.b) {
						return list;
					} else {
						if (_v0.b.b.b) {
							switch (_v0.a) {
								case 1:
									break _v0$1;
								case 2:
									var _v2 = _v0.b;
									var x = _v2.a;
									var _v3 = _v2.b;
									var y = _v3.a;
									return _List_fromArray(
										[x, y]);
								case 3:
									if (_v0.b.b.b.b) {
										var _v4 = _v0.b;
										var x = _v4.a;
										var _v5 = _v4.b;
										var y = _v5.a;
										var _v6 = _v5.b;
										var z = _v6.a;
										return _List_fromArray(
											[x, y, z]);
									} else {
										break _v0$5;
									}
								default:
									if (_v0.b.b.b.b && _v0.b.b.b.b.b) {
										var _v7 = _v0.b;
										var x = _v7.a;
										var _v8 = _v7.b;
										var y = _v8.a;
										var _v9 = _v8.b;
										var z = _v9.a;
										var _v10 = _v9.b;
										var w = _v10.a;
										var tl = _v10.b;
										return (ctr > 1000) ? A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A2($elm$core$List$takeTailRec, n - 4, tl))))) : A2(
											$elm$core$List$cons,
											x,
											A2(
												$elm$core$List$cons,
												y,
												A2(
													$elm$core$List$cons,
													z,
													A2(
														$elm$core$List$cons,
														w,
														A3($elm$core$List$takeFast, ctr + 1, n - 4, tl)))));
									} else {
										break _v0$5;
									}
							}
						} else {
							if (_v0.a === 1) {
								break _v0$1;
							} else {
								break _v0$5;
							}
						}
					}
				}
				return list;
			}
			var _v1 = _v0.b;
			var x = _v1.a;
			return _List_fromArray(
				[x]);
		}
	});
var $elm$core$List$take = F2(
	function (n, list) {
		return A3($elm$core$List$takeFast, 0, n, list);
	});
var $elm_community$list_extra$List$Extra$splitAt = F2(
	function (n, xs) {
		return _Utils_Tuple2(
			A2($elm$core$List$take, n, xs),
			A2($elm$core$List$drop, n, xs));
	});
var $elm_community$list_extra$List$Extra$splitWhen = F2(
	function (predicate, list) {
		return A2(
			$elm$core$Maybe$map,
			function (i) {
				return A2($elm_community$list_extra$List$Extra$splitAt, i, list);
			},
			A2($elm_community$list_extra$List$Extra$findIndex, predicate, list));
	});
var $author$project$Code$Workspace$WorkspaceItems$insertWithFocusAfter = F3(
	function (items, afterRef, toInsert) {
		if (items.$ === 'Empty') {
			return $author$project$Code$Workspace$WorkspaceItems$singleton(toInsert);
		} else {
			if (A2($author$project$Code$Workspace$WorkspaceItems$member, items, afterRef)) {
				var make = function (_v1) {
					var before = _v1.a;
					var afterInclusive = _v1.b;
					return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
						{
							after: A2($elm$core$List$drop, 1, afterInclusive),
							before: before,
							focus: toInsert
						});
				};
				var insertAfter = function (item) {
					return A2($author$project$Code$Workspace$WorkspaceItem$isSameReference, item, afterRef) ? _List_fromArray(
						[item, toInsert]) : _List_fromArray(
						[item]);
				};
				return A2(
					$elm$core$Maybe$withDefault,
					$author$project$Code$Workspace$WorkspaceItems$singleton(toInsert),
					A2(
						$elm$core$Maybe$map,
						make,
						A2(
							$elm_community$list_extra$List$Extra$splitWhen,
							$author$project$Code$Workspace$WorkspaceItem$isSameByReference(toInsert),
							A2(
								$elm$core$List$concatMap,
								insertAfter,
								$author$project$Code$Workspace$WorkspaceItems$toList(items)))));
			} else {
				return A2($author$project$Code$Workspace$WorkspaceItems$appendWithFocus, items, toInsert);
			}
		}
	});
var $author$project$Code$Workspace$WorkspaceItemsTests$notFoundRef = $author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#notfound');
var $author$project$Code$Workspace$WorkspaceItemsTests$insertWithFocusAfter = function () {
	var toInsert = $author$project$Code$Workspace$WorkspaceItemsTests$term;
	var expected = _List_fromArray(
		[
			$author$project$Code$Workspace$WorkspaceItem$Loading(
			$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a')),
			$author$project$Code$Workspace$WorkspaceItem$Loading($author$project$Code$Workspace$WorkspaceItemsTests$termRef),
			$author$project$Code$Workspace$WorkspaceItem$Loading(
			$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b')),
			$author$project$Code$Workspace$WorkspaceItem$Loading(
			$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus')),
			$author$project$Code$Workspace$WorkspaceItem$Loading(
			$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#c')),
			$author$project$Code$Workspace$WorkspaceItem$Loading(
			$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#d'))
		]);
	var afterRef = $author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a');
	var inserted = A3($author$project$Code$Workspace$WorkspaceItems$insertWithFocusAfter, $author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems, afterRef, toInsert);
	var currentFocusedRef = $author$project$Code$Workspace$WorkspaceItems$focusedReference(inserted);
	return A2(
		$elm_explorations$test$Test$describe,
		'WorkspaceItems.insertWithFocusAfter',
		_List_fromArray(
			[
				A2(
				$elm_explorations$test$Test$test,
				'Inserts after the \'after ref\'',
				function (_v0) {
					return A2(
						$elm_explorations$test$Expect$equal,
						expected,
						$author$project$Code$Workspace$WorkspaceItems$toList(inserted));
				}),
				A2(
				$elm_explorations$test$Test$test,
				'When inserted, the new element has focus',
				function (_v1) {
					return A2(
						$elm_explorations$test$Expect$true,
						'Has focus',
						A2(
							$elm$core$Maybe$withDefault,
							false,
							A2(
								$elm$core$Maybe$map,
								function (r) {
									return _Utils_eq(
										r,
										$author$project$Code$Workspace$WorkspaceItem$reference(toInsert));
								},
								currentFocusedRef)));
				}),
				A2(
				$elm_explorations$test$Test$test,
				'When the \'after ref\' is not present, insert at the end',
				function (_v2) {
					var result = $author$project$Code$Workspace$WorkspaceItems$toList(
						A3($author$project$Code$Workspace$WorkspaceItems$insertWithFocusAfter, $author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems, $author$project$Code$Workspace$WorkspaceItemsTests$notFoundRef, toInsert));
					var atEnd = _List_fromArray(
						[
							$author$project$Code$Workspace$WorkspaceItem$Loading(
							$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a')),
							$author$project$Code$Workspace$WorkspaceItem$Loading(
							$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b')),
							$author$project$Code$Workspace$WorkspaceItem$Loading(
							$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus')),
							$author$project$Code$Workspace$WorkspaceItem$Loading(
							$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#c')),
							$author$project$Code$Workspace$WorkspaceItem$Loading(
							$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#d')),
							$author$project$Code$Workspace$WorkspaceItem$Loading(
							$author$project$Code$Workspace$WorkspaceItem$reference(toInsert))
						]);
					return A2($elm_explorations$test$Expect$equal, atEnd, result);
				})
			]));
}();
var $author$project$Code$Workspace$WorkspaceItems$prependWithFocus = F2(
	function (workspaceItems, item) {
		if (workspaceItems.$ === 'Empty') {
			return $author$project$Code$Workspace$WorkspaceItems$singleton(item);
		} else {
			var items = workspaceItems.a;
			return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
				{
					after: _Utils_ap(
						items.before,
						A2($elm$core$List$cons, items.focus, items.after)),
					before: _List_Nil,
					focus: item
				});
		}
	});
var $author$project$Code$Workspace$WorkspaceItems$insertWithFocusBefore = F3(
	function (items, beforeRef, toInsert) {
		if (items.$ === 'Empty') {
			return $author$project$Code$Workspace$WorkspaceItems$singleton(toInsert);
		} else {
			if (A2($author$project$Code$Workspace$WorkspaceItems$member, items, beforeRef)) {
				var make = function (_v1) {
					var before = _v1.a;
					var afterInclusive = _v1.b;
					return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
						{
							after: A2($elm$core$List$drop, 1, afterInclusive),
							before: before,
							focus: toInsert
						});
				};
				var insertBefore = function (item) {
					return A2($author$project$Code$Workspace$WorkspaceItem$isSameReference, item, beforeRef) ? _List_fromArray(
						[toInsert, item]) : _List_fromArray(
						[item]);
				};
				return A2(
					$elm$core$Maybe$withDefault,
					$author$project$Code$Workspace$WorkspaceItems$singleton(toInsert),
					A2(
						$elm$core$Maybe$map,
						make,
						A2(
							$elm_community$list_extra$List$Extra$splitWhen,
							$author$project$Code$Workspace$WorkspaceItem$isSameByReference(toInsert),
							A2(
								$elm$core$List$concatMap,
								insertBefore,
								$author$project$Code$Workspace$WorkspaceItems$toList(items)))));
			} else {
				return A2($author$project$Code$Workspace$WorkspaceItems$prependWithFocus, items, toInsert);
			}
		}
	});
var $author$project$Code$Workspace$WorkspaceItemsTests$insertWithFocusBefore = function () {
	var toInsert = $author$project$Code$Workspace$WorkspaceItemsTests$term;
	var expected = _List_fromArray(
		[
			$author$project$Code$Workspace$WorkspaceItem$Loading(
			$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a')),
			$author$project$Code$Workspace$WorkspaceItem$Loading($author$project$Code$Workspace$WorkspaceItemsTests$termRef),
			$author$project$Code$Workspace$WorkspaceItem$Loading(
			$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b')),
			$author$project$Code$Workspace$WorkspaceItem$Loading(
			$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus')),
			$author$project$Code$Workspace$WorkspaceItem$Loading(
			$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#c')),
			$author$project$Code$Workspace$WorkspaceItem$Loading(
			$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#d'))
		]);
	var beforeRef = $author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b');
	var inserted = A3($author$project$Code$Workspace$WorkspaceItems$insertWithFocusBefore, $author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems, beforeRef, toInsert);
	var currentFocusedRef = $author$project$Code$Workspace$WorkspaceItems$focusedReference(inserted);
	return A2(
		$elm_explorations$test$Test$describe,
		'WorkspaceItems.insertWithFocusBefore',
		_List_fromArray(
			[
				A2(
				$elm_explorations$test$Test$test,
				'Inserts before the \'before ref\'',
				function (_v0) {
					return A2(
						$elm_explorations$test$Expect$equal,
						expected,
						$author$project$Code$Workspace$WorkspaceItems$toList(inserted));
				}),
				A2(
				$elm_explorations$test$Test$test,
				'When inserted, the new element has focus',
				function (_v1) {
					return A2(
						$elm_explorations$test$Expect$true,
						'Has focus',
						A2(
							$elm$core$Maybe$withDefault,
							false,
							A2(
								$elm$core$Maybe$map,
								function (r) {
									return _Utils_eq(
										r,
										$author$project$Code$Workspace$WorkspaceItem$reference(toInsert));
								},
								currentFocusedRef)));
				}),
				A2(
				$elm_explorations$test$Test$test,
				'When the \'before hash\' is not present, insert at the end',
				function (_v2) {
					var result = $author$project$Code$Workspace$WorkspaceItems$toList(
						A3($author$project$Code$Workspace$WorkspaceItems$insertWithFocusAfter, $author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems, $author$project$Code$Workspace$WorkspaceItemsTests$notFoundRef, toInsert));
					var atEnd = _List_fromArray(
						[
							$author$project$Code$Workspace$WorkspaceItem$Loading(
							$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a')),
							$author$project$Code$Workspace$WorkspaceItem$Loading(
							$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b')),
							$author$project$Code$Workspace$WorkspaceItem$Loading(
							$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus')),
							$author$project$Code$Workspace$WorkspaceItem$Loading(
							$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#c')),
							$author$project$Code$Workspace$WorkspaceItem$Loading(
							$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#d')),
							$author$project$Code$Workspace$WorkspaceItem$Loading(
							$author$project$Code$Workspace$WorkspaceItem$reference(toInsert))
						]);
					return A2($elm_explorations$test$Expect$equal, atEnd, result);
				})
			]));
}();
var $elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 'Failure', a: a, b: b};
	});
var $elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 'Field', a: a, b: b};
	});
var $elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 'Index', a: a, b: b};
	});
var $elm$json$Json$Decode$OneOf = function (a) {
	return {$: 'OneOf', a: a};
};
var $elm$core$String$all = _String_all;
var $elm$json$Json$Encode$encode = _Json_encode;
var $elm$core$String$fromInt = _String_fromNumber;
var $elm$json$Json$Decode$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n    ',
		A2($elm$core$String$split, '\n', str));
};
var $elm$core$List$length = function (xs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var $elm$core$List$map2 = _List_map2;
var $elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2($elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var $elm$core$List$range = F2(
	function (lo, hi) {
		return A3($elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var $elm$core$List$indexedMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$map2,
			f,
			A2(
				$elm$core$List$range,
				0,
				$elm$core$List$length(xs) - 1),
			xs);
	});
var $elm$core$Char$toCode = _Char_toCode;
var $elm$core$Char$isLower = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var $elm$core$Char$isUpper = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var $elm$core$Char$isAlpha = function (_char) {
	return $elm$core$Char$isLower(_char) || $elm$core$Char$isUpper(_char);
};
var $elm$core$Char$isDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var $elm$core$Char$isAlphaNum = function (_char) {
	return $elm$core$Char$isLower(_char) || ($elm$core$Char$isUpper(_char) || $elm$core$Char$isDigit(_char));
};
var $elm$core$String$uncons = _String_uncons;
var $elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + ($elm$core$String$fromInt(i + 1) + (') ' + $elm$json$Json$Decode$indent(
			$elm$json$Json$Decode$errorToString(error))));
	});
var $elm$json$Json$Decode$errorToString = function (error) {
	return A2($elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var $elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 'Field':
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _v1 = $elm$core$String$uncons(f);
						if (_v1.$ === 'Nothing') {
							return false;
						} else {
							var _v2 = _v1.a;
							var _char = _v2.a;
							var rest = _v2.b;
							return $elm$core$Char$isAlpha(_char) && A2($elm$core$String$all, $elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'Index':
					var i = error.a;
					var err = error.b;
					var indexName = '[' + ($elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 'OneOf':
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									$elm$core$String$join,
									'',
									$elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										$elm$core$String$join,
										'',
										$elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + ($elm$core$String$fromInt(
								$elm$core$List$length(errors)) + ' ways:'));
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$cons,
									introduction,
									A2($elm$core$List$indexedMap, $elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								$elm$core$String$join,
								'',
								$elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + ($elm$json$Json$Decode$indent(
						A2($elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var $elm$core$Array$branchFactor = 32;
var $elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 'Array_elm_builtin', a: a, b: b, c: c, d: d};
	});
var $elm$core$Elm$JsArray$empty = _JsArray_empty;
var $elm$core$Basics$ceiling = _Basics_ceiling;
var $elm$core$Basics$fdiv = _Basics_fdiv;
var $elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var $elm$core$Basics$toFloat = _Basics_toFloat;
var $elm$core$Array$shiftStep = $elm$core$Basics$ceiling(
	A2($elm$core$Basics$logBase, 2, $elm$core$Array$branchFactor));
var $elm$core$Array$empty = A4($elm$core$Array$Array_elm_builtin, 0, $elm$core$Array$shiftStep, $elm$core$Elm$JsArray$empty, $elm$core$Elm$JsArray$empty);
var $elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var $elm$core$Array$Leaf = function (a) {
	return {$: 'Leaf', a: a};
};
var $elm$core$Basics$floor = _Basics_floor;
var $elm$core$Elm$JsArray$length = _JsArray_length;
var $elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var $elm$core$Basics$mul = _Basics_mul;
var $elm$core$Array$SubTree = function (a) {
	return {$: 'SubTree', a: a};
};
var $elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var $elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodes);
			var node = _v0.a;
			var remainingNodes = _v0.b;
			var newAcc = A2(
				$elm$core$List$cons,
				$elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return $elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var $elm$core$Tuple$first = function (_v0) {
	var x = _v0.a;
	return x;
};
var $elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = $elm$core$Basics$ceiling(nodeListSize / $elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2($elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var $elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.nodeListSize) {
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail),
				$elm$core$Array$shiftStep,
				$elm$core$Elm$JsArray$empty,
				builder.tail);
		} else {
			var treeLen = builder.nodeListSize * $elm$core$Array$branchFactor;
			var depth = $elm$core$Basics$floor(
				A2($elm$core$Basics$logBase, $elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? $elm$core$List$reverse(builder.nodeList) : builder.nodeList;
			var tree = A2($elm$core$Array$treeFromBuilder, correctNodeList, builder.nodeListSize);
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.tail) + treeLen,
				A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep),
				tree,
				builder.tail);
		}
	});
var $elm$core$Basics$idiv = _Basics_idiv;
var $elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					false,
					{nodeList: nodeList, nodeListSize: (len / $elm$core$Array$branchFactor) | 0, tail: tail});
			} else {
				var leaf = $elm$core$Array$Leaf(
					A3($elm$core$Elm$JsArray$initialize, $elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - $elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2($elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var $elm$core$Basics$remainderBy = _Basics_remainderBy;
var $elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return $elm$core$Array$empty;
		} else {
			var tailLen = len % $elm$core$Array$branchFactor;
			var tail = A3($elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - $elm$core$Array$branchFactor;
			return A5($elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var $elm$core$Result$isOk = function (result) {
	if (result.$ === 'Ok') {
		return true;
	} else {
		return false;
	}
};
var $elm$json$Json$Decode$int = _Json_decodeInt;
var $author$project$Code$Definition$Doc$DocFoldToggles = function (a) {
	return {$: 'DocFoldToggles', a: a};
};
var $author$project$Code$Definition$Doc$emptyDocFoldToggles = $author$project$Code$Definition$Doc$DocFoldToggles($elm$core$Set$empty);
var $author$project$Lib$TreePath$toString = function (path) {
	var pathItemToString = function (item) {
		if (item.$ === 'VariantIndex') {
			var i = item.a;
			return 'VariantIndex#' + $elm$core$String$fromInt(i);
		} else {
			var i = item.a;
			return 'ListIndex#' + $elm$core$String$fromInt(i);
		}
	};
	return A2(
		$elm$core$String$join,
		'.',
		A2($elm$core$List$map, pathItemToString, path));
};
var $author$project$Code$Definition$Doc$isDocFoldToggled = F2(
	function (_v0, _v1) {
		var toggles = _v0.a;
		var path = _v1.a;
		var rawPath = $author$project$Lib$TreePath$toString(path);
		return A2($elm$core$Set$member, rawPath, toggles);
	});
var $elm$core$Dict$getMin = function (dict) {
	getMin:
	while (true) {
		if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
			var left = dict.d;
			var $temp$dict = left;
			dict = $temp$dict;
			continue getMin;
		} else {
			return dict;
		}
	}
};
var $elm$core$Dict$moveRedLeft = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.e.d.$ === 'RBNode_elm_builtin') && (dict.e.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var lLeft = _v1.d;
			var lRight = _v1.e;
			var _v2 = dict.e;
			var rClr = _v2.a;
			var rK = _v2.b;
			var rV = _v2.c;
			var rLeft = _v2.d;
			var _v3 = rLeft.a;
			var rlK = rLeft.b;
			var rlV = rLeft.c;
			var rlL = rLeft.d;
			var rlR = rLeft.e;
			var rRight = _v2.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				rlK,
				rlV,
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					rlL),
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, rK, rV, rlR, rRight));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v4 = dict.d;
			var lClr = _v4.a;
			var lK = _v4.b;
			var lV = _v4.c;
			var lLeft = _v4.d;
			var lRight = _v4.e;
			var _v5 = dict.e;
			var rClr = _v5.a;
			var rK = _v5.b;
			var rV = _v5.c;
			var rLeft = _v5.d;
			var rRight = _v5.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$moveRedRight = function (dict) {
	if (((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) && (dict.e.$ === 'RBNode_elm_builtin')) {
		if ((dict.d.d.$ === 'RBNode_elm_builtin') && (dict.d.d.a.$ === 'Red')) {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v1 = dict.d;
			var lClr = _v1.a;
			var lK = _v1.b;
			var lV = _v1.c;
			var _v2 = _v1.d;
			var _v3 = _v2.a;
			var llK = _v2.b;
			var llV = _v2.c;
			var llLeft = _v2.d;
			var llRight = _v2.e;
			var lRight = _v1.e;
			var _v4 = dict.e;
			var rClr = _v4.a;
			var rK = _v4.b;
			var rV = _v4.c;
			var rLeft = _v4.d;
			var rRight = _v4.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				$elm$core$Dict$Red,
				lK,
				lV,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, llK, llV, llLeft, llRight),
				A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					lRight,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight)));
		} else {
			var clr = dict.a;
			var k = dict.b;
			var v = dict.c;
			var _v5 = dict.d;
			var lClr = _v5.a;
			var lK = _v5.b;
			var lV = _v5.c;
			var lLeft = _v5.d;
			var lRight = _v5.e;
			var _v6 = dict.e;
			var rClr = _v6.a;
			var rK = _v6.b;
			var rV = _v6.c;
			var rLeft = _v6.d;
			var rRight = _v6.e;
			if (clr.$ === 'Black') {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					$elm$core$Dict$Black,
					k,
					v,
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, rK, rV, rLeft, rRight));
			}
		}
	} else {
		return dict;
	}
};
var $elm$core$Dict$removeHelpPrepEQGT = F7(
	function (targetKey, dict, color, key, value, left, right) {
		if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Red')) {
			var _v1 = left.a;
			var lK = left.b;
			var lV = left.c;
			var lLeft = left.d;
			var lRight = left.e;
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				lK,
				lV,
				lLeft,
				A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Red, key, value, lRight, right));
		} else {
			_v2$2:
			while (true) {
				if ((right.$ === 'RBNode_elm_builtin') && (right.a.$ === 'Black')) {
					if (right.d.$ === 'RBNode_elm_builtin') {
						if (right.d.a.$ === 'Black') {
							var _v3 = right.a;
							var _v4 = right.d;
							var _v5 = _v4.a;
							return $elm$core$Dict$moveRedRight(dict);
						} else {
							break _v2$2;
						}
					} else {
						var _v6 = right.a;
						var _v7 = right.d;
						return $elm$core$Dict$moveRedRight(dict);
					}
				} else {
					break _v2$2;
				}
			}
			return dict;
		}
	});
var $elm$core$Dict$removeMin = function (dict) {
	if ((dict.$ === 'RBNode_elm_builtin') && (dict.d.$ === 'RBNode_elm_builtin')) {
		var color = dict.a;
		var key = dict.b;
		var value = dict.c;
		var left = dict.d;
		var lColor = left.a;
		var lLeft = left.d;
		var right = dict.e;
		if (lColor.$ === 'Black') {
			if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
				var _v3 = lLeft.a;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					key,
					value,
					$elm$core$Dict$removeMin(left),
					right);
			} else {
				var _v4 = $elm$core$Dict$moveRedLeft(dict);
				if (_v4.$ === 'RBNode_elm_builtin') {
					var nColor = _v4.a;
					var nKey = _v4.b;
					var nValue = _v4.c;
					var nLeft = _v4.d;
					var nRight = _v4.e;
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						$elm$core$Dict$removeMin(nLeft),
						nRight);
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			}
		} else {
			return A5(
				$elm$core$Dict$RBNode_elm_builtin,
				color,
				key,
				value,
				$elm$core$Dict$removeMin(left),
				right);
		}
	} else {
		return $elm$core$Dict$RBEmpty_elm_builtin;
	}
};
var $elm$core$Dict$removeHelp = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBEmpty_elm_builtin') {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		} else {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_cmp(targetKey, key) < 0) {
				if ((left.$ === 'RBNode_elm_builtin') && (left.a.$ === 'Black')) {
					var _v4 = left.a;
					var lLeft = left.d;
					if ((lLeft.$ === 'RBNode_elm_builtin') && (lLeft.a.$ === 'Red')) {
						var _v6 = lLeft.a;
						return A5(
							$elm$core$Dict$RBNode_elm_builtin,
							color,
							key,
							value,
							A2($elm$core$Dict$removeHelp, targetKey, left),
							right);
					} else {
						var _v7 = $elm$core$Dict$moveRedLeft(dict);
						if (_v7.$ === 'RBNode_elm_builtin') {
							var nColor = _v7.a;
							var nKey = _v7.b;
							var nValue = _v7.c;
							var nLeft = _v7.d;
							var nRight = _v7.e;
							return A5(
								$elm$core$Dict$balance,
								nColor,
								nKey,
								nValue,
								A2($elm$core$Dict$removeHelp, targetKey, nLeft),
								nRight);
						} else {
							return $elm$core$Dict$RBEmpty_elm_builtin;
						}
					}
				} else {
					return A5(
						$elm$core$Dict$RBNode_elm_builtin,
						color,
						key,
						value,
						A2($elm$core$Dict$removeHelp, targetKey, left),
						right);
				}
			} else {
				return A2(
					$elm$core$Dict$removeHelpEQGT,
					targetKey,
					A7($elm$core$Dict$removeHelpPrepEQGT, targetKey, dict, color, key, value, left, right));
			}
		}
	});
var $elm$core$Dict$removeHelpEQGT = F2(
	function (targetKey, dict) {
		if (dict.$ === 'RBNode_elm_builtin') {
			var color = dict.a;
			var key = dict.b;
			var value = dict.c;
			var left = dict.d;
			var right = dict.e;
			if (_Utils_eq(targetKey, key)) {
				var _v1 = $elm$core$Dict$getMin(right);
				if (_v1.$ === 'RBNode_elm_builtin') {
					var minKey = _v1.b;
					var minValue = _v1.c;
					return A5(
						$elm$core$Dict$balance,
						color,
						minKey,
						minValue,
						left,
						$elm$core$Dict$removeMin(right));
				} else {
					return $elm$core$Dict$RBEmpty_elm_builtin;
				}
			} else {
				return A5(
					$elm$core$Dict$balance,
					color,
					key,
					value,
					left,
					A2($elm$core$Dict$removeHelp, targetKey, right));
			}
		} else {
			return $elm$core$Dict$RBEmpty_elm_builtin;
		}
	});
var $elm$core$Dict$remove = F2(
	function (key, dict) {
		var _v0 = A2($elm$core$Dict$removeHelp, key, dict);
		if ((_v0.$ === 'RBNode_elm_builtin') && (_v0.a.$ === 'Red')) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, $elm$core$Dict$Black, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Set$remove = F2(
	function (key, _v0) {
		var dict = _v0.a;
		return $elm$core$Set$Set_elm_builtin(
			A2($elm$core$Dict$remove, key, dict));
	});
var $author$project$Code$Definition$Doc$toggleFold = F2(
	function (_v0, _v1) {
		var toggles = _v0.a;
		var path = _v1.a;
		var rawPath = $author$project$Lib$TreePath$toString(path);
		return A2($elm$core$Set$member, rawPath, toggles) ? $author$project$Code$Definition$Doc$DocFoldToggles(
			A2($elm$core$Set$remove, rawPath, toggles)) : $author$project$Code$Definition$Doc$DocFoldToggles(
			A2($elm$core$Set$insert, rawPath, toggles));
	});
var $author$project$Code$Definition$DocTests$isDocFoldToggled = A2(
	$elm_explorations$test$Test$describe,
	'Doc.isDocFoldToggled',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'returns True if the doc is toggled',
			function (_v0) {
				var toggles = A2($author$project$Code$Definition$Doc$toggleFold, $author$project$Code$Definition$Doc$emptyDocFoldToggles, $author$project$Code$Definition$DocTests$id);
				return A2(
					$elm_explorations$test$Expect$true,
					'doc is toggled',
					A2($author$project$Code$Definition$Doc$isDocFoldToggled, toggles, $author$project$Code$Definition$DocTests$id));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'returns False if the doc is not toggled',
			function (_v1) {
				var toggles = $author$project$Code$Definition$Doc$emptyDocFoldToggles;
				return A2(
					$elm_explorations$test$Expect$false,
					'doc is not toggled',
					A2($author$project$Code$Definition$Doc$isDocFoldToggled, toggles, $author$project$Code$Definition$DocTests$id));
			})
		]));
var $author$project$Code$HashTests$isRawHash = A2(
	$elm_explorations$test$Test$describe,
	'Hash.isRawHash',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'True for strings prefixed with #',
			function (_v0) {
				return A2(
					$elm_explorations$test$Expect$true,
					'# is a raw hash',
					$author$project$Code$Hash$isRawHash('#foo'));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'True for strings prefixed with @',
			function (_v1) {
				return A2(
					$elm_explorations$test$Expect$true,
					'@ is a raw hash',
					$author$project$Code$Hash$isRawHash('@foo'));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'False for non prefixed strings',
			function (_v2) {
				return A2(
					$elm_explorations$test$Expect$false,
					'needs prefix',
					$author$project$Code$Hash$isRawHash('foo'));
			})
		]));
var $elm$core$String$endsWith = _String_endsWith;
var $author$project$Code$FullyQualifiedName$isSuffixOf = F2(
	function (suffixName, fqn) {
		return A2(
			$elm$core$String$endsWith,
			$author$project$Code$FullyQualifiedName$toString(suffixName),
			$author$project$Code$FullyQualifiedName$toString(fqn));
	});
var $author$project$Code$FullyQualifiedNameTests$isSuffixOf = A2(
	$elm_explorations$test$Test$describe,
	'FullyQualifiedName.isSuffixOf',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Returns True when an FQN ends in the provided suffix',
			function (_v0) {
				var suffix = $author$project$Code$FullyQualifiedName$fromString('List.map');
				var fqn = $author$project$Code$FullyQualifiedName$fromString('base.List.map');
				return A2(
					$elm_explorations$test$Expect$true,
					'is correctly a suffix of',
					A2($author$project$Code$FullyQualifiedName$isSuffixOf, suffix, fqn));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Returns False when an FQN does not end in the provided suffix',
			function (_v1) {
				var suffix = $author$project$Code$FullyQualifiedName$fromString('List.foldl');
				var fqn = $author$project$Code$FullyQualifiedName$fromString('base.List.map');
				return A2(
					$elm_explorations$test$Expect$false,
					'is correctly *not* a suffix of',
					A2($author$project$Code$FullyQualifiedName$isSuffixOf, suffix, fqn));
			})
		]));
var $krisajenkins$remotedata$RemoteData$Loading = {$: 'Loading'};
var $author$project$Code$CodebaseTree$NamespaceListing$NamespaceListing = F3(
	function (a, b, c) {
		return {$: 'NamespaceListing', a: a, b: b, c: c};
	});
var $author$project$Code$CodebaseTree$NamespaceListing$SubNamespace = function (a) {
	return {$: 'SubNamespace', a: a};
};
var $krisajenkins$remotedata$RemoteData$Success = function (a) {
	return {$: 'Success', a: a};
};
var $author$project$Code$FullyQualifiedName$equals = F2(
	function (a, b) {
		return _Utils_eq(
			$author$project$Code$FullyQualifiedName$toString(a),
			$author$project$Code$FullyQualifiedName$toString(b));
	});
var $krisajenkins$remotedata$RemoteData$Failure = function (a) {
	return {$: 'Failure', a: a};
};
var $krisajenkins$remotedata$RemoteData$map = F2(
	function (f, data) {
		switch (data.$) {
			case 'Success':
				var value = data.a;
				return $krisajenkins$remotedata$RemoteData$Success(
					f(value));
			case 'Loading':
				return $krisajenkins$remotedata$RemoteData$Loading;
			case 'NotAsked':
				return $krisajenkins$remotedata$RemoteData$NotAsked;
			default:
				var error = data.a;
				return $krisajenkins$remotedata$RemoteData$Failure(error);
		}
	});
var $author$project$Code$CodebaseTree$NamespaceListing$map = F2(
	function (f, _v0) {
		var hash = _v0.a;
		var fqn = _v0.b;
		var content = _v0.c;
		var mapNamespaceListing = function (c) {
			if (c.$ === 'SubNamespace') {
				var nl = c.a;
				return $author$project$Code$CodebaseTree$NamespaceListing$SubNamespace(
					A2($author$project$Code$CodebaseTree$NamespaceListing$map, f, nl));
			} else {
				return c;
			}
		};
		return f(
			A3(
				$author$project$Code$CodebaseTree$NamespaceListing$NamespaceListing,
				hash,
				fqn,
				A2(
					$krisajenkins$remotedata$RemoteData$map,
					$elm$core$List$map(mapNamespaceListing),
					content)));
	});
var $elm$core$Maybe$map3 = F4(
	function (func, ma, mb, mc) {
		if (ma.$ === 'Nothing') {
			return $elm$core$Maybe$Nothing;
		} else {
			var a = ma.a;
			if (mb.$ === 'Nothing') {
				return $elm$core$Maybe$Nothing;
			} else {
				var b = mb.a;
				if (mc.$ === 'Nothing') {
					return $elm$core$Maybe$Nothing;
				} else {
					var c = mc.a;
					return $elm$core$Maybe$Just(
						A3(func, a, b, c));
				}
			}
		}
	});
var $author$project$Code$CodebaseTree$NamespaceListingTests$map = A2(
	$elm_explorations$test$Test$describe,
	'CodebaseTree.NamespaceListing.map',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'runs the function on deeply nestes namespaces',
			function (_v0) {
				var hashC = $author$project$Code$Hash$fromString('#b');
				var hashB = $author$project$Code$Hash$fromString('#c');
				var hashA = $author$project$Code$Hash$fromString('#a');
				var fqnC = $author$project$Code$FullyQualifiedName$fromString('a.b.c');
				var fqnB = $author$project$Code$FullyQualifiedName$fromString('a.b');
				var fqnA = $author$project$Code$FullyQualifiedName$fromString('a');
				var original = A4(
					$elm$core$Maybe$map3,
					F3(
						function (ha, hb, hc) {
							return A3(
								$author$project$Code$CodebaseTree$NamespaceListing$NamespaceListing,
								ha,
								fqnA,
								$krisajenkins$remotedata$RemoteData$Success(
									_List_fromArray(
										[
											$author$project$Code$CodebaseTree$NamespaceListing$SubNamespace(
											A3(
												$author$project$Code$CodebaseTree$NamespaceListing$NamespaceListing,
												hb,
												fqnB,
												$krisajenkins$remotedata$RemoteData$Success(
													_List_fromArray(
														[
															$author$project$Code$CodebaseTree$NamespaceListing$SubNamespace(
															A3($author$project$Code$CodebaseTree$NamespaceListing$NamespaceListing, hc, fqnC, $krisajenkins$remotedata$RemoteData$NotAsked))
														]))))
										])));
						}),
					hashA,
					hashB,
					hashC);
				var f = function (nl) {
					var h = nl.a;
					var fqn = nl.b;
					return A2($author$project$Code$FullyQualifiedName$equals, fqn, fqnC) ? A3($author$project$Code$CodebaseTree$NamespaceListing$NamespaceListing, h, fqn, $krisajenkins$remotedata$RemoteData$Loading) : nl;
				};
				var result = A2(
					$elm$core$Maybe$map,
					$author$project$Code$CodebaseTree$NamespaceListing$map(f),
					original);
				var expected = A4(
					$elm$core$Maybe$map3,
					F3(
						function (ha, hb, hc) {
							return A3(
								$author$project$Code$CodebaseTree$NamespaceListing$NamespaceListing,
								ha,
								fqnA,
								$krisajenkins$remotedata$RemoteData$Success(
									_List_fromArray(
										[
											$author$project$Code$CodebaseTree$NamespaceListing$SubNamespace(
											A3(
												$author$project$Code$CodebaseTree$NamespaceListing$NamespaceListing,
												hb,
												fqnB,
												$krisajenkins$remotedata$RemoteData$Success(
													_List_fromArray(
														[
															$author$project$Code$CodebaseTree$NamespaceListing$SubNamespace(
															A3($author$project$Code$CodebaseTree$NamespaceListing$NamespaceListing, hc, fqnC, $krisajenkins$remotedata$RemoteData$Loading))
														]))))
										])));
						}),
					hashA,
					hashB,
					hashC);
				return A2($elm_explorations$test$Expect$equal, expected, result);
			})
		]));
var $elm$http$Http$BadUrl = function (a) {
	return {$: 'BadUrl', a: a};
};
var $author$project$Code$Workspace$WorkspaceItem$Failure = F2(
	function (a, b) {
		return {$: 'Failure', a: a, b: b};
	});
var $author$project$Code$Workspace$WorkspaceItems$map = F2(
	function (f, wItems) {
		if (wItems.$ === 'Empty') {
			return $author$project$Code$Workspace$WorkspaceItems$Empty;
		} else {
			var data = wItems.a;
			return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
				{
					after: A2($elm$core$List$map, f, data.after),
					before: A2($elm$core$List$map, f, data.before),
					focus: f(data.focus)
				});
		}
	});
var $author$project$Code$Workspace$WorkspaceItemsTests$map = A2(
	$elm_explorations$test$Test$describe,
	'WorkspaceItems.map',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Maps definitions',
			function (_v0) {
				var result = $author$project$Code$Workspace$WorkspaceItems$toList(
					A2(
						$author$project$Code$Workspace$WorkspaceItems$map,
						function (i) {
							return A2(
								$author$project$Code$Workspace$WorkspaceItem$Failure,
								$author$project$Code$Workspace$WorkspaceItem$reference(i),
								$elm$http$Http$BadUrl('err'));
						},
						$author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems));
				var expected = _List_fromArray(
					[
						A2(
						$author$project$Code$Workspace$WorkspaceItem$Failure,
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a'),
						$elm$http$Http$BadUrl('err')),
						A2(
						$author$project$Code$Workspace$WorkspaceItem$Failure,
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b'),
						$elm$http$Http$BadUrl('err')),
						A2(
						$author$project$Code$Workspace$WorkspaceItem$Failure,
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus'),
						$elm$http$Http$BadUrl('err')),
						A2(
						$author$project$Code$Workspace$WorkspaceItem$Failure,
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#c'),
						$elm$http$Http$BadUrl('err')),
						A2(
						$author$project$Code$Workspace$WorkspaceItem$Failure,
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#d'),
						$elm$http$Http$BadUrl('err'))
					]);
				return A2($elm_explorations$test$Expect$equal, expected, result);
			})
		]));
var $author$project$Code$Workspace$WorkspaceItems$mapToList = F2(
	function (f, wItems) {
		if (wItems.$ === 'Empty') {
			return _List_Nil;
		} else {
			var data = wItems.a;
			var before = A2(
				$elm$core$List$map,
				function (i) {
					return A2(f, i, false);
				},
				data.before);
			var after = A2(
				$elm$core$List$map,
				function (i) {
					return A2(f, i, false);
				},
				data.after);
			return _Utils_ap(
				before,
				A2(
					$elm$core$List$cons,
					A2(f, data.focus, true),
					after));
		}
	});
var $author$project$Code$Workspace$WorkspaceItemsTests$mapToList = A2(
	$elm_explorations$test$Test$describe,
	'WorkspaceItems.mapToList',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Maps definitions',
			function (_v0) {
				var result = A2(
					$author$project$Code$Workspace$WorkspaceItems$mapToList,
					F2(
						function (i, _v1) {
							return $author$project$Code$Definition$Reference$toString(
								$author$project$Code$Workspace$WorkspaceItem$reference(i));
						}),
					$author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems);
				var expected = _List_fromArray(
					['term__#a', 'term__#b', 'term__#focus', 'term__#c', 'term__#d']);
				return A2($elm_explorations$test$Expect$equal, expected, result);
			})
		]));
var $wernerdegroot$listzipper$List$Zipper$from = F3(
	function (bef, curr, aft) {
		return A3(
			$wernerdegroot$listzipper$List$Zipper$Zipper,
			$elm$core$List$reverse(bef),
			curr,
			aft);
	});
var $author$project$Lib$SearchResults$from = F3(
	function (before, focus_, after) {
		return $author$project$Lib$SearchResults$SearchResults(
			$author$project$Lib$SearchResults$Matches(
				A3($wernerdegroot$listzipper$List$Zipper$from, before, focus_, after)));
	});
var $author$project$Lib$SearchResults$mapMatchesToList = F2(
	function (f, _v0) {
		var data = _v0.a;
		var focus_ = A2(
			f,
			$wernerdegroot$listzipper$List$Zipper$current(data),
			true);
		var before = A2(
			$elm$core$List$map,
			function (a) {
				return A2(f, a, false);
			},
			$wernerdegroot$listzipper$List$Zipper$before(data));
		var after = A2(
			$elm$core$List$map,
			function (a) {
				return A2(f, a, false);
			},
			$wernerdegroot$listzipper$List$Zipper$after(data));
		return _Utils_ap(
			before,
			A2($elm$core$List$cons, focus_, after));
	});
var $author$project$Lib$SearchResults$mapToList = F2(
	function (f, results) {
		if (results.$ === 'Empty') {
			return _List_Nil;
		} else {
			var matches = results.a;
			return A2($author$project$Lib$SearchResults$mapMatchesToList, f, matches);
		}
	});
var $author$project$Lib$SearchResultsTests$mapToList = A2(
	$elm_explorations$test$Test$describe,
	'SearchResults.mapToList',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Maps definitions',
			function (_v0) {
				var result = A2(
					$author$project$Lib$SearchResults$mapToList,
					F2(
						function (x, isFocused) {
							return _Utils_Tuple2(x + 'mapped', isFocused);
						}),
					A3(
						$author$project$Lib$SearchResults$from,
						_List_fromArray(
							['a']),
						'b',
						_List_fromArray(
							['c'])));
				var expected = _List_fromArray(
					[
						_Utils_Tuple2('amapped', false),
						_Utils_Tuple2('bmapped', true),
						_Utils_Tuple2('cmapped', false)
					]);
				return A2($elm_explorations$test$Expect$equal, expected, result);
			})
		]));
var $author$project$Code$Workspace$WorkspaceItemsTests$member = function () {
	var items = $author$project$Code$Workspace$WorkspaceItems$singleton($author$project$Code$Workspace$WorkspaceItemsTests$term);
	return A2(
		$elm_explorations$test$Test$describe,
		'WorkspaceItems.member',
		_List_fromArray(
			[
				A2(
				$elm_explorations$test$Test$test,
				'Returns true for a ref housed within',
				function (_v0) {
					return A2(
						$elm_explorations$test$Expect$true,
						'item is a member',
						A2($author$project$Code$Workspace$WorkspaceItems$member, items, $author$project$Code$Workspace$WorkspaceItemsTests$termRef));
				}),
				A2(
				$elm_explorations$test$Test$test,
				'Returns false for a ref *not* housed within',
				function (_v1) {
					return A2(
						$elm_explorations$test$Expect$false,
						'item is *not* a member',
						A2($author$project$Code$Workspace$WorkspaceItems$member, items, $author$project$Code$Workspace$WorkspaceItemsTests$notFoundRef));
				})
			]));
}();
var $author$project$Code$Definition$Doc$Blankline = {$: 'Blankline'};
var $author$project$Code$Definition$Doc$Word = function (a) {
	return {$: 'Word', a: a};
};
var $author$project$Code$Definition$Doc$mergeWords = F2(
	function (sep, docs) {
		var merge_ = F2(
			function (d, acc) {
				var _v0 = _Utils_Tuple2(d, acc);
				if (((_v0.a.$ === 'Word') && _v0.b.b) && (_v0.b.a.$ === 'Word')) {
					var w = _v0.a.a;
					var _v1 = _v0.b;
					var w_ = _v1.a.a;
					var rest = _v1.b;
					return A2(
						$elm$core$List$cons,
						$author$project$Code$Definition$Doc$Word(
							_Utils_ap(
								w,
								_Utils_ap(sep, w_))),
						rest);
				} else {
					return A2($elm$core$List$cons, d, acc);
				}
			});
		return A3($elm$core$List$foldr, merge_, _List_Nil, docs);
	});
var $author$project$Code$Definition$DocTests$mergeWords = A2(
	$elm_explorations$test$Test$describe,
	'Doc.mergeWords',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'merges adjacent Word elements with a separator',
			function (_v0) {
				var expected = _List_fromArray(
					[
						$author$project$Code$Definition$Doc$Word('Hello World'),
						$author$project$Code$Definition$Doc$Blankline,
						$author$project$Code$Definition$Doc$Word('After non word')
					]);
				var before = _List_fromArray(
					[
						$author$project$Code$Definition$Doc$Word('Hello'),
						$author$project$Code$Definition$Doc$Word('World'),
						$author$project$Code$Definition$Doc$Blankline,
						$author$project$Code$Definition$Doc$Word('After'),
						$author$project$Code$Definition$Doc$Word('non'),
						$author$project$Code$Definition$Doc$Word('word')
					]);
				return A2(
					$elm_explorations$test$Expect$equal,
					expected,
					A2($author$project$Code$Definition$Doc$mergeWords, ' ', before));
			})
		]));
var $author$project$Code$Workspace$WorkspaceItems$moveDown = function (items) {
	if (items.$ === 'Empty') {
		return $author$project$Code$Workspace$WorkspaceItems$Empty;
	} else {
		var data = items.a;
		var _v1 = data.after;
		if (!_v1.b) {
			return items;
		} else {
			var i = _v1.a;
			var after = _v1.b;
			return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
				{
					after: after,
					before: _Utils_ap(
						data.before,
						_List_fromArray(
							[i])),
					focus: data.focus
				});
		}
	}
};
var $author$project$Code$Workspace$WorkspaceItemsTests$moveDown = A2(
	$elm_explorations$test$Test$describe,
	'WorkspaceItems.moveDown',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'moves the focused item down one position',
			function (_v0) {
				var result = $author$project$Code$Workspace$WorkspaceItems$toList(
					$author$project$Code$Workspace$WorkspaceItems$moveDown($author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems));
				var expected = _List_fromArray(
					[
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#c')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#d'))
					]);
				return A2($elm_explorations$test$Expect$equal, expected, result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'last item is last item',
			function (_v1) {
				var result = $author$project$Code$Workspace$WorkspaceItems$toList(
					$author$project$Code$Workspace$WorkspaceItems$moveDown(
						A3($author$project$Code$Workspace$WorkspaceItems$fromItems, $author$project$Code$Workspace$WorkspaceItemsTests$before, $author$project$Code$Workspace$WorkspaceItemsTests$focused, _List_Nil)));
				var expected = _List_fromArray(
					[
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus'))
					]);
				return A2($elm_explorations$test$Expect$equal, expected, result);
			})
		]));
var $elm_community$list_extra$List$Extra$unconsLast = function (list) {
	var _v0 = $elm$core$List$reverse(list);
	if (!_v0.b) {
		return $elm$core$Maybe$Nothing;
	} else {
		var last_ = _v0.a;
		var rest = _v0.b;
		return $elm$core$Maybe$Just(
			_Utils_Tuple2(
				last_,
				$elm$core$List$reverse(rest)));
	}
};
var $author$project$Code$Workspace$WorkspaceItems$moveUp = function (items) {
	if (items.$ === 'Empty') {
		return $author$project$Code$Workspace$WorkspaceItems$Empty;
	} else {
		var data = items.a;
		var _v1 = $elm_community$list_extra$List$Extra$unconsLast(data.before);
		if (_v1.$ === 'Nothing') {
			return items;
		} else {
			var _v2 = _v1.a;
			var i = _v2.a;
			var before = _v2.b;
			return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
				{
					after: A2($elm$core$List$cons, i, data.after),
					before: before,
					focus: data.focus
				});
		}
	}
};
var $author$project$Code$Workspace$WorkspaceItemsTests$moveUp = A2(
	$elm_explorations$test$Test$describe,
	'WorkspaceItems.moveUp',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'moves the focused item up one position',
			function (_v0) {
				var result = $author$project$Code$Workspace$WorkspaceItems$toList(
					$author$project$Code$Workspace$WorkspaceItems$moveUp($author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems));
				var expected = _List_fromArray(
					[
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#c')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#d'))
					]);
				return A2($elm_explorations$test$Expect$equal, expected, result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'first item is first item',
			function (_v1) {
				var result = $author$project$Code$Workspace$WorkspaceItems$toList(
					$author$project$Code$Workspace$WorkspaceItems$moveUp(
						A3($author$project$Code$Workspace$WorkspaceItems$fromItems, _List_Nil, $author$project$Code$Workspace$WorkspaceItemsTests$focused, $author$project$Code$Workspace$WorkspaceItemsTests$after)));
				var expected = _List_fromArray(
					[
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#c')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#d'))
					]);
				return A2($elm_explorations$test$Expect$equal, expected, result);
			})
		]));
var $author$project$Code$HashQualified$name = function (hq) {
	switch (hq.$) {
		case 'NameOnly':
			var fqn = hq.a;
			return $elm$core$Maybe$Just(fqn);
		case 'HashOnly':
			return $elm$core$Maybe$Nothing;
		default:
			var fqn = hq.a;
			return $elm$core$Maybe$Just(fqn);
	}
};
var $author$project$Code$HashQualifiedTests$name = A2(
	$elm_explorations$test$Test$describe,
	'HashQualified.name',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Returns Just name when NameOnly',
			function (_v0) {
				var hq = $author$project$Code$HashQualified$NameOnly($author$project$Code$HashQualifiedTests$name_);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('test.name'),
					A2(
						$elm$core$Maybe$map,
						$author$project$Code$FullyQualifiedName$toString,
						$author$project$Code$HashQualified$name(hq)));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Returns Nothing when HashOnly',
			function (_v1) {
				var hq = A2($elm$core$Maybe$map, $author$project$Code$HashQualified$HashOnly, $author$project$Code$HashQualifiedTests$hash_);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Nothing,
					A2($elm$core$Maybe$andThen, $author$project$Code$HashQualified$name, hq));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Returns Just name when HashQualified',
			function (_v2) {
				var hq = A2(
					$elm$core$Maybe$map,
					$author$project$Code$HashQualified$HashQualified($author$project$Code$HashQualifiedTests$name_),
					$author$project$Code$HashQualifiedTests$hash_);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('test.name'),
					A2(
						$elm$core$Maybe$map,
						$author$project$Code$FullyQualifiedName$toString,
						A2($elm$core$Maybe$andThen, $author$project$Code$HashQualified$name, hq)));
			})
		]));
var $elm$core$List$tail = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(xs);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $elm_community$list_extra$List$Extra$init = function (items) {
	if (!items.b) {
		return $elm$core$Maybe$Nothing;
	} else {
		var nonEmptyList = items;
		return A2(
			$elm$core$Maybe$map,
			$elm$core$List$reverse,
			$elm$core$List$tail(
				$elm$core$List$reverse(nonEmptyList)));
	}
};
var $author$project$Code$FullyQualifiedName$namespace = function (_v0) {
	var segments_ = _v0.a;
	var _v1 = $elm_community$list_extra$List$Extra$init(
		$mgold$elm_nonempty_list$List$Nonempty$toList(segments_));
	if (_v1.$ === 'Nothing') {
		return $elm$core$Maybe$Nothing;
	} else {
		if (!_v1.a.b) {
			return $elm$core$Maybe$Nothing;
		} else {
			var segments__ = _v1.a;
			return $elm$core$Maybe$Just(
				$author$project$Code$FullyQualifiedName$fromList(segments__));
		}
	}
};
var $author$project$Code$FullyQualifiedNameTests$namespace = A2(
	$elm_explorations$test$Test$describe,
	'FullyQualifiedName.namespace',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'removes qualified name',
			function (_v0) {
				var fqn = $author$project$Code$FullyQualifiedName$fromString('base.List.map');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just(
						$author$project$Code$FullyQualifiedName$fromString('base.List')),
					$author$project$Code$FullyQualifiedName$namespace(fqn));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'with an FQN of only 1 segment, it returns Nothing',
			function (_v1) {
				var fqn = $author$project$Code$FullyQualifiedName$fromString('map');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Nothing,
					$author$project$Code$FullyQualifiedName$namespace(fqn));
			})
		]));
var $elm$core$Basics$negate = function (n) {
	return -n;
};
var $elm$core$String$dropRight = F2(
	function (n, string) {
		return (n < 1) ? string : A3($elm$core$String$slice, 0, -n, string);
	});
var $elm_community$string_extra$String$Extra$nonEmpty = function (string) {
	return $elm$core$String$isEmpty(string) ? $elm$core$Maybe$Nothing : $elm$core$Maybe$Just(string);
};
var $author$project$Code$FullyQualifiedName$namespaceOf = F2(
	function (suffixName, fqn) {
		var dropLastDot = function (s) {
			return A2($elm$core$String$endsWith, '.', s) ? A2($elm$core$String$dropRight, 1, s) : s;
		};
		return A2($author$project$Code$FullyQualifiedName$isSuffixOf, suffixName, fqn) ? A2(
			$elm$core$Maybe$map,
			dropLastDot,
			$elm_community$string_extra$String$Extra$nonEmpty(
				A2(
					$elm$core$String$dropRight,
					$elm$core$String$length(
						$author$project$Code$FullyQualifiedName$toString(suffixName)),
					$author$project$Code$FullyQualifiedName$toString(fqn)))) : $elm$core$Maybe$Nothing;
	});
var $author$project$Code$FullyQualifiedNameTests$namespaceOf = A2(
	$elm_explorations$test$Test$describe,
	'FullyQualifiedName.namespaceOf',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'With an FQN including the suffix, it returns the non suffix part',
			function (_v0) {
				var suffix = $author$project$Code$FullyQualifiedName$fromString('List.map');
				var fqn = $author$project$Code$FullyQualifiedName$fromString('base.List.map');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('base'),
					A2($author$project$Code$FullyQualifiedName$namespaceOf, suffix, fqn));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'When the suffix and FQN are exactly the same, it returns Nothing',
			function (_v1) {
				var suffix = $author$project$Code$FullyQualifiedName$fromString('base.List.map');
				var fqn = $author$project$Code$FullyQualifiedName$fromString('base.List.map');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Nothing,
					A2($author$project$Code$FullyQualifiedName$namespaceOf, suffix, fqn));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'When the suffix is not included at all in the FQN, it returns Nothing',
			function (_v2) {
				var suffix = $author$project$Code$FullyQualifiedName$fromString('List.map.foldl');
				var fqn = $author$project$Code$FullyQualifiedName$fromString('base.List.map');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Nothing,
					A2($author$project$Code$FullyQualifiedName$namespaceOf, suffix, fqn));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'When the suffix is included more than once, only the last match of the FQN is removed',
			function (_v3) {
				var suffix = $author$project$Code$FullyQualifiedName$fromString('Map');
				var fqn = $author$project$Code$FullyQualifiedName$fromString('base.Map.Map');
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('base.Map'),
					A2($author$project$Code$FullyQualifiedName$namespaceOf, suffix, fqn));
			})
		]));
var $author$project$Code$Workspace$WorkspaceItems$next = function (items) {
	if (items.$ === 'Empty') {
		return $author$project$Code$Workspace$WorkspaceItems$Empty;
	} else {
		var data = items.a;
		var _v1 = data.after;
		if (!_v1.b) {
			return items;
		} else {
			var newFocus = _v1.a;
			var rest = _v1.b;
			return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
				{
					after: rest,
					before: _Utils_ap(
						data.before,
						_List_fromArray(
							[data.focus])),
					focus: newFocus
				});
		}
	}
};
var $author$project$Code$Workspace$WorkspaceItemsTests$next = A2(
	$elm_explorations$test$Test$describe,
	'WorkspaceItems.next',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'moves focus to the next element',
			function (_v0) {
				var result = A2(
					$elm$core$Maybe$map,
					$author$project$Code$Definition$Reference$toString,
					$author$project$Code$Workspace$WorkspaceItems$focusedReference(
						$author$project$Code$Workspace$WorkspaceItems$next($author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems)));
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('term__#c'),
					result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'keeps focus if no elements after',
			function (_v1) {
				var result = A2(
					$elm$core$Maybe$map,
					$author$project$Code$Definition$Reference$toString,
					$author$project$Code$Workspace$WorkspaceItems$focusedReference(
						$author$project$Code$Workspace$WorkspaceItems$next(
							A3($author$project$Code$Workspace$WorkspaceItems$fromItems, $author$project$Code$Workspace$WorkspaceItemsTests$before, $author$project$Code$Workspace$WorkspaceItemsTests$focused, _List_Nil))));
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('term__#focus'),
					result);
			})
		]));
var $author$project$Lib$SearchResults$focus = function (_v0) {
	var data = _v0.a;
	return $wernerdegroot$listzipper$List$Zipper$current(data);
};
var $author$project$Lib$SearchResults$map = F2(
	function (f, results) {
		if (results.$ === 'Empty') {
			return $author$project$Lib$SearchResults$Empty;
		} else {
			var matches = results.a;
			return $author$project$Lib$SearchResults$SearchResults(
				f(matches));
		}
	});
var $wernerdegroot$listzipper$List$Zipper$next = function (_v0) {
	var ls = _v0.a;
	var x = _v0.b;
	var rs = _v0.c;
	if (!rs.b) {
		return $elm$core$Maybe$Nothing;
	} else {
		var y = rs.a;
		var ys = rs.b;
		return $elm$core$Maybe$Just(
			A3(
				$wernerdegroot$listzipper$List$Zipper$Zipper,
				A2($elm$core$List$cons, x, ls),
				y,
				ys));
	}
};
var $author$project$Lib$SearchResults$nextMatch = function (matches) {
	var data = matches.a;
	return A3(
		$elm_community$maybe_extra$Maybe$Extra$unwrap,
		matches,
		$author$project$Lib$SearchResults$Matches,
		$wernerdegroot$listzipper$List$Zipper$next(data));
};
var $author$project$Lib$SearchResults$next = $author$project$Lib$SearchResults$map($author$project$Lib$SearchResults$nextMatch);
var $author$project$Lib$SearchResults$toMaybe = function (results) {
	if (results.$ === 'Empty') {
		return $elm$core$Maybe$Nothing;
	} else {
		var matches = results.a;
		return $elm$core$Maybe$Just(matches);
	}
};
var $author$project$Lib$SearchResultsTests$next = A2(
	$elm_explorations$test$Test$describe,
	'SearchResults.next',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'moves focus to the next element',
			function (_v0) {
				var result = A2(
					$elm$core$Maybe$map,
					$author$project$Lib$SearchResults$focus,
					$author$project$Lib$SearchResults$toMaybe(
						$author$project$Lib$SearchResults$next(
							A3(
								$author$project$Lib$SearchResults$from,
								_List_fromArray(
									['a']),
								'b',
								_List_fromArray(
									['c'])))));
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('c'),
					result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'keeps focus if no elements after',
			function (_v1) {
				var result = A2(
					$elm$core$Maybe$map,
					$author$project$Lib$SearchResults$focus,
					$author$project$Lib$SearchResults$toMaybe(
						$author$project$Lib$SearchResults$next(
							A3(
								$author$project$Lib$SearchResults$from,
								_List_fromArray(
									['a', 'b']),
								'c',
								_List_Nil))));
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('c'),
					result);
			})
		]));
var $author$project$Code$Workspace$WorkspaceItems$head = function (items) {
	return $elm$core$List$head(
		$author$project$Code$Workspace$WorkspaceItems$toList(items));
};
var $author$project$Code$Workspace$WorkspaceItemsTests$prependWithFocus = function () {
	var result = A2($author$project$Code$Workspace$WorkspaceItems$prependWithFocus, $author$project$Code$Workspace$WorkspaceItems$empty, $author$project$Code$Workspace$WorkspaceItemsTests$term);
	var currentFocusedRef = $author$project$Code$Workspace$WorkspaceItems$focusedReference(result);
	return A2(
		$elm_explorations$test$Test$describe,
		'WorkspaceItems.prependWithFocus',
		_List_fromArray(
			[
				A2(
				$elm_explorations$test$Test$test,
				'Prepends the term',
				function (_v0) {
					return A2(
						$elm_explorations$test$Expect$equal,
						$elm$core$Maybe$Just($author$project$Code$Workspace$WorkspaceItemsTests$term),
						$author$project$Code$Workspace$WorkspaceItems$head(result));
				}),
				A2(
				$elm_explorations$test$Test$test,
				'Sets focus',
				function (_v1) {
					return A2(
						$elm_explorations$test$Expect$true,
						'Has focus',
						A2(
							$elm$core$Maybe$withDefault,
							false,
							A2(
								$elm$core$Maybe$map,
								function (r) {
									return _Utils_eq(r, $author$project$Code$Workspace$WorkspaceItemsTests$termRef);
								},
								currentFocusedRef)));
				})
			]));
}();
var $author$project$Code$Workspace$WorkspaceItems$prev = function (items) {
	if (items.$ === 'Empty') {
		return $author$project$Code$Workspace$WorkspaceItems$Empty;
	} else {
		var data = items.a;
		var _v1 = $elm_community$list_extra$List$Extra$unconsLast(data.before);
		if (_v1.$ === 'Nothing') {
			return items;
		} else {
			var _v2 = _v1.a;
			var newFocus = _v2.a;
			var newBefore = _v2.b;
			return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
				{
					after: A2($elm$core$List$cons, data.focus, data.after),
					before: newBefore,
					focus: newFocus
				});
		}
	}
};
var $author$project$Code$Workspace$WorkspaceItemsTests$prev = A2(
	$elm_explorations$test$Test$describe,
	'WorkspaceItems.prev',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'moves focus to the prev element',
			function (_v0) {
				var result = A2(
					$elm$core$Maybe$map,
					$author$project$Code$Definition$Reference$toString,
					$author$project$Code$Workspace$WorkspaceItems$focusedReference(
						$author$project$Code$Workspace$WorkspaceItems$prev($author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems)));
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('term__#b'),
					result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'keeps focus if no elements before',
			function (_v1) {
				var result = A2(
					$elm$core$Maybe$map,
					$author$project$Code$Definition$Reference$toString,
					$author$project$Code$Workspace$WorkspaceItems$focusedReference(
						$author$project$Code$Workspace$WorkspaceItems$prev(
							A3($author$project$Code$Workspace$WorkspaceItems$fromItems, _List_Nil, $author$project$Code$Workspace$WorkspaceItemsTests$focused, $author$project$Code$Workspace$WorkspaceItemsTests$after))));
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('term__#focus'),
					result);
			})
		]));
var $wernerdegroot$listzipper$List$Zipper$previous = function (_v0) {
	var ls = _v0.a;
	var x = _v0.b;
	var rs = _v0.c;
	if (!ls.b) {
		return $elm$core$Maybe$Nothing;
	} else {
		var y = ls.a;
		var ys = ls.b;
		return $elm$core$Maybe$Just(
			A3(
				$wernerdegroot$listzipper$List$Zipper$Zipper,
				ys,
				y,
				A2($elm$core$List$cons, x, rs)));
	}
};
var $author$project$Lib$SearchResults$prevMatch = function (matches) {
	var data = matches.a;
	return A3(
		$elm_community$maybe_extra$Maybe$Extra$unwrap,
		matches,
		$author$project$Lib$SearchResults$Matches,
		$wernerdegroot$listzipper$List$Zipper$previous(data));
};
var $author$project$Lib$SearchResults$prev = $author$project$Lib$SearchResults$map($author$project$Lib$SearchResults$prevMatch);
var $author$project$Lib$SearchResultsTests$prev = A2(
	$elm_explorations$test$Test$describe,
	'SearchResults.prev',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'moves focus to the prev element',
			function (_v0) {
				var result = A2(
					$elm$core$Maybe$map,
					$author$project$Lib$SearchResults$focus,
					$author$project$Lib$SearchResults$toMaybe(
						$author$project$Lib$SearchResults$prev(
							A3(
								$author$project$Lib$SearchResults$from,
								_List_fromArray(
									['a']),
								'b',
								_List_fromArray(
									['c'])))));
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('a'),
					result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'keeps focus if no elements before',
			function (_v1) {
				var result = A2(
					$elm$core$Maybe$map,
					$author$project$Lib$SearchResults$focus,
					$author$project$Lib$SearchResults$toMaybe(
						$author$project$Lib$SearchResults$prev(
							A3(
								$author$project$Lib$SearchResults$from,
								_List_Nil,
								'a',
								_List_fromArray(
									['b', 'c'])))));
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just('a'),
					result);
			})
		]));
var $author$project$Code$Project$Owner = function (a) {
	return {$: 'Owner', a: a};
};
var $author$project$Code$Hash$unsafeFromString = function (raw) {
	return $author$project$Code$Hash$Hash(raw);
};
var $author$project$Code$ProjectTests$project = {
	hash: $author$project$Code$Hash$unsafeFromString('##unison.http'),
	name: $author$project$Code$FullyQualifiedName$fromString('http'),
	owner: $author$project$Code$Project$Owner('unison')
};
var $author$project$Code$Workspace$WorkspaceItems$isEmpty = function (workspaceItems) {
	if (workspaceItems.$ === 'Empty') {
		return true;
	} else {
		return false;
	}
};
var $author$project$Code$Workspace$WorkspaceItems$isFocused = F2(
	function (workspaceItems, ref) {
		return A2(
			$elm$core$Maybe$withDefault,
			false,
			A2(
				$elm$core$Maybe$map,
				function (i) {
					return A2($author$project$Code$Workspace$WorkspaceItem$isSameReference, i, ref);
				},
				$author$project$Code$Workspace$WorkspaceItems$focus(workspaceItems)));
	});
var $elm$core$Basics$composeL = F3(
	function (g, f, x) {
		return g(
			f(x));
	});
var $elm_community$list_extra$List$Extra$filterNot = F2(
	function (pred, list) {
		return A2(
			$elm$core$List$filter,
			A2($elm$core$Basics$composeL, $elm$core$Basics$not, pred),
			list);
	});
var $author$project$Code$Workspace$WorkspaceItems$remove = F2(
	function (items, ref) {
		if (items.$ === 'Empty') {
			return $author$project$Code$Workspace$WorkspaceItems$Empty;
		} else {
			var data = items.a;
			var without = function (r) {
				return $elm_community$list_extra$List$Extra$filterNot(
					function (i) {
						return A2($author$project$Code$Workspace$WorkspaceItem$isSameReference, i, r);
					});
			};
			if (A2($author$project$Code$Workspace$WorkspaceItem$isSameReference, data.focus, ref)) {
				var rightBeforeFocus = $elm_community$list_extra$List$Extra$last(data.before);
				var rightAfterFocus = $elm$core$List$head(data.after);
				if (rightAfterFocus.$ === 'Just') {
					var i = rightAfterFocus.a;
					return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
						{
							after: A2(
								without,
								$author$project$Code$Workspace$WorkspaceItem$reference(i),
								data.after),
							before: data.before,
							focus: i
						});
				} else {
					if (rightBeforeFocus.$ === 'Just') {
						var i = rightBeforeFocus.a;
						return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
							{
								after: data.after,
								before: A2(
									without,
									$author$project$Code$Workspace$WorkspaceItem$reference(i),
									data.before),
								focus: i
							});
					} else {
						return $author$project$Code$Workspace$WorkspaceItems$Empty;
					}
				}
			} else {
				return $author$project$Code$Workspace$WorkspaceItems$WorkspaceItems(
					{
						after: A2(without, ref, data.after),
						before: A2(without, ref, data.before),
						focus: data.focus
					});
			}
		}
	});
var $author$project$Code$Workspace$WorkspaceItemsTests$remove = A2(
	$elm_explorations$test$Test$describe,
	'WorkspaceItems.remove',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Returns original when trying to remove a missing Hash',
			function (_v0) {
				var result = $author$project$Code$Workspace$WorkspaceItems$toList(
					A2($author$project$Code$Workspace$WorkspaceItems$remove, $author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems, $author$project$Code$Workspace$WorkspaceItemsTests$notFoundRef));
				var expected = $author$project$Code$Workspace$WorkspaceItems$toList($author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems);
				return A2($elm_explorations$test$Expect$equal, expected, result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Removes the element',
			function (_v1) {
				var toRemove = $author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a');
				var result = A2($author$project$Code$Workspace$WorkspaceItems$remove, $author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems, toRemove);
				return A2(
					$elm_explorations$test$Expect$false,
					'#a is removed',
					A2($author$project$Code$Workspace$WorkspaceItems$member, result, toRemove));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'When the element to remove is focused, remove the element and change focus to right after it',
			function (_v2) {
				var toRemove = $author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus');
				var result = A2($author$project$Code$Workspace$WorkspaceItems$remove, $author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems, toRemove);
				var expectedNewFocus = $author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#c');
				return A2(
					$elm_explorations$test$Expect$true,
					'#focus is removed and #c has focus',
					(!A2($author$project$Code$Workspace$WorkspaceItems$member, result, toRemove)) && A2($author$project$Code$Workspace$WorkspaceItems$isFocused, result, expectedNewFocus));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'When the element to remove is focused and there are no elements after, remove the element and change focus to right before it',
			function (_v3) {
				var toRemove = $author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus');
				var result = A2(
					$author$project$Code$Workspace$WorkspaceItems$remove,
					A3($author$project$Code$Workspace$WorkspaceItems$fromItems, $author$project$Code$Workspace$WorkspaceItemsTests$before, $author$project$Code$Workspace$WorkspaceItemsTests$focused, _List_Nil),
					toRemove);
				var expectedNewFocus = $author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b');
				return A2(
					$elm_explorations$test$Expect$true,
					'#focus is removed and #b has focus',
					(!A2($author$project$Code$Workspace$WorkspaceItems$member, result, toRemove)) && A2($author$project$Code$Workspace$WorkspaceItems$isFocused, result, expectedNewFocus));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'When the element to remove is focused there are no other elements, it returns Empty',
			function (_v4) {
				var result = A2(
					$author$project$Code$Workspace$WorkspaceItems$remove,
					$author$project$Code$Workspace$WorkspaceItems$singleton($author$project$Code$Workspace$WorkspaceItemsTests$term),
					$author$project$Code$Workspace$WorkspaceItem$reference($author$project$Code$Workspace$WorkspaceItemsTests$term));
				return A2(
					$elm_explorations$test$Expect$true,
					'Definition is empty',
					$author$project$Code$Workspace$WorkspaceItems$isEmpty(result));
			})
		]));
var $author$project$Code$Finder$SearchOptions$removeWithin = F2(
	function (perspective, _v0) {
		var within = _v0.a;
		var nextWithin = function () {
			var _v1 = _Utils_Tuple2(within, perspective);
			if ((_v1.a.$ === 'WithinNamespace') && (_v1.b.$ === 'Namespace')) {
				var fqn = _v1.b.a.fqn;
				return $author$project$Code$Finder$SearchOptions$WithinNamespacePerspective(fqn);
			} else {
				return $author$project$Code$Finder$SearchOptions$AllNamespaces;
			}
		}();
		return $author$project$Code$Finder$SearchOptions$SearchOptions(nextWithin);
	});
var $author$project$Code$Finder$SearchOptionsTests$removeWithin = A2(
	$elm_explorations$test$Test$describe,
	'Finder.SearchOptions.removeWithin',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'when removing AllNamespaces it returns the AllNamespaces WithinOption',
			function (_v0) {
				var initial = $author$project$Code$Finder$SearchOptions$SearchOptions($author$project$Code$Finder$SearchOptions$AllNamespaces);
				var result = A2(
					$elm$core$Maybe$map,
					function (p) {
						return A2($author$project$Code$Finder$SearchOptions$removeWithin, p, initial);
					},
					$author$project$Code$Finder$SearchOptionsTests$codebasePerspective);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just(
						$author$project$Code$Finder$SearchOptions$SearchOptions($author$project$Code$Finder$SearchOptions$AllNamespaces)),
					result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'when removing WithinNamespacePerspective it returns the AllNamespaces WithinOption',
			function (_v1) {
				var initial = $author$project$Code$Finder$SearchOptions$SearchOptions(
					$author$project$Code$Finder$SearchOptions$WithinNamespacePerspective($author$project$Code$Finder$SearchOptionsTests$perspectiveFqn));
				var result = A2(
					$elm$core$Maybe$map,
					function (p) {
						return A2($author$project$Code$Finder$SearchOptions$removeWithin, p, initial);
					},
					$author$project$Code$Finder$SearchOptionsTests$namespacePerspective);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just(
						$author$project$Code$Finder$SearchOptions$SearchOptions($author$project$Code$Finder$SearchOptions$AllNamespaces)),
					result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'when removing WithinNamespace and Perspective is Root, it returns the AllNamespaces WithinOption',
			function (_v2) {
				var initial = $author$project$Code$Finder$SearchOptions$SearchOptions(
					$author$project$Code$Finder$SearchOptions$WithinNamespace($author$project$Code$Finder$SearchOptionsTests$namespaceFqn));
				var result = A2(
					$elm$core$Maybe$map,
					function (p) {
						return A2($author$project$Code$Finder$SearchOptions$removeWithin, p, initial);
					},
					$author$project$Code$Finder$SearchOptionsTests$codebasePerspective);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just(
						$author$project$Code$Finder$SearchOptions$SearchOptions($author$project$Code$Finder$SearchOptions$AllNamespaces)),
					result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'when removing WithinNamespace and Perspective is Namespace, it returns the WithinNamespacePerspective WithinOption',
			function (_v3) {
				var initial = $author$project$Code$Finder$SearchOptions$SearchOptions(
					$author$project$Code$Finder$SearchOptions$WithinNamespace($author$project$Code$Finder$SearchOptionsTests$namespaceFqn));
				var result = A2(
					$elm$core$Maybe$map,
					function (p) {
						return A2($author$project$Code$Finder$SearchOptions$removeWithin, p, initial);
					},
					$author$project$Code$Finder$SearchOptionsTests$namespacePerspective);
				return A2(
					$elm_explorations$test$Expect$equal,
					$elm$core$Maybe$Just(
						$author$project$Code$Finder$SearchOptions$SearchOptions(
							$author$project$Code$Finder$SearchOptions$WithinNamespacePerspective($author$project$Code$Finder$SearchOptionsTests$perspectiveFqn))),
					result);
			})
		]));
var $author$project$Code$Workspace$WorkspaceItems$replace = F3(
	function (items, ref, newItem) {
		var replaceMatching = function (i) {
			return A2($author$project$Code$Workspace$WorkspaceItem$isSameReference, i, ref) ? newItem : i;
		};
		return A2($author$project$Code$Workspace$WorkspaceItems$map, replaceMatching, items);
	});
var $author$project$Code$Workspace$WorkspaceItemsTests$replace = A2(
	$elm_explorations$test$Test$describe,
	'WorkspaceItems.replace',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Can replace element in \'before\' focus',
			function (_v0) {
				var newItem = A2(
					$author$project$Code$Workspace$WorkspaceItem$Failure,
					$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b'),
					$elm$http$Http$BadUrl('err'));
				var result = $author$project$Code$Workspace$WorkspaceItems$toList(
					A3(
						$author$project$Code$Workspace$WorkspaceItems$replace,
						$author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems,
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b'),
						newItem));
				var expected = _List_fromArray(
					[
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a')),
						newItem,
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#c')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#d'))
					]);
				return A2($elm_explorations$test$Expect$equal, expected, result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Can replace element in focus',
			function (_v1) {
				var newItem = A2(
					$author$project$Code$Workspace$WorkspaceItem$Failure,
					$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus'),
					$elm$http$Http$BadUrl('err'));
				var result = $author$project$Code$Workspace$WorkspaceItems$toList(
					A3(
						$author$project$Code$Workspace$WorkspaceItems$replace,
						$author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems,
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus'),
						newItem));
				var expected = _List_fromArray(
					[
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b')),
						newItem,
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#c')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#d'))
					]);
				return A2($elm_explorations$test$Expect$equal, expected, result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Can replace element in \'after\' focus',
			function (_v2) {
				var newItem = A2(
					$author$project$Code$Workspace$WorkspaceItem$Failure,
					$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#d'),
					$elm$http$Http$BadUrl('err'));
				var result = $author$project$Code$Workspace$WorkspaceItems$toList(
					A3(
						$author$project$Code$Workspace$WorkspaceItems$replace,
						$author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems,
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#d'),
						newItem));
				var expected = _List_fromArray(
					[
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#a')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#b')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#focus')),
						$author$project$Code$Workspace$WorkspaceItem$Loading(
						$author$project$Code$Workspace$WorkspaceItemsTests$termRefFromStr('#c')),
						newItem
					]);
				return A2($elm_explorations$test$Expect$equal, expected, result);
			})
		]));
var $author$project$Test$Runner$Node$Receive = function (a) {
	return {$: 'Receive', a: a};
};
var $elm_explorations$test$Test$concat = function (tests) {
	if ($elm$core$List$isEmpty(tests)) {
		return $elm_explorations$test$Test$Internal$failNow(
			{
				description: 'This `concat` has no tests in it. Let\'s give it some!',
				reason: $elm_explorations$test$Test$Runner$Failure$Invalid($elm_explorations$test$Test$Runner$Failure$EmptyList)
			});
	} else {
		var _v0 = $elm_explorations$test$Test$Internal$duplicatedName(tests);
		if (_v0.$ === 'Err') {
			var duped = _v0.a;
			return $elm_explorations$test$Test$Internal$failNow(
				{
					description: 'A test group contains multiple tests named \'' + (duped + '\'. Do some renaming so that tests have unique names.'),
					reason: $elm_explorations$test$Test$Runner$Failure$Invalid($elm_explorations$test$Test$Runner$Failure$DuplicatedName)
				});
		} else {
			return $elm_explorations$test$Test$Internal$Batch(tests);
		}
	}
};
var $elm$json$Json$Decode$value = _Json_decodeValue;
var $author$project$Test$Runner$Node$elmTestPort__receive = _Platform_incomingPort('elmTestPort__receive', $elm$json$Json$Decode$value);
var $author$project$Test$Reporter$Reporter$TestReporter = F4(
	function (format, reportBegin, reportComplete, reportSummary) {
		return {format: format, reportBegin: reportBegin, reportComplete: reportComplete, reportSummary: reportSummary};
	});
var $author$project$Console$Text$Default = {$: 'Default'};
var $author$project$Console$Text$Normal = {$: 'Normal'};
var $author$project$Console$Text$Text = F2(
	function (a, b) {
		return {$: 'Text', a: a, b: b};
	});
var $author$project$Console$Text$plain = $author$project$Console$Text$Text(
	{background: $author$project$Console$Text$Default, foreground: $author$project$Console$Text$Default, modifiers: _List_Nil, style: $author$project$Console$Text$Normal});
var $author$project$Test$Reporter$Console$pluralize = F3(
	function (singular, plural, count) {
		var suffix = (count === 1) ? singular : plural;
		return A2(
			$elm$core$String$join,
			' ',
			_List_fromArray(
				[
					$elm$core$String$fromInt(count),
					suffix
				]));
	});
var $author$project$Test$Runner$Node$Vendor$Console$colorsInverted = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[7m', str, '\u001B[27m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$dark = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[2m', str, '\u001B[22m']));
};
var $author$project$Console$Text$applyModifiersHelp = F2(
	function (modifier, str) {
		if (modifier.$ === 'Inverted') {
			return $author$project$Test$Runner$Node$Vendor$Console$colorsInverted(str);
		} else {
			return $author$project$Test$Runner$Node$Vendor$Console$dark(str);
		}
	});
var $author$project$Console$Text$applyModifiers = F2(
	function (modifiers, str) {
		return A3($elm$core$List$foldl, $author$project$Console$Text$applyModifiersHelp, str, modifiers);
	});
var $author$project$Test$Runner$Node$Vendor$Console$bold = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[1m', str, '\u001B[22m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$underline = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[4m', str, '\u001B[24m']));
};
var $author$project$Console$Text$applyStyle = F2(
	function (style, str) {
		switch (style.$) {
			case 'Normal':
				return str;
			case 'Bold':
				return $author$project$Test$Runner$Node$Vendor$Console$bold(str);
			default:
				return $author$project$Test$Runner$Node$Vendor$Console$underline(str);
		}
	});
var $author$project$Test$Runner$Node$Vendor$Console$bgBlack = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[40m', str, '\u001B[49m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$bgBlue = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[44m', str, '\u001B[49m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$bgCyan = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[46m', str, '\u001B[49m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$bgGreen = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[42m', str, '\u001B[49m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$bgMagenta = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[45m', str, '\u001B[49m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$bgRed = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[41m', str, '\u001B[49m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$bgWhite = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[47m', str, '\u001B[49m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$bgYellow = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[43m', str, '\u001B[49m']));
};
var $author$project$Console$Text$colorizeBackground = F2(
	function (color, str) {
		switch (color.$) {
			case 'Default':
				return str;
			case 'Red':
				return $author$project$Test$Runner$Node$Vendor$Console$bgRed(str);
			case 'Green':
				return $author$project$Test$Runner$Node$Vendor$Console$bgGreen(str);
			case 'Yellow':
				return $author$project$Test$Runner$Node$Vendor$Console$bgYellow(str);
			case 'Black':
				return $author$project$Test$Runner$Node$Vendor$Console$bgBlack(str);
			case 'Blue':
				return $author$project$Test$Runner$Node$Vendor$Console$bgBlue(str);
			case 'Magenta':
				return $author$project$Test$Runner$Node$Vendor$Console$bgMagenta(str);
			case 'Cyan':
				return $author$project$Test$Runner$Node$Vendor$Console$bgCyan(str);
			default:
				return $author$project$Test$Runner$Node$Vendor$Console$bgWhite(str);
		}
	});
var $author$project$Test$Runner$Node$Vendor$Console$black = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[30m', str, '\u001B[39m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$blue = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[34m', str, '\u001B[39m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$cyan = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[36m', str, '\u001B[39m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$green = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[32m', str, '\u001B[39m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$magenta = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[35m', str, '\u001B[39m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$red = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[31m', str, '\u001B[39m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$white = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[37m', str, '\u001B[39m']));
};
var $author$project$Test$Runner$Node$Vendor$Console$yellow = function (str) {
	return A2(
		$elm$core$String$join,
		'',
		_List_fromArray(
			['\u001B[33m', str, '\u001B[39m']));
};
var $author$project$Console$Text$colorizeForeground = F2(
	function (color, str) {
		switch (color.$) {
			case 'Default':
				return str;
			case 'Red':
				return $author$project$Test$Runner$Node$Vendor$Console$red(str);
			case 'Green':
				return $author$project$Test$Runner$Node$Vendor$Console$green(str);
			case 'Yellow':
				return $author$project$Test$Runner$Node$Vendor$Console$yellow(str);
			case 'Black':
				return $author$project$Test$Runner$Node$Vendor$Console$black(str);
			case 'Blue':
				return $author$project$Test$Runner$Node$Vendor$Console$blue(str);
			case 'Magenta':
				return $author$project$Test$Runner$Node$Vendor$Console$magenta(str);
			case 'Cyan':
				return $author$project$Test$Runner$Node$Vendor$Console$cyan(str);
			default:
				return $author$project$Test$Runner$Node$Vendor$Console$white(str);
		}
	});
var $author$project$Console$Text$render = F2(
	function (useColor, txt) {
		if (txt.$ === 'Text') {
			var attrs = txt.a;
			var str = txt.b;
			if (useColor.$ === 'UseColor') {
				return A2(
					$author$project$Console$Text$applyStyle,
					attrs.style,
					A2(
						$author$project$Console$Text$applyModifiers,
						attrs.modifiers,
						A2(
							$author$project$Console$Text$colorizeForeground,
							attrs.foreground,
							A2($author$project$Console$Text$colorizeBackground, attrs.background, str))));
			} else {
				return str;
			}
		} else {
			var texts = txt.a;
			return A2(
				$elm$core$String$join,
				'',
				A2(
					$elm$core$List$map,
					$author$project$Console$Text$render(useColor),
					texts));
		}
	});
var $elm$json$Json$Encode$string = _Json_wrap;
var $author$project$Test$Reporter$Console$textToValue = F2(
	function (useColor, txt) {
		return $elm$json$Json$Encode$string(
			A2($author$project$Console$Text$render, useColor, txt));
	});
var $author$project$Test$Reporter$Console$reportBegin = F2(
	function (useColor, _v0) {
		var globs = _v0.globs;
		var fuzzRuns = _v0.fuzzRuns;
		var testCount = _v0.testCount;
		var initialSeed = _v0.initialSeed;
		var prefix = 'Running ' + (A3($author$project$Test$Reporter$Console$pluralize, 'test', 'tests', testCount) + ('. To reproduce these results, run: elm-test --fuzz ' + ($elm$core$String$fromInt(fuzzRuns) + (' --seed ' + $elm$core$String$fromInt(initialSeed)))));
		return $elm$core$Maybe$Just(
			A2(
				$author$project$Test$Reporter$Console$textToValue,
				useColor,
				$author$project$Console$Text$plain(
					A2(
						$elm$core$String$join,
						' ',
						A2($elm$core$List$cons, prefix, globs)) + '\n')));
	});
var $author$project$Test$Reporter$JUnit$reportBegin = function (_v0) {
	return $elm$core$Maybe$Nothing;
};
var $elm$json$Json$Encode$list = F2(
	function (func, entries) {
		return _Json_wrap(
			A3(
				$elm$core$List$foldl,
				_Json_addEntry(func),
				_Json_emptyArray(_Utils_Tuple0),
				entries));
	});
var $elm$json$Json$Encode$object = function (pairs) {
	return _Json_wrap(
		A3(
			$elm$core$List$foldl,
			F2(
				function (_v0, obj) {
					var k = _v0.a;
					var v = _v0.b;
					return A3(_Json_addField, k, v, obj);
				}),
			_Json_emptyObject(_Utils_Tuple0),
			pairs));
};
var $author$project$Test$Reporter$Json$reportBegin = function (_v0) {
	var globs = _v0.globs;
	var paths = _v0.paths;
	var fuzzRuns = _v0.fuzzRuns;
	var testCount = _v0.testCount;
	var initialSeed = _v0.initialSeed;
	return $elm$core$Maybe$Just(
		$elm$json$Json$Encode$object(
			_List_fromArray(
				[
					_Utils_Tuple2(
					'event',
					$elm$json$Json$Encode$string('runStart')),
					_Utils_Tuple2(
					'testCount',
					$elm$json$Json$Encode$string(
						$elm$core$String$fromInt(testCount))),
					_Utils_Tuple2(
					'fuzzRuns',
					$elm$json$Json$Encode$string(
						$elm$core$String$fromInt(fuzzRuns))),
					_Utils_Tuple2(
					'globs',
					A2($elm$json$Json$Encode$list, $elm$json$Json$Encode$string, globs)),
					_Utils_Tuple2(
					'paths',
					A2($elm$json$Json$Encode$list, $elm$json$Json$Encode$string, paths)),
					_Utils_Tuple2(
					'initialSeed',
					$elm$json$Json$Encode$string(
						$elm$core$String$fromInt(initialSeed)))
				])));
};
var $author$project$Console$Text$Texts = function (a) {
	return {$: 'Texts', a: a};
};
var $author$project$Console$Text$concat = $author$project$Console$Text$Texts;
var $author$project$Console$Text$Dark = {$: 'Dark'};
var $author$project$Console$Text$dark = function (txt) {
	if (txt.$ === 'Text') {
		var styles = txt.a;
		var str = txt.b;
		return A2(
			$author$project$Console$Text$Text,
			_Utils_update(
				styles,
				{
					modifiers: A2($elm$core$List$cons, $author$project$Console$Text$Dark, styles.modifiers)
				}),
			str);
	} else {
		var texts = txt.a;
		return $author$project$Console$Text$Texts(
			A2($elm$core$List$map, $author$project$Console$Text$dark, texts));
	}
};
var $elm_explorations$test$Test$Runner$formatLabels = F3(
	function (formatDescription, formatTest, labels) {
		var _v0 = A2(
			$elm$core$List$filter,
			A2($elm$core$Basics$composeL, $elm$core$Basics$not, $elm$core$String$isEmpty),
			labels);
		if (!_v0.b) {
			return _List_Nil;
		} else {
			var test = _v0.a;
			var descriptions = _v0.b;
			return $elm$core$List$reverse(
				A2(
					$elm$core$List$cons,
					formatTest(test),
					A2($elm$core$List$map, formatDescription, descriptions)));
		}
	});
var $author$project$Console$Text$Red = {$: 'Red'};
var $author$project$Console$Text$red = $author$project$Console$Text$Text(
	{background: $author$project$Console$Text$Default, foreground: $author$project$Console$Text$Red, modifiers: _List_Nil, style: $author$project$Console$Text$Normal});
var $elm$core$String$cons = _String_cons;
var $elm$core$String$fromChar = function (_char) {
	return A2($elm$core$String$cons, _char, '');
};
var $author$project$Test$Reporter$Console$withChar = F2(
	function (icon, str) {
		return $elm$core$String$fromChar(icon) + (' ' + (str + '\n'));
	});
var $author$project$Test$Reporter$Console$failureLabelsToText = A2(
	$elm$core$Basics$composeR,
	A2(
		$elm_explorations$test$Test$Runner$formatLabels,
		A2(
			$elm$core$Basics$composeL,
			A2($elm$core$Basics$composeL, $author$project$Console$Text$dark, $author$project$Console$Text$plain),
			$author$project$Test$Reporter$Console$withChar(
				_Utils_chr('↓'))),
		A2(
			$elm$core$Basics$composeL,
			$author$project$Console$Text$red,
			$author$project$Test$Reporter$Console$withChar(
				_Utils_chr('✗')))),
	$author$project$Console$Text$concat);
var $elm$core$Basics$always = F2(
	function (a, _v0) {
		return a;
	});
var $elm$core$Array$fromListHelp = F3(
	function (list, nodeList, nodeListSize) {
		fromListHelp:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, list);
			var jsArray = _v0.a;
			var remainingItems = _v0.b;
			if (_Utils_cmp(
				$elm$core$Elm$JsArray$length(jsArray),
				$elm$core$Array$branchFactor) < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					true,
					{nodeList: nodeList, nodeListSize: nodeListSize, tail: jsArray});
			} else {
				var $temp$list = remainingItems,
					$temp$nodeList = A2(
					$elm$core$List$cons,
					$elm$core$Array$Leaf(jsArray),
					nodeList),
					$temp$nodeListSize = nodeListSize + 1;
				list = $temp$list;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue fromListHelp;
			}
		}
	});
var $elm$core$Array$fromList = function (list) {
	if (!list.b) {
		return $elm$core$Array$empty;
	} else {
		return A3($elm$core$Array$fromListHelp, list, _List_Nil, 0);
	}
};
var $elm$core$Bitwise$and = _Bitwise_and;
var $elm$core$Bitwise$shiftRightZfBy = _Bitwise_shiftRightZfBy;
var $elm$core$Array$bitMask = 4294967295 >>> (32 - $elm$core$Array$shiftStep);
var $elm$core$Basics$ge = _Utils_ge;
var $elm$core$Elm$JsArray$unsafeGet = _JsArray_unsafeGet;
var $elm$core$Array$getHelp = F3(
	function (shift, index, tree) {
		getHelp:
		while (true) {
			var pos = $elm$core$Array$bitMask & (index >>> shift);
			var _v0 = A2($elm$core$Elm$JsArray$unsafeGet, pos, tree);
			if (_v0.$ === 'SubTree') {
				var subTree = _v0.a;
				var $temp$shift = shift - $elm$core$Array$shiftStep,
					$temp$index = index,
					$temp$tree = subTree;
				shift = $temp$shift;
				index = $temp$index;
				tree = $temp$tree;
				continue getHelp;
			} else {
				var values = _v0.a;
				return A2($elm$core$Elm$JsArray$unsafeGet, $elm$core$Array$bitMask & index, values);
			}
		}
	});
var $elm$core$Bitwise$shiftLeftBy = _Bitwise_shiftLeftBy;
var $elm$core$Array$tailIndex = function (len) {
	return (len >>> 5) << 5;
};
var $elm$core$Array$get = F2(
	function (index, _v0) {
		var len = _v0.a;
		var startShift = _v0.b;
		var tree = _v0.c;
		var tail = _v0.d;
		return ((index < 0) || (_Utils_cmp(index, len) > -1)) ? $elm$core$Maybe$Nothing : ((_Utils_cmp(
			index,
			$elm$core$Array$tailIndex(len)) > -1) ? $elm$core$Maybe$Just(
			A2($elm$core$Elm$JsArray$unsafeGet, $elm$core$Array$bitMask & index, tail)) : $elm$core$Maybe$Just(
			A3($elm$core$Array$getHelp, startShift, index, tree)));
	});
var $elm$core$Array$length = function (_v0) {
	var len = _v0.a;
	return len;
};
var $author$project$Test$Runner$Node$Vendor$Diff$Added = function (a) {
	return {$: 'Added', a: a};
};
var $author$project$Test$Runner$Node$Vendor$Diff$CannotGetA = function (a) {
	return {$: 'CannotGetA', a: a};
};
var $author$project$Test$Runner$Node$Vendor$Diff$CannotGetB = function (a) {
	return {$: 'CannotGetB', a: a};
};
var $author$project$Test$Runner$Node$Vendor$Diff$NoChange = function (a) {
	return {$: 'NoChange', a: a};
};
var $author$project$Test$Runner$Node$Vendor$Diff$Removed = function (a) {
	return {$: 'Removed', a: a};
};
var $author$project$Test$Runner$Node$Vendor$Diff$UnexpectedPath = F2(
	function (a, b) {
		return {$: 'UnexpectedPath', a: a, b: b};
	});
var $author$project$Test$Runner$Node$Vendor$Diff$makeChangesHelp = F5(
	function (changes, getA, getB, _v0, path) {
		makeChangesHelp:
		while (true) {
			var x = _v0.a;
			var y = _v0.b;
			if (!path.b) {
				return $elm$core$Result$Ok(changes);
			} else {
				var _v2 = path.a;
				var prevX = _v2.a;
				var prevY = _v2.b;
				var tail = path.b;
				var change = function () {
					if (_Utils_eq(x - 1, prevX) && _Utils_eq(y - 1, prevY)) {
						var _v4 = getA(x);
						if (_v4.$ === 'Just') {
							var a = _v4.a;
							return $elm$core$Result$Ok(
								$author$project$Test$Runner$Node$Vendor$Diff$NoChange(a));
						} else {
							return $elm$core$Result$Err(
								$author$project$Test$Runner$Node$Vendor$Diff$CannotGetA(x));
						}
					} else {
						if (_Utils_eq(x, prevX)) {
							var _v5 = getB(y);
							if (_v5.$ === 'Just') {
								var b = _v5.a;
								return $elm$core$Result$Ok(
									$author$project$Test$Runner$Node$Vendor$Diff$Added(b));
							} else {
								return $elm$core$Result$Err(
									$author$project$Test$Runner$Node$Vendor$Diff$CannotGetB(y));
							}
						} else {
							if (_Utils_eq(y, prevY)) {
								var _v6 = getA(x);
								if (_v6.$ === 'Just') {
									var a = _v6.a;
									return $elm$core$Result$Ok(
										$author$project$Test$Runner$Node$Vendor$Diff$Removed(a));
								} else {
									return $elm$core$Result$Err(
										$author$project$Test$Runner$Node$Vendor$Diff$CannotGetA(x));
								}
							} else {
								return $elm$core$Result$Err(
									A2(
										$author$project$Test$Runner$Node$Vendor$Diff$UnexpectedPath,
										_Utils_Tuple2(x, y),
										path));
							}
						}
					}
				}();
				if (change.$ === 'Err') {
					var err = change.a;
					return $elm$core$Result$Err(err);
				} else {
					var c = change.a;
					var $temp$changes = A2($elm$core$List$cons, c, changes),
						$temp$getA = getA,
						$temp$getB = getB,
						$temp$_v0 = _Utils_Tuple2(prevX, prevY),
						$temp$path = tail;
					changes = $temp$changes;
					getA = $temp$getA;
					getB = $temp$getB;
					_v0 = $temp$_v0;
					path = $temp$path;
					continue makeChangesHelp;
				}
			}
		}
	});
var $author$project$Test$Runner$Node$Vendor$Diff$makeChanges = F3(
	function (getA, getB, path) {
		if (!path.b) {
			return $elm$core$Result$Ok(_List_Nil);
		} else {
			var latest = path.a;
			var tail = path.b;
			return A5($author$project$Test$Runner$Node$Vendor$Diff$makeChangesHelp, _List_Nil, getA, getB, latest, tail);
		}
	});
var $author$project$Test$Runner$Node$Vendor$Diff$Continue = function (a) {
	return {$: 'Continue', a: a};
};
var $author$project$Test$Runner$Node$Vendor$Diff$Found = function (a) {
	return {$: 'Found', a: a};
};
var $elm$core$Elm$JsArray$unsafeSet = _JsArray_unsafeSet;
var $elm$core$Array$setHelp = F4(
	function (shift, index, value, tree) {
		var pos = $elm$core$Array$bitMask & (index >>> shift);
		var _v0 = A2($elm$core$Elm$JsArray$unsafeGet, pos, tree);
		if (_v0.$ === 'SubTree') {
			var subTree = _v0.a;
			var newSub = A4($elm$core$Array$setHelp, shift - $elm$core$Array$shiftStep, index, value, subTree);
			return A3(
				$elm$core$Elm$JsArray$unsafeSet,
				pos,
				$elm$core$Array$SubTree(newSub),
				tree);
		} else {
			var values = _v0.a;
			var newLeaf = A3($elm$core$Elm$JsArray$unsafeSet, $elm$core$Array$bitMask & index, value, values);
			return A3(
				$elm$core$Elm$JsArray$unsafeSet,
				pos,
				$elm$core$Array$Leaf(newLeaf),
				tree);
		}
	});
var $elm$core$Array$set = F3(
	function (index, value, array) {
		var len = array.a;
		var startShift = array.b;
		var tree = array.c;
		var tail = array.d;
		return ((index < 0) || (_Utils_cmp(index, len) > -1)) ? array : ((_Utils_cmp(
			index,
			$elm$core$Array$tailIndex(len)) > -1) ? A4(
			$elm$core$Array$Array_elm_builtin,
			len,
			startShift,
			tree,
			A3($elm$core$Elm$JsArray$unsafeSet, $elm$core$Array$bitMask & index, value, tail)) : A4(
			$elm$core$Array$Array_elm_builtin,
			len,
			startShift,
			A4($elm$core$Array$setHelp, startShift, index, value, tree),
			tail));
	});
var $author$project$Test$Runner$Node$Vendor$Diff$step = F4(
	function (snake_, offset, k, v) {
		var fromTop = A2(
			$elm$core$Maybe$withDefault,
			_List_Nil,
			A2($elm$core$Array$get, (k + 1) + offset, v));
		var fromLeft = A2(
			$elm$core$Maybe$withDefault,
			_List_Nil,
			A2($elm$core$Array$get, (k - 1) + offset, v));
		var _v0 = function () {
			var _v2 = _Utils_Tuple2(fromLeft, fromTop);
			if (!_v2.a.b) {
				if (!_v2.b.b) {
					return _Utils_Tuple2(
						_List_Nil,
						_Utils_Tuple2(0, 0));
				} else {
					var _v3 = _v2.b;
					var _v4 = _v3.a;
					var topX = _v4.a;
					var topY = _v4.b;
					return _Utils_Tuple2(
						fromTop,
						_Utils_Tuple2(topX + 1, topY));
				}
			} else {
				if (!_v2.b.b) {
					var _v5 = _v2.a;
					var _v6 = _v5.a;
					var leftX = _v6.a;
					var leftY = _v6.b;
					return _Utils_Tuple2(
						fromLeft,
						_Utils_Tuple2(leftX, leftY + 1));
				} else {
					var _v7 = _v2.a;
					var _v8 = _v7.a;
					var leftX = _v8.a;
					var leftY = _v8.b;
					var _v9 = _v2.b;
					var _v10 = _v9.a;
					var topX = _v10.a;
					var topY = _v10.b;
					return (_Utils_cmp(leftY + 1, topY) > -1) ? _Utils_Tuple2(
						fromLeft,
						_Utils_Tuple2(leftX, leftY + 1)) : _Utils_Tuple2(
						fromTop,
						_Utils_Tuple2(topX + 1, topY));
				}
			}
		}();
		var path = _v0.a;
		var _v1 = _v0.b;
		var x = _v1.a;
		var y = _v1.b;
		var _v11 = A3(
			snake_,
			x + 1,
			y + 1,
			A2(
				$elm$core$List$cons,
				_Utils_Tuple2(x, y),
				path));
		var newPath = _v11.a;
		var goal = _v11.b;
		return goal ? $author$project$Test$Runner$Node$Vendor$Diff$Found(newPath) : $author$project$Test$Runner$Node$Vendor$Diff$Continue(
			A3($elm$core$Array$set, k + offset, newPath, v));
	});
var $author$project$Test$Runner$Node$Vendor$Diff$onpLoopK = F4(
	function (snake_, offset, ks, v) {
		onpLoopK:
		while (true) {
			if (!ks.b) {
				return $author$project$Test$Runner$Node$Vendor$Diff$Continue(v);
			} else {
				var k = ks.a;
				var ks_ = ks.b;
				var _v1 = A4($author$project$Test$Runner$Node$Vendor$Diff$step, snake_, offset, k, v);
				if (_v1.$ === 'Found') {
					var path = _v1.a;
					return $author$project$Test$Runner$Node$Vendor$Diff$Found(path);
				} else {
					var v_ = _v1.a;
					var $temp$snake_ = snake_,
						$temp$offset = offset,
						$temp$ks = ks_,
						$temp$v = v_;
					snake_ = $temp$snake_;
					offset = $temp$offset;
					ks = $temp$ks;
					v = $temp$v;
					continue onpLoopK;
				}
			}
		}
	});
var $author$project$Test$Runner$Node$Vendor$Diff$onpLoopP = F5(
	function (snake_, delta, offset, p, v) {
		onpLoopP:
		while (true) {
			var ks = (delta > 0) ? _Utils_ap(
				$elm$core$List$reverse(
					A2($elm$core$List$range, delta + 1, delta + p)),
				A2($elm$core$List$range, -p, delta)) : _Utils_ap(
				$elm$core$List$reverse(
					A2($elm$core$List$range, delta + 1, p)),
				A2($elm$core$List$range, (-p) + delta, delta));
			var _v0 = A4($author$project$Test$Runner$Node$Vendor$Diff$onpLoopK, snake_, offset, ks, v);
			if (_v0.$ === 'Found') {
				var path = _v0.a;
				return path;
			} else {
				var v_ = _v0.a;
				var $temp$snake_ = snake_,
					$temp$delta = delta,
					$temp$offset = offset,
					$temp$p = p + 1,
					$temp$v = v_;
				snake_ = $temp$snake_;
				delta = $temp$delta;
				offset = $temp$offset;
				p = $temp$p;
				v = $temp$v;
				continue onpLoopP;
			}
		}
	});
var $author$project$Test$Runner$Node$Vendor$Diff$snake = F5(
	function (getA, getB, nextX, nextY, path) {
		snake:
		while (true) {
			var _v0 = _Utils_Tuple2(
				getA(nextX),
				getB(nextY));
			_v0$2:
			while (true) {
				if (_v0.a.$ === 'Just') {
					if (_v0.b.$ === 'Just') {
						var a = _v0.a.a;
						var b = _v0.b.a;
						if (_Utils_eq(a, b)) {
							var $temp$getA = getA,
								$temp$getB = getB,
								$temp$nextX = nextX + 1,
								$temp$nextY = nextY + 1,
								$temp$path = A2(
								$elm$core$List$cons,
								_Utils_Tuple2(nextX, nextY),
								path);
							getA = $temp$getA;
							getB = $temp$getB;
							nextX = $temp$nextX;
							nextY = $temp$nextY;
							path = $temp$path;
							continue snake;
						} else {
							return _Utils_Tuple2(path, false);
						}
					} else {
						break _v0$2;
					}
				} else {
					if (_v0.b.$ === 'Nothing') {
						var _v1 = _v0.a;
						var _v2 = _v0.b;
						return _Utils_Tuple2(path, true);
					} else {
						break _v0$2;
					}
				}
			}
			return _Utils_Tuple2(path, false);
		}
	});
var $author$project$Test$Runner$Node$Vendor$Diff$onp = F4(
	function (getA, getB, m, n) {
		var v = A2(
			$elm$core$Array$initialize,
			(m + n) + 1,
			$elm$core$Basics$always(_List_Nil));
		var delta = n - m;
		return A5(
			$author$project$Test$Runner$Node$Vendor$Diff$onpLoopP,
			A2($author$project$Test$Runner$Node$Vendor$Diff$snake, getA, getB),
			delta,
			m,
			0,
			v);
	});
var $author$project$Test$Runner$Node$Vendor$Diff$testDiff = F2(
	function (a, b) {
		var arrB = $elm$core$Array$fromList(b);
		var getB = function (y) {
			return A2($elm$core$Array$get, y - 1, arrB);
		};
		var n = $elm$core$Array$length(arrB);
		var arrA = $elm$core$Array$fromList(a);
		var getA = function (x) {
			return A2($elm$core$Array$get, x - 1, arrA);
		};
		var m = $elm$core$Array$length(arrA);
		var path = A4($author$project$Test$Runner$Node$Vendor$Diff$onp, getA, getB, m, n);
		return A3($author$project$Test$Runner$Node$Vendor$Diff$makeChanges, getA, getB, path);
	});
var $author$project$Test$Runner$Node$Vendor$Diff$diff = F2(
	function (a, b) {
		var _v0 = A2($author$project$Test$Runner$Node$Vendor$Diff$testDiff, a, b);
		if (_v0.$ === 'Ok') {
			var changes = _v0.a;
			return changes;
		} else {
			return _List_Nil;
		}
	});
var $author$project$Test$Reporter$Highlightable$Highlighted = function (a) {
	return {$: 'Highlighted', a: a};
};
var $author$project$Test$Reporter$Highlightable$Plain = function (a) {
	return {$: 'Plain', a: a};
};
var $author$project$Test$Reporter$Highlightable$fromDiff = function (diff) {
	switch (diff.$) {
		case 'Added':
			return _List_Nil;
		case 'Removed':
			var _char = diff.a;
			return _List_fromArray(
				[
					$author$project$Test$Reporter$Highlightable$Highlighted(_char)
				]);
		default:
			var _char = diff.a;
			return _List_fromArray(
				[
					$author$project$Test$Reporter$Highlightable$Plain(_char)
				]);
	}
};
var $author$project$Test$Reporter$Highlightable$diffLists = F2(
	function (expected, actual) {
		return A2(
			$elm$core$List$concatMap,
			$author$project$Test$Reporter$Highlightable$fromDiff,
			A2($author$project$Test$Runner$Node$Vendor$Diff$diff, expected, actual));
	});
var $author$project$Test$Reporter$Console$Format$isFloat = function (str) {
	var _v0 = $elm$core$String$toFloat(str);
	if (_v0.$ === 'Just') {
		return true;
	} else {
		return false;
	}
};
var $author$project$Test$Reporter$Highlightable$map = F2(
	function (transform, highlightable) {
		if (highlightable.$ === 'Highlighted') {
			var val = highlightable.a;
			return $author$project$Test$Reporter$Highlightable$Highlighted(
				transform(val));
		} else {
			var val = highlightable.a;
			return $author$project$Test$Reporter$Highlightable$Plain(
				transform(val));
		}
	});
var $elm$core$Basics$neq = _Utils_notEqual;
var $elm$core$Tuple$pair = F2(
	function (a, b) {
		return _Utils_Tuple2(a, b);
	});
var $author$project$Test$Reporter$Highlightable$resolve = F2(
	function (_v0, highlightable) {
		var fromHighlighted = _v0.fromHighlighted;
		var fromPlain = _v0.fromPlain;
		if (highlightable.$ === 'Highlighted') {
			var val = highlightable.a;
			return fromHighlighted(val);
		} else {
			var val = highlightable.a;
			return fromPlain(val);
		}
	});
var $elm$core$String$foldr = _String_foldr;
var $elm$core$String$toList = function (string) {
	return A3($elm$core$String$foldr, $elm$core$List$cons, _List_Nil, string);
};
var $author$project$Test$Reporter$Console$Format$highlightEqual = F2(
	function (expected, actual) {
		if ((expected === '\"\"') || (actual === '\"\"')) {
			return $elm$core$Maybe$Nothing;
		} else {
			if ($author$project$Test$Reporter$Console$Format$isFloat(expected) && $author$project$Test$Reporter$Console$Format$isFloat(actual)) {
				return $elm$core$Maybe$Nothing;
			} else {
				var isHighlighted = $author$project$Test$Reporter$Highlightable$resolve(
					{
						fromHighlighted: $elm$core$Basics$always(true),
						fromPlain: $elm$core$Basics$always(false)
					});
				var expectedChars = $elm$core$String$toList(expected);
				var edgeCount = function (highlightedString) {
					var highlights = A2($elm$core$List$map, isHighlighted, highlightedString);
					return $elm$core$List$length(
						A2(
							$elm$core$List$filter,
							function (_v0) {
								var lhs = _v0.a;
								var rhs = _v0.b;
								return !_Utils_eq(lhs, rhs);
							},
							A3(
								$elm$core$List$map2,
								$elm$core$Tuple$pair,
								A2($elm$core$List$drop, 1, highlights),
								highlights)));
				};
				var actualChars = $elm$core$String$toList(actual);
				var highlightedActual = A2(
					$elm$core$List$map,
					$author$project$Test$Reporter$Highlightable$map($elm$core$String$fromChar),
					A2($author$project$Test$Reporter$Highlightable$diffLists, actualChars, expectedChars));
				var highlightedExpected = A2(
					$elm$core$List$map,
					$author$project$Test$Reporter$Highlightable$map($elm$core$String$fromChar),
					A2($author$project$Test$Reporter$Highlightable$diffLists, expectedChars, actualChars));
				var plainCharCount = $elm$core$List$length(
					A2(
						$elm$core$List$filter,
						A2($elm$core$Basics$composeL, $elm$core$Basics$not, isHighlighted),
						highlightedExpected));
				return ((_Utils_cmp(
					edgeCount(highlightedActual),
					plainCharCount) > 0) || (_Utils_cmp(
					edgeCount(highlightedExpected),
					plainCharCount) > 0)) ? $elm$core$Maybe$Nothing : $elm$core$Maybe$Just(
					_Utils_Tuple2(highlightedExpected, highlightedActual));
			}
		}
	});
var $author$project$Test$Reporter$Console$Format$verticalBar = F3(
	function (comparison, expected, actual) {
		return A2(
			$elm$core$String$join,
			'\n',
			_List_fromArray(
				[actual, '╷', '│ ' + comparison, '╵', expected]));
	});
var $author$project$Test$Reporter$Console$Format$listDiffToString = F4(
	function (index, description, _v0, originals) {
		listDiffToString:
		while (true) {
			var expected = _v0.expected;
			var actual = _v0.actual;
			var _v1 = _Utils_Tuple2(expected, actual);
			if (!_v1.a.b) {
				if (!_v1.b.b) {
					return A2(
						$elm$core$String$join,
						'',
						_List_fromArray(
							[
								'Two lists were unequal previously, yet ended up equal later.',
								'This should never happen!',
								'Please report this bug to https://github.com/elm-community/elm-test/issues - and include these lists: ',
								'\n',
								A2($elm$core$String$join, ', ', originals.originalExpected),
								'\n',
								A2($elm$core$String$join, ', ', originals.originalActual)
							]));
				} else {
					var _v3 = _v1.b;
					return A3(
						$author$project$Test$Reporter$Console$Format$verticalBar,
						description + ' was longer than',
						A2($elm$core$String$join, ', ', originals.originalExpected),
						A2($elm$core$String$join, ', ', originals.originalActual));
				}
			} else {
				if (!_v1.b.b) {
					var _v2 = _v1.a;
					return A3(
						$author$project$Test$Reporter$Console$Format$verticalBar,
						description + ' was shorter than',
						A2($elm$core$String$join, ', ', originals.originalExpected),
						A2($elm$core$String$join, ', ', originals.originalActual));
				} else {
					var _v4 = _v1.a;
					var firstExpected = _v4.a;
					var restExpected = _v4.b;
					var _v5 = _v1.b;
					var firstActual = _v5.a;
					var restActual = _v5.b;
					if (_Utils_eq(firstExpected, firstActual)) {
						var $temp$index = index + 1,
							$temp$description = description,
							$temp$_v0 = {actual: restActual, expected: restExpected},
							$temp$originals = originals;
						index = $temp$index;
						description = $temp$description;
						_v0 = $temp$_v0;
						originals = $temp$originals;
						continue listDiffToString;
					} else {
						return A2(
							$elm$core$String$join,
							'',
							_List_fromArray(
								[
									A3(
									$author$project$Test$Reporter$Console$Format$verticalBar,
									description,
									A2($elm$core$String$join, ', ', originals.originalExpected),
									A2($elm$core$String$join, ', ', originals.originalActual)),
									'\n\nThe first diff is at index ',
									$elm$core$String$fromInt(index),
									': it was `',
									firstActual,
									'`, but `',
									firstExpected,
									'` was expected.'
								]));
					}
				}
			}
		}
	});
var $author$project$Test$Reporter$Console$Format$format = F3(
	function (formatEquality, description, reason) {
		switch (reason.$) {
			case 'Custom':
				return description;
			case 'Equality':
				var expected = reason.a;
				var actual = reason.b;
				var _v1 = A2($author$project$Test$Reporter$Console$Format$highlightEqual, expected, actual);
				if (_v1.$ === 'Nothing') {
					return A3($author$project$Test$Reporter$Console$Format$verticalBar, description, expected, actual);
				} else {
					var _v2 = _v1.a;
					var highlightedExpected = _v2.a;
					var highlightedActual = _v2.b;
					var _v3 = A2(formatEquality, highlightedExpected, highlightedActual);
					var formattedExpected = _v3.a;
					var formattedActual = _v3.b;
					return A3($author$project$Test$Reporter$Console$Format$verticalBar, description, formattedExpected, formattedActual);
				}
			case 'Comparison':
				var first = reason.a;
				var second = reason.b;
				return A3($author$project$Test$Reporter$Console$Format$verticalBar, description, first, second);
			case 'TODO':
				return description;
			case 'Invalid':
				if (reason.a.$ === 'BadDescription') {
					var _v4 = reason.a;
					return (description === '') ? 'The empty string is not a valid test description.' : ('This is an invalid test description: ' + description);
				} else {
					return description;
				}
			case 'ListDiff':
				var expected = reason.a;
				var actual = reason.b;
				return A4(
					$author$project$Test$Reporter$Console$Format$listDiffToString,
					0,
					description,
					{actual: actual, expected: expected},
					{originalActual: actual, originalExpected: expected});
			default:
				var expected = reason.a.expected;
				var actual = reason.a.actual;
				var extra = reason.a.extra;
				var missing = reason.a.missing;
				var missingStr = $elm$core$List$isEmpty(missing) ? '' : ('\nThese keys are missing: ' + function (d) {
					return '[ ' + (d + ' ]');
				}(
					A2($elm$core$String$join, ', ', missing)));
				var extraStr = $elm$core$List$isEmpty(extra) ? '' : ('\nThese keys are extra: ' + function (d) {
					return '[ ' + (d + ' ]');
				}(
					A2($elm$core$String$join, ', ', extra)));
				return A2(
					$elm$core$String$join,
					'',
					_List_fromArray(
						[
							A3($author$project$Test$Reporter$Console$Format$verticalBar, description, expected, actual),
							'\n',
							extraStr,
							missingStr
						]));
		}
	});
var $author$project$Test$Reporter$Console$Format$Color$fromHighlightable = $author$project$Test$Reporter$Highlightable$resolve(
	{fromHighlighted: $author$project$Test$Runner$Node$Vendor$Console$colorsInverted, fromPlain: $elm$core$Basics$identity});
var $author$project$Test$Reporter$Console$Format$Color$formatEquality = F2(
	function (highlightedExpected, highlightedActual) {
		var formattedExpected = A2(
			$elm$core$String$join,
			'',
			A2($elm$core$List$map, $author$project$Test$Reporter$Console$Format$Color$fromHighlightable, highlightedExpected));
		var formattedActual = A2(
			$elm$core$String$join,
			'',
			A2($elm$core$List$map, $author$project$Test$Reporter$Console$Format$Color$fromHighlightable, highlightedActual));
		return _Utils_Tuple2(formattedExpected, formattedActual);
	});
var $author$project$Test$Reporter$Console$Format$Monochrome$fromHighlightable = function (indicator) {
	return $author$project$Test$Reporter$Highlightable$resolve(
		{
			fromHighlighted: function (_char) {
				return _Utils_Tuple2(_char, indicator);
			},
			fromPlain: function (_char) {
				return _Utils_Tuple2(_char, ' ');
			}
		});
};
var $elm$core$List$unzip = function (pairs) {
	var step = F2(
		function (_v0, _v1) {
			var x = _v0.a;
			var y = _v0.b;
			var xs = _v1.a;
			var ys = _v1.b;
			return _Utils_Tuple2(
				A2($elm$core$List$cons, x, xs),
				A2($elm$core$List$cons, y, ys));
		});
	return A3(
		$elm$core$List$foldr,
		step,
		_Utils_Tuple2(_List_Nil, _List_Nil),
		pairs);
};
var $author$project$Test$Reporter$Console$Format$Monochrome$formatEquality = F2(
	function (highlightedExpected, highlightedActual) {
		var _v0 = $elm$core$List$unzip(
			A2(
				$elm$core$List$map,
				$author$project$Test$Reporter$Console$Format$Monochrome$fromHighlightable('▲'),
				highlightedExpected));
		var formattedExpected = _v0.a;
		var expectedIndicators = _v0.b;
		var combinedExpected = A2(
			$elm$core$String$join,
			'\n',
			_List_fromArray(
				[
					A2($elm$core$String$join, '', formattedExpected),
					A2($elm$core$String$join, '', expectedIndicators)
				]));
		var _v1 = $elm$core$List$unzip(
			A2(
				$elm$core$List$map,
				$author$project$Test$Reporter$Console$Format$Monochrome$fromHighlightable('▼'),
				highlightedActual));
		var formattedActual = _v1.a;
		var actualIndicators = _v1.b;
		var combinedActual = A2(
			$elm$core$String$join,
			'\n',
			_List_fromArray(
				[
					A2($elm$core$String$join, '', actualIndicators),
					A2($elm$core$String$join, '', formattedActual)
				]));
		return _Utils_Tuple2(combinedExpected, combinedActual);
	});
var $author$project$Test$Reporter$Console$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n',
		A2(
			$elm$core$List$map,
			$elm$core$Basics$append('    '),
			A2($elm$core$String$split, '\n', str)));
};
var $author$project$Test$Reporter$Console$failureToText = F2(
	function (useColor, _v0) {
		var given = _v0.given;
		var description = _v0.description;
		var reason = _v0.reason;
		var formatEquality = function () {
			if (useColor.$ === 'Monochrome') {
				return $author$project$Test$Reporter$Console$Format$Monochrome$formatEquality;
			} else {
				return $author$project$Test$Reporter$Console$Format$Color$formatEquality;
			}
		}();
		var messageText = $author$project$Console$Text$plain(
			'\n' + ($author$project$Test$Reporter$Console$indent(
				A3($author$project$Test$Reporter$Console$Format$format, formatEquality, description, reason)) + '\n\n'));
		if (given.$ === 'Nothing') {
			return messageText;
		} else {
			var givenStr = given.a;
			return $author$project$Console$Text$concat(
				_List_fromArray(
					[
						$author$project$Console$Text$dark(
						$author$project$Console$Text$plain('\nGiven ' + (givenStr + '\n'))),
						messageText
					]));
		}
	});
var $author$project$Test$Reporter$Console$failuresToText = F3(
	function (useColor, labels, failures) {
		return $author$project$Console$Text$concat(
			A2(
				$elm$core$List$cons,
				$author$project$Test$Reporter$Console$failureLabelsToText(labels),
				A2(
					$elm$core$List$map,
					$author$project$Test$Reporter$Console$failureToText(useColor),
					failures)));
	});
var $elm$json$Json$Encode$null = _Json_encodeNull;
var $author$project$Test$Reporter$Console$reportComplete = F2(
	function (useColor, _v0) {
		var labels = _v0.labels;
		var outcome = _v0.outcome;
		switch (outcome.$) {
			case 'Passed':
				return $elm$json$Json$Encode$null;
			case 'Failed':
				var failures = outcome.a;
				return A2(
					$author$project$Test$Reporter$Console$textToValue,
					useColor,
					A3($author$project$Test$Reporter$Console$failuresToText, useColor, labels, failures));
			default:
				var str = outcome.a;
				return $elm$json$Json$Encode$object(
					_List_fromArray(
						[
							_Utils_Tuple2(
							'todo',
							$elm$json$Json$Encode$string(str)),
							_Utils_Tuple2(
							'labels',
							A2($elm$json$Json$Encode$list, $elm$json$Json$Encode$string, labels))
						]));
		}
	});
var $elm$core$String$fromFloat = _String_fromNumber;
var $author$project$Test$Reporter$JUnit$encodeDuration = function (time) {
	return $elm$json$Json$Encode$string(
		$elm$core$String$fromFloat(time / 1000));
};
var $author$project$Test$Reporter$JUnit$encodeFailureTuple = function (message) {
	return _Utils_Tuple2(
		'failure',
		$elm$json$Json$Encode$string(message));
};
var $author$project$Test$Reporter$JUnit$reasonToString = F2(
	function (description, reason) {
		switch (reason.$) {
			case 'Custom':
				return description;
			case 'Equality':
				var expected = reason.a;
				var actual = reason.b;
				return expected + ('\n\nwas not equal to\n\n' + actual);
			case 'Comparison':
				var first = reason.a;
				var second = reason.b;
				return first + ('\n\nfailed when compared with ' + (description + (' on\n\n' + second)));
			case 'TODO':
				return 'TODO: ' + description;
			case 'Invalid':
				if (reason.a.$ === 'BadDescription') {
					var _v1 = reason.a;
					var explanation = (description === '') ? 'The empty string is not a valid test description.' : ('This is an invalid test description: ' + description);
					return 'Invalid test: ' + explanation;
				} else {
					return 'Invalid test: ' + description;
				}
			case 'ListDiff':
				var expected = reason.a;
				var actual = reason.b;
				return A2($elm$core$String$join, ', ', expected) + ('\n\nhad different elements than\n\n' + A2($elm$core$String$join, ', ', actual));
			default:
				var expected = reason.a.expected;
				var actual = reason.a.actual;
				var extra = reason.a.extra;
				var missing = reason.a.missing;
				return expected + ('\n\nhad different contents than\n\n' + (actual + ('\n\nthese were extra:\n\n' + (A2($elm$core$String$join, '\n', extra) + ('\n\nthese were missing:\n\n' + A2($elm$core$String$join, '\n', missing))))));
		}
	});
var $author$project$Test$Reporter$JUnit$formatFailure = function (_v0) {
	var given = _v0.given;
	var description = _v0.description;
	var reason = _v0.reason;
	var message = A2($author$project$Test$Reporter$JUnit$reasonToString, description, reason);
	if (given.$ === 'Just') {
		var str = given.a;
		return 'Given ' + (str + ('\n\n' + message));
	} else {
		return message;
	}
};
var $author$project$Test$Reporter$JUnit$encodeOutcome = function (outcome) {
	switch (outcome.$) {
		case 'Passed':
			return _List_Nil;
		case 'Failed':
			var failures = outcome.a;
			var message = A2(
				$elm$core$String$join,
				'\n\n\n',
				A2($elm$core$List$map, $author$project$Test$Reporter$JUnit$formatFailure, failures));
			return _List_fromArray(
				[
					$author$project$Test$Reporter$JUnit$encodeFailureTuple(message)
				]);
		default:
			var message = outcome.a;
			return _List_fromArray(
				[
					$author$project$Test$Reporter$JUnit$encodeFailureTuple('TODO: ' + message)
				]);
	}
};
var $author$project$Test$Reporter$JUnit$formatClassAndName = function (labels) {
	if (labels.b) {
		var head = labels.a;
		var rest = labels.b;
		return _Utils_Tuple2(
			A2(
				$elm$core$String$join,
				' ',
				$elm$core$List$reverse(rest)),
			head);
	} else {
		return _Utils_Tuple2('', '');
	}
};
var $author$project$Test$Reporter$JUnit$reportComplete = function (_v0) {
	var labels = _v0.labels;
	var duration = _v0.duration;
	var outcome = _v0.outcome;
	var _v1 = $author$project$Test$Reporter$JUnit$formatClassAndName(labels);
	var classname = _v1.a;
	var name = _v1.b;
	return $elm$json$Json$Encode$object(
		_Utils_ap(
			_List_fromArray(
				[
					_Utils_Tuple2(
					'@classname',
					$elm$json$Json$Encode$string(classname)),
					_Utils_Tuple2(
					'@name',
					$elm$json$Json$Encode$string(name)),
					_Utils_Tuple2(
					'@time',
					$author$project$Test$Reporter$JUnit$encodeDuration(duration))
				]),
			$author$project$Test$Reporter$JUnit$encodeOutcome(outcome)));
};
var $author$project$Test$Reporter$Json$encodeReasonType = F2(
	function (reasonType, data) {
		return $elm$json$Json$Encode$object(
			_List_fromArray(
				[
					_Utils_Tuple2(
					'type',
					$elm$json$Json$Encode$string(reasonType)),
					_Utils_Tuple2('data', data)
				]));
	});
var $author$project$Test$Reporter$Json$encodeReason = F2(
	function (description, reason) {
		switch (reason.$) {
			case 'Custom':
				return A2(
					$author$project$Test$Reporter$Json$encodeReasonType,
					'Custom',
					$elm$json$Json$Encode$string(description));
			case 'Equality':
				var expected = reason.a;
				var actual = reason.b;
				return A2(
					$author$project$Test$Reporter$Json$encodeReasonType,
					'Equality',
					$elm$json$Json$Encode$object(
						_List_fromArray(
							[
								_Utils_Tuple2(
								'expected',
								$elm$json$Json$Encode$string(expected)),
								_Utils_Tuple2(
								'actual',
								$elm$json$Json$Encode$string(actual)),
								_Utils_Tuple2(
								'comparison',
								$elm$json$Json$Encode$string(description))
							])));
			case 'Comparison':
				var first = reason.a;
				var second = reason.b;
				return A2(
					$author$project$Test$Reporter$Json$encodeReasonType,
					'Comparison',
					$elm$json$Json$Encode$object(
						_List_fromArray(
							[
								_Utils_Tuple2(
								'first',
								$elm$json$Json$Encode$string(first)),
								_Utils_Tuple2(
								'second',
								$elm$json$Json$Encode$string(second)),
								_Utils_Tuple2(
								'comparison',
								$elm$json$Json$Encode$string(description))
							])));
			case 'TODO':
				return A2(
					$author$project$Test$Reporter$Json$encodeReasonType,
					'TODO',
					$elm$json$Json$Encode$string(description));
			case 'Invalid':
				if (reason.a.$ === 'BadDescription') {
					var _v1 = reason.a;
					var explanation = (description === '') ? 'The empty string is not a valid test description.' : ('This is an invalid test description: ' + description);
					return A2(
						$author$project$Test$Reporter$Json$encodeReasonType,
						'Invalid',
						$elm$json$Json$Encode$string(explanation));
				} else {
					return A2(
						$author$project$Test$Reporter$Json$encodeReasonType,
						'Invalid',
						$elm$json$Json$Encode$string(description));
				}
			case 'ListDiff':
				var expected = reason.a;
				var actual = reason.b;
				return A2(
					$author$project$Test$Reporter$Json$encodeReasonType,
					'ListDiff',
					$elm$json$Json$Encode$object(
						_List_fromArray(
							[
								_Utils_Tuple2(
								'expected',
								A2($elm$json$Json$Encode$list, $elm$json$Json$Encode$string, expected)),
								_Utils_Tuple2(
								'actual',
								A2($elm$json$Json$Encode$list, $elm$json$Json$Encode$string, actual))
							])));
			default:
				var expected = reason.a.expected;
				var actual = reason.a.actual;
				var extra = reason.a.extra;
				var missing = reason.a.missing;
				return A2(
					$author$project$Test$Reporter$Json$encodeReasonType,
					'CollectionDiff',
					$elm$json$Json$Encode$object(
						_List_fromArray(
							[
								_Utils_Tuple2(
								'expected',
								$elm$json$Json$Encode$string(expected)),
								_Utils_Tuple2(
								'actual',
								$elm$json$Json$Encode$string(actual)),
								_Utils_Tuple2(
								'extra',
								A2($elm$json$Json$Encode$list, $elm$json$Json$Encode$string, extra)),
								_Utils_Tuple2(
								'missing',
								A2($elm$json$Json$Encode$list, $elm$json$Json$Encode$string, missing))
							])));
		}
	});
var $author$project$Test$Reporter$Json$encodeFailure = function (_v0) {
	var given = _v0.given;
	var description = _v0.description;
	var reason = _v0.reason;
	return $elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'given',
				A2(
					$elm$core$Maybe$withDefault,
					$elm$json$Json$Encode$null,
					A2($elm$core$Maybe$map, $elm$json$Json$Encode$string, given))),
				_Utils_Tuple2(
				'message',
				$elm$json$Json$Encode$string(description)),
				_Utils_Tuple2(
				'reason',
				A2($author$project$Test$Reporter$Json$encodeReason, description, reason))
			]));
};
var $author$project$Test$Reporter$Json$encodeFailures = function (outcome) {
	switch (outcome.$) {
		case 'Failed':
			var failures = outcome.a;
			return A2($elm$core$List$map, $author$project$Test$Reporter$Json$encodeFailure, failures);
		case 'Todo':
			var str = outcome.a;
			return _List_fromArray(
				[
					$elm$json$Json$Encode$string(str)
				]);
		default:
			return _List_Nil;
	}
};
var $author$project$Test$Reporter$Json$encodeLabels = function (labels) {
	return A2(
		$elm$json$Json$Encode$list,
		$elm$json$Json$Encode$string,
		$elm$core$List$reverse(labels));
};
var $author$project$Test$Reporter$Json$getStatus = function (outcome) {
	switch (outcome.$) {
		case 'Failed':
			return 'fail';
		case 'Todo':
			return 'todo';
		default:
			return 'pass';
	}
};
var $author$project$Test$Reporter$Json$reportComplete = function (_v0) {
	var duration = _v0.duration;
	var labels = _v0.labels;
	var outcome = _v0.outcome;
	return $elm$json$Json$Encode$object(
		_List_fromArray(
			[
				_Utils_Tuple2(
				'event',
				$elm$json$Json$Encode$string('testCompleted')),
				_Utils_Tuple2(
				'status',
				$elm$json$Json$Encode$string(
					$author$project$Test$Reporter$Json$getStatus(outcome))),
				_Utils_Tuple2(
				'labels',
				$author$project$Test$Reporter$Json$encodeLabels(labels)),
				_Utils_Tuple2(
				'failures',
				A2(
					$elm$json$Json$Encode$list,
					$elm$core$Basics$identity,
					$author$project$Test$Reporter$Json$encodeFailures(outcome))),
				_Utils_Tuple2(
				'duration',
				$elm$json$Json$Encode$string(
					$elm$core$String$fromInt(duration)))
			]));
};
var $author$project$Test$Reporter$Console$formatDuration = function (time) {
	return $elm$core$String$fromFloat(time) + ' ms';
};
var $author$project$Console$Text$Green = {$: 'Green'};
var $author$project$Console$Text$green = $author$project$Console$Text$Text(
	{background: $author$project$Console$Text$Default, foreground: $author$project$Console$Text$Green, modifiers: _List_Nil, style: $author$project$Console$Text$Normal});
var $author$project$Test$Reporter$Console$stat = F2(
	function (label, value) {
		return $author$project$Console$Text$concat(
			_List_fromArray(
				[
					$author$project$Console$Text$dark(
					$author$project$Console$Text$plain(label)),
					$author$project$Console$Text$plain(value + '\n')
				]));
	});
var $author$project$Test$Reporter$Console$todoLabelsToText = A2(
	$elm$core$Basics$composeR,
	A2(
		$elm_explorations$test$Test$Runner$formatLabels,
		A2(
			$elm$core$Basics$composeL,
			A2($elm$core$Basics$composeL, $author$project$Console$Text$dark, $author$project$Console$Text$plain),
			$author$project$Test$Reporter$Console$withChar(
				_Utils_chr('↓'))),
		A2(
			$elm$core$Basics$composeL,
			A2($elm$core$Basics$composeL, $author$project$Console$Text$dark, $author$project$Console$Text$plain),
			$author$project$Test$Reporter$Console$withChar(
				_Utils_chr('↓')))),
	$author$project$Console$Text$concat);
var $author$project$Test$Reporter$Console$todoToChalk = function (message) {
	return $author$project$Console$Text$plain('◦ TODO: ' + (message + '\n\n'));
};
var $author$project$Test$Reporter$Console$todosToText = function (_v0) {
	var labels = _v0.a;
	var failure = _v0.b;
	return $author$project$Console$Text$concat(
		_List_fromArray(
			[
				$author$project$Test$Reporter$Console$todoLabelsToText(labels),
				$author$project$Test$Reporter$Console$todoToChalk(failure)
			]));
};
var $author$project$Test$Reporter$Console$summarizeTodos = A2(
	$elm$core$Basics$composeR,
	$elm$core$List$map($author$project$Test$Reporter$Console$todosToText),
	$author$project$Console$Text$concat);
var $author$project$Console$Text$Underline = {$: 'Underline'};
var $author$project$Console$Text$underline = function (txt) {
	if (txt.$ === 'Text') {
		var styles = txt.a;
		var str = txt.b;
		return A2(
			$author$project$Console$Text$Text,
			_Utils_update(
				styles,
				{style: $author$project$Console$Text$Underline}),
			str);
	} else {
		var texts = txt.a;
		return $author$project$Console$Text$Texts(
			A2($elm$core$List$map, $author$project$Console$Text$dark, texts));
	}
};
var $author$project$Console$Text$Yellow = {$: 'Yellow'};
var $author$project$Console$Text$yellow = $author$project$Console$Text$Text(
	{background: $author$project$Console$Text$Default, foreground: $author$project$Console$Text$Yellow, modifiers: _List_Nil, style: $author$project$Console$Text$Normal});
var $author$project$Test$Reporter$Console$reportSummary = F3(
	function (useColor, _v0, autoFail) {
		var todos = _v0.todos;
		var passed = _v0.passed;
		var failed = _v0.failed;
		var duration = _v0.duration;
		var todoStats = function () {
			var _v7 = $elm$core$List$length(todos);
			if (!_v7) {
				return $author$project$Console$Text$plain('');
			} else {
				var numTodos = _v7;
				return A2(
					$author$project$Test$Reporter$Console$stat,
					'Todo:     ',
					$elm$core$String$fromInt(numTodos));
			}
		}();
		var individualTodos = (failed > 0) ? $author$project$Console$Text$plain('') : $author$project$Test$Reporter$Console$summarizeTodos(
			$elm$core$List$reverse(todos));
		var headlineResult = function () {
			var _v3 = _Utils_Tuple3(
				autoFail,
				failed,
				$elm$core$List$length(todos));
			_v3$4:
			while (true) {
				if (_v3.a.$ === 'Nothing') {
					if (!_v3.b) {
						switch (_v3.c) {
							case 0:
								var _v4 = _v3.a;
								return $elm$core$Result$Ok('TEST RUN PASSED');
							case 1:
								var _v5 = _v3.a;
								return $elm$core$Result$Err(
									_Utils_Tuple3($author$project$Console$Text$yellow, 'TEST RUN INCOMPLETE', ' because there is 1 TODO remaining'));
							default:
								var _v6 = _v3.a;
								var numTodos = _v3.c;
								return $elm$core$Result$Err(
									_Utils_Tuple3(
										$author$project$Console$Text$yellow,
										'TEST RUN INCOMPLETE',
										' because there are ' + ($elm$core$String$fromInt(numTodos) + ' TODOs remaining')));
						}
					} else {
						break _v3$4;
					}
				} else {
					if (!_v3.b) {
						var failure = _v3.a.a;
						return $elm$core$Result$Err(
							_Utils_Tuple3($author$project$Console$Text$yellow, 'TEST RUN INCOMPLETE', ' because ' + failure));
					} else {
						break _v3$4;
					}
				}
			}
			return $elm$core$Result$Err(
				_Utils_Tuple3($author$project$Console$Text$red, 'TEST RUN FAILED', ''));
		}();
		var headline = function () {
			if (headlineResult.$ === 'Ok') {
				var str = headlineResult.a;
				return $author$project$Console$Text$underline(
					$author$project$Console$Text$green('\n' + (str + '\n\n')));
			} else {
				var _v2 = headlineResult.a;
				var colorize = _v2.a;
				var str = _v2.b;
				var suffix = _v2.c;
				return $author$project$Console$Text$concat(
					_List_fromArray(
						[
							$author$project$Console$Text$underline(
							colorize('\n' + str)),
							colorize(suffix + '\n\n')
						]));
			}
		}();
		return $elm$json$Json$Encode$string(
			A2(
				$author$project$Console$Text$render,
				useColor,
				$author$project$Console$Text$concat(
					_List_fromArray(
						[
							headline,
							A2(
							$author$project$Test$Reporter$Console$stat,
							'Duration: ',
							$author$project$Test$Reporter$Console$formatDuration(duration)),
							A2(
							$author$project$Test$Reporter$Console$stat,
							'Passed:   ',
							$elm$core$String$fromInt(passed)),
							A2(
							$author$project$Test$Reporter$Console$stat,
							'Failed:   ',
							$elm$core$String$fromInt(failed)),
							todoStats,
							individualTodos
						]))));
	});
var $author$project$Test$Reporter$TestResults$Failed = function (a) {
	return {$: 'Failed', a: a};
};
var $author$project$Test$Reporter$JUnit$encodeExtraFailure = function (_v0) {
	return $author$project$Test$Reporter$JUnit$reportComplete(
		{
			duration: 0,
			labels: _List_Nil,
			outcome: $author$project$Test$Reporter$TestResults$Failed(_List_Nil)
		});
};
var $elm$json$Json$Encode$float = _Json_wrap;
var $elm$json$Json$Encode$int = _Json_wrap;
var $author$project$Test$Reporter$JUnit$reportSummary = F2(
	function (_v0, autoFail) {
		var testCount = _v0.testCount;
		var duration = _v0.duration;
		var failed = _v0.failed;
		var extraFailures = function () {
			var _v1 = _Utils_Tuple2(failed, autoFail);
			if ((!_v1.a) && (_v1.b.$ === 'Just')) {
				var failure = _v1.b.a;
				return _List_fromArray(
					[
						$author$project$Test$Reporter$JUnit$encodeExtraFailure(failure)
					]);
			} else {
				return _List_Nil;
			}
		}();
		return $elm$json$Json$Encode$object(
			_List_fromArray(
				[
					_Utils_Tuple2(
					'testsuite',
					$elm$json$Json$Encode$object(
						_List_fromArray(
							[
								_Utils_Tuple2(
								'@name',
								$elm$json$Json$Encode$string('elm-test')),
								_Utils_Tuple2(
								'@package',
								$elm$json$Json$Encode$string('elm-test')),
								_Utils_Tuple2(
								'@tests',
								$elm$json$Json$Encode$int(testCount)),
								_Utils_Tuple2(
								'@failures',
								$elm$json$Json$Encode$int(failed)),
								_Utils_Tuple2(
								'@errors',
								$elm$json$Json$Encode$int(0)),
								_Utils_Tuple2(
								'@time',
								$elm$json$Json$Encode$float(duration)),
								_Utils_Tuple2(
								'testcase',
								A2($elm$json$Json$Encode$list, $elm$core$Basics$identity, extraFailures))
							])))
				]));
	});
var $author$project$Test$Reporter$Json$reportSummary = F2(
	function (_v0, autoFail) {
		var duration = _v0.duration;
		var passed = _v0.passed;
		var failed = _v0.failed;
		return $elm$json$Json$Encode$object(
			_List_fromArray(
				[
					_Utils_Tuple2(
					'event',
					$elm$json$Json$Encode$string('runComplete')),
					_Utils_Tuple2(
					'passed',
					$elm$json$Json$Encode$string(
						$elm$core$String$fromInt(passed))),
					_Utils_Tuple2(
					'failed',
					$elm$json$Json$Encode$string(
						$elm$core$String$fromInt(failed))),
					_Utils_Tuple2(
					'duration',
					$elm$json$Json$Encode$string(
						$elm$core$String$fromFloat(duration))),
					_Utils_Tuple2(
					'autoFail',
					A2(
						$elm$core$Maybe$withDefault,
						$elm$json$Json$Encode$null,
						A2($elm$core$Maybe$map, $elm$json$Json$Encode$string, autoFail)))
				]));
	});
var $author$project$Test$Reporter$Reporter$createReporter = function (report) {
	switch (report.$) {
		case 'JsonReport':
			return A4($author$project$Test$Reporter$Reporter$TestReporter, 'JSON', $author$project$Test$Reporter$Json$reportBegin, $author$project$Test$Reporter$Json$reportComplete, $author$project$Test$Reporter$Json$reportSummary);
		case 'ConsoleReport':
			var useColor = report.a;
			return A4(
				$author$project$Test$Reporter$Reporter$TestReporter,
				'CHALK',
				$author$project$Test$Reporter$Console$reportBegin(useColor),
				$author$project$Test$Reporter$Console$reportComplete(useColor),
				$author$project$Test$Reporter$Console$reportSummary(useColor));
		default:
			return A4($author$project$Test$Reporter$Reporter$TestReporter, 'JUNIT', $author$project$Test$Reporter$JUnit$reportBegin, $author$project$Test$Reporter$JUnit$reportComplete, $author$project$Test$Reporter$JUnit$reportSummary);
	}
};
var $author$project$Test$Runner$Node$elmTestPort__send = _Platform_outgoingPort('elmTestPort__send', $elm$json$Json$Encode$string);
var $author$project$Test$Runner$Node$failInit = F3(
	function (message, report, _v0) {
		var model = {
			autoFail: $elm$core$Maybe$Nothing,
			available: $elm$core$Dict$empty,
			nextTestToRun: 0,
			processes: 0,
			results: _List_Nil,
			runInfo: {fuzzRuns: 0, globs: _List_Nil, initialSeed: 0, paths: _List_Nil, testCount: 0},
			testReporter: $author$project$Test$Reporter$Reporter$createReporter(report)
		};
		var cmd = $author$project$Test$Runner$Node$elmTestPort__send(
			A2(
				$elm$json$Json$Encode$encode,
				0,
				$elm$json$Json$Encode$object(
					_List_fromArray(
						[
							_Utils_Tuple2(
							'type',
							$elm$json$Json$Encode$string('SUMMARY')),
							_Utils_Tuple2(
							'exitCode',
							$elm$json$Json$Encode$int(1)),
							_Utils_Tuple2(
							'message',
							$elm$json$Json$Encode$string(message))
						]))));
		return _Utils_Tuple2(model, cmd);
	});
var $elm$core$List$maybeCons = F3(
	function (f, mx, xs) {
		var _v0 = f(mx);
		if (_v0.$ === 'Just') {
			var x = _v0.a;
			return A2($elm$core$List$cons, x, xs);
		} else {
			return xs;
		}
	});
var $elm$core$List$filterMap = F2(
	function (f, xs) {
		return A3(
			$elm$core$List$foldr,
			$elm$core$List$maybeCons(f),
			_List_Nil,
			xs);
	});
var $elm_explorations$test$Test$Runner$Invalid = function (a) {
	return {$: 'Invalid', a: a};
};
var $elm_explorations$test$Test$Runner$Only = function (a) {
	return {$: 'Only', a: a};
};
var $elm_explorations$test$Test$Runner$Plain = function (a) {
	return {$: 'Plain', a: a};
};
var $elm_explorations$test$Test$Runner$Skipping = function (a) {
	return {$: 'Skipping', a: a};
};
var $elm_explorations$test$Test$Runner$countRunnables = function (runnable) {
	countRunnables:
	while (true) {
		switch (runnable.$) {
			case 'Runnable':
				return 1;
			case 'Labeled':
				var runner = runnable.b;
				var $temp$runnable = runner;
				runnable = $temp$runnable;
				continue countRunnables;
			default:
				var runners = runnable.a;
				return $elm_explorations$test$Test$Runner$cyclic$countAllRunnables()(runners);
		}
	}
};
function $elm_explorations$test$Test$Runner$cyclic$countAllRunnables() {
	return A2(
		$elm$core$List$foldl,
		A2($elm$core$Basics$composeR, $elm_explorations$test$Test$Runner$countRunnables, $elm$core$Basics$add),
		0);
}
try {
	var $elm_explorations$test$Test$Runner$countAllRunnables = $elm_explorations$test$Test$Runner$cyclic$countAllRunnables();
	$elm_explorations$test$Test$Runner$cyclic$countAllRunnables = function () {
		return $elm_explorations$test$Test$Runner$countAllRunnables;
	};
} catch ($) {
	throw 'Some top-level definitions from `Test.Runner` are causing infinite recursion:\n\n  ┌─────┐\n  │    countAllRunnables\n  │     ↓\n  │    countRunnables\n  └─────┘\n\nThese errors are very tricky, so read https://elm-lang.org/0.19.1/bad-recursion to learn how to fix it!';}
var $elm_explorations$test$Test$Runner$Labeled = F2(
	function (a, b) {
		return {$: 'Labeled', a: a, b: b};
	});
var $elm_explorations$test$Test$Runner$Runnable = function (a) {
	return {$: 'Runnable', a: a};
};
var $elm_explorations$test$Test$Runner$Thunk = function (a) {
	return {$: 'Thunk', a: a};
};
var $elm_explorations$test$Test$Runner$emptyDistribution = function (seed) {
	return {all: _List_Nil, only: _List_Nil, seed: seed, skipped: _List_Nil};
};
var $elm$core$Bitwise$xor = _Bitwise_xor;
var $elm_explorations$test$Test$Runner$fnvHash = F2(
	function (a, b) {
		return ((a ^ b) * 16777619) >>> 0;
	});
var $elm_explorations$test$Test$Runner$fnvHashString = F2(
	function (hash, str) {
		return A3(
			$elm$core$List$foldl,
			$elm_explorations$test$Test$Runner$fnvHash,
			hash,
			A2(
				$elm$core$List$map,
				$elm$core$Char$toCode,
				$elm$core$String$toList(str)));
	});
var $elm_explorations$test$Test$Runner$fnvInit = 2166136261;
var $elm$random$Random$Generator = function (a) {
	return {$: 'Generator', a: a};
};
var $elm$random$Random$Seed = F2(
	function (a, b) {
		return {$: 'Seed', a: a, b: b};
	});
var $elm$random$Random$next = function (_v0) {
	var state0 = _v0.a;
	var incr = _v0.b;
	return A2($elm$random$Random$Seed, ((state0 * 1664525) + incr) >>> 0, incr);
};
var $elm$random$Random$peel = function (_v0) {
	var state = _v0.a;
	var word = (state ^ (state >>> ((state >>> 28) + 4))) * 277803737;
	return ((word >>> 22) ^ word) >>> 0;
};
var $elm$random$Random$int = F2(
	function (a, b) {
		return $elm$random$Random$Generator(
			function (seed0) {
				var _v0 = (_Utils_cmp(a, b) < 0) ? _Utils_Tuple2(a, b) : _Utils_Tuple2(b, a);
				var lo = _v0.a;
				var hi = _v0.b;
				var range = (hi - lo) + 1;
				if (!((range - 1) & range)) {
					return _Utils_Tuple2(
						(((range - 1) & $elm$random$Random$peel(seed0)) >>> 0) + lo,
						$elm$random$Random$next(seed0));
				} else {
					var threshhold = (((-range) >>> 0) % range) >>> 0;
					var accountForBias = function (seed) {
						accountForBias:
						while (true) {
							var x = $elm$random$Random$peel(seed);
							var seedN = $elm$random$Random$next(seed);
							if (_Utils_cmp(x, threshhold) < 0) {
								var $temp$seed = seedN;
								seed = $temp$seed;
								continue accountForBias;
							} else {
								return _Utils_Tuple2((x % range) + lo, seedN);
							}
						}
					};
					return accountForBias(seed0);
				}
			});
	});
var $elm$random$Random$map3 = F4(
	function (func, _v0, _v1, _v2) {
		var genA = _v0.a;
		var genB = _v1.a;
		var genC = _v2.a;
		return $elm$random$Random$Generator(
			function (seed0) {
				var _v3 = genA(seed0);
				var a = _v3.a;
				var seed1 = _v3.b;
				var _v4 = genB(seed1);
				var b = _v4.a;
				var seed2 = _v4.b;
				var _v5 = genC(seed2);
				var c = _v5.a;
				var seed3 = _v5.b;
				return _Utils_Tuple2(
					A3(func, a, b, c),
					seed3);
			});
	});
var $elm$core$Bitwise$or = _Bitwise_or;
var $elm$random$Random$step = F2(
	function (_v0, seed) {
		var generator = _v0.a;
		return generator(seed);
	});
var $elm$random$Random$independentSeed = $elm$random$Random$Generator(
	function (seed0) {
		var makeIndependentSeed = F3(
			function (state, b, c) {
				return $elm$random$Random$next(
					A2($elm$random$Random$Seed, state, (1 | (b ^ c)) >>> 0));
			});
		var gen = A2($elm$random$Random$int, 0, 4294967295);
		return A2(
			$elm$random$Random$step,
			A4($elm$random$Random$map3, makeIndependentSeed, gen, gen, gen),
			seed0);
	});
var $elm$random$Random$initialSeed = function (x) {
	var _v0 = $elm$random$Random$next(
		A2($elm$random$Random$Seed, 0, 1013904223));
	var state1 = _v0.a;
	var incr = _v0.b;
	var state2 = (state1 + x) >>> 0;
	return $elm$random$Random$next(
		A2($elm$random$Random$Seed, state2, incr));
};
var $elm$random$Random$maxInt = 2147483647;
var $elm_explorations$test$Test$Runner$batchDistribute = F4(
	function (hashed, runs, test, prev) {
		var next = A4($elm_explorations$test$Test$Runner$distributeSeedsHelp, hashed, runs, prev.seed, test);
		return {
			all: _Utils_ap(prev.all, next.all),
			only: _Utils_ap(prev.only, next.only),
			seed: next.seed,
			skipped: _Utils_ap(prev.skipped, next.skipped)
		};
	});
var $elm_explorations$test$Test$Runner$distributeSeedsHelp = F4(
	function (hashed, runs, seed, test) {
		switch (test.$) {
			case 'UnitTest':
				var aRun = test.a;
				return {
					all: _List_fromArray(
						[
							$elm_explorations$test$Test$Runner$Runnable(
							$elm_explorations$test$Test$Runner$Thunk(
								function (_v1) {
									return aRun(_Utils_Tuple0);
								}))
						]),
					only: _List_Nil,
					seed: seed,
					skipped: _List_Nil
				};
			case 'FuzzTest':
				var aRun = test.a;
				var _v2 = A2($elm$random$Random$step, $elm$random$Random$independentSeed, seed);
				var firstSeed = _v2.a;
				var nextSeed = _v2.b;
				return {
					all: _List_fromArray(
						[
							$elm_explorations$test$Test$Runner$Runnable(
							$elm_explorations$test$Test$Runner$Thunk(
								function (_v3) {
									return A2(aRun, firstSeed, runs);
								}))
						]),
					only: _List_Nil,
					seed: nextSeed,
					skipped: _List_Nil
				};
			case 'Labeled':
				var description = test.a;
				var subTest = test.b;
				if (hashed) {
					var next = A4($elm_explorations$test$Test$Runner$distributeSeedsHelp, true, runs, seed, subTest);
					return {
						all: A2(
							$elm$core$List$map,
							$elm_explorations$test$Test$Runner$Labeled(description),
							next.all),
						only: A2(
							$elm$core$List$map,
							$elm_explorations$test$Test$Runner$Labeled(description),
							next.only),
						seed: next.seed,
						skipped: A2(
							$elm$core$List$map,
							$elm_explorations$test$Test$Runner$Labeled(description),
							next.skipped)
					};
				} else {
					var intFromSeed = A2(
						$elm$random$Random$step,
						A2($elm$random$Random$int, 0, $elm$random$Random$maxInt),
						seed).a;
					var hashedSeed = $elm$random$Random$initialSeed(
						A2(
							$elm_explorations$test$Test$Runner$fnvHash,
							intFromSeed,
							A2($elm_explorations$test$Test$Runner$fnvHashString, $elm_explorations$test$Test$Runner$fnvInit, description)));
					var next = A4($elm_explorations$test$Test$Runner$distributeSeedsHelp, true, runs, hashedSeed, subTest);
					return {
						all: A2(
							$elm$core$List$map,
							$elm_explorations$test$Test$Runner$Labeled(description),
							next.all),
						only: A2(
							$elm$core$List$map,
							$elm_explorations$test$Test$Runner$Labeled(description),
							next.only),
						seed: seed,
						skipped: A2(
							$elm$core$List$map,
							$elm_explorations$test$Test$Runner$Labeled(description),
							next.skipped)
					};
				}
			case 'Skipped':
				var subTest = test.a;
				var next = A4($elm_explorations$test$Test$Runner$distributeSeedsHelp, hashed, runs, seed, subTest);
				return {all: _List_Nil, only: _List_Nil, seed: next.seed, skipped: next.all};
			case 'Only':
				var subTest = test.a;
				var next = A4($elm_explorations$test$Test$Runner$distributeSeedsHelp, hashed, runs, seed, subTest);
				return _Utils_update(
					next,
					{only: next.all});
			default:
				var tests = test.a;
				return A3(
					$elm$core$List$foldl,
					A2($elm_explorations$test$Test$Runner$batchDistribute, hashed, runs),
					$elm_explorations$test$Test$Runner$emptyDistribution(seed),
					tests);
		}
	});
var $elm_explorations$test$Test$Runner$distributeSeeds = $elm_explorations$test$Test$Runner$distributeSeedsHelp(false);
var $elm_explorations$test$Test$Runner$runThunk = _Test_runThunk;
var $elm_explorations$test$Test$Runner$run = function (_v0) {
	var fn = _v0.a;
	var _v1 = $elm_explorations$test$Test$Runner$runThunk(fn);
	if (_v1.$ === 'Ok') {
		var tests = _v1.a;
		return tests;
	} else {
		var message = _v1.a;
		return _List_fromArray(
			[
				$elm_explorations$test$Expect$fail('This test failed because it threw an exception: \"' + (message + '\"'))
			]);
	}
};
var $elm_explorations$test$Test$Runner$fromRunnableTreeHelp = F2(
	function (labels, runner) {
		fromRunnableTreeHelp:
		while (true) {
			switch (runner.$) {
				case 'Runnable':
					var runnable = runner.a;
					return _List_fromArray(
						[
							{
							labels: labels,
							run: function (_v1) {
								return $elm_explorations$test$Test$Runner$run(runnable);
							}
						}
						]);
				case 'Labeled':
					var label = runner.a;
					var subRunner = runner.b;
					var $temp$labels = A2($elm$core$List$cons, label, labels),
						$temp$runner = subRunner;
					labels = $temp$labels;
					runner = $temp$runner;
					continue fromRunnableTreeHelp;
				default:
					var runners = runner.a;
					return A2(
						$elm$core$List$concatMap,
						$elm_explorations$test$Test$Runner$fromRunnableTreeHelp(labels),
						runners);
			}
		}
	});
var $elm_explorations$test$Test$Runner$fromRunnableTree = $elm_explorations$test$Test$Runner$fromRunnableTreeHelp(_List_Nil);
var $elm_explorations$test$Test$Runner$fromTest = F3(
	function (runs, seed, test) {
		if (runs < 1) {
			return $elm_explorations$test$Test$Runner$Invalid(
				'Test runner run count must be at least 1, not ' + $elm$core$String$fromInt(runs));
		} else {
			var distribution = A3($elm_explorations$test$Test$Runner$distributeSeeds, runs, seed, test);
			return $elm$core$List$isEmpty(distribution.only) ? ((!$elm_explorations$test$Test$Runner$countAllRunnables(distribution.skipped)) ? $elm_explorations$test$Test$Runner$Plain(
				A2($elm$core$List$concatMap, $elm_explorations$test$Test$Runner$fromRunnableTree, distribution.all)) : $elm_explorations$test$Test$Runner$Skipping(
				A2($elm$core$List$concatMap, $elm_explorations$test$Test$Runner$fromRunnableTree, distribution.all))) : $elm_explorations$test$Test$Runner$Only(
				A2($elm$core$List$concatMap, $elm_explorations$test$Test$Runner$fromRunnableTree, distribution.only));
		}
	});
var $elm$core$Dict$fromList = function (assocs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, dict) {
				var key = _v0.a;
				var value = _v0.b;
				return A3($elm$core$Dict$insert, key, value, dict);
			}),
		$elm$core$Dict$empty,
		assocs);
};
var $elm$core$Platform$Cmd$batch = _Platform_batch;
var $elm$core$Platform$Cmd$none = $elm$core$Platform$Cmd$batch(_List_Nil);
var $author$project$Test$Runner$Node$init = F2(
	function (_v0, _v1) {
		var processes = _v0.processes;
		var globs = _v0.globs;
		var paths = _v0.paths;
		var fuzzRuns = _v0.fuzzRuns;
		var initialSeed = _v0.initialSeed;
		var report = _v0.report;
		var runners = _v0.runners;
		var testReporter = $author$project$Test$Reporter$Reporter$createReporter(report);
		var _v2 = function () {
			switch (runners.$) {
				case 'Plain':
					var runnerList = runners.a;
					return {
						autoFail: $elm$core$Maybe$Nothing,
						indexedRunners: A2(
							$elm$core$List$indexedMap,
							F2(
								function (a, b) {
									return _Utils_Tuple2(a, b);
								}),
							runnerList)
					};
				case 'Only':
					var runnerList = runners.a;
					return {
						autoFail: $elm$core$Maybe$Just('Test.only was used'),
						indexedRunners: A2(
							$elm$core$List$indexedMap,
							F2(
								function (a, b) {
									return _Utils_Tuple2(a, b);
								}),
							runnerList)
					};
				case 'Skipping':
					var runnerList = runners.a;
					return {
						autoFail: $elm$core$Maybe$Just('Test.skip was used'),
						indexedRunners: A2(
							$elm$core$List$indexedMap,
							F2(
								function (a, b) {
									return _Utils_Tuple2(a, b);
								}),
							runnerList)
					};
				default:
					var str = runners.a;
					return {
						autoFail: $elm$core$Maybe$Just(str),
						indexedRunners: _List_Nil
					};
			}
		}();
		var indexedRunners = _v2.indexedRunners;
		var autoFail = _v2.autoFail;
		var testCount = $elm$core$List$length(indexedRunners);
		var model = {
			autoFail: autoFail,
			available: $elm$core$Dict$fromList(indexedRunners),
			nextTestToRun: 0,
			processes: processes,
			results: _List_Nil,
			runInfo: {fuzzRuns: fuzzRuns, globs: globs, initialSeed: initialSeed, paths: paths, testCount: testCount},
			testReporter: testReporter
		};
		return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
	});
var $author$project$Test$Runner$Node$noTestsFoundError = function (globs) {
	return $elm$core$List$isEmpty(globs) ? $elm$core$String$trim('\nNo exposed values of type Test found in the tests/ directory.\n\nAre there tests in any .elm file in the tests/ directory?\nIf not – add some!\nIf there are – are they exposed?\n        ') : A3(
		$elm$core$String$replace,
		'%globs',
		A2($elm$core$String$join, '\n', globs),
		$elm$core$String$trim('\nNo exposed values of type Test found in files matching:\n\n%globs\n\nAre the above patterns correct? Maybe try running elm-test with no arguments?\n\nAre there tests in any of the matched files?\nIf not – add some!\nIf there are – are they exposed?\n        '));
};
var $elm$core$Platform$Sub$batch = _Platform_batch;
var $elm$core$Platform$Sub$none = $elm$core$Platform$Sub$batch(_List_Nil);
var $author$project$Test$Runner$Node$Dispatch = function (a) {
	return {$: 'Dispatch', a: a};
};
var $elm$json$Json$Decode$decodeValue = _Json_run;
var $elm$json$Json$Decode$andThen = _Json_andThen;
var $author$project$Test$Runner$JsMessage$Summary = F3(
	function (a, b, c) {
		return {$: 'Summary', a: a, b: b, c: c};
	});
var $author$project$Test$Runner$JsMessage$Test = function (a) {
	return {$: 'Test', a: a};
};
var $elm$json$Json$Decode$fail = _Json_fail;
var $elm$json$Json$Decode$field = _Json_decodeField;
var $elm$json$Json$Decode$float = _Json_decodeFloat;
var $elm$json$Json$Decode$list = _Json_decodeList;
var $elm$json$Json$Decode$map = _Json_map1;
var $elm$json$Json$Decode$map3 = _Json_map3;
var $elm$json$Json$Decode$map2 = _Json_map2;
var $elm$json$Json$Decode$string = _Json_decodeString;
var $author$project$Test$Runner$JsMessage$todoDecoder = A3(
	$elm$json$Json$Decode$map2,
	F2(
		function (a, b) {
			return _Utils_Tuple2(a, b);
		}),
	A2(
		$elm$json$Json$Decode$field,
		'labels',
		$elm$json$Json$Decode$list($elm$json$Json$Decode$string)),
	A2($elm$json$Json$Decode$field, 'todo', $elm$json$Json$Decode$string));
var $author$project$Test$Runner$JsMessage$decodeMessageFromType = function (messageType) {
	switch (messageType) {
		case 'TEST':
			return A2(
				$elm$json$Json$Decode$map,
				$author$project$Test$Runner$JsMessage$Test,
				A2($elm$json$Json$Decode$field, 'index', $elm$json$Json$Decode$int));
		case 'SUMMARY':
			return A4(
				$elm$json$Json$Decode$map3,
				$author$project$Test$Runner$JsMessage$Summary,
				A2($elm$json$Json$Decode$field, 'duration', $elm$json$Json$Decode$float),
				A2($elm$json$Json$Decode$field, 'failures', $elm$json$Json$Decode$int),
				A2(
					$elm$json$Json$Decode$field,
					'todos',
					$elm$json$Json$Decode$list($author$project$Test$Runner$JsMessage$todoDecoder)));
		default:
			return $elm$json$Json$Decode$fail('Unrecognized message type: ' + messageType);
	}
};
var $author$project$Test$Runner$JsMessage$decoder = A2(
	$elm$json$Json$Decode$andThen,
	$author$project$Test$Runner$JsMessage$decodeMessageFromType,
	A2($elm$json$Json$Decode$field, 'type', $elm$json$Json$Decode$string));
var $author$project$Test$Runner$Node$Complete = F4(
	function (a, b, c, d) {
		return {$: 'Complete', a: a, b: b, c: c, d: d};
	});
var $elm$time$Time$Name = function (a) {
	return {$: 'Name', a: a};
};
var $elm$time$Time$Offset = function (a) {
	return {$: 'Offset', a: a};
};
var $elm$time$Time$Zone = F2(
	function (a, b) {
		return {$: 'Zone', a: a, b: b};
	});
var $elm$time$Time$customZone = $elm$time$Time$Zone;
var $elm$time$Time$Posix = function (a) {
	return {$: 'Posix', a: a};
};
var $elm$time$Time$millisToPosix = $elm$time$Time$Posix;
var $elm$time$Time$now = _Time_now($elm$time$Time$millisToPosix);
var $author$project$Test$Reporter$TestResults$Passed = {$: 'Passed'};
var $author$project$Test$Reporter$TestResults$Todo = function (a) {
	return {$: 'Todo', a: a};
};
var $elm_explorations$test$Test$Runner$getFailureReason = function (expectation) {
	if (expectation.$ === 'Pass') {
		return $elm$core$Maybe$Nothing;
	} else {
		var record = expectation.a;
		return $elm$core$Maybe$Just(record);
	}
};
var $elm_explorations$test$Test$Runner$Failure$TODO = {$: 'TODO'};
var $elm_explorations$test$Test$Runner$isTodo = function (expectation) {
	if (expectation.$ === 'Pass') {
		return false;
	} else {
		var reason = expectation.a.reason;
		return _Utils_eq(reason, $elm_explorations$test$Test$Runner$Failure$TODO);
	}
};
var $author$project$Test$Reporter$TestResults$outcomesFromExpectationsHelp = F2(
	function (expectation, builder) {
		var _v0 = $elm_explorations$test$Test$Runner$getFailureReason(expectation);
		if (_v0.$ === 'Just') {
			var failure = _v0.a;
			return $elm_explorations$test$Test$Runner$isTodo(expectation) ? _Utils_update(
				builder,
				{
					todos: A2($elm$core$List$cons, failure.description, builder.todos)
				}) : _Utils_update(
				builder,
				{
					failures: A2($elm$core$List$cons, failure, builder.failures)
				});
		} else {
			return _Utils_update(
				builder,
				{passes: builder.passes + 1});
		}
	});
var $elm$core$List$repeatHelp = F3(
	function (result, n, value) {
		repeatHelp:
		while (true) {
			if (n <= 0) {
				return result;
			} else {
				var $temp$result = A2($elm$core$List$cons, value, result),
					$temp$n = n - 1,
					$temp$value = value;
				result = $temp$result;
				n = $temp$n;
				value = $temp$value;
				continue repeatHelp;
			}
		}
	});
var $elm$core$List$repeat = F2(
	function (n, value) {
		return A3($elm$core$List$repeatHelp, _List_Nil, n, value);
	});
var $author$project$Test$Reporter$TestResults$outcomesFromExpectations = function (expectations) {
	if (expectations.b) {
		if (!expectations.b.b) {
			var expectation = expectations.a;
			var _v1 = $elm_explorations$test$Test$Runner$getFailureReason(expectation);
			if (_v1.$ === 'Nothing') {
				return _List_fromArray(
					[$author$project$Test$Reporter$TestResults$Passed]);
			} else {
				var failure = _v1.a;
				return $elm_explorations$test$Test$Runner$isTodo(expectation) ? _List_fromArray(
					[
						$author$project$Test$Reporter$TestResults$Todo(failure.description)
					]) : _List_fromArray(
					[
						$author$project$Test$Reporter$TestResults$Failed(
						_List_fromArray(
							[failure]))
					]);
			}
		} else {
			var builder = A3(
				$elm$core$List$foldl,
				$author$project$Test$Reporter$TestResults$outcomesFromExpectationsHelp,
				{failures: _List_Nil, passes: 0, todos: _List_Nil},
				expectations);
			var failuresList = function () {
				var _v2 = builder.failures;
				if (!_v2.b) {
					return _List_Nil;
				} else {
					var failures = _v2;
					return _List_fromArray(
						[
							$author$project$Test$Reporter$TestResults$Failed(failures)
						]);
				}
			}();
			return $elm$core$List$concat(
				_List_fromArray(
					[
						A2($elm$core$List$repeat, builder.passes, $author$project$Test$Reporter$TestResults$Passed),
						A2($elm$core$List$map, $author$project$Test$Reporter$TestResults$Todo, builder.todos),
						failuresList
					]));
		}
	} else {
		return _List_Nil;
	}
};
var $elm$core$Task$Perform = function (a) {
	return {$: 'Perform', a: a};
};
var $elm$core$Task$succeed = _Scheduler_succeed;
var $elm$core$Task$init = $elm$core$Task$succeed(_Utils_Tuple0);
var $elm$core$Task$andThen = _Scheduler_andThen;
var $elm$core$Task$map = F2(
	function (func, taskA) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return $elm$core$Task$succeed(
					func(a));
			},
			taskA);
	});
var $elm$core$Task$map2 = F3(
	function (func, taskA, taskB) {
		return A2(
			$elm$core$Task$andThen,
			function (a) {
				return A2(
					$elm$core$Task$andThen,
					function (b) {
						return $elm$core$Task$succeed(
							A2(func, a, b));
					},
					taskB);
			},
			taskA);
	});
var $elm$core$Task$sequence = function (tasks) {
	return A3(
		$elm$core$List$foldr,
		$elm$core$Task$map2($elm$core$List$cons),
		$elm$core$Task$succeed(_List_Nil),
		tasks);
};
var $elm$core$Platform$sendToApp = _Platform_sendToApp;
var $elm$core$Task$spawnCmd = F2(
	function (router, _v0) {
		var task = _v0.a;
		return _Scheduler_spawn(
			A2(
				$elm$core$Task$andThen,
				$elm$core$Platform$sendToApp(router),
				task));
	});
var $elm$core$Task$onEffects = F3(
	function (router, commands, state) {
		return A2(
			$elm$core$Task$map,
			function (_v0) {
				return _Utils_Tuple0;
			},
			$elm$core$Task$sequence(
				A2(
					$elm$core$List$map,
					$elm$core$Task$spawnCmd(router),
					commands)));
	});
var $elm$core$Task$onSelfMsg = F3(
	function (_v0, _v1, _v2) {
		return $elm$core$Task$succeed(_Utils_Tuple0);
	});
var $elm$core$Task$cmdMap = F2(
	function (tagger, _v0) {
		var task = _v0.a;
		return $elm$core$Task$Perform(
			A2($elm$core$Task$map, tagger, task));
	});
_Platform_effectManagers['Task'] = _Platform_createManager($elm$core$Task$init, $elm$core$Task$onEffects, $elm$core$Task$onSelfMsg, $elm$core$Task$cmdMap);
var $elm$core$Task$command = _Platform_leaf('Task');
var $elm$core$Task$perform = F2(
	function (toMessage, task) {
		return $elm$core$Task$command(
			$elm$core$Task$Perform(
				A2($elm$core$Task$map, toMessage, task)));
	});
var $author$project$Test$Runner$Node$sendResults = F3(
	function (isFinished, testReporter, results) {
		var typeStr = isFinished ? 'FINISHED' : 'RESULTS';
		var addToKeyValues = F2(
			function (_v0, list) {
				var testId = _v0.a;
				var result = _v0.b;
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(
						$elm$core$String$fromInt(testId),
						testReporter.reportComplete(result)),
					list);
			});
		return $author$project$Test$Runner$Node$elmTestPort__send(
			A2(
				$elm$json$Json$Encode$encode,
				0,
				$elm$json$Json$Encode$object(
					_List_fromArray(
						[
							_Utils_Tuple2(
							'type',
							$elm$json$Json$Encode$string(typeStr)),
							_Utils_Tuple2(
							'results',
							$elm$json$Json$Encode$object(
								A3($elm$core$List$foldl, addToKeyValues, _List_Nil, results)))
						]))));
	});
var $author$project$Test$Runner$Node$dispatch = F2(
	function (model, startTime) {
		var _v0 = A2($elm$core$Dict$get, model.nextTestToRun, model.available);
		if (_v0.$ === 'Nothing') {
			return A3($author$project$Test$Runner$Node$sendResults, true, model.testReporter, model.results);
		} else {
			var config = _v0.a;
			var outcomes = $author$project$Test$Reporter$TestResults$outcomesFromExpectations(
				config.run(_Utils_Tuple0));
			return A2(
				$elm$core$Task$perform,
				A3($author$project$Test$Runner$Node$Complete, config.labels, outcomes, startTime),
				$elm$time$Time$now);
		}
	});
var $author$project$Test$Reporter$TestResults$isFailure = function (outcome) {
	if (outcome.$ === 'Failed') {
		return true;
	} else {
		return false;
	}
};
var $elm$time$Time$posixToMillis = function (_v0) {
	var millis = _v0.a;
	return millis;
};
var $author$project$Test$Runner$Node$sendBegin = function (model) {
	var extraFields = function () {
		var _v0 = model.testReporter.reportBegin(model.runInfo);
		if (_v0.$ === 'Just') {
			var report = _v0.a;
			return _List_fromArray(
				[
					_Utils_Tuple2('message', report)
				]);
		} else {
			return _List_Nil;
		}
	}();
	var baseFields = _List_fromArray(
		[
			_Utils_Tuple2(
			'type',
			$elm$json$Json$Encode$string('BEGIN')),
			_Utils_Tuple2(
			'testCount',
			$elm$json$Json$Encode$int(model.runInfo.testCount))
		]);
	return $author$project$Test$Runner$Node$elmTestPort__send(
		A2(
			$elm$json$Json$Encode$encode,
			0,
			$elm$json$Json$Encode$object(
				_Utils_ap(baseFields, extraFields))));
};
var $author$project$Test$Runner$Node$update = F2(
	function (msg, model) {
		var testReporter = model.testReporter;
		switch (msg.$) {
			case 'Receive':
				var val = msg.a;
				var _v1 = A2($elm$json$Json$Decode$decodeValue, $author$project$Test$Runner$JsMessage$decoder, val);
				if (_v1.$ === 'Ok') {
					if (_v1.a.$ === 'Summary') {
						var _v2 = _v1.a;
						var duration = _v2.a;
						var failed = _v2.b;
						var todos = _v2.c;
						var testCount = model.runInfo.testCount;
						var summaryInfo = {
							duration: duration,
							failed: failed,
							passed: (testCount - failed) - $elm$core$List$length(todos),
							testCount: testCount,
							todos: todos
						};
						var summary = A2(testReporter.reportSummary, summaryInfo, model.autoFail);
						var exitCode = (failed > 0) ? 2 : ((_Utils_eq(model.autoFail, $elm$core$Maybe$Nothing) && $elm$core$List$isEmpty(todos)) ? 0 : 3);
						var cmd = $author$project$Test$Runner$Node$elmTestPort__send(
							A2(
								$elm$json$Json$Encode$encode,
								0,
								$elm$json$Json$Encode$object(
									_List_fromArray(
										[
											_Utils_Tuple2(
											'type',
											$elm$json$Json$Encode$string('SUMMARY')),
											_Utils_Tuple2(
											'exitCode',
											$elm$json$Json$Encode$int(exitCode)),
											_Utils_Tuple2('message', summary)
										]))));
						return _Utils_Tuple2(model, cmd);
					} else {
						var index = _v1.a.a;
						var cmd = A2($elm$core$Task$perform, $author$project$Test$Runner$Node$Dispatch, $elm$time$Time$now);
						return _Utils_eq(index, -1) ? _Utils_Tuple2(
							_Utils_update(
								model,
								{nextTestToRun: index + model.processes}),
							$elm$core$Platform$Cmd$batch(
								_List_fromArray(
									[
										cmd,
										$author$project$Test$Runner$Node$sendBegin(model)
									]))) : _Utils_Tuple2(
							_Utils_update(
								model,
								{nextTestToRun: index}),
							cmd);
					}
				} else {
					var err = _v1.a;
					var cmd = $author$project$Test$Runner$Node$elmTestPort__send(
						A2(
							$elm$json$Json$Encode$encode,
							0,
							$elm$json$Json$Encode$object(
								_List_fromArray(
									[
										_Utils_Tuple2(
										'type',
										$elm$json$Json$Encode$string('ERROR')),
										_Utils_Tuple2(
										'message',
										$elm$json$Json$Encode$string(
											$elm$json$Json$Decode$errorToString(err)))
									]))));
					return _Utils_Tuple2(model, cmd);
				}
			case 'Dispatch':
				var startTime = msg.a;
				return _Utils_Tuple2(
					model,
					A2($author$project$Test$Runner$Node$dispatch, model, startTime));
			default:
				var labels = msg.a;
				var outcomes = msg.b;
				var startTime = msg.c;
				var endTime = msg.d;
				var nextTestToRun = model.nextTestToRun + model.processes;
				var isFinished = _Utils_cmp(nextTestToRun, model.runInfo.testCount) > -1;
				var duration = $elm$time$Time$posixToMillis(endTime) - $elm$time$Time$posixToMillis(startTime);
				var prependOutcome = F2(
					function (outcome, rest) {
						return A2(
							$elm$core$List$cons,
							_Utils_Tuple2(
								model.nextTestToRun,
								{duration: duration, labels: labels, outcome: outcome}),
							rest);
					});
				var results = A3($elm$core$List$foldl, prependOutcome, model.results, outcomes);
				if (isFinished || A2($elm$core$List$any, $author$project$Test$Reporter$TestResults$isFailure, outcomes)) {
					var cmd = A3($author$project$Test$Runner$Node$sendResults, isFinished, testReporter, results);
					return isFinished ? _Utils_Tuple2(model, cmd) : _Utils_Tuple2(
						_Utils_update(
							model,
							{nextTestToRun: nextTestToRun, results: _List_Nil}),
						$elm$core$Platform$Cmd$batch(
							_List_fromArray(
								[
									cmd,
									A2($elm$core$Task$perform, $author$project$Test$Runner$Node$Dispatch, $elm$time$Time$now)
								])));
				} else {
					return _Utils_Tuple2(
						_Utils_update(
							model,
							{nextTestToRun: nextTestToRun, results: results}),
						A2($elm$core$Task$perform, $author$project$Test$Runner$Node$Dispatch, $elm$time$Time$now));
				}
		}
	});
var $elm$core$Platform$worker = _Platform_worker;
var $author$project$Test$Runner$Node$run = F2(
	function (_v0, possiblyTests) {
		var runs = _v0.runs;
		var seed = _v0.seed;
		var report = _v0.report;
		var globs = _v0.globs;
		var paths = _v0.paths;
		var processes = _v0.processes;
		var tests = A2(
			$elm$core$List$filterMap,
			function (_v4) {
				var moduleName = _v4.a;
				var maybeModuleTests = _v4.b;
				var moduleTests = A2($elm$core$List$filterMap, $elm$core$Basics$identity, maybeModuleTests);
				return $elm$core$List$isEmpty(moduleTests) ? $elm$core$Maybe$Nothing : $elm$core$Maybe$Just(
					A2($elm_explorations$test$Test$describe, moduleName, moduleTests));
			},
			possiblyTests);
		if ($elm$core$List$isEmpty(tests)) {
			return $elm$core$Platform$worker(
				{
					init: A2(
						$author$project$Test$Runner$Node$failInit,
						$author$project$Test$Runner$Node$noTestsFoundError(globs),
						report),
					subscriptions: function (_v1) {
						return $elm$core$Platform$Sub$none;
					},
					update: F2(
						function (_v2, model) {
							return _Utils_Tuple2(model, $elm$core$Platform$Cmd$none);
						})
				});
		} else {
			var runners = A3(
				$elm_explorations$test$Test$Runner$fromTest,
				runs,
				$elm$random$Random$initialSeed(seed),
				$elm_explorations$test$Test$concat(tests));
			var wrappedInit = $author$project$Test$Runner$Node$init(
				{fuzzRuns: runs, globs: globs, initialSeed: seed, paths: paths, processes: processes, report: report, runners: runners});
			return $elm$core$Platform$worker(
				{
					init: wrappedInit,
					subscriptions: function (_v3) {
						return $author$project$Test$Runner$Node$elmTestPort__receive($author$project$Test$Runner$Node$Receive);
					},
					update: $author$project$Test$Runner$Node$update
				});
		}
	});
var $author$project$Code$Project$ownerToString = function (_v0) {
	var o = _v0.a;
	return o;
};
var $author$project$Code$Project$slug = function (project) {
	return A2(
		$author$project$Code$FullyQualifiedName$cons,
		$author$project$Code$Project$ownerToString(project.owner),
		project.name);
};
var $author$project$Code$ProjectTests$slug = A2(
	$elm_explorations$test$Test$describe,
	'Project.slug',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Returns the slug of a project by owner and name',
			function (_v0) {
				return A2(
					$elm_explorations$test$Expect$equal,
					'unison.http',
					$author$project$Code$FullyQualifiedName$toString(
						$author$project$Code$Project$slug($author$project$Code$ProjectTests$project)));
			})
		]));
var $author$project$Code$FullyQualifiedName$snoc = F2(
	function (_v0, s) {
		var segments_ = _v0.a;
		return $author$project$Code$FullyQualifiedName$FQN(
			A2(
				$mgold$elm_nonempty_list$List$Nonempty$append,
				segments_,
				$mgold$elm_nonempty_list$List$Nonempty$fromElement(s)));
	});
var $author$project$Code$FullyQualifiedNameTests$snoc = A2(
	$elm_explorations$test$Test$describe,
	'FullyQualifiedName.snoc',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'snoc a String to the end of the FQN segments',
			function (_v0) {
				var list = $author$project$Code$FullyQualifiedName$fromString('List');
				return A2(
					$elm_explorations$test$Expect$equal,
					_List_fromArray(
						['List', 'map']),
					$author$project$Code$FullyQualifiedNameTests$segments(
						A2($author$project$Code$FullyQualifiedName$snoc, list, 'map')));
			})
		]));
var $elm$regex$Regex$Match = F4(
	function (match, index, number, submatches) {
		return {index: index, match: match, number: number, submatches: submatches};
	});
var $elm$regex$Regex$fromStringWith = _Regex_fromStringWith;
var $elm$regex$Regex$fromString = function (string) {
	return A2(
		$elm$regex$Regex$fromStringWith,
		{caseInsensitive: false, multiline: false},
		string);
};
var $elm$regex$Regex$never = _Regex_never;
var $elm$regex$Regex$replace = _Regex_replaceAtMost(_Regex_infinity);
var $author$project$Code$Hash$stripHashPrefix = function (s) {
	var re = A2(
		$elm$core$Maybe$withDefault,
		$elm$regex$Regex$never,
		$elm$regex$Regex$fromString('^(#+)'));
	return A3(
		$elm$regex$Regex$replace,
		re,
		function (_v0) {
			return '';
		},
		s);
};
var $author$project$Code$HashTests$stripHashPrefix = A2(
	$elm_explorations$test$Test$describe,
	'Hash.stripHashPrefix',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'removes the prefix of the hash',
			function (_v0) {
				var result = $author$project$Code$Hash$stripHashPrefix('#abc123def456');
				return A2($elm_explorations$test$Expect$equal, 'abc123def456', result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'removes both hash prefixes for builtins',
			function (_v1) {
				var result = $author$project$Code$Hash$stripHashPrefix('##IO.socketSend.impl');
				return A2($elm_explorations$test$Expect$equal, 'IO.socketSend.impl', result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'ignores non hashes',
			function (_v2) {
				var result = $author$project$Code$Hash$stripHashPrefix('thisis#not##ahash');
				return A2($elm_explorations$test$Expect$equal, 'thisis#not##ahash', result);
			})
		]));
var $author$project$Code$Hash$isAssumedBuiltin = function (hash_) {
	return A2(
		$elm$core$String$startsWith,
		'##',
		$author$project$Code$Hash$toString(hash_));
};
var $elm$core$String$left = F2(
	function (n, string) {
		return (n < 1) ? '' : A3($elm$core$String$slice, 0, n, string);
	});
var $author$project$Code$Hash$toShortString = function (h) {
	var shorten = function (s) {
		return $author$project$Code$Hash$isAssumedBuiltin(h) ? s : A2($elm$core$String$left, 9, s);
	};
	return shorten(
		$author$project$Code$Hash$toString(h));
};
var $author$project$Code$HashTests$toShortString = A2(
	$elm_explorations$test$Test$describe,
	'Hash.toShortString',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Returns a short version of the hash',
			function (_v0) {
				var result = A2(
					$elm$core$Maybe$withDefault,
					'fail',
					A2(
						$elm$core$Maybe$map,
						$author$project$Code$Hash$toShortString,
						$author$project$Code$Hash$fromString('#abc123def456')));
				return A2($elm_explorations$test$Expect$equal, '#abc123de', result);
			}),
			A2(
			$elm_explorations$test$Test$test,
			'doesn\'t shorten for builtins',
			function (_v1) {
				var result = A2(
					$elm$core$Maybe$withDefault,
					'fail',
					A2(
						$elm$core$Maybe$map,
						$author$project$Code$Hash$toShortString,
						$author$project$Code$Hash$fromString('##IO.socketSend.impl')));
				return A2($elm_explorations$test$Expect$equal, '##IO.socketSend.impl', result);
			})
		]));
var $author$project$Code$Definition$Doc$Span = function (a) {
	return {$: 'Span', a: a};
};
var $author$project$Code$Definition$Doc$toString = F2(
	function (sep, doc) {
		toString:
		while (true) {
			var listToString = A2(
				$elm$core$Basics$composeR,
				$elm$core$List$map(
					$author$project$Code$Definition$Doc$toString(sep)),
				A2(
					$elm$core$Basics$composeR,
					$elm$core$List$filter(
						A2($elm$core$Basics$composeR, $elm$core$String$isEmpty, $elm$core$Basics$not)),
					$elm$core$String$join(sep)));
			switch (doc.$) {
				case 'Span':
					var ds = doc.a;
					return listToString(ds);
				case 'Group':
					var d = doc.a;
					var $temp$sep = sep,
						$temp$doc = d;
					sep = $temp$sep;
					doc = $temp$doc;
					continue toString;
				case 'Join':
					var ds = doc.a;
					return listToString(ds);
				case 'Bold':
					var d = doc.a;
					var $temp$sep = sep,
						$temp$doc = d;
					sep = $temp$sep;
					doc = $temp$doc;
					continue toString;
				case 'Italic':
					var d = doc.a;
					var $temp$sep = sep,
						$temp$doc = d;
					sep = $temp$sep;
					doc = $temp$doc;
					continue toString;
				case 'Strikethrough':
					var d = doc.a;
					var $temp$sep = sep,
						$temp$doc = d;
					sep = $temp$sep;
					doc = $temp$doc;
					continue toString;
				case 'Blockquote':
					var d = doc.a;
					var $temp$sep = sep,
						$temp$doc = d;
					sep = $temp$sep;
					doc = $temp$doc;
					continue toString;
				case 'Section':
					var d = doc.a;
					var ds = doc.b;
					return _Utils_ap(
						A2($author$project$Code$Definition$Doc$toString, sep, d),
						_Utils_ap(
							sep,
							listToString(ds)));
				case 'UntitledSection':
					var ds = doc.a;
					return listToString(ds);
				case 'Column':
					var ds = doc.a;
					return listToString(ds);
				case 'Word':
					var w = doc.a;
					return w;
				default:
					return '';
			}
		}
	});
var $author$project$Code$Definition$DocTests$toString = A2(
	$elm_explorations$test$Test$describe,
	'Doc.toString',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'merges docs down to a string with a separator',
			function (_v0) {
				var expected = 'Hello World After non word';
				var before = $author$project$Code$Definition$Doc$Span(
					_List_fromArray(
						[
							$author$project$Code$Definition$Doc$Word('Hello'),
							$author$project$Code$Definition$Doc$Word('World'),
							$author$project$Code$Definition$Doc$Blankline,
							$author$project$Code$Definition$Doc$Word('After'),
							$author$project$Code$Definition$Doc$Word('non'),
							$author$project$Code$Definition$Doc$Word('word')
						]));
				return A2(
					$elm_explorations$test$Expect$equal,
					expected,
					A2($author$project$Code$Definition$Doc$toString, ' ', before));
			})
		]));
var $author$project$Code$FullyQualifiedNameTests$toString = A2(
	$elm_explorations$test$Test$describe,
	'FullyQualifiedName.toString with segments separate by .',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'serializes the FQN',
			function (_v0) {
				return A2(
					$elm_explorations$test$Expect$equal,
					'foo.bar',
					$author$project$Code$FullyQualifiedName$toString(
						$author$project$Code$FullyQualifiedName$fromString('foo.bar')));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'it supports . as term names (compose)',
			function (_v1) {
				return A2(
					$elm_explorations$test$Expect$equal,
					'foo.bar..',
					$author$project$Code$FullyQualifiedName$toString(
						$author$project$Code$FullyQualifiedName$fromString('foo.bar..')));
			})
		]));
var $author$project$Lib$TreePathTests$toString = A2(
	$elm_explorations$test$Test$describe,
	'TreePath.toString',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Returns a string version of a TreePath',
			function (_v0) {
				var path = _List_fromArray(
					[
						$author$project$Lib$TreePath$VariantIndex(0),
						$author$project$Lib$TreePath$ListIndex(1),
						$author$project$Lib$TreePath$VariantIndex(4)
					]);
				return A2(
					$elm_explorations$test$Expect$equal,
					'VariantIndex#0.ListIndex#1.VariantIndex#4',
					$author$project$Lib$TreePath$toString(path));
			})
		]));
var $mgold$elm_nonempty_list$List$Nonempty$map = F2(
	function (f, _v0) {
		var x = _v0.a;
		var xs = _v0.b;
		return A2(
			$mgold$elm_nonempty_list$List$Nonempty$Nonempty,
			f(x),
			A2($elm$core$List$map, f, xs));
	});
var $elm$url$Url$percentEncode = _Url_percentEncode;
var $author$project$Code$FullyQualifiedName$urlEncodeSegmentDot = function (s) {
	return (s === '.') ? ';.' : s;
};
var $author$project$Code$FullyQualifiedName$toUrlSegments = function (fqn) {
	return A2(
		$mgold$elm_nonempty_list$List$Nonempty$map,
		A2($elm$core$Basics$composeR, $elm$url$Url$percentEncode, $author$project$Code$FullyQualifiedName$urlEncodeSegmentDot),
		$author$project$Code$FullyQualifiedName$segments(fqn));
};
var $author$project$Code$FullyQualifiedName$toUrlString = function (fqn) {
	return A2(
		$elm$core$String$join,
		'/',
		$mgold$elm_nonempty_list$List$Nonempty$toList(
			$author$project$Code$FullyQualifiedName$toUrlSegments(fqn)));
};
var $author$project$Code$FullyQualifiedNameTests$toUrlString = A2(
	$elm_explorations$test$Test$describe,
	'FullyQualifiedName.toUrlString',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'serializes the FQN with segments separate by /',
			function (_v0) {
				return A2(
					$elm_explorations$test$Expect$equal,
					'foo/bar',
					$author$project$Code$FullyQualifiedName$toUrlString(
						$author$project$Code$FullyQualifiedName$fromString('foo.bar')));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'URL encodes / (divide) segments',
			function (_v1) {
				return A2(
					$elm_explorations$test$Expect$equal,
					'foo/bar/%2F/doc',
					$author$project$Code$FullyQualifiedName$toUrlString(
						$author$project$Code$FullyQualifiedName$fromString('foo.bar./.doc')));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'URL encodes % segments',
			function (_v2) {
				return A2(
					$elm_explorations$test$Expect$equal,
					'foo/bar/%25/doc',
					$author$project$Code$FullyQualifiedName$toUrlString(
						$author$project$Code$FullyQualifiedName$fromString('foo.bar.%.doc')));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'URL encodes . segments with a ; prefix',
			function (_v3) {
				return A2(
					$elm_explorations$test$Expect$equal,
					'foo/bar/;./doc',
					$author$project$Code$FullyQualifiedName$toUrlString(
						$author$project$Code$FullyQualifiedName$fromString('foo.bar...doc')));
			})
		]));
var $author$project$Code$Hash$toUrlString = function (hash) {
	return A3(
		$elm$core$String$replace,
		$author$project$Code$Hash$prefix,
		$author$project$Code$Hash$urlPrefix,
		$author$project$Code$Hash$toString(hash));
};
var $author$project$Code$HashTests$toUrlString = A2(
	$elm_explorations$test$Test$describe,
	'Hash.toUrlString',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Extracts the raw hash value in a URL format',
			function (_v0) {
				var result = A2(
					$elm$core$Maybe$withDefault,
					'fail',
					A2(
						$elm$core$Maybe$map,
						$author$project$Code$Hash$toUrlString,
						$author$project$Code$Hash$fromString('#foo')));
				return A2($elm_explorations$test$Expect$equal, '@foo', result);
			})
		]));
var $author$project$Code$Definition$DocTests$toggleFold = A2(
	$elm_explorations$test$Test$describe,
	'Doc.toggleFold',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Adds a toggle if not present',
			function (_v0) {
				var toggles = A2($author$project$Code$Definition$Doc$toggleFold, $author$project$Code$Definition$Doc$emptyDocFoldToggles, $author$project$Code$Definition$DocTests$id);
				return A2(
					$elm_explorations$test$Expect$true,
					'doc was added',
					A2($author$project$Code$Definition$Doc$isDocFoldToggled, toggles, $author$project$Code$Definition$DocTests$id));
			}),
			A2(
			$elm_explorations$test$Test$test,
			'Removes a toggle if present',
			function (_v1) {
				var toggles = A2($author$project$Code$Definition$Doc$toggleFold, $author$project$Code$Definition$Doc$emptyDocFoldToggles, $author$project$Code$Definition$DocTests$id);
				var without = A2($author$project$Code$Definition$Doc$toggleFold, toggles, $author$project$Code$Definition$DocTests$id);
				return A2(
					$elm_explorations$test$Expect$false,
					'doc was removed',
					A2($author$project$Code$Definition$Doc$isDocFoldToggled, without, $author$project$Code$Definition$DocTests$id));
			})
		]));
var $mgold$elm_nonempty_list$List$Nonempty$last = function (_v0) {
	last:
	while (true) {
		var x = _v0.a;
		var xs = _v0.b;
		if (!xs.b) {
			return x;
		} else {
			if (!xs.b.b) {
				var y = xs.a;
				return y;
			} else {
				var rest = xs.b;
				var $temp$_v0 = A2($mgold$elm_nonempty_list$List$Nonempty$Nonempty, x, rest);
				_v0 = $temp$_v0;
				continue last;
			}
		}
	}
};
var $author$project$Code$FullyQualifiedName$unqualifiedName = function (_v0) {
	var nameParts = _v0.a;
	return $mgold$elm_nonempty_list$List$Nonempty$last(nameParts);
};
var $author$project$Code$FullyQualifiedNameTests$unqualifiedName = A2(
	$elm_explorations$test$Test$describe,
	'FullyQualifiedName.unqualifiedName',
	_List_fromArray(
		[
			A2(
			$elm_explorations$test$Test$test,
			'Extracts the last portion of a FQN',
			function (_v0) {
				return A2(
					$elm_explorations$test$Expect$equal,
					'List',
					$author$project$Code$FullyQualifiedName$unqualifiedName(
						$author$project$Code$FullyQualifiedName$fromString('base.List')));
			})
		]));
var $author$project$Test$Generated$Main$main = A2(
	$author$project$Test$Runner$Node$run,
	{
		globs: _List_Nil,
		paths: _List_fromArray(
			['/Users/hojberg/code/unison/ui-core/tests/Code/CodebaseTree/NamespaceListingTests.elm', '/Users/hojberg/code/unison/ui-core/tests/Code/Definition/DocTests.elm', '/Users/hojberg/code/unison/ui-core/tests/Code/Finder/SearchOptionsTests.elm', '/Users/hojberg/code/unison/ui-core/tests/Code/FullyQualifiedNameTests.elm', '/Users/hojberg/code/unison/ui-core/tests/Code/HashQualifiedTests.elm', '/Users/hojberg/code/unison/ui-core/tests/Code/HashTests.elm', '/Users/hojberg/code/unison/ui-core/tests/Code/ProjectTests.elm', '/Users/hojberg/code/unison/ui-core/tests/Code/Workspace/WorkspaceItemsTests.elm', '/Users/hojberg/code/unison/ui-core/tests/Lib/SearchResultsTests.elm', '/Users/hojberg/code/unison/ui-core/tests/Lib/TreePathTests.elm']),
		processes: 16,
		report: $author$project$Test$Reporter$Reporter$ConsoleReport($author$project$Console$Text$UseColor),
		runs: 100,
		seed: 66268589582276
	},
	_List_fromArray(
		[
			_Utils_Tuple2(
			'Code.CodebaseTree.NamespaceListingTests',
			_List_fromArray(
				[
					$author$project$Test$Runner$Node$check($author$project$Code$CodebaseTree$NamespaceListingTests$map)
				])),
			_Utils_Tuple2(
			'Code.Definition.DocTests',
			_List_fromArray(
				[
					$author$project$Test$Runner$Node$check($author$project$Code$Definition$DocTests$mergeWords),
					$author$project$Test$Runner$Node$check($author$project$Code$Definition$DocTests$isDocFoldToggled),
					$author$project$Test$Runner$Node$check($author$project$Code$Definition$DocTests$toString),
					$author$project$Test$Runner$Node$check($author$project$Code$Definition$DocTests$toggleFold),
					$author$project$Test$Runner$Node$check($author$project$Code$Definition$DocTests$id)
				])),
			_Utils_Tuple2(
			'Code.Finder.SearchOptionsTests',
			_List_fromArray(
				[
					$author$project$Test$Runner$Node$check($author$project$Code$Finder$SearchOptionsTests$init),
					$author$project$Test$Runner$Node$check($author$project$Code$Finder$SearchOptionsTests$removeWithin),
					$author$project$Test$Runner$Node$check($author$project$Code$Finder$SearchOptionsTests$namespaceFqn),
					$author$project$Test$Runner$Node$check($author$project$Code$Finder$SearchOptionsTests$perspectiveFqn),
					$author$project$Test$Runner$Node$check($author$project$Code$Finder$SearchOptionsTests$namespacePerspective),
					$author$project$Test$Runner$Node$check($author$project$Code$Finder$SearchOptionsTests$codebasePerspective)
				])),
			_Utils_Tuple2(
			'Code.FullyQualifiedNameTests',
			_List_fromArray(
				[
					$author$project$Test$Runner$Node$check($author$project$Code$FullyQualifiedNameTests$cons),
					$author$project$Test$Runner$Node$check($author$project$Code$FullyQualifiedNameTests$snoc),
					$author$project$Test$Runner$Node$check($author$project$Code$FullyQualifiedNameTests$append),
					$author$project$Test$Runner$Node$check($author$project$Code$FullyQualifiedNameTests$fromString),
					$author$project$Test$Runner$Node$check($author$project$Code$FullyQualifiedNameTests$fromUrlString),
					$author$project$Test$Runner$Node$check($author$project$Code$FullyQualifiedNameTests$toString),
					$author$project$Test$Runner$Node$check($author$project$Code$FullyQualifiedNameTests$toUrlString),
					$author$project$Test$Runner$Node$check($author$project$Code$FullyQualifiedNameTests$fromParent),
					$author$project$Test$Runner$Node$check($author$project$Code$FullyQualifiedNameTests$unqualifiedName),
					$author$project$Test$Runner$Node$check($author$project$Code$FullyQualifiedNameTests$isSuffixOf),
					$author$project$Test$Runner$Node$check($author$project$Code$FullyQualifiedNameTests$namespaceOf),
					$author$project$Test$Runner$Node$check($author$project$Code$FullyQualifiedNameTests$namespace),
					$author$project$Test$Runner$Node$check($author$project$Code$FullyQualifiedNameTests$segments)
				])),
			_Utils_Tuple2(
			'Code.HashQualifiedTests',
			_List_fromArray(
				[
					$author$project$Test$Runner$Node$check($author$project$Code$HashQualifiedTests$name),
					$author$project$Test$Runner$Node$check($author$project$Code$HashQualifiedTests$hash),
					$author$project$Test$Runner$Node$check($author$project$Code$HashQualifiedTests$fromUrlString),
					$author$project$Test$Runner$Node$check($author$project$Code$HashQualifiedTests$name_),
					$author$project$Test$Runner$Node$check($author$project$Code$HashQualifiedTests$urlName_),
					$author$project$Test$Runner$Node$check($author$project$Code$HashQualifiedTests$hash_)
				])),
			_Utils_Tuple2(
			'Code.HashTests',
			_List_fromArray(
				[
					$author$project$Test$Runner$Node$check($author$project$Code$HashTests$equals),
					$author$project$Test$Runner$Node$check($author$project$Code$HashTests$toShortString),
					$author$project$Test$Runner$Node$check($author$project$Code$HashTests$stripHashPrefix),
					$author$project$Test$Runner$Node$check($author$project$Code$HashTests$toUrlString),
					$author$project$Test$Runner$Node$check($author$project$Code$HashTests$fromString),
					$author$project$Test$Runner$Node$check($author$project$Code$HashTests$fromUrlString),
					$author$project$Test$Runner$Node$check($author$project$Code$HashTests$isRawHash)
				])),
			_Utils_Tuple2(
			'Code.ProjectTests',
			_List_fromArray(
				[
					$author$project$Test$Runner$Node$check($author$project$Code$ProjectTests$slug),
					$author$project$Test$Runner$Node$check($author$project$Code$ProjectTests$project)
				])),
			_Utils_Tuple2(
			'Code.Workspace.WorkspaceItemsTests',
			_List_fromArray(
				[
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$appendWithFocus),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$prependWithFocus),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$insertWithFocusAfter),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$insertWithFocusBefore),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$replace),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$remove),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$member),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$next),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$prev),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$focusedReference),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$moveUp),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$moveDown),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$map),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$mapToList),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$termRef),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$notFoundRef),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$hashQualified),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$term),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$before),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$focused),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$after),
					$author$project$Test$Runner$Node$check($author$project$Code$Workspace$WorkspaceItemsTests$workspaceItems)
				])),
			_Utils_Tuple2(
			'Lib.SearchResultsTests',
			_List_fromArray(
				[
					$author$project$Test$Runner$Node$check($author$project$Lib$SearchResultsTests$fromList),
					$author$project$Test$Runner$Node$check($author$project$Lib$SearchResultsTests$next),
					$author$project$Test$Runner$Node$check($author$project$Lib$SearchResultsTests$prev),
					$author$project$Test$Runner$Node$check($author$project$Lib$SearchResultsTests$getAt),
					$author$project$Test$Runner$Node$check($author$project$Lib$SearchResultsTests$mapToList)
				])),
			_Utils_Tuple2(
			'Lib.TreePathTests',
			_List_fromArray(
				[
					$author$project$Test$Runner$Node$check($author$project$Lib$TreePathTests$toString)
				]))
		]));
_Platform_export({'Test':{'Generated':{'Main':{'init':$author$project$Test$Generated$Main$main($elm$json$Json$Decode$int)(0)}}}});}(this));
return this.Elm;
})({});
var pipeFilename = "/tmp/elm_test-1389.sock";
var net = require('net'),
  client = net.createConnection(pipeFilename);

client.on('error', function (error) {
  console.error(error);
  client.end();
  process.exit(1);
});

client.setEncoding('utf8');
client.setNoDelay(true);

// Run the Elm app.
var app = Elm.Test.Generated.Main.init({ flags: Date.now() });

client.on('data', function (msg) {
  app.ports.elmTestPort__receive.send(JSON.parse(msg));
});

// Use ports for inter-process communication.
app.ports.elmTestPort__send.subscribe(function (msg) {
  // We split incoming messages on the socket on newlines. The gist is that node
  // is rather unpredictable in whether or not a single `write` will result in a
  // single `on('data')` callback. Sometimes it does, sometimes multiple writes
  // result in a single callback and - worst of all - sometimes a single read
  // results in multiple callbacks, each receiving a piece of the data. The
  // horror.
  client.write(msg + '\n');
});