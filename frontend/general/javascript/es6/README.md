![alt text](../../../../static/horizontal-beeva-logo.png "BEEVA")

# Front-end Development Best Practices

## ES6

ECMAScript is a trademarked scripting language specification standardized by Ecma International in ECMA-262 and ISO/IEC 16262. Well-known implementations of the language, such as JavaScript, JScript and ActionScript are widely used for client-side scripting on the Web.

The Sixth Edition, known as ECMAScript 2015, adds significant new syntax for writing complex applications, including classes and modules, but defines them semantically in the same terms as ECMAScript 5 strict mode. Other new features include iterators and for/of loops, Python-style generators and generator expressions, arrow functions, binary data, collections (maps, sets and weak maps), and proxies (metaprogramming for virtual objects and wrappers). As the first “ECMAScript Harmony” specification, it is also known as “ES6 Harmony”.

### Releases

* [Promises](#promises)
* [Array](#array)
* [Class](#class)
* [Destructuring](#destructuring)
* [Generator](#generator)
* [Map](#map)
* [Set](#set)
* [Proxy](#proxy)
* [Reflect](#reflect)
* [Iterator](#iterator)
* [Object literal](#object_literal)
* [String](#string)
* [Template strings](#template_strings)
* [Symbol](#symbol)
* [Arrow functions](#arrow_functions)
* [Block scope](#block_scope)
* [Spread operator](#spread_operator)
* [Default parameters](#default_parameters)
* [Modules](#modules)
* [Number](#number)
* [Object](#object)
* [Unicode](#unicode)

## <a name='promises'>Promises</a>

A promise represents an operation that hasn`t completed yet, but is expected in the future.

```javascript
function msgAfterTimeout (msg, who, timeout) {
    return new Promise((resolve, reject) => {
        setTimeout(() => resolve(`${msg} Hello ${who}!`), timeout)
    })
}

msgAfterTimeout("", "Foo", 100).then((msg) =>
    msgAfterTimeout(msg, "Bar", 200)
).then((msg) => {
    console.log(`done after 300ms:${msg}`)
})
```

## <a name='array'>Array</a>

###Array.from()

The Array.from() method creates a new Array instance from an array-like or iterable object.

In ES6, class syntax allows for the subclassing of both built-in and user defined classes; as a result, class-side static methods such as Array.from are "inherited" by subclasses of Array and create new instances of the subclass, not Array.

```javascript
// Array-like object (arguments) to Array
function f() {
  return Array.from(arguments);
}

f(1, 2, 3); 
// [1, 2, 3]
```

###Array.fill()

The fill() method fills all the elements of an array from a start index to an end index with a static value.

```javascript
[1, 2, 3].fill(4);               // [4, 4, 4]
[1, 2, 3].fill(4, 1);            // [1, 4, 4]
[1, 2, 3].fill(4, 1, 2);         // [1, 4, 3]
[1, 2, 3].fill(4, 1, 1);         // [1, 2, 3]
[1, 2, 3].fill(4, -3, -2);       // [4, 2, 3]
[1, 2, 3].fill(4, NaN, NaN);     // [1, 2, 3]
Array(3).fill(4);                // [4, 4, 4]
[].fill.call({ length: 3 }, 4);  // {0: 4, 1: 4, 2: 4, length: 3}
```

###Array.find()

The find() method returns a value in the array, if an element in the array satisfies the provided testing function. Otherwise undefined is returned.

```javascript
function isPrime(element, index, array) {
  var start = 2;
  while (start <= Math.sqrt(element)) {
    if (element % start++ < 1) {
      return false;
    }
  }
  return element > 1;
}

console.log([4, 6, 8, 12].find(isPrime)); // undefined, not found
console.log([4, 5, 8, 12].find((x) => x>10); // 12
```

###Array.findIndex()

The findIndex() method returns an index in the array, if an element in the array satisfies the provided testing function. Otherwise -1 is returned.

```javascript
function isPrime(element, index, array) {
  var start = 2;
  while (start <= Math.sqrt(element)) {
    if (element % start++ < 1) {
      return false;
    }
  }
  return element > 1;
}

console.log([4, 6, 8, 12].findIndex(isPrime)); // -1, not found
console.log([4, 6, 7, 12].findIndex(isPrime)); // 2
```

###Array.entries()

The entries() method returns a new Array Iterator object that contains the key/value pairs for each index in the array.

```javascript
var arr = ['a', 'b', 'c'];
var eArr = arr.entries();

console.log(eArr.next().value); // [0, 'a']
console.log(eArr.next().value); // [1, 'b']
console.log(eArr.next().value); // [2, 'c']
```

###Array.keys()

The keys() method returns a new Array Iterator that contains the keys for each index in the array.

```javascript
var arr = ["a", "b", "c"];
var iterator = arr.keys();

console.log(iterator.next()); // { value: 0, done: false }
console.log(iterator.next()); // { value: 1, done: false }
console.log(iterator.next()); // { value: 2, done: false }
console.log(iterator.next()); // { value: undefined, done: true }
```

###Array.values()

The values() method returns a new Array Iterator object that contains the values for each index in the array.

```javascript
var arr = ['w', 'y', 'k', 'o', 'p'];
var eArr = arr.values();
console.log(eArr.next().value); // w
console.log(eArr.next().value); // y
console.log(eArr.next().value); // k
console.log(eArr.next().value); // o
console.log(eArr.next().value); // p
```

## <a name='class'>Class</a>

###Array.from()

JavaScript classes are introduced in ECMAScript 6 and are syntactical sugar over JavaScript's existing prototype-based inheritance. The class syntax is not introducing a new object-oriented inheritance model to JavaScript. JavaScript classes provide a much simpler and clearer syntax to create objects and deal with inheritance.

####Defining classes

Classes are in fact functions, and just as you can define function expressions and function declarations, the class syntax has two components: class expressions and class declarations.

####Class declarations

One way to define a class is using a class declaration. To declare a class, you use the class keyword with the name of the class ("Polygon" here).

```javascript
class Polygon {
  constructor(height, width) {
    this.height = height;
    this.width = width;
  }
}
```

Hoisting

An important difference between function declarations and class declarations is that function declarations are hoisted and class declarations are not. You first need to declare your class and then access it, otherwise code like the following will throw a ReferenceError:

```javascript
var p = new Polygon(); // ReferenceError

class Polygon {}
```

####Static methods

The static keyword defines a static method for a class. Static methods are called without instantiating their class and are also not callable when the class is instantiated. Static methods are often used to create utility functions for an application.

```javascript
class Point {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }

    static distance(a, b) {
        const dx = a.x - b.x;
        const dy = a.y - b.y;

        return Math.sqrt(dx*dx + dy*dy);
    }
}

const p1 = new Point(5, 5);
const p2 = new Point(10, 10);

console.log(Point.distance(p1, p2));
```

####Sub classing with extends

The extends keyword is used in class declarations or class expressions to create a class with a child of another class.

```javascript
class Animal { 
  constructor(name) {
    this.name = name;
  }
  
  speak() {
    console.log(this.name + ' makes a noise.');
  }
}

class Dog extends Animal {
  speak() {
    console.log(this.name + ' barks.');
  }
}
```

####Super

The super keyword is used to call functions on an object's parent.

The super.prop and super(expr) expressions are valid in any method definition in both classes and object literals.

```javascript
class Polygon {
  constructor(height, width) {
    this.name = 'Polygon';
    this.height = height;
    this.width = width;
  }
  sayName() {
    console.log('Hi, I am a ', this.name + '.');
  }
}

class Square extends Polygon {
  constructor(length) {
    this.height; // ReferenceError, super needs to be called first!
    
    // Here, it calls the parent class' constructor with lengths
    // provided for the Polygon's width and height
    super(length, length);
    
    // Note: In derived classes, super() must be called before you
    // can use 'this'. Leaving this out will cause a reference error.
    this.name = 'Square';
  }

  get area() {
    return this.height * this.width;
  }

  set area(value) {
    this.area = value;
  } 
}
```

#####Super.prop can not overwrite non-writable properties

When defining non-writable properties with e.g. Object.defineProperty, super can not overwrite the value of the property.

```javascript
class X {
  constructor() {
    Object.defineProperty(this, "prop", {
      configurable: true,
      writable: false, 
      value: 1
    });
  } 
  f() { 
    super.prop = 2;
  }
}

var x = new X();
x.f();
console.log(x.prop); // 1
```

## <a name='destructuring'>Destructuring</a>

Destructuring Assignment

####Array Matching

Intuitive and flexible destructuring of Arrays into individual variables during assignment.

```javascript
var list = [ 1, 2, 3 ]
var [ a, , b ] = list
console.log(a); // 1
console.log(b); // 3
[ b, a ] = [ a, b ]
console.log(a); // 3
console.log(b); // 1
```



Intuitive and flexible destructuring of Objects into individual variables during assignment.


```javascript
console.log(getNode); // { "a" : 1, "b" : 2 }
var { a, b } = getNode();
console.log(a); // 1
console.log(b); // 2
```

####Object Matching, Shorthand Notation

Intuitive and flexible destructuring of Arrays and Objects into individual parameters during function calls.

```javascript
function f ([ name, val ]) {
    console.log(name, val)
}
function g ({ name: n, val: v }) {
    console.log(n, v)
}
function h ({ name, val }) {
    console.log(name, val)
}
f([ "bar", 42 ]) // bar,42
g({ name: "foo", val:  7 }) //foo,7
h({ name: "bar", val: 42 }) //bar,42
```

####Fail-Soft Destructuring

Fail-soft destructuring, optionally with defaults.

```javascript
var list = [ 7, 42 ]
var [ a = 1, b = 2, c = 3, d ] = list
a === 7
b === 42
c === 3
d === undefined
```

## <a name='generator'>Generator</a>

####Generator Function, Iterator Protocol

Support for generators, a special case of Iterators containing a generator function, where the control flow can be paused and resumed, in order to produce sequence of values (either finite or infinite).

```javascript
let fibonacci = {
    *[Symbol.iterator]() {
        let pre = 0, cur = 1
        for (;;) {
            [ pre, cur ] = [ cur, pre + cur ]
            yield cur
        }
    }
}

for (let n of fibonacci) {
    if (n > 1000)
        break
    console.log(n)
}
```

####Generator Function, Direct Use

Support for generator functions, a special variant of functions where the control flow can be paused and resumed, in order to produce sequence of values (either finite or infinite).

```javascript
function* range (start, end, step) {
    while (start < end) {
        yield start
        start += step
    }
}

for (let i of range(0, 10, 2)) {
    console.log(i) // 0, 2, 4, 6, 8
}
```

####Generator Matching

Support for generator functions, i.e., functions where the control flow can be paused and resumed, in order to produce and spread sequence of values (either finite or infinite).

```javascript
let fibonacci = function* (numbers) {
    let pre = 0, cur = 1
    while (numbers-- > 0) {
        [ pre, cur ] = [ cur, pre + cur ]
        yield cur
    }
}

for (let n of fibonacci(1000))
    console.log(n)

let numbers = [ ...fibonacci(1000) ]

let [ n1, n2, n3, ...others ] = fibonacci(1000)
```

## <a name='map'>Map</a>

The Map object is a simple key/value map. Any value (both objects and primitive values) may be used as either a key or a value.

```javascript
let m = new Map()
m.set("hello", 42)
m.set(s, 34)
m.get(s) === 34
m.size === 2
for (let [ key, val ] of m.entries())
    console.log(key + " = " + val)
```

## <a name='set'>Set</a>

The Set object lets you store unique values of any type, whether primitive values or object references.

```javascript
let s = new Set()
s.add("hello").add("goodbye").add("hello")
s.size === 2
s.has("hello") === true
for (let key of s.values()) // insertion order
    console.log(key)
```

## <a name='proxy'>Proxy</a>

The Proxy object is used to define custom behavior for fundamental operations (e.g. property lookup, assignment, enumeration, function invocation, etc).

```javascript
let target = {
    foo: "Welcome, foo"
}
let proxy = new Proxy(target, {
    get (receiver, name) {
        return name in receiver ? receiver[name] : `Hello, ${name}`
    }
})
console.log(proxy.foo) //"Welcome, foo"
console.log(proxy.world) //"Hello, world"
```

## <a name='reflect'>Reflect</a>

Reflect is a built-in object that provides methods for interceptable JavaScript operations. The methods are the same as those of [proxy](#proxy) handlers. Reflect is not a function object, so it's not constructible.

```javascript
let obj = { a: 1 }
Object.defineProperty(obj, "b", { value: 2 })
obj[Symbol("c")] = 3
console.log(Reflect.ownKeys(obj)) // [ "a", "b", Symbol(c) ]
```

## <a name='iterator'>Iterator</a>

Support "iterable" protocol to allow objects to customize their iteration behaviour. Additionally, support "iterator" protocol to produce sequence of values (either finite or infinite). Finally, provide convenient of operator to iterate over all values of an iterable object.

```javascript
let fibonacci = {
    [Symbol.iterator]() {
        let pre = 0, cur = 1
        return {
           next () {
               [ pre, cur ] = [ cur, pre + cur ]
               return { done: false, value: cur }
           }
        }
    }
}

for (let n of fibonacci) {
    if (n > 1000)
        break
    console.log(n)
}
```

## <a name='object_literal'>Object literal</a>

Direct support for safe binary and octal literals.

```javascript
0b111110111 === 503
0o767 === 503
```

## <a name='string'>String</a>

####String.includes()

The includes() method determines whether one string may be found within another string, returning true or false as appropriate.

```javascript
var str = 'To be, or not to be, that is the question.';

console.log(str.includes('To be'));       // true
console.log(str.includes('question'));    // true
console.log(str.includes('nonexistent')); // false
console.log(str.includes('To be', 1));    // false
console.log(str.includes('TO BE'));       // false
```

####String.repeat()

The repeat() method constructs and returns a new string which contains the specified number of copies of the string on which it was called, concatenated together.

```javascript
'abc'.repeat(-1);   // RangeError
'abc'.repeat(0);    // ''
'abc'.repeat(1);    // 'abc'
'abc'.repeat(2);    // 'abcabc'
'abc'.repeat(3.5);  // 'abcabcabc' (count will be converted to integer)
'abc'.repeat(1/0);  // RangeError

({ toString: () => 'abc', repeat: String.prototype.repeat }).repeat(2);
// 'abcabc' (repeat() is a generic method)
```

####String.startsWith()

The startsWith() method determines whether a string begins with the characters of another string, returning true or false as appropriate.

```javascript
var str = 'To be, or not to be, that is the question.';

console.log(str.startsWith('To be'));         // true
console.log(str.startsWith('not to be'));     // false
console.log(str.startsWith('not to be', 10)); // true
```

####String.endsWith()

The endsWith() method determines whether a string ends with the characters of another string, returning true or false as appropriate.

```javascript
var str = 'To be, or not to be, that is the question.';

console.log(str.endsWith('question.')); // true
console.log(str.endsWith('to be'));     // false
console.log(str.endsWith('to be', 19)); // true
```

## <a name='template_strings'>Template strings</a>

Template strings are string literals allowing embedded expressions. You can use multi-line strings and string interpolation features with them.

```javascript
`string text`

`string text line 1
 string text line 2`

`string text ${expression} string text`

tag `string text ${expression} string text`
```

Template strings are enclosed by the back-tick (` `) (grave accent) character instead of double or single quotes. Template strings can contain place holders. These are indicated by the Dollar sign and curly braces (${expression}). The expressions in the place holders and the text between them get passed to a function. The default function just concatenates the parts into a single string. If there is an expression preceding the template string (tag here),  the template string is called "tagged template string". In that case, the tag expression (usually a function) gets called with the processed template string, which you can then manipulate before outputting.

####Multi-line strings

Any new line characters inserted in the source are part of the template string. Using normal strings, you would have to use the following syntax in order to get multi-line strings:

```javascript
console.log("string text line 1\n"+
"string text line 2");
// "string text line 1
// string text line 2"

//With ES6

console.log(`string text line 1
string text line 2`);
// "string text line 1
// string text line 2"
```

####Expression interpolation

In order to embed expressions within normal strings, you would use the following syntax:

```javascript
var a = 5;
var b = 10;
console.log(`Fifteen is ${a + b} and\nnot ${2 * a + b}.`);
// "Fifteen is 15 and
// not 20."
```

####Tagged template strings

A more advanced form of template strings are tagged template strings. With them you are able to modify the output of template strings using a function. The first argument contains an array of string literals ("Hello " and " world" in this example). The second, and each argument after the first one, are the values of the processed (or sometimes called cooked) substitution expressions ("15" and "50" here). In the end, your function returns your manipulated string. There is nothing special about the name tag in the following example. The function name may be anything you want.

```javascript
var a = 5;
var b = 10;

function tag(strings, ...values) {
  console.log(strings[0]); // "Hello "
  console.log(strings[1]); // " world "
  console.log(values[0]);  // 15
  console.log(values[1]);  // 50

  return "Bazinga!";
}

tag`Hello ${ a + b } world ${ a * b }`;
// "Bazinga!"
```

## <a name='symbol'>Symbol</a>

A symbol is a unique and immutable data type and may be used as an identifier for object properties. The symbol object is an implicit object wrapper for the symbol primitive data type.


```javascript
var sym1 = Symbol();
var sym2 = Symbol("foo");
var sym3 = Symbol("foo");
Symbol("foo") === Symbol("foo"); // false
```

####Iterator

We can make our own iterables like this:

```javascript
var myIterable = {}
myIterable[Symbol.iterator] = function* () {
    yield 1;
    yield 2;
    yield 3;
};
[...myIterable] // [1, 2, 3]
```

####Symbol.for()

The Symbol.for(key) method searches for existing symbols in a runtime-wide symbol registry with the given key and returns it if found. Otherwise a new symbol gets created in the global symbol registry with this key.

```javascript
Symbol.for("foo"); // create a new global symbol
Symbol.for("foo"); // retrieve the already created symbol

// Same global symbol, but not locally
Symbol.for("bar") === Symbol.for("bar"); // true
Symbol("bar") === Symbol("bar"); // false

// The key is also used as the description
var sym = Symbol.for("mario");
sym.toString(); // "Symbol(mario)"
```

####Symbol.keyFor()

The Symbol.keyFor(sym) method retrieves a shared symbol key from the global symbol registry for the given symbol.


```javascript
var globalSym = Symbol.for("foo"); // create a new global symbol
Symbol.keyFor(globalSym); // "foo"

var localSym = Symbol();
Symbol.keyFor(localSym); // undefined

// well-known symbols are not symbols registered 
// in the global symbol registry
Symbol.keyFor(Symbol.iterator) // undefined
```

## <a name='arrow_functions'>Arrow functions</a>

Arrow functions are a more convinient and shorter way to write a function. 

####Expression Bodies

More expressive closure syntax.

```javascript
odds  = evens.map(v => v + 1)
pairs = evens.map(v => ({ even: v, odd: v + 1 }))
nums  = evens.map((v, i) => v + i)
```

####Statement Bodies

```javascript
nums.forEach(v => {
   if (v % 5 === 0)
       fives.push(v)
})
```

####Lexical this

More intuitive handling of current object context.

```javascript
this.nums.forEach((v) => {
    if (v % 5 === 0)
        this.fives.push(v)
})
```

## <a name='block_scope'>Block scope</a>

####Block-Scoped Variables

Block-scoped variables (and constants) without hoisting.

```javascript
for (let i = 0; i < a.length; i++) {
    let x = a[i]
    …
}
for (let i = 0; i < b.length; i++) {
    let y = b[i]
    …
}

let callbacks = []
for (let i = 0; i <= 2; i++) {
    callbacks[i] = function () { return i * 2 }
}
callbacks[0]() === 0
callbacks[1]() === 2
callbacks[2]() === 4
```

####Block-Scoped Functions

```javascript
{
    function foo () { return 1 }
    foo() === 1
    {
        function foo () { return 2 }
        foo() === 2
    }
    foo() === 1
}
```

## <a name='spread_operator'>Spread operator</a>

Spreading of elements of an iterable collection (like an array or even a string) into both literal elements and individual function parameters.

```javascript
var params = [ "hello", true, 7 ]
var other = [ 1, 2, ...params ] // [ 1, 2, "hello", true, 7 ]
f(1, 2, ...params) === 9

var str = "foo"
var chars = [ ...str ] // [ "f", "o", "o" ]
```

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies

