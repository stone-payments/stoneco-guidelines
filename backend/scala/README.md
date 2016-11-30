# Scala Programming Best Practices

![Scala Logo](static/scala-logo.png "Scala")

## Index

* [Introduction](#introduction)
* [Formatting](#formatting)
* [Types and Generics](#types-and-generics)
* [Collections](#collections)
* [Concurrency](#concurrency)
* [Control structures](#control-structures)
* [Functional programming](#functional-programming)
* [Object oriented programming](#object-oriented-programming)
* [Error handling](#error-handling)
* [Tools](#tools)
* [References](#references)

### <a name="introduction"></a>Introduction

This is not an introduction to Scala we assume the reader is familiar with the language. Some resources for learning Scala are:

[ScalaByExample](http://www.scala-lang.org/docu/files/ScalaByExample.pdf)

[A Scalable Language](https://www.artima.com/pins1ed/index.html#TOC)

This is a living document that will change to reflect our current “best practices,” but its core ideas are unlikely to change: Always favor readability write generic code but not at the expensive of clarity take advantage of simple language features that afford great power but avoid the esoteric ones (especially in the type system). Above all, be always aware of the trade offs you make. A sophisticated language requires a complex implementation, and complexity begets complexity: of reasoning, of semantics, of interaction between features, and of the understanding of your collaborators. Thus complexity is the tax of sophistication — you must always ensure that its utility exceeds its cost.

**[Index](#index)**

### <a name="formatting"></a>Formatting

Style cannot be inherently good or bad and almost everybody differs in personal preference. However the consistent application of the same formatting rules will almost always enhance readability. A reader already familiar with a particular style does not have to grasp yet another set of local conventions, or decipher yet another corner of the language grammar.

This is of particular importance to Scala, as its grammar has a high degree of overlap.

We adhere to the [Scala style] (http://docs.scala-lang.org/style/)  guide plus the following rules

#### Whitespace
Indent by two spaces. Try to avoid lines greater than 100 columns in length. Use one blank line between method, class, and object definitions

#### Naming
_Use short names for small scopes_

    is, js and ks are all but expected in loops.

_Use longer names for larger scopes_

    external APIs should have longer and explanatory names that confer meaning. Future.collect not Future.all

_Use common abbreviations but eschew esoteric ones_

    Everyone knows ok, err or defn whereas sfri is not so common.

_Don't rebind names for different uses_

    Use vals

_Avoid using s to overload reserved names_

    typ instead of `type`

_Use active names for operations with side effects_

    user.activate() not user.setActive()

_Use descriptive names for methods that return values_

    src.isDefined not src.defined

_Do not prefix getters with get_

    As per the previous rule, it is redundant: site.count not site.getCount

_Do not repeat names that are already encapsulated in package or object name_

    Prefer:

```scala
object User {
  def get(id: Int): Option[User]
}
```

    to:

```scala
object User {
  def getUser(id: Int): Option[User]
}
```

_They are redundant in use_

    User.getUser provides no more information than User.get.

#### Imports

_Sort import lines alphabetically_

    This makes it easy to examine visually, and is simple to automate.

_Use braces when importing several names from a package_

    import com.beeva.concurrent.{Broker, Offer}

_Use wildcards when more than six names are imported_

    e.g.: import com.beeva.concurrent._
    Don't apply this blindly: some packages export too many names_

_When using collections, qualify names by importing scala.collection.immutable and/or scala.collection.mutable_

    Mutable and immutable collections have dual names.
    Qualifiying the names makes is obvious to the reader which variant is being used (e.g. "immutable.Map")

_Do not use relative imports from other packages_

Avoid

    import com.beeva
    import concurrent

in favor of the unambiguous

    import com.beeva.concurrent

_Put imports at the top of the file_

    The reader can refer to all imports in one place.

#### Braces

Braces are used to create compound expressions (they serve other uses in the “module language”), where the value of the compound expression is the last expression in the list. Avoid using braces for simple expressions.

Write

```scala
def square(x: Int) = x*x
```

but not

```scala
def square(x: Int) = {
  x * x
}
```

even though it may be tempting to distinguish the method body syntactically. The first alternative has less clutter and is easier to read. Avoid syntactical ceremony unless it clarifies.

#### Pattern matching

Use pattern matching directly in function definitions whenever applicable.

Instead of

```scala
list map { item =>
  item match {
    case Some(x) => x
    case None => default
  }
}
```

collapse the match

```scala
list map {
  case Some(x) => x
  case None => default
}
```

it's clear that the list items are being mapped over — the extra indirection does not elucidate.

#### Comments

Use ScalaDoc to provide API documentation. Use the following style:

```scala
/**
 * ServiceBuilder builds services
 * ...
 */
 ```

but not the standard ScalaDoc style:

```scala
/** ServiceBuilder builds services
 * ...
 */
```

Do not resort to ASCII art or other visual embellishments. Document APIs but do not add unnecessary comments. If you find yourself adding comments to explain the behavior of your code, ask first if it can be restructured so that it becomes obvious what it does. Prefer “obviously it works” to “it works, obviously” (with apologies to Hoare).

#### ScalaDoc

Use Scaladoc when something deserves explanation. In general we must try use user defined types and the choose expressive names. The code is "self-explanatory".


**[Index](#index)**

### <a name="types-and-generics"></a>Types and Generics

The primary objective of a type system is to detect programming errors. Use of the type system should reflect this goal, but we must remain mindful of the reader: judicious use of types can serve to enhance clarity, being unduly clever only obfuscates.

#### Return type annotations

While Scala allows these to be omitted, such annotations provide good documentation: this is especially important for public methods. Where a method is not exposed and its return type obvious, omit them.

#### Variance

Variance arises when generics are combined with subtyping. Variance defines how subtyping of the contained type relates to subtyping of the container type. Because Scala has declaration site variance annotations, authors of common libraries — especially collections — must be prolific annotators. Such annotations are important for the usability of shared code, but misapplication can be dangerous.

Invariants are an advanced but necessary aspect of Scala’s typesystem, and should be used widely (and correctly) as it aids the application of subtyping.

Immutable collections should be covariant. Methods that receive the contained type should “downgrade” the collection appropriately:

```scala
trait Collection[+T] {
  def add[U >: T](other: U): Collection[U]
}
```

Mutable collections should be invariant. Covariance is typically invalid with mutable collections. Consider

```scala
trait HashSet[+T] {
  def add[U >: T](item: U)
}
```

and the following type hierarchy:

```scala
trait Mammal
trait Dog extends Mammal
trait Cat extends Mammal
```

If I now have a hash set of dogs

```scala
val dogs: HashSet[Dog]
```

treat it as a set of Mammals and add a cat.

```scala
val mammals: HashSet[Mammal] = dogs
mammals.add(new Cat{})
```

This is no longer a HashSet of dogs

#### Type aliases

Use type aliases when they provide convenient naming or clarify purpose, but do not alias types that are self-explanatory.

#### Implicits

It’s definitely OK to use implicits in the following situations:

- Extending or adding a Scala-style collection
- Adapting or extending an object (“pimp my library” pattern)
- Use to enhance type safety by providing constraint evidence
- To provide type evidence (typeclassing)
- For Manifests

**[Index](#index)**

### <a name="collections"></a>Collections
Scala has a very generic, rich, powerful, and composable collections library. Collections are high level and expose a large set of operations.
Always use the simplest collection that meets your needs.

#### Use
Prefer using immutable collections. They are applicable in most circumstances, and make programs easier to reason about since they are referentially transparent and are thus also threadsafe by default.

Use the mutable namespace explicitly. Don’t import scala.collection.mutable._ and refer to Set, instead

```scala
import scala.collection.mutable
val set = mutable.Set()
```

makes it clear that the mutable variant is being used.

Use the default constructor for the collection type. Whenever you need an ordered sequence (and not necessarily linked list semantics), use the Seq() constructor, and so on:

```scala
val seq = Seq(1, 2, 3)
val set = Set(1, 2, 3)
val map = Map(1 -> "one", 2 -> "two", 3 -> "three")
```

#### Style

Functional programming encourages pipelining transformations of an immutable collection to shape it to its desired result. This often leads to very succinct solutions, but can also be confusing to the reader — it is often difficult to discern the author’s intent, or keep track of all the intermediate results that are only implied.

Developer must think that code will be read by other people. Using {} and intermediate state values you will get readable code

#### Performance

Before focusing on low level details, make sure you are using a collection appropriate for your use. Make sure your datastructure doesn’t have unexpected asymptotic complexity.

It is often appropriate to use lower level collections in situations that require better performance or space efficiency. Use arrays instead of lists for large sequences (the immutable Vector collections provides a referentially transparent interface to arrays) and use buffers instead of direct sequence construction when performance matters.

**[Index](#index)**

### <a name="concurrency"></a>Concurrency

Modern services are highly concurrent, _Threads_ provide a means of expressing concurrency but they are dificult to manage. Also you have to consider issues such as cancellations and timeouts and your code usually lost modularity and it becomes difficult to maintain

#### Futures

Use Futures to manage concurrency. Scala has lightweight closure literal syntax, so Futures introduce little syntactic overhead, and they become second nature to most programmers.

Futures allow the programmer to express concurrent computation in a declarative style, are composable, and have principled handling of failure.

Prefer transforming futures over creating your own. Future transformations ensure that failures are propagated, that cancellations are signalled, and free the programmer from thinking about the implications of the Java memory model.

We use flatMap to sequence operations and prepend the result onto the list as we proceed. This is a common functional programming idiom translated to Futures. This is correct, requires less boilerplate, is less error prone, and also reads better.

Use the Future combinators. Future.select, Future.join, and Future.collect codify common patterns when operating over multiple futures that should be combined.


Do not throw your own exceptions in methods that return Futures. Futures represent both successful and failed computations. Therefore, it’s important that errors involved in that computation are properly encapsulated in the returned Future.

####Collections

In most practical situations they are a nonissue: Always start with the simplest, most boring, and most standard collection that serves the purpose. Don’t reach for a concurrent collection before you know that a synchronized one won’t do.

If an immutable collection will do, use it.

Mutable concurrent collections have complicated semantics, and make use of subtler aspects of the Java memory model, so make sure you understand the implications — especially with respect to publishing updates — before you use them.

**[Index](#index)**

### <a name="control-structures"></a>Control structures

Functional programs tend to require fewer traditional control structures, and read better when written in the declarative style. This typically implies breaking your logic skills. Functional programs also tend to be more expression-oriented.

#### Recursion

Focus problem recursively often simplifies, and if the *tail call* optimization applies (which can be checked by the *@tailrec* annotation), the compiler will even translate your code into a regular loop.

Consider a version of a recursive function:

```scala
def fixDown(heap: Array[T], m: Int, n: Int): Unit = {
  var k: Int = m
  while (n >= 2*k) {
    var j = 2*k
    if (j < n && heap(j) < heap(j + 1))
      j += 1
    if (heap(k) >= heap(j))
      return
    else {
      swap(heap, k, j)
      k = j
    }
  }
}
```

Every time the while loop is entered, we’re working with state dirtied by the previous iteration. The value of each variable is a function of which branches were taken, and it returns in the middle of the loop when the correct position was found.

Consider a *tail* recursive implementation:

```scala
@tailrec
final def fixDown(heap: Array[T], i: Int, j: Int) {
  if (j < i*2) return

  val m = if (j == i*2 || heap(2*i) < heap(2*i+1)) 2*i else 2*i + 1
  if (heap(m) < heap(i)) {
    swap(heap, i, m)
    fixDown(heap, m, j)
  }
}
```

here every iteration starts with a well-defined clean slate, and there are no reference cells: invariants abound. It’s much easier to reason about, and easier to read as well. There is also no performance penalty: since the method is tail-recursive, the compiler translates this into a standard imperative loop.

#### Returns

Returns can be used to cut down on branching and establish invariants. This helps the reader by reducing nesting and making it easier to reason about the correctness of subsequent code.

Use returns to clarify and enhance readability, but not as you would in an imperative language. Avoid using them to return the results of a computation.

Instead of

```scala
def suffix(i: Int) = {
  if      (i == 1) return "st"
  else if (i == 2) return "nd"
  else if (i == 3) return "rd"
  else             return "th"
}
```

prefer:

```scala
def suffix(i: Int) =
  if      (i == 1) "st"
  else if (i == 2) "nd"
  else if (i == 3) "rd"
  else             "th"
```

but using a match expression is superior to either:

```scala
def suffix(i: Int) = i match {
  case 1 => "st"
  case 2 => "nd"
  case 3 => "rd"
  case _ => "th"
}
```

Note that returns can have hidden costs: when used inside of a closure,

```scala
seq foreach { elem =>
  if (elem.isLast)
    return

  // process...
}
```

this is implemented in bytecode as an exception catching/throwing pair which, used in hot code, has performance implications.

##### for loops and comprehensions

*for* provides natural expression for looping and aggregation. It is especially useful when flattening many sequences. The syntax can lead to both unexpected costs and semantics. For example:

```scala
for (item <- container) {
  if (item != 2) return
}
```

may cause a runtime error if the container delays computation, making the return nonlocal!

For these reasons, it is often preferable to call *foreach*, *flatMap*, *map*, and *filter* directly — but do use *for* when they clarify.

##### require and assert

*require* and *assert* both serve as executable documentation. Both are useful for situations in which the type system cannot express the required invariants. *assert* is used for invariants that the code assumes (either internal or external). For example:

```scala
val stream = getClass.getResourceAsStream("someclassdata")
assert(stream != null)
```

Whereas *require* is used to express API contracts:

```scala
def fib(n: Int) = {
  require(n > 0)
  ...
}
```

**[Index](#index)**

### <a name="functional-programming"></a>Functional programming

OOP confers many advantages, especially when used in conjunction with functional programming constructs. This style emphasizes the transformation of values over stateful mutation, yielding code that is referentially transparent, providing stronger invariants and thus also easier to reason about. Case classes, pattern matching, destructuring bindings, type inference, and lightweight closure and method-creation syntax are the tools of this trade.

#### Case classes as algebraic data types

Case classes encode ADTs (Algebraic Data Types): they are useful for modeling a large number of data structures and provide summarized code with strong invariants, especially when used in conjunction with pattern matching. The pattern matcher implements analysis providing even stronger static guarantees.

Use the following pattern when encoding ADTs with case classes:

```scala
sealed trait Tree[T]
case class Node[T](left: Tree[T], right: Tree[T]) extends Tree[T]
case class Leaf[T](value: T) extends Tree[T]
```

The type Tree[T] has two constructors: Node and Leaf. Declaring the type sealed allows the compiler to do exhaustivity analysis since constructors cannot be added outside the source file.

Together with pattern matching, such modeling results in code that is both succinct and “obviously correct”:

```scala
def findMin[T <: Ordered[T]](tree: Tree[T]) = tree match {
  case Node(left, right) => Seq(findMin(left), findMin(right)).min
  case Leaf(value) => value
}
```

While recursive structures like trees constitute classic applications of ADTs, their domain of usefulness is much larger like in state machines.

#### Options

The *Option* type is a container that is either empty (None) or full (Some(value)). It provides a safe alternative to the use of null, and should be used instead of null whenever possible. Options are collections, of at most one item, and they are embellished with collection operations

Write

```scala
var username: Option[String] = None
...
username = Some("foobar")
```

instead of

```scala
var username: String = null
...
username = "foobar"
```

since the former is safer: the Option type statically enforces that username must be checked for emptiness.

Conditional execution on an *Option* value should be done with *foreach*

Write

```scala
opt foreach { value =>
  operate(value)
}
```

instead of

```scala
if (opt.isDefined)
  operate(opt.get)
```

The style may seem odd, but provides greater safety and brevity. If both branches are taken, use pattern matching:

```scala
opt match {
  case Some(value) => operate(value)
  case None => defaultAction()
}
```

but if all that's missing is a default value, use *getOrElse*

```scala
operate(opt getOrElse defaultValue)
```

Do not overuse *Option*: if there is a sensible default — a Null Object — use that instead.

*Option* also comes with a handy constructor for wrapping nullable values:

```scala
Option(getClass.getResourceAsStream("foo"))
```

is an *Option[InputStream]* that assumes a value of None should getResourceAsStream return null.

#### Pattern matching

Pattern matches (*x match { ... }*) are pervasive in well written Scala code: they conflate conditional execution, destructuring, and casting into one construct. Used well they enhance both clarity and safety.

Use pattern matching to implement type switches:

```scala
obj match {
  case str: String => ...
  case addr: SocketAddress => ...
```

Pattern matching works best when also combined with destructuring

write

```scala
animal match {
  case Dog(breed) => "dog (%s)".format(breed)
  case other => other.species
}
```

instead of

```scala
animal match {
  case dog: Dog => "dog (%s)".format(dog.breed)
  case _ => animal.species
  }
```

Write custom extractors but only with a dual constructor (apply), otherwise their use may be out of place.

Don’t use pattern matching for conditional execution when defaults make more sense. The collections libraries usually provide methods that return Options.

Avoid

```scala
val x = list match {
  case head :: _ => head
  case Nil => default
}
```

because

```scala
val x = list.headOption getOrElse default
```

is both shorter and communicates purpose.

#### Partial functions

Scala provides syntactical shorthand for defining a PartialFunction:

```scala
val pf: PartialFunction[Int, String] = {
  case i if i%2 == 0 => "even"
}
```

and they may be composed with orElse

```scala
val tf: (Int => String) = pf orElse { case _ => "odd"}

tf(1) == "odd"
tf(2) == "even"
```

Partial functions arise in many situations and are effectively encoded with PartialFunction, for example as arguments to methods

```scala
trait Publisher[T] {
  def subscribe(f: PartialFunction[T, Unit])
}

val publisher: Publisher[Int] = ...
publisher.subscribe {
  case i if isPrime(i) => println("found prime", i)
  case i if i%2 == 0 => count += 2
  /* ignore the rest */
}
```

or in situations that might otherwise call for returning an *Option*:

```scala
// Attempt to classify the the throwable for logging.
type Classifier = Throwable => Option[java.util.logging.Level]
```

might be better expressed with a PartialFunction

```scala
type Classifier = PartialFunction[Throwable, java.util.Logging.Level]
```

as it affords greater composability:

```scala
val classifier1: Classifier
val classifier2: Classifier

val classifier: Classifier = classifier1 orElse classifier2 orElse { case _ => java.util.Logging.Level.FINEST }
```

#### Destructuring bindings

Destructuring value bindings are related to pattern matching. They use the same mechanism but are applicable when there is exactly one option (lest you accept the possibility of an exception). Destructuring binds are particularly useful for tuples and case classes.

```scala
val tuple = ('a', 1)
val (char, digit) = tuple

val tweet = Tweet("just tweeting", Time.now)
val Tweet(text, timestamp) = tweet
```

#### Laziness

Fields in Scala are computed by need when *val* is prefixed with lazy. Because fields and methods are equivalent in Scala (lest the fields are private[this])

```scala
lazy val field = computation()
```

is shorter than

```scala
var _theField = None
def field = if (_theField.isDefined) _theField.get else {
  _theField = Some(computation())
  _theField.get
}
```

Use lazy fields for this purpose, but avoid using laziness when laziness is required by semantics. In these cases it's better to be explicit since it makes the cost model explicit, and side effects can be controlled more precisely.

Lazy fields are thread safe.

#### Call by name

Method parameters may be specified by-name, meaning the parameter is bound not to a value but to a computation that may be repeated. The motivation for this feature is to construct syntactically natural DSLs — new control constructs in particular can be made to look much like native language features.

Only use call-by-name for such control constructs, where it is obvious to the caller that what is being passed in is a “block” rather than the result of an unsuspecting computation. Only use call-by-name arguments in the last position of the last argument list. When using call-by-name, ensure that the method is named so that it is obvious to the caller that its argument is call-by-name.

When you do want a value to be computed multiple times, and especially when this computation is side effecting, use explicit functions:

```scala
class SSLConnector(mkEngine: () => SSLEngine)
```

The intent remains obvious and the caller is left without surprises.

##### flatMap

*flatMap* — the combination of map with flatten — deserves special attention, for it has subtle power and great utility. Like its brethren map, it is frequently available in nontraditional collections such as Future and Option. Its behavior is revealed by its signature for some Container[A]

```scala
flatMap[B](f: A => Container[B]): Container[B]
```

*flatMap* invokes the function f for the element(s) of the collection producing a new collection, which are flattened into its result. For example, to get all permutations of two character strings that aren't the same character repeated twice:

```scala
val chars = 'a' to 'z'
val perms = chars flatMap { a =>
  chars flatMap { b =>
    if (a != b) Seq("%c%c".format(a, b))
    else Seq()
  }
}
```

which is equivalent to the more concise for comprehension:

```scala
val perms = for {
  a <- chars
  b <- chars
  if a != b
} yield "%c%c".format(a, b)
```

*flatMap* is frequently useful when dealing with *Options*. It will collapse chains of options down to one

```scala
val host: Option[String] = ...
val port: Option[Int] = ...

val addr: Option[InetSocketAddress] =
  host flatMap { h =>
    port map { p =>
      new InetSocketAddress(h, p)
    }
  }
```

which is also made more succinct with for

```scala
val addr: Option[InetSocketAddress] = for {
  h <- host
  p <- port
} yield new InetSocketAddress(h, p)
```

The use of *flatMap* in Futures is discussed in the futures section.

**[Index](#index)**

### <a name="object-oriented-programming"></a>Object oriented programming

Scala is a pure language in the sense that all values are objects. There is no distinction between primitive types and composite ones. Scala also features mixins allowing for more orthogonal and piecemeal construction of modules that can be flexibly put together at compile time with all the benefits of static type checking.

A motivation behind the mixin system was to obviate the need for traditional dependency injection. The culmination of this “component style” of programming is the cake pattern.

#### Dependency injection

Scala removes so much of the syntactical overhead of “classic” dependency injection: it is clearer, the dependencies are still encoded in the (constructor) type, and class construction is so syntactically trivial that it becomes a breeze. Use dependency injection for program modularization, and in particular, prefer composition over inheritance — for this leads to more modular and testable programs. When encountering a situation requiring inheritance, ask yourself: how would you structure the program if the language lacked support for inheritance? The answer may be compelling.

Dependency injection typically makes use of traits:

```scala
trait TweetStream {
  def subscribe(f: Tweet => Unit)
}
class HosebirdStream extends TweetStream ...
class FileStream extends TweetStream ...

class TweetCounter(stream: TweetStream) {
  stream.subscribe { tweet => count += 1 }
}
```

It is common to inject factories — objects that produce other objects. In these cases, you use simple functions over specialized factory types:

```scala
class FilteredTweetCounter(mkStream: Filter => TweetStream) {
  mkStream(PublicTweets).subscribe { tweet => publicCount += 1 }
  mkStream(DMs).subscribe { tweet => dmCount += 1 }
}
```

#### Traits

Dependency injection does not at all preclude the use of common interfaces, or the implementation of common code in traits. Quite the contrary — the use of traits are highly encouraged for exactly this reason: multiple interfaces (traits) may be implemented by a concrete class, and common code can be reused across all such classes.

Keep traits short and orthogonal: don’t lump separable functionality into a trait, think of the smallest related ideas that fit together. For example, imagine you have an something that can do IO:

```scala
trait IOer {
  def write(bytes: Array[Byte])
  def read(n: Int): Array[Byte]
}
```

separate the two behaviors:

```scala
trait Reader {
  def read(n: Int): Array[Byte]
}
trait Writer {
  def write(bytes: Array[Byte])
}
```

and mix them together to form what was an IOer: new Reader with Writer Interface minimalism leads to greater orthogonality and cleaner modularization.

#### Visibility

Scala has very expressive visibility modifiers. It’s important to use these as they define what constitutes the public API. Public APIs should be limited so users don’t inadvertently rely on implementation details and limit the author’s ability to change them: They are crucial to good modularity. As a rule, it’s much easier to expand public APIs than to contract them. Poor annotations can also compromise backwards binary compatibility of your code.

##### private[this]

A class member marked private

```scala
private val x: Int = ...
```

is visible to all instances of that class (but not their subclasses). In most cases, you want private[this].

```scala
private[this] val x: Int = ...
```

which limits visibility to the particular instance. The Scala compiler is also able to translate private[this] into a simple field access (since access is limited to the statically defined class) which can sometimes aid performance optimizations.

#### Singleton class types

It’s common in Scala to create singleton class types, for example

```scala
def foo() = new Foo with Bar with Baz {
  ...
}
```

In these situations, visibility can be constrained by declaring the returned type:

```scala
def foo(): Foo with Bar = new Foo with Bar with Baz {
  ...
}
```

where callers of foo() will see a restricted view (Foo with Bar) of the returned instance.

#### Structural typing

Do not use structural types in normal use. They are a convenient and powerful feature, but unfortunately do not have an efficient implementation on the JVM. However, due to an implementation quirk, they provide a very nice shorthand for doing reflection.

```scala
val obj: AnyRef
obj.asInstanceOf[{def close()}].close()
```

**[Index](#index)**

### <a name="error-handling"></a>Error handling

Scala provides an exception facility, but do not use it for commonplace errors, when the programmer must handle errors properly for correctness. Instead, encode such errors explicitly: using Option are good, idiomatic choices, as they harness the type system to ensure that the user is properly considering error handling.

For example, when designing a repository, the following API may be tempting:

```
trait Repository[Key, Value] {
  def get(key: Key): Value
}
```

but this would require the implementor to throw an exception when the key is absent. A better approach is to use an *Option*:

```
trait Repository[Key, Value] {
  def get(key: Key): Option[Value]
}
```

This interface makes it obvious that the repository may not contain every key, and that the programmer must handle missing keys. Furthermore, *Option* has a number of combinators to handle these cases. For example, getOrElse is used to supply a default value for missing keys:

```
val repo: Repository[Int, String]
repo.get(123) getOrElse "defaultString"
```

#### Handling exceptions

Because Scala’s exception mechanism isn’t checked, the compiler can not statically tell whether the programmer has covered the set of possible exceptions, it is often tempting to cast a wide net when handling exceptions.

However, some exceptions are fatal and should never be caught:

```
try {
  operation()
} catch {
  case _ => ...
}
```

is almost always wrong, as it would catch fatal errors that need to be propagated.

If handling exceptions is mandatory for your system a better option to deal with it's usign [Try](http://www.scala-lang.org/api/current/scala/util/Try.html) class. It allows us to manage errors with pattern matching and monoid operations  

### <a name="tools"></a>Tools
There is a set of tools and sbt plugins that help us to prevent bugs and and follow coding best practises in Scala Projects.

* [**sCoverage**](http://scoverage.org/) It is a Scala coverage tool that provides statement and branch coverage. It has plugins available for [Maven](https://github.com/scoverage/scoverage-maven-plugin), [Sbt](https://github.com/scoverage/sbt-scoverage) and [Gradle](https://github.com/scoverage/gradle-scoverage).
* [**WartRemover**](https://github.com/puffnfresh/wartremover) It is a Scala code linting tool that allows control which kind of errors and warnings you want to receive and excluding code from analysis.
* [**CPD4SBT**](https://github.com/sbt/cpd4sbt) Integrates the classic PMD Copy Paste Detection into SBT.
* [**ScalaStyle**](http://www.scalastyle.org/) It's Scala equivalence to Java CheckStyle
* [**ScapeGoat**](https://github.com/sksamuel/scapegoat) It's an static code analyzer that provides an equivalent functionality of Java's FindBugs
* [**Scalariform**](https://github.com/daniel-trinh/scalariform) or [**Scalafmt**](https://olafurpg.github.io/scalafmt/) aren't properly a QA tools but a code formatters for Scala

All of them are or provide plugins to be integrated in SBT.

### <a name="references"></a>References

* [Scala Lang](http://www.scala-lang.org/) Documentation and download
* [Scala Cheat Sheet](http://docs.scala-lang.org/cheatsheets/) A scala full cheatsheet
* [Scala Effective](http://twitter.github.io/effectivescala/)
* [Scala Style Guide](http://docs.scala-lang.org/style/)

___

[BEEVA](http://www.beeva.com) | 2016
