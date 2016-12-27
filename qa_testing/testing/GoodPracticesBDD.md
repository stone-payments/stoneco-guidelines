# Testing techniques TDD, BDD and Acceptance Test

###Índex

* [Introduction](#introduction)

* [TDD](#tdd)

* [BDD](#bdd)

* [Acceptance Test](#acceptance-test)

* [Conclusions](#conclusions)


----------------
##Introduction
----------------

Let's do a review of the techniques most widespread agile development
today we can find:
 

* TDD (Test Driven Develop) 

* BDD (Behaviour Driven Development) 


These two techniques have a common goal which is to improve the quality
SW produced. Also it tries to go a step beyond the unit testing and
integration that are often linked to TDD / BDD making a brief time to
integrate acceptance test in our test cycle less expensive way possible
review.


--------
##TDD 
--------

Test-driven Development or TDD is a programming technique that focuses
sen that you write tests before scheduling functionality, following the
cycle of failure, pass, refactor trying to improve the quality of SW

 

Advantages of us:

* It helps to think as we develop functionality 

* Power become more modular and flexible 

* It minimizes the need for a "debugger" 

* Increases developer confidence when changes to the application 

 

Disadvantages that gives us:

* Wing difficulties in testing situations where necessary functional
    or integration tests are, as can be BD or user interfaces. 

* Creating unnecessary test. 

* The test must remain as the code. 

* TDD introduce problems in projects that have not been developed
    from the start with TDD 

* To be effective this technique takes the whole team to do TDD
    Development. 

* Problems developer focuses more on how to build functionality,
    which ask if the functionality is really needed by the user or the
    user wanted. 

To understand some of these disadvantages born BDD and other techniques
are used as are Acceptance Test.

-------
##BDD 
-------

Guided BDD behavior or development is a process that extends TDD ideas
and combines them with other SW design ideas and business analysis to
provide a process (and a series of tools) to developers, with the aim of
improving the development SW.\
BDD is based on TDD formalizing best practices of TDD, which are
clarifying and emphasizing it.

In DB not only tested units or classes, test scenarios and behavior when
classes meet those scenarios, which can be composed of various kinds.

 
![BDD + TDD](static/BDD1.jpg "BBD + TDD")
 

BDD habits, adding that TDD provides are:

* It helps us focus what really matters for the 'business'. 

* If we generate the correct language tests, they can serve to make
    the Acceptance Test. 


When carrying wing practices DB is strongly recommended to use DSL that
offers a common language on which to do the test.

The DLS's most used when defining scenarios in BDD usually consist of
Steps or Steps, are usually divided into:

* Given: The steps needed to put the system in the state to be
    tested. 

* When: User interaction functionality driving wish to test. 

* Then: In this step we will look at changes in the system and see if
    they are desired. 


DSL instead use natural language to specify when it can help us to
maintain the same level of abstraction in defining the scenarios. A good
DSL is flexible and powerful once all members of an organization know
and use.

All this serves to test the internal behavior of the application, once
the functionality is made, we want to know if what the user really
looking for it there is evidence of acceptance.

-----------------
##Acceptance Test
-----------------


The acceptance test are those recipients to determine whether certain
functionality requirements have been met, as end users need not worry
about the implementation details, but should be able to focus on the
functional part that meets the expectations created at the beginning
Sprint.

 
![Acceptance test](static/BDD2.jpg "Acceptance test")


DSL's DB and practices give us an extra point of abstraction in
specifying the stories, plus documentation of the progress and
achievements of each Sprint.

The acceptance test raises a number of technical problems:

* Wing problems in automating this test. 

* En el caso de no usar un lenguaje muy concreto pueden encontrarse
    problemas a la hora de compartir test. 

In the case of not using a very specific language problems can be found
in sharing test.

The acceptance test automation generally have a number of associated
problems:

* Do the test is expensive in terms of resources (time / money) 

* Do not tolerate changes in both the specification and
    implementation 

* Difficulties when develop the scenario tests. 


So it is very useful to use tools such as TestLink or TestRails,
allowing us to document and organize all have our test application,
ordering them so as Srpint version of our application.


Here the use of DSL is almost essential, since freedom of natural
language specification makes it very difficult later have to make the
user because by using highly technical language or select a level of
abstraction wrong in declaring the proves.


-------------
##Conclusions 
-------------

As we can see BDD gets the best practices of RUP and tries to guide
development when choosing which parts of the application prove that
joined the acceptance test can help to prioritize the development of the
stories that really add value to the user .

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies

