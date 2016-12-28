
![Ruby logo](static/ruby.png "Ruby logo")

# Ruby Style Guide & Best Practices

## INDEX

* [1. Preface](#1-preface)
* [2. Source Code Layout](#2-source-code-layout)
* [3. Syntax](#3-syntax)
* [4. Naming](#4-naming)
* [5. Comments](#5-comments)
* [6. Classes and Modules](#6-classes-and-modules)
* [7. Exceptions](#7-exceptions)
* [8. Collections](#8-collections)
* [9. Strings](#9-strings)
* [10. Regular Expressions](#10-regular-expressions)
* [11. Percent Literals](#11-percent-literals)
* [12. Metaprogramming](#12-metaprogramming)
* [13. Rubygems and RVM (Ruby Version Manager)](#13-Rubygems-and-rvm-ruby-version-manager)
* [14. Tools for development](#14-tools-for-development)
* [15. Testing](#15-testing)
* [16. Project Documentation](#16-project-documentation)
* [17. Development Environments (IDEs)](#17-development-environments-ides)
* [18. References](#18-References)

## 1. Preface

One thing has always bothered ous as a Ruby developer - Python developers have a great programming style reference (PEP-8) and we never got an official guide, documenting Ruby coding style and best practices. 

This guide contains procedures and advices, collected from our experience on the tool over time and extracted of another guides as the original [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide) and [ManageIQ Ruby Style Guide](https://github.com/ManageIQ/ruby-style-guide) to clarify or add points that pertain to the code written.

At this point we're going to talk about Ruby, we're using Ruby to develop apps using coding style and standards for the code written:

* Be consistent.

* These guides describes general guidelines to follow for new code.
  For existing code, stay consistent with the conventions of the code you
  are changing.

* Prefer readability over performance and conciseness when the performance
  difference is minimal.

* If you can convince others why we should violate a guideline, then violate
  the guideline.

* These guides are living documents and are subject to change.  Feel free
  to comment or submit pull requests for changes, additions, or removals.

## 2. Source Code Layout

* Don't use magic comments for encoding, unless it is necessary. 

* Use `UTF-8` as the source file encoding.

* Use two **spaces** per indentation level (aka soft tabs). No hard tabs.

  ```Ruby
  # bad - four spaces
  def some_method
      do_something
  end

  # good
  def some_method
    do_something
  end
  ```

* Use Unix-style line endings. (*BSD/Solaris/Linux/OS X users are covered by default,
  Windows users have to be extra careful.)
  * If you're using Git you might want to add the following
    configuration setting to protect your project from Windows line
    endings creeping in:

    ```bash
    $ git config --global core.autocrlf true
    ```

* Don't use `;` to separate statements and expressions. As a
  corollary - use one expression per line.

  ```Ruby
  # bad
  puts 'foobar'; # superfluous semicolon

  puts 'foo'; puts 'bar' # two expressions on the same line

  # good
  puts 'foobar'

  puts 'foo'
  puts 'bar'

  puts 'foo', 'bar' # this applies to puts in particular
  ```
    
* Prefer a single-line format for class definitions with no body.
  
  ```Ruby
  # bad
  class FooError < StandardError
  end

  # okish
  class FooError < StandardError; end

  # good
  FooError = Class.new(StandardError)
  ```

* Avoid single-line methods. Although they are somewhat popular in the
  wild, there are a few peculiarities about their definition syntax
  that make their use undesirable.
    
  ```Ruby
  # bad
  def too_much; something; something_else; end

  # bad - notice that the first ; is required
  def no_braces_method; body end

  # bad - notice that the second ; is optional
  def no_braces_method; body; end

  # bad - valid syntax, but no ; make it kind of hard to read
  def some_method() body end

  # good
  def some_method
    body
  end
  ```
    
* Use spaces around operators, after commas, colons and semicolons, around `{`
  and before `}`. Whitespace might be (mostly) irrelevant to the Ruby
  interpreter, but its proper use is the key to writing easily
  readable code.
    
  ```Ruby
  sum = 1 + 2
  a, b = 1, 2
  [1, 2, 3].each { |e| puts e }
  class FooError < StandardError; end
  ```

  The only exception, regarding operators, is the exponent operator:
  
  ```Ruby
  # bad
  e = M * c ** 2

  # good
  e = M * c**2
  ```
  
  `{` and `}` deserve a bit of clarification, since they are used
  for block and hash literals, as well as embedded expressions in
  strings. For hash literals two styles are considered acceptable.
  
  ```Ruby
  # okish - space after { and before }
  { :one => 1, :two => 2 }
  
  # good - no space after { and before }, and more consistent in the codebase
  {:one => 1, :two => 2}
  ```
  
  As far as embedded expressions go, there are also two options:
  
  ```Ruby
  # good - no spaces, much more popular in the community
  "string#{expr}"
  
  # bad - arguably more readable, but not consistent in the codebase
  "string#{ expr }"
  ```

* No spaces after `(`, `[` or before `]`, `)`.

  ```Ruby
  some(arg).other
  [1, 2, 3].size
  ```
  
* No space after `!`.
  
  ```Ruby
  # bad
  ! something
  
  # good
  !something
  ```
  
* Indent `when` as deep as `case`. I know that many would disagree
  with this one, but it's the style established in both "The Ruby
  Programming Language" and "Programming Ruby".
  
  ```Ruby
  # bad
  case
    when song.name == 'Misty'
      puts 'Not again!'
    when song.duration > 120
      puts 'Too long!'
    when Time.now.hour > 21
      puts "It's too late"
    else
      song.play
  end
  
  # good
  case
  when song.name == 'Misty'
    puts 'Not again!'
  when song.duration > 120
    puts 'Too long!'
  when Time.now.hour > 21
    puts "It's too late"
  else
    song.play
  end
  ```
  
* When assigning the result of a conditional expression to a variable, preserve
  the usual alignment of its branches.
  
  ```Ruby
  # bad - pretty convoluted
  kind = case year
  when 1850..1889 then 'Blues'
  when 1890..1909 then 'Ragtime'
  when 1910..1929 then 'New Orleans Jazz'
  when 1930..1939 then 'Swing'
  when 1940..1950 then 'Bebop'
  else 'Jazz'
  end
  
  result = if some_cond
    calc_something
  else
    calc_something_else
  end
  
  # good - it's apparent what's going on, however, can get pushed too far over with long variable names.
  kind = case year
         when 1850..1889 then 'Blues'
         when 1890..1909 then 'Ragtime'
         when 1910..1929 then 'New Orleans Jazz'
         when 1930..1939 then 'Swing'
         when 1940..1950 then 'Bebop'
         else 'Jazz'
         end
  
  result = if some_cond
             calc_something
           else
             calc_something_else
           end
  
  # good (and a bit more width efficient)
  kind =
    case year
    when 1850..1889 then 'Blues'
    when 1890..1909 then 'Ragtime'
    when 1910..1929 then 'New Orleans Jazz'
    when 1930..1939 then 'Swing'
    when 1940..1950 then 'Bebop'
    else                 'Jazz'
    end
  
  result =
    if some_cond
      calc_something
    else
      calc_something_else
    end
  ```
  
* Use empty lines between method definitions and also to break up a method
  into logical paragraphs internally.
  
  ```Ruby
  def some_method
    data = initialize(options)

    data.manipulate!

    data.result
  end

  def some_method
    result
  end
  ```
  
* Avoid comma after the last parameter in a method call, especially when the
  parameters are not on separate lines.
  
  ```Ruby
  # bad - easier to move/add/remove parameters, but still not preferred
  some_method(
               size,
               count,
               color,
             )

  # bad
  some_method(size, count, color, )

  # good
  some_method(size, count, color)
  ```

* When using `alias` or `alias_method`, place the call immediately after the method definition.

  ```Ruby
  def some_method
    ...
  end
  alias_method :aliased_method, :some_method

  def some_other_method
    ...
  end
  ```

* Use spaces around the `=` operator when assigning default values to method parameters:

  ```Ruby
  # bad
  def some_method(arg1=:default, arg2=nil, arg3=[])
    # do something...
  end

  # good
  def some_method(arg1 = :default, arg2 = nil, arg3 = [])
    # do something...
  end
  ```

  While several Ruby books suggest the first style, the second is much more prominent
  in practice (and arguably a bit more readable).

* Avoid line continuation `\` where not required.

  ```Ruby
  # bad
  result = 1 - \
           2

  result = 1 \
           - 2

  long_string = 'First part of the long string' \
                ' and second part of the long string'
  ```

* Adopt a consistent multi-line method chaining style. There are two
  popular styles in the Ruby community, both of which are considered
  good - leading `.` (Option A) and trailing `.` (Option B).

  * **(Option A)** When continuing a chained method invocation on
    another line keep the `.` on the second line.

  ```Ruby
  # bad - need to consult first line to understand second line
  one.two.three.
    four

  # good - it's immediately clear what's going on the second line
  one.two.three
    .four
  ```

  * **(Option B)** When continuing a chained method invocation on another line,
    include the `.` on the first line to indicate that the
    expression continues.

  ```Ruby
  # bad - need to read ahead to the second line to know that the chain continues
  one.two.three
    .four

  # good - it's immediately clear that the expression continues beyond the first line
  one.two.three.
    four
  ```

  A discussion on the merits of both alternative styles can be found
  [here](https://github.com/bbatsov/ruby-style-guide/pull/176).

* Align the parameters of a method call if they span more than one
  line. When aligning parameters is not appropriate due to line-length
  constraints, single indent for the lines after the first is also
  acceptable.

  ```Ruby
  # starting point (line is too long)
  def send_mail(source)
    Mailer.deliver(:to => 'bob@example.com', :from => 'us@example.com', :subject => 'Important message', :body => source.text)
  end

  # bad (double indent and trailing parenthesis on the last line)
  def send_mail(source)
    Mailer.deliver(
        :to      => 'bob@example.com',
        :from    => 'us@example.com',
        :subject => 'Important message',
        :body    => source.text)
  end

  # okish - it's apparent what's going on, however, can get pushed too far over with long method names.
  def send_mail(source)
    Mailer.deliver(:to      => 'bob@example.com',
                   :from    => 'us@example.com',
                   :subject => 'Important message',
                   :body    => source.text)
  end

  # good (normal indent)
  def send_mail(source)
    Mailer.deliver(
      :to      => 'bob@example.com',
      :from    => 'us@example.com',
      :subject => 'Important message',
      :body    => source.text
    )
  end
  ```

* Align the elements of array literals spanning multiple lines.

  ```Ruby
  # bad - single indent
  menu_item = ['Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam',
    'Baked beans', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam']

  # good
  menu_item =
    ['Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam',
     'Baked beans', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam']

  # good
  menu_item = [
    'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam',
    'Baked beans', 'Spam', 'Spam', 'Spam', 'Spam', 'Spam'
  ]
  ```

* Add underscores to large numeric literals to improve their readability.

  ```Ruby
  # bad - how many 0s are there?
  num = 1000000

  # good - much easier to parse for the human brain
  num = 1_000_000
  ```

* Do not limit lines to a hard value of 80 characters, however, be reasonable
  with line lengths.  Once you hit around 100-120 characters, you should
  consider why your line is so long, and perhaps use intermediate variables,
  methods, or other techniques to make the code more readable.

* Avoid trailing whitespace.

* End each file with a newline.  If you are using an editor that manipulates
  this, please be sure it doesn't remove the newline.
  * In Sublime Text, the user setting is called "ensure_newline_at_eof_on_save"
    and should be set to true.

* Don't use block comments. They cannot be preceded by whitespace and are not
  as easy to spot as regular comments.

  ```Ruby
  # bad
  =begin
  comment line
  another comment line
  =end

  # good
  # comment line
  # another comment line
  ```

## 3. Syntax

* Use `::` only to reference constants(this includes classes and
  modules) and constructors (like `Array()` or `Nokogiri::HTML()`).
  Never use `::` for regular method invocation.

  ```Ruby
  # bad
  SomeClass::some_method
  some_object::some_method

  # good
  SomeClass.some_method
  some_object.some_method
  SomeModule::SomeClass::SOME_CONST
  SomeModule::SomeClass()
  ```

* Use `def` with parentheses when there are arguments. Omit the
  parentheses when the method doesn't accept any arguments.

   ```Ruby
   # bad
   def some_method()
     # body omitted
   end

   # good
   def some_method
     # body omitted
   end

   # bad
   def some_method_with_arguments arg1, arg2
     # body omitted
   end

   # good
   def some_method_with_arguments(arg1, arg2)
     # body omitted
   end
   ```

* Never use `for`, unless you know exactly why. Most of the time iterators
  should be used instead. `for` is implemented in terms of `each` (so
  you're adding a level of indirection), but with a twist - `for`
  doesn't introduce a new scope (unlike `each`) and variables defined
  in its block will be visible outside it.

  ```Ruby
  arr = [1, 2, 3]

  # bad
  for elem in arr do
    puts elem
  end

  # note that elem is accessible outside of the for loop
  elem #=> 3

  # good
  arr.each { |elem| puts elem }

  # elem is not accessible outside each's block
  elem #=> NameError: undefined local variable or method `elem'
  ```

* Never use `then` for multi-line `if/unless`.

  ```Ruby
  # bad
  if some_condition then
    # body omitted
  end

  # good
  if some_condition
    # body omitted
  end
  ```

* Always put the condition on the same line as the `if`/`unless` in a multi-line conditional.

  ```Ruby
  # bad
  if
    some_condition
    do_something
    do_something_else
  end

  # good
  if some_condition
    do_something
    do_something_else
  end
  ```

* Favor the ternary operator(`?:`) over `if/then/else/end` constructs.
  It's more common and obviously more concise.

  ```Ruby
  # bad
  result = if some_condition then something else something_else end

  # good
  result = some_condition ? something : something_else
  ```

* Use one expression per branch in a ternary operator. This
  also means that ternary operators must not be nested. Prefer
  `if/else` constructs in these cases.

  ```Ruby
  # bad
  some_condition ? (nested_condition ? nested_something : nested_something_else) : something_else

  # good
  if some_condition
    nested_condition ? nested_something : nested_something_else
  else
    something_else
  end
  ```

* Never use single line if statement with a semicolon: `if x; ...`. Use the ternary operator instead.

* Never use `if x: ...` - as of Ruby 1.9 it has been removed. Use
  the ternary operator instead.

  ```Ruby
  # bad
  result = if some_condition: something else something_else end

  # good
  result = some_condition ? something : something_else
  ```

* Never use `if x; ...`. Use the ternary operator instead.

* Leverage the fact that `if` and `case` are expressions which return a result.

  ```Ruby
  # bad
  if condition
    result = x
  else
    result = y
  end

  # good
  result =
    if condition
      x
    else
      y
    end
  ```

* Use `when x then ...` for one-line cases. The alternative syntax
  `when x: ...` has been removed as of Ruby 1.9.

* Never use `when x; ...`. See the previous rule.

  ```Ruby
  # okish
  case year
  when 1850..1889; 'Blues'
  when 1890..1909; 'Ragtime'
  else             'Jazz'
  end

  # good
  case year
  when 1850..1889 then 'Blues'
  when 1890..1909 then 'Ragtime'
  else                 'Jazz'
  end
  ```

* Use `!` instead of `not`.

  ```Ruby
  # bad - braces are required because of op precedence
  x = (not something)

  # good
  x = !something
  ```

* Avoid the use of `!!`, except when writing `?` methods, where returning a Boolean is required.

  ```Ruby
  # bad
  x = 'test'
  # obscure nil check
  if !!x
    # body omitted
  end

  x = false
  # double negation is useless on booleans
  !!x # => false

  # good
  x = 'test'
  unless x.nil?
    # body omitted
  end

  # good
  def x_is_good?
    !!x
  end
  ```

* The `and` and `or` keywords are banned. It's just not worth
  it. Always use `&&` and `||` instead.

  ```Ruby
  # bad
  # boolean expression
  if some_condition and some_other_condition
    do_something
  end

  # control flow
  document.saved? or document.save!

  # good
  # boolean expression
  if some_condition && some_other_condition
    do_something
  end

  # control flow
  document.saved? || document.save!
  ```

* Avoid multi-line `?:` (the ternary operator); use `if/unless` instead.

* Favor modifier `if/unless` usage when you have a single-line
  body. Another good alternative is the usage of control flow `&&/||`.

  ```Ruby
  # bad
  if some_condition
    do_something
  end

  # good
  do_something if some_condition

  # another good option
  some_condition && do_something
  ```

* Avoid modifier `if/unless` usage at the end of a
  non-trivial multi-line block.

  ```Ruby
  # bad
  10.times do
    # multi-line body omitted
  end if some_condition

  # good
  if some_condition
    10.times do
      # multi-line body omitted
    end
  end
  ```

* Favor `unless` over `if` for negative conditions (or control
  flow `||`).

  ```Ruby
  # bad
  do_something if !some_condition

  # bad
  do_something if not some_condition

  # good
  do_something unless some_condition

  # another good option
  some_condition || do_something
  ```

* Avoid double and triple negatives with if/unless

  ```Ruby
  # bad
  do_something unless !some_conditions
  do_something unless !x.nil?
  do_something if !x.nil?

  # good
  do_something if some_conditions
  do_something if x.nil?
  do_something unless x.nil?  # or perhaps "if x", if we know x is never a Boolean
  ```

* Never use `unless` with `else`. Rewrite these with the positive case first.

  ```Ruby
  # bad
  unless success?
    puts 'failure'
  else
    puts 'success'
  end

  # good
  if success?
    puts 'success'
  else
    puts 'failure'
  end
  ```

* Don't use parentheses around the condition of an `if/unless/while/until`.

  ```Ruby
  # bad
  if (x > 10)
    # body omitted
  end

  # good
  if x > 10
    # body omitted
  end
  ```

* Never use `while/until condition do` for multi-line `while/until`.

  ```Ruby
  # bad
  while x > 5 do
    # body omitted
  end

  until x > 5 do
    # body omitted
  end

  # good
  while x > 5
    # body omitted
  end

  until x > 5
    # body omitted
  end
  ```

* Favor modifier `while/until` usage when you have a single-line
  body.

  ```Ruby
  # bad
  while some_condition
    do_something
  end

  # good
  do_something while some_condition
  ```

* Favor `until` over `while` for negative conditions.

  ```Ruby
  # bad
  do_something while !some_condition

  # good
  do_something until some_condition
  ```

* Use `Kernel#loop` instead of `while/until` when you need an infinite loop.

    ```ruby
    # bad
    while true
      do_something
    end

    while false
      do_something
    end

    # good
    loop do
      do_something
    end
    ```

* Use `Kernel#loop` with `break` rather than `begin/end/until` or `begin/end/while` for post-loop tests.

  ```Ruby
  # bad
  begin
    puts val
    val += 1
  end while val < 0

  # good
  loop do
    puts val
    val += 1
    break unless val < 0
  end
  ```

* Omit parentheses around parameters for methods that are part of an
  internal DSL (e.g. Rake, Rails, RSpec), methods that have
  "keyword" status in Ruby (e.g. `attr_reader`, `puts`) and attribute
  access methods. Use parentheses around the arguments of all other
  method invocations.

  ```Ruby
  class Person
    attr_reader :name, :age

    # omitted
  end

  temperance = Person.new('Temperance', 30)
  temperance.name

  puts temperance.age

  x = Math.sin(y)
  array.delete(e)

  bowling.score.should == 0
  ```

* Omit the outer braces around an implicit options hash.

  ```Ruby
  # bad
  user.set({ :name => 'John', :age => 45, :permissions => { :read => true } })

  # good
  user.set(:name => 'John', :age => 45, :permissions => { :read => true })
  ```

* Omit both the outer braces and parentheses for methods that are
  part of an internal DSL.

  ```Ruby
  class Person < ActiveRecord::Base
    # bad
    validates(:name, { :presence => true, :length => { :within => 1..10 } })

    # good
    validates :name, :presence => true, :length => { :within => 1..10 }
  end
  ```

* Omit parentheses for method calls with no arguments.

  ```Ruby
  # bad
  Kernel.exit!()
  2.even?()
  fork()
  'test'.upcase()

  # good
  Kernel.exit!
  2.even?
  fork
  'test'.upcase
  ```

* Prefer `{...}` over `do...end` for single-line blocks.  Avoid using
  `{...}` for multi-line blocks (multiline chaining is always
  ugly). Always use `do...end` for "control flow" and "method
  definitions" (e.g. in Rakefiles and certain DSLs).  Avoid `do...end`
  when chaining.

  ```Ruby
  names = ['Bozhidar', 'Steve', 'Sarah']

  # bad
  names.each do |name|
    puts name
  end

  # good
  names.each { |name| puts name }

  # bad
  names.select do |name|
    name.start_with?('S')
  end.map { |name| name.upcase }

  # good
  names.select { |name| name.start_with?('S') }.map { |name| name.upcase }
  ```

  Some will argue that multiline chaining would look OK with the use of {...}, but they should
  ask themselves - is this code really readable and can the blocks' contents be extracted into
  nifty methods?

* Prefer Symbol#to_proc (`&` operator on a Symbol) for simple block passing cases.

  ```Ruby
  # ok
  names.map { |name| name.upcase }

  # good
  names.map(&:upcase)
  ```

* Consider using explicit block argument to avoid writing block
  literal that just passes its arguments to another block. Beware of
  the performance impact, though, as the block gets converted to a
  Proc.

  ```Ruby
  require 'tempfile'

  # bad
  def with_tmp_dir
    Dir.mktmpdir do |tmp_dir|
      Dir.chdir(tmp_dir) { |dir| yield dir }  # block just passes arguments
    end
  end

  # good
  def with_tmp_dir(&block)
    Dir.mktmpdir do |tmp_dir|
      Dir.chdir(tmp_dir, &block)
    end
  end

  with_tmp_dir do |dir|
    puts "dir is accessible as a parameter and pwd is set: #{dir}"
  end
  ```

* Avoid `return` where not required for flow of control.

  ```Ruby
  # bad
  def some_method(some_arr)
    return some_arr.size
  end

  # good
  def some_method(some_arr)
    some_arr.size
  end
  ```

* Avoid `self` where not required. (It is only required when calling a self write accessor.)

  ```Ruby
  # bad
  def ready?
    if self.last_reviewed_at > self.last_updated_at
      self.worker.update(self.content, self.options)
      self.status = :in_progress
    end
    self.status == :verified
  end

  # good
  def ready?
    if last_reviewed_at > last_updated_at
      worker.update(content, options)
      self.status = :in_progress
    end
    status == :verified
  end
  ```

* As a corollary, avoid shadowing methods with local variables unless they are both equivalent.

  ```Ruby
  class Foo
    attr_accessor :options

    # ok
    def initialize(options)
      self.options = options
      # both options and self.options are equivalent here
    end

    # bad
    def do_something(options = {})
      unless options[:when] == :later
        output(self.options[:message])
      end
    end

    # good
    def do_something(params = {})
      unless params[:when] == :later
        output(options[:message])
      end
    end
  end
  ```

* Don't use the return value of `=` (an assignment) in conditional
  expressions unless the assignment is wrapped in parentheses. This is
  a fairly popular idiom among Rubyists that's sometimes referred to as
  *safe assignment in condition*.

  ```Ruby
  # bad (+ a warning)
  if v = array.grep(/foo/)
    do_something(v)
    ...
  end

  # good (MRI would still complain, but RuboCop won't)
  if (v = array.grep(/foo/))
    do_something(v)
    ...
  end

  # good
  v = array.grep(/foo/)
  if v
    do_something(v)
    ...
  end
  ```

* Use shorthand self assignment operators whenever applicable.

  ```Ruby
  # bad
  x = x + y
  x = x * y
  x = x**y
  x = x / y
  x = x || y
  x = x && y

  # good
  x += y
  x *= y
  x **= y
  x /= y
  x ||= y
  x &&= y
  ```

* Use `||=` to initialize variables only if they're not already initialized.

  ```Ruby
  # bad
  name = name ? name : 'Bozhidar'

  # bad
  name = 'Bozhidar' unless name

  # good - set name to Bozhidar, only if it's nil or false
  name ||= 'Bozhidar'
  ```

* Don't use `||=` to initialize boolean variables. (Consider what
  would happen if the current value happened to be `false`.)

  ```Ruby
  # bad - would set enabled to true even if it was false
  enabled ||= true

  # good
  enabled = true if enabled.nil?
  ```

* Use `&&=` to preprocess variables that may or may not exist. Using
  `&&=` will change the value only if it exists, removing the need to
  check its existence with `if`.

  ```Ruby
  # bad
  if something
    something = something.downcase
  end

  # bad
  something = something ? nil : something.downcase

  # ok
  something = something.downcase if something

  # good
  something = something && something.downcase

  # better
  something &&= something.downcase
  ```

* Avoid explicit use of the case equality operator `===`. As its name
  implies it is meant to be used implicitly by `case` expressions and
  outside of them it yields some pretty confusing code.

  ```Ruby
  # bad
  Array === something
  (1..100) === 7
  /something/ === some_string

  # good
  something.is_a?(Array)
  (1..100).include?(7)
  some_string =~ /something/
  ```

* Avoid using Perl-style special variables (like `$:`, `$;`,
  etc. ). They are quite cryptic and their use in anything but
  one-liner scripts is discouraged. Use the human-friendly
  aliases provided by the `English` library.

  ```Ruby
  # bad
  $:.unshift File.dirname(__FILE__)

  # good
  require 'English'
  $LOAD_PATH.unshift File.dirname(__FILE__)
  ```

* Never put a space between a method name and the opening parenthesis.

  ```Ruby
  # bad
  f (3 + 2) + 1

  # good
  f(3 + 2) + 1
  ```

* If the first argument to a method begins with an open parenthesis,
  always use parentheses in the method invocation. For example, write
  `f((3 + 2) + 1)`.

* Always run the Ruby interpreter with the `-w` option so it will warn
  you if you forget either of the rules above!

* Prefer the new lambda literal syntax for single line body blocks. Always use the
  `lambda` method for multi-line blocks.

  ```Ruby
  # bad
  l = lambda { |a, b| a + b }
  l.call(1, 2)

  # correct, but looks extremely awkward
  l = ->(a, b) do
    tmp = a * 7
    tmp * b / 50
  end

  # good
  l = ->(a, b) { a + b }
  l.call(1, 2)

  l = lambda do |a, b|
    tmp = a * 7
    tmp * b / 50
  end
  ```

* Prefer `proc` over `Proc.new`.

  ```Ruby
  # bad
  p = Proc.new { |n| puts n }

  # good
  p = proc { |n| puts n }
  ```

* Prefer `proc.call()` over `proc[]` or `proc.()` for both lambdas and procs.

  ```Ruby
  # bad - looks similar to Enumeration access
  l = ->(v) { puts v }
  l[1]

  # also bad - uncommon syntax
  l = ->(v) { puts v }
  l.(1)

  # good
  l = ->(v) { puts v }
  l.call(1)
  ```

* Prefix with `_` unused block parameters and local variables. It's
  also acceptable to use just `_` (although it's a bit less
  descriptive). This convention is recognized by the Ruby interpreter
  and tools like RuboCop and will suppress their unused variable warnings.

  ```Ruby
  # bad
  result = hash.map { |k, v| v + 1 }

  def something(x)
    unused_var, used_var = something_else(x)
    # ...
  end

  # good
  result = hash.map { |_k, v| v + 1 }

  def something(x)
    _unused_var, used_var = something_else(x)
    # ...
  end

  # good
  result = hash.map { |_, v| v + 1 }

  def something(x)
    _, used_var = something_else(x)
    # ...
  end
  ```

* Use `$stdout/$stderr/$stdin` instead of
  `STDOUT/STDERR/STDIN`. `STDOUT/STDERR/STDIN` are constants, and
  while you can actually reassign (possibly to redirect some stream)
  constants in Ruby, you'll get an interpreter warning if you do so.

* Use `warn` instead of `$stderr.puts`. Apart from being more concise
  and clear, `warn` allows you to suppress warnings if you need to (by
  setting the warn level to 0 via `-W0`).

* Favor the use of `sprintf` and its alias `format` over the fairly
  cryptic `String#%` method.

  ```Ruby
  # bad
  '%d %d' % [20, 10]
  # => '20 10'

  # good
  sprintf('%d %d', 20, 10)
  # => '20 10'

  # good
  sprintf('%{first} %{second}', :first => 20, :second => 10)
  # => '20 10'

  format('%d %d', 20, 10)
  # => '20 10'

  # good
  format('%{first} %{second}', :first => 20, :second => 10)
  # => '20 10'
  ```

* Favor the use of `Array#join` over the fairly cryptic `Array#*` with
  a string argument.

  ```Ruby
  # bad
  %w(one two three) * ', '
  # => 'one, two, three'

  # good
  %w(one two three).join(', ')
  # => 'one, two, three'
  ```

* Use `[*var]` or `Array()` instead of explicit `Array` check, when dealing with a
  variable you want to treat as an Array, but you're not certain it's
  an array.

  ```Ruby
  # bad
  paths = [paths] unless paths.is_a? Array
  paths.each { |path| do_something(path) }

  # good
  [*paths].each { |path| do_something(path) }

  # good (and a bit more readable)
  Array(paths).each { |path| do_something(path) }
  ```

* Use ranges or `Comparable#between?` instead of complex comparison logic when possible.

  ```Ruby
  # bad
  do_something if x >= 1000 && x <= 2000

  # good
  do_something if (1000..2000).include?(x)

  # good
  do_something if x.between?(1000, 2000)
  ```

* When comparing Time objects, do not use Range#include? due to performance issues.
  Instead use Range#cover?

* Favor the use of predicate methods to explicit comparisons with
  `==`. Numeric comparisons are OK.

  ```Ruby
  # bad
  if x % 2 == 0
  end

  if x % 2 == 1
  end

  if x == nil
  end

  # good
  if x.even?
  end

  if x.odd?
  end

  if x.nil?
  end

  if x.zero?
  end

  if x == 0
  end
  ```

* Don't do explicit non-`nil` checks unless you're dealing with boolean values.

  ```ruby
  # bad
  do_something if !something.nil?
  do_something if something != nil

  # good
  do_something if something

  # good - dealing with a boolean
  def value_set?
    !@some_boolean.nil?
  end
  ```

* Avoid the use of `BEGIN` blocks.

* Never use `END` blocks. Use `Kernel#at_exit` instead.

  ```ruby
  # bad
  END { puts 'Goodbye!' }

  # good
  at_exit { puts 'Goodbye!' }
  ```

* Avoid the use of flip-flops.

* Avoid use of nested conditionals for flow of control.
  Prefer a guard clause when you can assert invalid data. A guard clause is a conditional
  statement at the top of a function that bails out as soon as it can.
  Avoid returns in the middle of a method.  Try to have all code use the last expression of the method as the return.

  ```Ruby
  # bad
  def compute_thing(thing)
    if thing[:foo]
      update_with_bar(thing)
      if thing[:foo][:bar]
        partial_compute(thing)
      else
        re_compute(thing)
      end
    end
  end

  # okish - returns in the middle of the method
  def compute_thing(thing)
    return unless thing[:foo]

    update_with_bar(thing[:foo])
    return re_compute(thing) unless thing[:foo][:bar]
    partial_compute(thing)
  end

  # good
  def compute_thing(thing)
    return unless thing[:foo]

    update_with_bar(thing[:foo])
    if thing[:foo][:bar]
      partial_compute(thing)
    else
      re_compute(thing)
    end
  end
  ```
  
## 4. Naming

* Name identifiers in English.

  ```Ruby
  # bad - identifier using non-ascii characters
  заплата = 1_000

  # bad - identifier is a Bulgarian word, written with Latin letters (instead of Cyrillic)
  zaplata = 1_000

  # good
  salary = 1_000
  ```

* Use `snake_case` for symbols, methods and variables.

  ```Ruby
  # bad
  :'some symbol'
  :SomeSymbol
  :someSymbol

  someVar = 5

  def someMethod
    ...
  end

  def SomeMethod
   ...
  end

  # good
  :some_symbol

  def some_method
    ...
  end
  ```

* Use `CamelCase` for classes and modules.  (Keep acronyms like HTTP,
  RFC, XML uppercase.)

  ```Ruby
  # bad
  class Someclass
    ...
  end

  class Some_Class
    ...
  end

  class SomeXml
    ...
  end

  # good
  class SomeClass
    ...
  end

  class SomeXML
    ...
  end
  ```

* Use `snake_case` for naming files, e.g. `hello_world.rb`.

* Use `snake_case` for naming directories, e.g. `lib/hello_world/hello_world.rb`.

* Aim to have just a single class/module per source file. Name the file name as
  the class/module, but replacing CamelCase with snake_case.

* Use `SCREAMING_SNAKE_CASE` for other constants.

  ```Ruby
  # bad
  SomeConst = 5

  # good
  SOME_CONST = 5
  ```

* The names of predicate methods (methods that return a boolean value)
  should end in a question mark.
  (i.e. `Array#empty?`). Methods that don't return a boolean, shouldn't
  end in a question mark.

* The names of potentially *dangerous* methods (i.e. methods that
  modify `self` or the arguments, `exit!` (doesn't run the finalizers
  like `exit` does), etc.) should end with an exclamation mark if
  there exists a safe version of that *dangerous* method.

  ```Ruby
  # bad - there is no matching 'safe' method
  class Person
    def update!
    end
  end

  # good
  class Person
    def update
    end
  end

  # good
  class Person
    def update!
    end

    def update
    end
  end
  ```

* Define the non-bang (safe) method in terms of the bang (dangerous)
  one if possible.

  ```Ruby
  class Array
    def flatten_once!
      res = []

      each do |e|
        [*e].each { |f| res << f }
      end

      replace(res)
    end

    def flatten_once
      dup.flatten_once!
    end
  end
  ```

* When using `inject` with short blocks, consider naming the arguments `|a, e|`
  (accumulator, element) or `|m, o|` (memo, object)

* When defining binary operators, name the argument `other`(`<<` and
  `[]` are exceptions to the rule, since their semantics are different).

  ```Ruby
  def +(other)
    # body omitted
  end
  ```

* Prefer `collect` over `map`, `detect` over `find`, `select` over `find_all`,
  `inject` over `reduce`. This is not a hard requirement; if the use of the
  alias enhances readability, it's ok to use it. The rhyming methods are
  inherited from Smalltalk and are not common in other programming languages, so
  their use may be more appropriate in code that deals in cross-language
  concerns. The reason the use of `select` is encouraged over `find_all` is that
  it goes together nicely with `reject` and its name is pretty self-explanatory.
  In addition, Rails overloaded the `find` and `find_all` methods, so their use
  in Rails code can get confusing.

* Don't use `count` as a substitute for `size`. For `Enumerable`
  objects other than `Array` it will iterate the entire collection in
  order to determine its size.

  ```Ruby
  # bad
  some_hash.count

  # good
  some_hash.size
  ```

* Use `flat_map` instead of `map` + `flatten`.
  This does not apply for arrays with a depth greater than 2, i.e.
  if `users.first.songs == ['a', ['b','c']]`, then use `map + flatten` rather than `flat_map`.
  `flat_map` flattens the array by 1, whereas `flatten` flattens it all the way.

  ```Ruby
  # bad
  all_songs = users.map(&:songs).flatten.uniq

  # good
  all_songs = users.flat_map(&:songs).uniq
  ```

* Use `reverse_each` instead of `reverse.each`. `reverse_each` doesn't
  do a new array allocation and that's a good thing.

  ```Ruby
  # bad
  array.reverse.each { ... }

  # good
  array.reverse_each { ... }
  ```

## 5. Comments

* Write self-documenting code and ignore the rest of this section. Seriously!

* Write comments in English.

* Use one space between the leading `#` character of the comment and the text
  of the comment.

* Comments longer than a word are capitalized and use punctuation. Use [one
  space](http://en.wikipedia.org/wiki/Sentence_spacing) after periods.

* Avoid superfluous comments.

  ```Ruby
  # bad
  counter += 1 # Increments counter by one.
  ```

* Keep existing comments up-to-date. An outdated comment is worse than no comment
  at all.

* Avoid writing comments to explain bad code. Refactor the code to
  make it self-explanatory. (Do or do not - there is no try. --Yoda)

* Use [YARD](http://yardoc.org/) and its conventions for API documentation.  Don't put an
  empty line between the comment block and the `def`.
  
* Don't use block comments. They cannot be preceded by whitespace and are not
as easy to spot as regular comments.

  ```Ruby
  # bad
  == begin
  comment line
  another comment line
  == end

  # good
  # comment line
  # another comment line

## 6. Classes and Modules

* Use a consistent structure in your class definitions.

  ```Ruby
  class Person
    # extend and include go first
    extend SomeModule
    include AnotherModule

    # inner classes
    CustomErrorKlass = Class.new(StandardError)

    # constants are next
    SOME_CONSTANT = 20

    # afterwards we have attribute macros
    attr_reader :name

    # followed by other macros (if any)
    validates :name

    # public class methods are next in line
    def self.some_method
    end

    # followed by public instance methods
    def some_method
    end

    # protected and private methods are grouped near the end
    protected

    def some_protected_method
    end

    private

    def some_private_method
    end
  end
  ```

* Don't nest multi line classes within classes. Try to have such nested
  classes each in their own file in a folder named like the containing class.

  ```Ruby
  # bad

  # foo.rb
  class Foo
    class Bar
      # 30 methods inside
    end

    class Car
      # 20 methods inside
    end

    # 30 methods inside
  end

  # good

  # foo.rb
  class Foo
    # 30 methods inside
  end

  # foo/bar.rb
  class Foo
    class Bar
      # 30 methods inside
    end
  end

  # foo/car.rb
  class Foo
    class Car
      # 20 methods inside
    end
  end
  ```

* Prefer modules to classes with only class methods. Classes should be
  used only when it makes sense to create instances out of them.

  ```Ruby
  # bad
  class SomeClass
    def self.some_method
      # body omitted
    end

    def self.some_other_method
    end
  end

  # good
  module SomeClass
    module_function

    def some_method
      # body omitted
    end

    def some_other_method
    end
  end
  ```

* Favor the use of `module_function` over `extend self` when you want
  to turn a module's instance methods into class methods.

  ```Ruby
  # bad
  module Utilities
    extend self

    def parse_something(string)
      # do stuff here
    end

    def other_utility_method(number, string)
      # do some more stuff
    end
  end

  # good
  module Utilities
    module_function

    def parse_something(string)
      # do stuff here
    end

    def other_utility_method(number, string)
      # do some more stuff
    end
  end
  ```

* When designing class hierarchies make sure that they conform to the
  [Liskov Substitution Principle](http://en.wikipedia.org/wiki/Liskov_substitution_principle).

* Try to make your classes as
  [SOLID](http://en.wikipedia.org/wiki/SOLID_\(object-oriented_design\))
  as possible.

* Always supply a proper `to_s` method for classes that represent
  domain objects.

  ```Ruby
  class Person
    attr_reader :first_name, :last_name

    def initialize(first_name, last_name)
      @first_name = first_name
      @last_name = last_name
    end

    def to_s
      "#{@first_name} #{@last_name}"
    end
  end
  ```

* Use the `attr` family of functions to define trivial accessors or mutators.

  ```Ruby
  # bad
  class Person
    def initialize(first_name, last_name)
      @first_name = first_name
      @last_name = last_name
    end

    def first_name
      @first_name
    end

    def last_name
      @last_name
    end
  end

  # good
  class Person
    attr_reader :first_name, :last_name

    def initialize(first_name, last_name)
      @first_name = first_name
      @last_name = last_name
    end
  end
  ```

* Avoid the use of `attr`. Use `attr_reader` and `attr_accessor` instead.

  ```Ruby
  # bad - creates a single attribute accessor (deprecated in 1.9)
  attr :something, true
  attr :one, :two, :three # behaves as attr_reader

  # good
  attr_accessor :something
  attr_reader :one, :two, :three
  ```

* Consider using `Struct.new`, which defines the trivial accessors,
  constructor and comparison operators for you.

  ```Ruby
  # good
  class Person
    attr_accessor :first_name, :last_name

    def initialize(first_name, last_name)
      @first_name = first_name
      @last_name = last_name
    end
  end

  # better
  Person = Struct.new(:first_name, :last_name) do
  end
  ````

* Don't extend a `Struct.new` - it already is a new class. Extending it introduces
  a superfluous class level and may also introduce weird errors if the file is
  required multiple times.

* Consider adding factory methods to provide additional sensible ways
  to create instances of a particular class.

  ```Ruby
  class Person
    def self.create(options_hash)
      # body omitted
    end
  end
  ```

* Prefer [duck-typing](http://en.wikipedia.org/wiki/Duck_typing) over inheritance.

  ```Ruby
  # bad
  class Animal
    # abstract method
    def speak
    end
  end

  # extend superclass
  class Duck < Animal
    def speak
      puts 'Quack! Quack'
    end
  end

  # extend superclass
  class Dog < Animal
    def speak
      puts 'Bau! Bau!'
    end
  end

  # good
  class Duck
    def speak
      puts 'Quack! Quack'
    end
  end

  class Dog
    def speak
      puts 'Bau! Bau!'
    end
  end
  ```

* Avoid the usage of class (`@@`) variables due to their "nasty" behavior in inheritance.

  ```Ruby
  class Parent
    @@class_var = 'parent'

    def self.print_class_var
      puts @@class_var
    end
  end

  class Child < Parent
    @@class_var = 'child'
  end

  Parent.print_class_var # => will print "child"
  ```

  As you can see all the classes in a class hierarchy actually share one
  class variable. Class instance variables should usually be preferred
  over class variables.

* Assign proper visibility levels to methods (`private`, `protected`)
  in accordance with their intended usage. Don't go off leaving
  everything `public` (which is the default).

* Indent the `public`, `protected`, and `private` methods as much the
  method definitions they apply to. Leave one blank line above the
  visibility modifier
  and one blank line below in order to emphasize that it applies to all
  methods below it.

  ```Ruby
  class SomeClass
    def public_method
      # ...
    end

    private

    def private_method
      # ...
    end

    def another_private_method
      # ...
    end
  end
  ```

* Use `def self.method` to define singleton methods. This makes the code
  easier to refactor since the class name is not repeated.

  ```Ruby
  class TestClass
    # bad
    def TestClass.some_method
      # body omitted
    end

    # good
    def self.some_other_method
      # body omitted
    end

    # Also possible and convenient when you have to define many singleton
    # methods, however after too many lines of methods, you visually lose the
    # self context, leading to them looking like instance methods.
    class << self
      def first_method
        # body omitted
      end

      def second_method_etc
        # body omitted
      end
    end
  end
  ```

## 7. Exceptions

* Don't specify `RuntimeError` explicitly in the two argument version of `fail/raise`.

  ```Ruby
  # bad
  raise RuntimeError, 'message'

  # good - signals a RuntimeError by default
  raise 'message'
  ```

* Prefer supplying an exception class and a message as two separate
  arguments to `fail/raise`, instead of an exception instance.

  ```Ruby
  # bad
  raise SomeException.new('message')
  # Note that there is no way to do `raise SomeException.new('message'), backtrace`.

  # good
  raise SomeException, 'message'
  # Consistent with `raise SomeException, 'message', backtrace`.
  ```

* Never return from an `ensure` block. If you explicitly return from a
  method inside an `ensure` block, the return will take precedence over
  any exception being raised, and the method will return as if no
  exception had been raised at all. In effect, the exception will be
  silently thrown away.

  ```Ruby
  def foo
    begin
      fail
    ensure
      return 'very bad idea'
    end
  end
  ```

* Use *implicit begin blocks* where possible.

  ```Ruby
  # bad
  def foo
    begin
      # main logic goes here
    rescue
      # failure handling goes here
    end
  end

  # good
  def foo
    # main logic goes here
  rescue
    # failure handling goes here
  end
  ```

* Mitigate the proliferation of `begin` blocks by using
  *contingency methods* (a term coined by Avdi Grimm).

  ```Ruby
  # bad
  begin
    something_that_might_fail
  rescue IOError
    # handle IOError
  end

  begin
    something_else_that_might_fail
  rescue IOError
    # handle IOError
  end

  # good
  def with_io_error_handling
     yield
  rescue IOError
    # handle IOError
  end

  with_io_error_handling { something_that_might_fail }

  with_io_error_handling { something_else_that_might_fail }
  ```

* Don't suppress exceptions.

  ```Ruby
  # bad
  begin
    # an exception occurs here
  rescue SomeError
    # the rescue clause does absolutely nothing
  end

  # bad
  do_something rescue nil
  ```

* Avoid using `rescue` in its modifier form.

  ```Ruby
  # bad - this catches exceptions of StandardError class and its descendant classes
  read_file rescue handle_error($!)

  # good - this catches only the exceptions of Errno::ENOENT class and its descendant classes
  def foo
    read_file
  rescue Errno::ENOENT => ex
    handle_error(ex)
  end
  ```

* Don't use exceptions for flow of control.

  ```Ruby
  # bad
  begin
    n / d
  rescue ZeroDivisionError
    puts 'Cannot divide by 0!'
  end

  # good
  if d.zero?
    puts 'Cannot divide by 0!'
  else
    n / d
  end
  ```

* Avoid rescuing the `Exception` class.  This will trap signals and calls to
  `exit`, requiring you to `kill -9` the process.

  ```Ruby
  # bad
  begin
    # calls to exit and kill signals will be caught (except kill -9)
    exit
  rescue Exception
    puts "you didn't really want to exit, right?"
    # exception handling
  end

  # good
  begin
    # a blind rescue rescues from StandardError, not Exception as many
    # programmers assume.
  rescue => e
    # exception handling
  end

  # also good
  begin
    # an exception occurs here

  rescue StandardError => e
    # exception handling
  end
  ```

* Put more specific exceptions higher up the rescue chain, otherwise
  they'll never be rescued from.

  ```Ruby
  # Given RuntimeError < StandardError

  # bad
  begin
    # some code
  rescue StandardError => e
    # some handling
  rescue RuntimeError => e
    # some handling
  end

  # good
  begin
    # some code
  rescue RuntimeError => e
    # some handling
  rescue StandardError => e
    # some handling
  end
  ```

* Release external resources obtained by your program in an ensure block.

  ```Ruby
  f = File.open('testfile')
  begin
    # .. process
  rescue
    # .. handle error
  ensure
    f.close unless f.nil?
  end
  ```

* Prefer constructs that use blocks that auto-release external resources over separate calls to get/release.

  ```Ruby
  File.open('testfile') do |f|
    begin
      # .. process
    rescue
      # .. handle error
    end
  end
  ```

* Favor the use of exceptions for the standard library over
  introducing new exception classes.

## 8. Collections

* Prefer literal array and hash creation notation (unless you need to
  pass parameters to their constructors, that is).

  ```Ruby
  # bad
  arr = Array.new
  hash = Hash.new

  # good
  arr = []
  hash = {}
  ```

* Prefer `%w` to the literal array syntax when you need an array of
  words (non-empty strings without spaces and special characters in them).
  Apply this rule only to arrays with two or more elements.

  ```Ruby
  # bad
  STATES = ['draft', 'open', 'closed']

  # good
  STATES = %w(draft open closed)
  ```

* Ruby 2.0+ - Prefer `%i` to the literal array syntax when you need an array of
  symbols (and you don't need to maintain Ruby 1.9 compatibility). Apply
  this rule only to arrays with two or more elements.

  ```Ruby
  # bad
  STATES = [:draft, :open, :closed]

  # good
  STATES = %i(draft open closed)
  ```

* Avoid comma after the last item of an `Array` or `Hash` literal, especially
  when the items are not on separate lines.

  ```Ruby
  # bad - easier to move/add/remove items, but still not preferred
  VALUES = [
             1001,
             2020,
             3333,
           ]

  # bad
  VALUES = [1001, 2020, 3333, ]

  # good
  VALUES = [1001, 2020, 3333]
  ```

* Avoid the creation of huge gaps in arrays.

  ```Ruby
  arr = []
  arr[100] = 1 # now you have an array with lots of nils
  ```

* When accessing the first or last element from an array, prefer `first` or `last` over `[0]` or `[-1]`.

* Use `Set` instead of `Array` when dealing with unique elements. `Set`
  implements a collection of unordered values with no duplicates. This
  is a hybrid of `Array`'s intuitive inter-operation facilities and
  `Hash`'s fast lookup.

* Prefer .each.with_object({}) over inject/reduce when accumulating a new Hash.

* Prefer .collect over inject/reduce when accumulating a new Array.

* Prefer symbols instead of strings as hash keys.  However, be aware of memory
  concerns with symbols vs strings. Symbols are not GC'ed, so they take up
  permanent memory, however all symbols "share" the same memory, unlike strings.

  ```Ruby
  # bad
  hash = { 'one' => 1, 'two' => 2, 'three' => 3 }

  # good
  hash = { :one => 1, :two => 2, :three => 3 }
  ```

* Avoid the use of mutable objects as hash keys.

* Do not use the newer Ruby 1.9 Hash literal syntax.

  ```Ruby
  # bad
  hash = { one: 1, two: 2, three: 3 }

  # good
  hash = { :one => 1, :two => 2, :three => 3 }
  ```

* Use `Hash#key?` instead of `Hash#has_key?` and `Hash#value?` instead
  of `Hash#has_value?`. As noted
  [here](http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/43765)
  by Matz, the longer forms are considered deprecated.

  ```Ruby
  # bad
  hash.has_key?(:test)
  hash.has_value?(value)

  # good
  hash.key?(:test)
  hash.value?(value)
  ```

* Consider using `Hash#fetch` when dealing with hash keys that must be present.

  ```Ruby
  heroes = { :batman => 'Bruce Wayne', :superman => 'Clark Kent' }
  # bad - if we make a mistake we might not spot it right away
  heroes[:batman] # => "Bruce Wayne"
  heroes[:supermann] # => nil

  # good - fetch raises a KeyError making the problem obvious
  heroes.fetch(:supermann)
  ```

* Consider using default values for hash keys via `Hash#fetch` as opposed to using custom logic.

  ```Ruby
  batman = { :name => 'Bruce Wayne', :is_evil => false }

  # okish - if we just use || operator with falsy value we won't get the expected result
  batman[:is_evil] || true # => true

  # good - fetch work correctly with falsy values
  batman.fetch(:is_evil, true) # => false
  ```

* Prefer the use of the block instead of the default value in `Hash#fetch`.

  ```Ruby
  batman = { :name => 'Bruce Wayne' }

  # bad - if we use the default value, we eager evaluate it
  # so it can slow the program down if done multiple times
  batman.fetch(:powers, get_batman_powers) # get_batman_powers is an expensive call

  # good - blocks are lazy evaluated, so only triggered in case of KeyError exception
  batman.fetch(:powers) { get_batman_powers }
  ```

* Use `Hash#values_at` when you need to retrieve several values consecutively from a hash.

  ```Ruby
  # bad
  email = data['email']
  nickname = data['nickname']

  # good
  email, username = data.values_at('email', 'nickname')
  ```

* Rely on the fact that as of Ruby 1.9 hashes are ordered.

* Never modify a collection while traversing it.

  ```Ruby
  # bad
  hash.each { |k, v| hash[k] = v + 1 }

  # bad - raises RuntimeError: can't add a new key into hash during iteration
  hash.each { |k, v| hash[:some_new_key] = v }

  # bad - each_key is still traversing the collection
  hash.each_key { |k| hash[k] += 1 }

  # good - keys returns an Array that is a copy of the keys
  hash.keys.each { |k| hash[k] += 1 }
  ```

## 9. Strings

* Prefer string interpolation and string formatting instead of string concatenation:

  ```Ruby
  # bad
  email_with_name = user.name + ' <' + user.email + '>'

  # good
  email_with_name = "#{user.name} <#{user.email}>"

  # good
  email_with_name = format('%s <%s>', user.name, user.email)
  ```

* Adopt a consistent string literal quoting style. There are two
  popular styles in the Ruby community, both of which are considered
  good - single quotes by default (Option A) and double quotes by default (Option B).

  * **(Option A)** Prefer single-quoted strings when you don't need
    string interpolation or special symbols such as `\t`, `\n`, `'`,
    etc.

  ```Ruby
  # bad
  name = "Bozhidar"

  # good
  name = 'Bozhidar'
  ```

  * **(Option B)** Prefer double-quotes unless your string literal
    contains `"` or escape characters you want to suppress.

  ```Ruby
  # bad
  name = 'Bozhidar'

  # good
  name = "Bozhidar"
  ```

  The second style is arguably a bit more popular in the Ruby
  community. The string literals in this guide, however, are
  aligned with the first style.

* Be consistent within string literal quoting style in nearby code, and
  especially within the same line.

  ```Ruby
  # bad - inconsistency in nearby code
  require 'fileutils'
  require "yaml"

  # bad - inconsistency in the same line
  h["key"] = 'value'
  ```

* Don't use the character literal syntax `?x`. Since Ruby 1.9 it's
  basically redundant - `?x` would interpreted as `'x'` (a string with
  a single character in it).

  ```Ruby
  # bad
  char = ?c

  # good
  char = 'c'
  ```

* Don't leave out `{}` around instance and global variables being
  interpolated into a string.

  ```Ruby
  class Person
    attr_reader :first_name, :last_name

    def initialize(first_name, last_name)
      @first_name = first_name
      @last_name = last_name
    end

    # bad - valid, but awkward
    def to_s
      "#@first_name #@last_name"
    end

    # good
    def to_s
      "#{@first_name} #{@last_name}"
    end
  end

  $global = 0
  # bad
  puts "$global = #$global"

  # good
  puts "$global = #{$global}"
  ```

* Don't use `Object#to_s` on interpolated objects. It's invoked on them automatically.

  ```Ruby
  # bad
  message = "This is the #{result.to_s}."

  # good
  message = "This is the #{result}."
  ```

* Avoid using `String#+` when you need to construct large data chunks.
  Instead, use `String#<<`. Concatenation mutates the string instance in-place
  and is always faster than `String#+`, which creates a bunch of new string objects.

  ```Ruby
  # good and also fast
  html = ''
  html << '<h1>Page title</h1>'

  paragraphs.each do |paragraph|
    html << "<p>#{paragraph}</p>"
  end
  ```

* When using heredocs for multi-line strings keep in mind the fact
  that they preserve leading whitespace. Align to the left of the file when you
  want to avoid leading whitespace

  ```Ruby
    def generate
      html = <<-END
  <body>
    <p>
  </body>
      END
      html.chomp
    end
  # => "<body>\n  <p>\n</body>"
  ```

## 10. Regular Expressions

* Don't use regular expressions if you just need plain text search in string:
  `string['text']`, `string.include?('text')`, `string.start_with?('text')`

* For simple constructions you can use regexp directly through string index.

  ```Ruby
  match = string[/regexp/]             # get content of matched regexp
  first_group = string[/text(grp)/, 1] # get content of captured group
  string[/text (grp)/, 1] = 'replace'  # string => 'text replace'
  ```

* Use non-capturing groups when you don't use captured result of parentheses.

  ```Ruby
  /(first|second)/   # bad
  /(?:first|second)/ # good
  ```

* Use the cryptic Perl-legacy variables denoting last regexp group matches
  (`$1`, `$2`, etc), however, consider using `Regexp.last_match[n]` instead.

  ```Ruby
  /(regexp)/ =~ string
  ...

  # okish - very common in our codebase
  process($1)

  # good
  process(Regexp.last_match[1])
  ```

* Avoid using numbered groups as it can be hard to track what they contain. Named groups
  can be used instead.

  ```Ruby
  # bad
  /(regexp)/ =~ string
  ...
  process(Regexp.last_match[1])

  # good
  /(?<meaningful_var>regexp)/ =~ string
  ...
  process(meaningful_var)
  ```

* Character classes have only a few special characters you should care about:
  `^`, `-`, `\`, `]`, so don't escape `.` or brackets in `[]`.

* Be careful with `^` and `$` as they match start/end of line, not string endings.
  If you want to match the whole string use: `\A` and `\z` (not to be
  confused with `\Z` which is the equivalent of `/\n?\z/`).

  ```Ruby
  string = "some injection\nusername"
  string[/^username$/]   # matches
  string[/\Ausername\z/] # doesn't match
  ```

* Use `x` modifier for complex regexps. This makes them more readable and you
  can add some useful comments. Just be careful as spaces are ignored.

  ```Ruby
  regexp = %r{
    start         # some text
    \s            # white space char
    (group)       # first group
    (?:alt1|alt2) # some alternation
    end
  }x
  ```

* For complex replacements `sub`/`gsub` can be used with block or hash.

## 11. Percent Literals

* Use `%()`(it's a shorthand for `%Q`) for single-line strings which require both
  interpolation and embedded double-quotes. For multi-line strings, prefer heredocs.

  ```Ruby
  # bad (no interpolation needed)
  %(<div class="text">Some text</div>)
  # should be '<div class="text">Some text</div>'

  # bad (no double-quotes)
  %(This is #{quality} style)
  # should be "This is #{quality} style"

  # bad (multiple lines)
  %(<div>\n<span class="big">#{exclamation}</span>\n</div>)
  # should be a heredoc.

  # good (requires interpolation, has quotes, single line)
  %(<tr><td class="name">#{name}</td>)
  ```

* Avoid `%q` unless you have a string with both `'` and `"` in
  it. Regular string literals are more readable and should be
  preferred unless a lot of characters would have to be escaped in
  them.

  ```Ruby
  # bad
  name = %q(Bruce Wayne)
  time = %q(8 o'clock)
  question = %q("What did you say?")

  # good
  name = 'Bruce Wayne'
  time = "8 o'clock"
  question = '"What did you say?"'
  ```

* Use `%r` only for regular expressions matching *more than* one '/' character.

  ```Ruby
  # bad
  %r(\s+)

  # still bad
  %r(^/(.*)$)
  # should be /^\/(.*)$/

  # good
  %r(^/blog/2011/(.*)$)
  ```

* Avoid the use of `%x` unless you're going to invoke a command with backquotes in
  it(which is rather unlikely).

  ```Ruby
  # bad
  date = %x(date)

  # good
  date = `date`
  echo = %x(echo `date`)
  ```

* Avoid the use of `%s`. It seems that the community has decided
  `:"some string"` is the preferred way to create a symbol with
  spaces in it.

* Prefer `()` as delimiters for all `%` literals, except `%r`. Since
  braces often appear inside regular expressions in many scenarios a
  less common character like `{` might be a better choice for a
  delimiter, depending on the regexp's content.

  ```Ruby
  # bad
  %w[one two three]
  %q{"Test's king!", John said.}

  # good
  %w(one two three)
  %q("Test's king!", John said.)
  ```

## 12. Metaprogramming

* Avoid needless metaprogramming.

* Do not mess around in core classes when writing libraries.
  (Do not monkey-patch them.)

* The block form of `class_eval` is preferable to the string-interpolated form.
  - when you use the string-interpolated form, always supply `__FILE__` and `__LINE__`,
    so that your backtraces make sense:

  ```ruby
  class_eval 'def use_relative_model_naming?; true; end', __FILE__, __LINE__
  ```

  - `define_method` is preferable to `class_eval{ def ... }`

* When using `class_eval` (or other `eval`) with string interpolation, add a comment block
  showing its appearance if interpolated (a practice used in Rails code):

  ```ruby
  # from activesupport/lib/active_support/core_ext/string/output_safety.rb
  UNSAFE_STRING_METHODS.each do |unsafe_method|
    if 'String'.respond_to?(unsafe_method)
      class_eval <<-EOT, __FILE__, __LINE__ + 1
        def #{unsafe_method}(*args, &block)       # def capitalize(*args, &block)
          to_str.#{unsafe_method}(*args, &block)  #   to_str.capitalize(*args, &block)
        end                                       # end

        def #{unsafe_method}!(*args)              # def capitalize!(*args)
          @dirty = true                           #   @dirty = true
          super                                   #   super
        end                                       # end
      EOT
    end
  end
  ```

* Avoid using `method_missing` for metaprogramming because backtraces become messy,
  the behavior is not listed in `#methods`, and misspelled method calls might silently
  work, e.g. `nukes.launch_state = false`. Consider using delegation, proxy, or
  `define_method` instead. If you must use `method_missing`:

  - Be sure to [also define `respond_to_missing?`](http://blog.marc-andre.ca/2010/11/methodmissing-politely.html)
  - Only catch methods with a well-defined prefix, such as `find_by_*` -- make your code as assertive as possible.
  - Call `super` at the end of your statement
  - Delegate to assertive, non-magical methods:

    ```ruby
    # bad
    def method_missing?(meth, *args, &block)
      if /^find_by_(?<prop>.*)/ =~ meth
        # ... lots of code to do a find_by
      else
        super
      end
    end

    # good
    def method_missing?(meth, *args, &block)
      if /^find_by_(?<prop>.*)/ =~ meth
        find_by(prop, *args, &block)
      else
        super
      end
    end

    # best of all, though, would to define_method as each findable attribute is declared
    ```

## 13. Rubygems and RVM (Ruby Version Manager)

This chapter explains how to add new libraries or packages to the project.

### Rubygems

The RubyGems software allows you to easily download, install, and use ruby software packages on your system. The software package is called a “gem” and contains a package Ruby application or library.

Gems can be used to extend or modify functionality in Ruby applications. Commonly they’re used to distribute reusable functionality that is shared with other Rubyists for use in their applications and libraries. Some gems provide command line utilities to help automate tasks and speed up your work.

The **gem** command allows you to interact with RubyGems.

  ```bash
  gem install <name gem>
  ```

Learn how RubyGems works, and how to make your own, [the documentation link here](http://guides.rubygems.org/).

### RVM (Ruby Version Manager)

RVM stands for the Ruby Version Manager. It is a piece of software that separates your entire Ruby environment in to component parts, separating your interpreter, installed RubyGems, and even docs. This lets you switch between different projects at will and use different versions of Ruby and different sets of gems at will.

In addition to managing Ruby versions (for which it gets its name), RVM also provides other features such as **gemsets**. This allows you not only to segregate Ruby versions, but also different versions of gems between two projects. The classic example of this sort of usage is where gems are not compatible as in Rails 4 and Rails 5.

If you need to install specific versions of Ruby for your application, you can do so with rvm like this:

  ```bash
  rvm install ruby_version
  ```
  
After the installation, we can list the available Ruby versions we have installed by typing:

  ```bash
  rvm list
  ```
  
We can switch between the Ruby versions by typing:

  ```bash
  rvm use ruby_version
  ```

#### RMV Gemset

We can use various Rails versions or other Gems versions with each Ruby by creating gemsets and then installing Rails within those using the normal gem commands:

  ```bash
  rvm gemset create gemset_name    # create a gemset
  rvm ruby_version@gemset_name  # specify Ruby version and our new gemset
  ```

We have covered the basics of how to install rvm and Ruby on Rails here, but there is a lot more to learn about rvm, [the documentation link here](https://rvm.io/).

## 14. Tools for development

There are a lot of tools that help you to improve your code design for ruby programming languages. It's very recommended to use them for help to mantain the same format in all project and prevent errors.

### RuboCop

[RuboCop](https://github.com/bbatsov/rubocop) is a Ruby code style checker based on the original style guide. RuboCop already covers a significant portion of the Guide.

We have a template the RuboCop configuration used to check the rubocop source code for your projects based on this style guide. You can find the Rubocop Configuration file [here]((templates/.rubocop.yml)) to use.

## 15. Testing

_NOTE:_ This chapter covers exclusively Ruby ways of testing. There's a broad greater set of best practises on the particular [Testing & QA](../../qa_testing) section of the guide.

### RSPEC

RSpec is a Behaviour-Driven Development tool for Ruby programmers. BDD is an approach
to software development that combines Test-Driven Development, Domain Driven Design,
and Acceptance Test-Driven Planning. RSpec helps you do the TDD part of that equation,
focusing on the documentation and design aspects of TDD.

Learn how Rspec works, [the documentation link here](https://www.relishapp.com/rspec), ["best practices" of Rspecs](http://betterspecs.org/)

## 16. Project Documentation

The documentation tools make it possible to generate documentation directly from your source code.

### YARD

YARD is a documentation generation tool for the Ruby programming language. It enables the user to generate consistent, usable documentation that can be exported to a number of formats very easily, and also supports extending for custom Ruby constructs such as custom class level definitions. [Yard documentation link](http://yardoc.org/)

## 17. Development Environments (IDEs)

To develop a Ruby program, it isn’t necessary to have a IDE. You can develop it in a text editor, for example gedit, Sublime Text, Atom... and run it in the Ruby console. You are free to decide which one to use.

### RubyMine

[RubyMine](http://www.jetbrains.com/ruby/)'s code inspections are
[partially based](http://confluence.jetbrains.com/display/RUBYDEV/RubyMine+Inspections)
on the original guide.

## 18. References

The following is the reference list used during the development of this best practices guide. Please follow the links in order to obtain further information regarding Ruby programming and best practices:

* https://github.com/bbatsov/ruby-style-guide
* https://github.com/ManageIQ/guides/blob/master/coding_style_and_standards.md
* https://en.wikipedia.org/wiki/Ruby_(programming_language)
* https://www.ruby-lang.org/en/
* https://rvm.io/
* http://rspec.info/
* https://www.jetbrains.com/ruby/


___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
