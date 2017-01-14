
![Ruby logo](static/ruby.png "Ruby logo")

# Ruby Best Practices

## INDEX

* [Introduction](#Introduction)
* [Formatting](#formatting)
* [Documentation](#documentation)
* [Project Structure](#project-structure)
* [Rubygems and RVM (Ruby Version Manager)](#5-rubygems-and-rvm-ruby-version-manager)
* [Running Ruby from the Command Line](#6-running-ruby-from-the-command-line)
* [Testing](#7-testing)
* [Frameworks](#8-frameworks)
* [Ruby Project Templates](#9-ruby-project-templates)
* [References](#10-References)

## Introduction

This document sets some principles and recommendations for developing Ruby applications.

## Formatting
Ruby developers haven't got a official guide for style guide for develop a great application applying best practices and 
consistent and readability code.
 
In this context, several communities have established and proposed their own conventions and best practices for Ruby style guide.
 
We adhere to the [Ruby ManageIQ style guide](https://github.com/ManageIQ/guides/blob/master/coding_style_and_standards.md).

*Note*: These guide are living documents and are subject to change.

## Documentation

The documentation tools make it possible to generate documentation directly from your source code.

### YARD

YARD is a documentation generation tool for the Ruby programming language. It enables the user to generate consistent, usable documentation that can be exported to a number of formats very easily, and also supports extending for custom Ruby constructs such as custom class level definitions. [Yard documentation link](http://yardoc.org/)

## Project Structure

Projects in Ruby can have different structures depending on the target that they have, or depending on the needs and policies of development teams.

### Example

As a reference example, the following link shows the structure of a Ruby gem follows the same standard structure of code organization:

http://guides.rubygems.org/what-is-a-gem/

## Rubygems and RVM (Ruby Version Manager)

This chapter explains how to add new libraries or packages to the project.

### Rubygems

The RubyGems software allows you to easily download, install, and use ruby software packages on your system. The software package is called a “gem” and contains a package Ruby application or library.

Gems can be used to extend or modify functionality in Ruby applications. Commonly they’re used to distribute reusable functionality that is shared with other Rubyists for use in their applications and libraries. Some gems provide command line utilities to help automate tasks and speed up your work.

The **gem** command allows you to interact with RubyGems.

  ```bash
  gem install <name gem>
  ```

But we can register all gems in a file called Gemfile.

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

## Running Ruby

### Running Ruby from the Command Line

This is the durable way to write Ruby code because you save your instructions into a file.

We might create a file named `my_program.rb` like this:

**script.rb**
  ```ruby
  class Sample
    def hello
      puts "Hello, World!"
    end
  end
  
  s = Sample.new
  s.hello
  ```
  
When you run: 
  ```bash
  $ ruby script.rb
  ```

You’re actually loading the Ruby virtual machine which in turn loads your `script.rb`

### Running Ruby from the IRB

Ruby was one of the first languages to popularize what’s called a "REPL": Read, Evaluate, Print, Loop. Think of it kind of like a calculator – as you put in each complete instruction, IRB executes that instruction and shows you the result.

IRB is best used as a scratch pad for experimenting.

To use IRB, you need start **IRB** by opening terminal and typing 

  ```bash
  $ irb
  ```

## Testing

_NOTE:_ This chapter covers exclusively Ruby ways of testing. There's a broad greater set of best practises on the particular [Testing & QA](../../qa_testing) section of the guide.

### RSPEC

RSpec is a Behaviour-Driven Development tool for Ruby programmers. BDD is an approach
to software development that combines Test-Driven Development, Domain Driven Design,
and Acceptance Test-Driven Planning. RSpec helps you do the TDD part of that equation,
focusing on the documentation and design aspects of TDD.

Learn how Rspec works, [the documentation link here](https://www.relishapp.com/rspec), ["best practices" of Rspecs](http://betterspecs.org/)

## Tools

There is a set of tools and gems that help us to prevent bugs, to improve your code design and and follow coding best practises in Ruby Projects.

* [**SimpleCov**](https://github.com/colszowka/simplecov) It is a code coverage analysis tool for Ruby.
* [**Rubocop**](https://github.com/bbatsov/rubocop) It is a Ruby static code analyzer.
* [**MetricFu**](https://github.com/metricfu/metric_fu/) It is a set of metric tools that make it easy to generate metrics reports as metrics: Cane, Churn, Flay, etc.

## Frameworks

In this section we have listed down Ruby Frameworks how we work with Ruby at BEEVA.

### Ruby on Rails

Ruby on Rails is a full-stack web framework optimized for programmer happiness and sustainable productivity. It  includes everything needed to create database-backed web applications according to the Model-View-Controller (MVC) pattern. It encourages beautiful code by favoring convention over configuration.


## Ruby Project Templates

There's a broad greater section of [Ruby Project Templates](templates/templates.md).

## References

The following is the reference list used during the development of this best practices guide. Please follow the links in order to obtain further information regarding Ruby programming and best practices:

* https://github.com/bbatsov/ruby-style-guide
* https://github.com/ManageIQ/guides/blob/master/coding_style_and_standards.md
* https://en.wikipedia.org/wiki/Ruby_(programming_language)
* https://www.ruby-lang.org/en/
* https://rvm.io/
* http://rspec.info/

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
