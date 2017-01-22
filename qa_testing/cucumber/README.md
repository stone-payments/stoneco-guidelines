<img src="static/cucumber.png" width="617" alt="Cucumber">

# Cucumber
Test, automation and alive documentation with Cucumber

## Index

* [What is Cucumber?](#what-is-cucumber)
* [ATDD & BDD with Cucumber](#atdd-and-bdd-with-cucumber)
* [Alive Documentation](#alive-documentation)
* [Life cycle](#life-cycle)
* [Cucumber writing tips](#cucumber-writing-tips)
* [Cucumber implementations](#cucumber-implementations)

### What is Cucumber?

Cucumber is a development tool for the automatic execution of the application acceptance test. It allows the business analyst to describe in a natural way the acceptance criteria of the application using Gherkin for it. On the same way it gives the developers the possibility of executing that criteria as tests against the application. That feature makes Cucumber really useful on agile development methodologies like [ATDD](../testing/ATDD/README.md) and [BDD](../testing/GoodPractivesBDD.md)

### ATDD and BDD with Cucumber

Without details, ATDD is an agile development methodology guided by acceptance test. ATDD also includes BDD, which is an agile development methodology guided by the behavior of the application. It means the same acceptance criteria can include different behavior criteria for the application.

One of the biggest difference between ATDD and BDD is the detail level on the criteria description. Thus Cucumber can be applied on both methodologies. Cucumber allows the execution of criteria or behavior of the application described by business analyst as a tests and because of that all depends on the detail level which the different criteria would be described. If both methodologies are used, it is possible to have a few high level acceptance test that shows the use of ATDD on the project and, on the other hand, a greater number of more detailed behavior tests following BDD methodology.

Therefore, Cucumber can be used with both methodologies, making easier the agile development for both of them.

### Alive documentation

Another advantage given by cucumber is that it can be part of the project documentation.

One of the biggest problems found in projects is the project documentation maintenance and now more than ever, because the projects are more agile, dynamical and changing. Using agile development methodologies like commented ones, the applications are constantly changing, leaving documentation outdated frequently. This means that maintenance expenses can be huge if we want to keep it updated.

One of the Cucumber main features is describing the requirements of the project both acceptance and functional and that this descriptions are part of the documentation. Besides project documentation, this descriptions are the acceptance and functional tests, that will be executed against the project once and again. It means that this documentation cannot be outdated because the test will fail until they are updated. Therefore, the project documentation will evolve with the application and never will be outdated.

### Life cycle

The ideal life cycle for cucumber tests is as follows:

**Write behavior scenarios with Gherkin**

The scenarios on Cucumber are written using Gherkin, which is a business readable, domain specific language that Cucumber understands. It is really useful because it lets you describe software’s behavior without detailing how that behavior is implemented.

Each scenario should describe an specific functionality, keeping an appropiate abstraction level. It means that the scenario descriptions should be on balance between business and technical vision, depending on the detail of the criteria specified on it.

Thus the scenarios should be written jointly by a business person, a developer and a QA. This allows them to be more coordinated and facilitates understanding between them.

The scenarios are grouped on features files. A feature file groups an indeterminate number of scenarios with similar functionality. An example of a simple feature file with an only scenario written with Gherkin would be the next:

```
Feature: Hello Cucumber
As a product manager
I want our users to be greeted when they visit our site
So that they have a better experience

Scenario: User sees the welcome message
Given An started application
When I go to the homepage
Then I should see the welcome message
```

As can be seen on the example, all features files have three main parts:

- Feature declaration: header with a brief description about the common functionality of the scenarios.

- Scenario declaration: brief but accurate description about the scenario functionality and the specific behaviour of the application. Every scenario should have one or more of the three main steps:

> * Given steps: On the "Given" steps the initial state of the application is detailed. It is set the application on an starting point to describe the funcionality.
> * When steps: On the "When" steps is described the funcionality that the application will execute, for example "go to the home page". 
> * Then steps: On the "Then" steps is checked that the application behaves properly as expected.

Those three types of steps could be used as desired, but it is advisable that every scenario should have only three of those simple steps. This will keep the scenario simple and understandable.

On a feature file it can be found other parts like:

> * Background: Only can be one "background" for a feature. It declares the steps that will be the same for all the scenarios of the feature.

> * Example: When some scenarios are really similar between them and only differ on the data tested, all of them could be grouped on an only one scenario with an "example" table, which contains all the parameters for every scenario.

The detail of the different features implementation could be found on main cucumber [page](https://cucumber.io/docs#reference)

**Scenarios implementation**

When the scenarios are properly written and business people and developers have reached an agreement, it is the moment to implement those scenarios. Using cucumber it can be given functionality to all of the Gherkin steps. Thus every step will interact with the application, getting automated tests for the application.

```
When(/^I go to the homepage$/) do
  visit root_path
end
```

The step implementations can have variables as property fields or tables with multiple values.

**Implementing the application functionality**

The next logic step is to implement the application functionality, which should works as described on the scenario. To ensure that the application behaves properly, the new functionality should pass the test described on the scenario.

**Automation of scenarios**

And finally, as the functionalities are being created, we should create executable scenarios with as against the application. Making the execution of those scenarios automatic, we will ensure that the application behave as expected without being worry about possible application errors and problems.

That way, we also get an alive documentation that will be updated next to application, that evolves with it and that ensures our application behaviour. 

### Cucumber writing tips

One of the advantages and at the same time, one of the dangers of cucumber, is the flexibility that provides to write examples like we want. Thus there are a simple guide lines to write scenarios that will make the life easier for us:

- Keep only the scenarios with the same functionality under the same feature file. 

	We quickly see how easy is to write scenarios with cucumber. But to be organized and keep all the features coherent, it is better to save under the same feature, only the scenarios that describes the same functionality. This will help us to understand the different functionalities of the application.

- Put together all common steps under the "background".

	This will keep our scenarios more simple and easy to read and understand.

- Keep the scenarios simple.

	As it is said on the writing scenarios part, it is better to only have three simple "Given, When, Then" steps to keep our scenarios more simple and readable. 

### Cucumber implementations

Initially, Cucumber was created for Ruby, so all other implementations are based on it. On Cucumber for Ruby, the standard directory structure is:

- features - Contains feature files, which all have a .feature extension. May contain subdirectories to organize feature files.

- features/step_definitions - Contains step definition files, which are Ruby code and have a .rb extension.

- features/support - Contains supporting Ruby code. Files in support load before those in step_definitions, which makes it useful for such things as environment configuration (commonly done in a file called env.rb).

There are Cucumber implementations for mostly common programming languages and all of it could be found on it's [main page](https://cucumber.io/docs#reference)

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies

