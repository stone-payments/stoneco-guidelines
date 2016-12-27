# Testing techniques 

##Index


[Testing Techniques](#testing-techniques)

[Dynamic](#dynamic)

[Based on the specification (black box)](#based-on-the-specification-black-box)

[Partitioning equivalence](#partitioning-equivalence)

[Analysis of limit value](#analysis-of-limit-value)

[Decision tables](#decision-tables)

[State transition](#state-transition)

[Testing Use Cases](#testing-use-cases)

[Based on the structure (white box)](#based-on-the-structure-white-box)

[Tests sentence](#tests-sentence)

[Testing decision](#testing-decision)

[Based on experience](#based-on-experience)

[Exploratory testing](#exploratory-testing)


------------------
##Testing Techniques
------------------

There are different software testing techniques, with their weaknesses
and their strengths. Each is good to find a specific type of defects.
For example, tests at different stages of the software development
cycle, you will find different types of defects; or it is more likely to
find unit tests logical flaws in the code and not in the system design.
Generally speaking, the techniques can be organized into two categories
which are: static and dynamic techniques techniques.


Dynamic testing techniques run the software. For it introduced a series
of input values, and examine the output compared with the expected
results. However, static testing techniques do not execute code but
analyze it (manually or by tools).
 

As a result, the dynamic tests only apply on the product code to detect
defects and determine software quality attributes. Moreover, static
testing techniques are useful in evaluating or analyzing requirements
documents, design documents, test plans, or user manuals, and even to
examine the source code before run. A technique used to perform static
tests are revisions. In the review process, its phases, roles, etc. and
also the characteristics of other known technique called static
analysis.

------------------
##Dynamic
------------------

Dynamic techniques are classified based specification, also called black
box techniques or structure based white box techniques and finally based
on experience. Then the techniques of each of these classifications as
shown in the figure are described below:

 
![Dynamics](https://github.com/beeva-josemiguelmorales/beeva-best-practices/blob/master/qa_testing/testing/static/Tecnic1.png "Dynamics")
 
-----------------
##Based on the specification (black box)
------------------

Dynamic testing techniques are testing techniques based on the
specification. They are also known as testing techniques "black box" or
driven by inputs / outputs, because they see the software as a black box
with inputs and outputs, but have no knowledge of how it is structured
the program or component inside the box. The test engineer focuses on
what the software does and how it does not.

The technical specifications based on test cases derived directly from
the specifications or other types of models containing what the system
should do. The most important techniques based on the point
specification is that the specifications do not define or models (and
should not define) how the system is to achieve the specified
performance when constructed; It is a specification of the required
performance (or at least desired). One of the most important lessons
that software engineers have learned through experience is that it is
important to separate the definition of what a system should do
(specification) of the definition of how it should work (design). This
separation allows the two (technical specifications and test for
designers to design) specialist groups work independently, so that they
can then check that they have come to the same place.

If we establish test cases so as to check that the program or component
actually have the desired behavior, then we are acting independently to
developers. If they misunderstand the specifications or decide to make
changes without telling anyone, then its implementation will return a
different behavior than the model or specification said. These tests,
based only on the specification will fail and will have uncovered a
problem. Keep in mind that not all systems are defined by a formal
detailed specification. In some cases the model used can be quite
informal. If there is no specification, the test engineer should build a
model of the proposed system, perhaps interviewing key people to
understand what their expectations are involved.

Keep in mind that the definition of these techniques mentioned both
functional and non-functional testing. As functional tests are related
to what the system, its features and functions mentioned in previous
sections. Non-functional tests are linked to examine how well the system
does something, but to examine what it does. The non-functional aspects
(also known as quality characteristics or attributes) include
performance, usability, portability, maintainability, etc. Techniques
for testing these non-functional aspects are less procedural and less
formalized than other categories.


------------------
##Partitioning equivalence
------------------

Partitioning equivalence is a black box technique based on the
specification. It can be applied at any level of evidence and is often
good as first technique to apply.  
The idea behind this technique is to divide a set of test conditions in
groups or sets that can be considered equal (eg the system should handle
equivalently), hence "equivalence partitioning". Equivalence partitions
are also known as equivalence classes, the two terms mean the same
thing.

The equivalence partitioning technique requires testing only one
condition for each partition. This is because we assume that all the
conditions of a partition will be treated in the same way by the
software. If a condition in a partition functions, we assume that all
conditions in the partition function. Likewise, if one of the conditions
on a partition does not work, then we assume that none of the conditions
in this particular partition function. Of course these are simplifying
assumptions that may not always be right, but if we write, at least give
the opportunity to others to challenge the assumptions we have made and
to help create better partitions. If time permits, you should try more
than one value for a partition, especially if you want to confirm a
typical user input selection.

There are several types of partitions among which partitions inputs and
outputs.


### Partitions Input

Grouping partitions possible entries of the program. For example, a
program that accepts integer values can accept as valid any entry that
is an integer and should no longer accept any value (as real numbers or
characters). The whole range is infinite, but the computer will limit
the range to some finite both negative and positive values (simply
because numbers can only handle a certain size, it is a finite machine).

Let's assume for the purpose of an example, the program accepts any
value between -10000 and + 10000. If a program that separates numbers in
two groups depending on whether they are positive or negative, the full
range of integers could be separated into three partitions : values
​​that are less than zero; zero; and values ​​that are greater than
zero. Each of these groups is known as "equivalence partitions" because
each of the values ​​in a partition is equal to any other value that
partition as the program is concerned. This way if the program accepts
-2905 as a valid negative integer wait also accept -3. Similarly, if you
accept 100 you should also accept 2345 as a positive integer. Zero is
treated as a special case. We could, if we wanted to, include zero
positive integers, but the rudimentary specification that we used for
the example does not specify this clearly, so it is left as an undefined
value (and typically find ambiguities of this type or areas not defined
in specifications).

In the example given, then you need any positive integer, any negative
integer and zero. Values near the center of each partition are generally
selected so that we can choose, -5000, 0 and 5000 as representations.
The theory is that if the program successfully addresses these three
values is very likely to do the same with the rest.

Partitions that have been chosen are called valid equivalence partitions
that collect valid entries, but there are other possible entries to this
program should not be valid: real numbers, for example. There are also
two partitions of integers that are not valid: integers under integers
greater -10000 and 10000.

We should prove that the program does not accept them, which is as
important as the program accepts valid entries.

If we think of the example, we recognize that there are more possible
invalid entries that valid, since all real numbers and characters are
not valid in this case. Overall there are more ways to provide you
correct incorrect entries; so we need to ensure that the program has
been tested against invalid entries possible. Here again appear
equivalence partitions: all real numbers are invalid and not characters.
This represents two partitions that invalid values should be tested
using 9.45 and 'r' respectively. There will be many other possible
invalid entries, so you have to limit those test cases that are most
likely to appear in a real situation.

 

   -------------------------------------------------------------------------------------------------------------------------------
  Examples of equivalence classes

  * Valid entry: integers in the range 100-999. 

          Valid partitions: 100-999 included.  
          Invalid partitions less than 100, more than 999 real numbers (decimal) and characters not numeric. 

  * Valid entry: names with up to 20 alphanumeric characters. 

          Valid partitions: strings up to 20 alphanumeric characters. 
          Partition invalid: strings longer than 20 alphanumeric characters, strings that contain non-alphanumeric characters. 

   -------------------------------------------------------------------------------------------------------------------------------

 

### Partitions outputs

Likewise the input of a program may be partitioned, it can be output.
Suppose a program of bank accounts that generate the following outputs:\
for the first € 1,000 0.5% interest rate, 1% for the following € 1000
and 1.5% for the rest. These data can be used to generate use cases each
of these outlets as an alternative to generate partition entries. An
input value between 0- € 1000 output would generate 0.5%; a value
between € 1001-2000 generate 1%; more than € 2000 value generates 1.5%
of output.


----------------------------------
##Analysis of limit value
----------------------------------

One of the things we know about the kinds of mistakes programmers is
that errors tend to cluster around the city. For example, if a program
should accept a sequence of numbers between 1 and 10, the most likely
error is that just out of range values are accepted incorrectly, or that
the right values in the range limits are rejected. Boundary value
analysis is based on test values of the partition border. By making
"checks range," you're probably unconsciously using analysis limit. In
this technique also we have valid limits (on valid partitions) and
invalid borders (in invalid partitions).

As an example, consider a printer that has an option input the number of
copies to be made, of 1 to 99.

| Not Valid     | Valid         | Not Valid     |
| ------------- |:-------------:| -------------:|
| 0             | 99            | 100           |


We partition of integers from 1 to 99, the minimum value 1 and a maximum
of 99. These two values are called frontier values. They are actually
called limit values are valid because borders within the valid
partition. And values out? The limit invalid lower values is zero
because it is the first value that is when it goes out of the partition
from the bottom (you can also think it is the highest value in the
invalid partition of integers under 1). On the top of the range we also
have an invalid limit value, 100.

There are two theoretical approaches to this technique. One takes the
minimum and maximum values valid partitions and the first or last value
respectively invalid partition adjacent valid partitions (in the case
that there is, as not all valid partitions will have invalid adjacent
partitions). In this way they are taken as limiting values reflected in
the previous paragraph: 0, 1, 99 and 100.

This approach also called approximation of two values.

The other approach involves a value more. The rule is that the limit
value in itself and a value to each side of the boundary (as close as
you can get) is used. So in this case we would like boundary values 0,
1, 2 for the lower limit and 98, 99 and 100 in the upper limit. What
does take the value as close as possible? It means taking the following
value in the sequence using precision has been applied to the partition.
If the numbers have a precision of 0.01, for example, the limit values
of the lower limit be 0.99, 1.00, 1.01 and the upper limit would be
98.99, 99.00, 99.01. This approach also called approximation of three
values.

When choosing between an approach or another should be borne in mind
that the second may be less efficient because these two techniques
(equivalence partitioning and boundary value analysis) is typically
performed together and following the example above, the values selected
as borders 2 and 98 would result, as these values would be tested with
representative number of the partition (equivalent value).

An example that reflects the technical equivalence partitioning and
limit values could be next. A savings account in a bank earns different
interest rates depending on the account balance. If the balance is 0 to
€ 100 has an interest rate of 3%, a balance above € 100-1000 has a 5%
interest and balances from 1000 € would have a 7% interest. We could
identify three partitions initially valid and an invalid equivalence as
shown below:

| Invalid partition  | Valid (3%)       | Valid (5%)       |  Valid(7%)    |
| :----------------- |:----------------:|:----------------:| -------------:|
| -0.01              | -0.00   100.00   | 100.01  999.99   | 100.00        |


The border values in this case would be -0.01 (an invalid boundary
value), 0.00, 0.01, 99.99, 100.00, 100.01, 999.98, 999.99, 1000.00.  
A good way to represent the partitions and the valid and invalid borders
is a table like this:


| Test Conditions    | Valid partitions   | Partitions invalid   | Limit values valid   | Limit values invalid   |
| :----------------- |:------------------:|:--------------------:|:--------------------:| ----------------------:|
| Account Balance    |  0.00 – 100.00     | \<0.00               |  0.00                | -0.01                  |
|                    |  100.01-999.99     | \>Max                |  0.01                | Max+0.01               |
|                    |  1000.00- Max      | Not integer          |  99.99               |                        |
|                    |                    |                      |  100.00              |                        |
|                    |                    |                      |  100.01              |                        |
|                    |                    |                      |  999.98              |                        |
|                    |                    |                      |  999.99              |                        |
|                    |                    |                      |  1000.00             |                        |
| Interest rates     |  3%                |   Any other value    |  Not applicable      | Not applicable         |
|                    |  5%                |   Not integer        |                      |                        |
|                    |  7%                |                      |                      |                        |


Looking at the data in the table we can see that is not specified for a
maximum interest rate of 7%. It would be interesting to know what is the
maximum value of an account balance to test the boundary values. This
type of boundary is called the "open border" because one side of the
partition is left open (not defined).

Does this mean that we can ignore?

Open borders are difficult to prove, but there are ways of approaching.
Really the best solution to the problem is to find as it should be
specified the border. One approach is to return to the specification to
see if it is set up somewhere. If so, we know what our value border.
Another approach would be to investigate other areas related system. For
example, the field containing the balance will only support six-digit
numbers and two decimals. This could give a maximum of € 999,999.99. If
we can not find anything on what should be the border, then we will need
to use an intuitive or based on experience to test various settings to
try to focus the program to fail.

We could also try to find the border open for the lower limit, what is
the minimum negative balance? This example is omitted, but in some cases
also be of interest.  
As already it mentioned before technical equivalence partitioning and
boundary value analysis are closely linked and that any partition border
is somewhere.  
We recommend choosing values on partitions other than border values.


------------------
##Decision tables
------------------

The technical equivalence partitioning and boundary value analysis are
often applied to specific situations or tickets. However, if different
combinations of inputs are resulting in different actions more difficult
using prior techniques. This technique and the next (transition states)
are more oriented to the logic or business rules.

The specifications often contain business rules to define the functions
of the system and the conditions under which each function operates.
Individual decisions are usually simple, but the overall effect of the
logical conditions can be very complex. The testers need to be able to
ensure that all combinations of conditions that may occur are to be
tested, so you have to capture all the decisions in a way that allows
exploring your combinations. The mechanism used frequently to capture
the logical decision is the decision table.

A decision table is a good way to deal with combinations of things (eg
tickets). This technique is sometimes also called table "cause and
effect". The reason for this is that there is a technique associated
logic diagrams called "cause-effect graphs" used to help build decision
tables.

A decision table lists all the input conditions that may occur and all
actions that may arise from them. They are structured in rows, with the
conditions in the top of the table and possible actions on the bottom.
Business rules, which include combinations of conditions to produce some
combinations of actions are included in the top of one end to another.
Each column, therefore, represents a single business rule and shows how
the entry conditions combine to produce actions. Thus, each column
represents a possible test case, because it identifies both inputs and
outputs. This is shown schematically in the following table:


####*STRUCTURE OF A BOARD DECISION*
|                                             |  Rule of Business 1    |  Rule of Business 2   |  Rule of Business 3    |
| :-------------------------------------------|:----------------------:|:---------------------:|:----------------------:|
| Condition 1                                 |     V                  |    F                  |  V                     |
| Condition 2                                 |     V                  |    V                  |  V                     |
| Condition 3                                 |     V                  |    \-                 |  F                     |
| Acction 1                                   |     S                  |    N                  |  S                     |
| Acction 2                                   |     N                  |    S                  |  S                     |
| Business Rule 1 requires that all the conditions are true to generate action 1. 2 business rule is in action 2 if condition1 is false and condition2 is true, but does not depend on condition3.  Rule 3 requires that business conditions 1 and 2 are true and three false.    |   |           |                    |


In fact, the number of conditions and actions can be very long, but
usually the number of combinations that produce a specific action is
relatively small.  
Therefore all possible combinations of conditions in decision tables are
not applied but is restricted to those that correspond to business
rules. A This is called limited decision table to distinguish it from
the tables with all entries identified combinations of inputs.


------------------
##State transition
------------------

The prior art testing decision tables, is particularly useful when
combinations of input conditions produce several actions. Now it is
going to consider a similar technique, but also involves the systems in
which outputs are triggered by changes in the conditions of entry, or
changes "status"; in other words, the behavior depends on the current
state and past state, and is the transition that triggers the system
behavior.

The state transition tests are used when one of the aspects of the
system can be described in what is called a "finite state machine". This
means that the system can be in a (finite) number of states, and
transitions from one state to another are determined by the rules of the
"machine". This is the model in which the system and the tests are
based. Any system in which different outputs can be achieved with the
same ticket, depending on what has gone before, is a finite state
system. A finite state system is usually represented by a state diagram.

It notes that in a given state, an event can cause one action, but the
same event from a different state, can cause a different action or a
different final state.  
If we have a representation of a state transition diagram we can analyze
the behavior in terms of what happens when a transition occurs.

The transitions are caused by events and can generate outputs and / or
status changes. An event is something that acts as a trigger for a
change; it can be a login prompt, or it can be something that changes in
the system for some reason, as a field in a database that is updated.

In some cases an event generates an output, in others the event changes
the internal state of the system without generating an output, and
others can cause an output and a change of state.  
What happens with every change can always deduce the state transition
diagram.

For example, if a request to get 100 € from a bank is done, it could be
that the money I give. After the same request is made, but the money is
denied (because the balance is insufficient). This last request was
rejected because the state changed the bank account have sufficient
funds to cover the request to not have them. The transition which caused
the status has changed was probably withdrawing money above. With state
diagrams can represent a model from the point of view of the system,
account or customer.

When we look at the test cases that can be generated must be borne in
mind that there are valid state transitions, but also invalid state
transitions.

The following figure shows an example of entering a personal
identification number (PIN) to enter a bank account. As explained in the
above figure states are shown by circles, transitions by arrows and
events with labels transitions (Figure Example no actions explicitly
shown, but it would be a message to the client things like "Please enter
PIN").

![State transition](https://documents.lucidchart.com/documents/4c504f61-cf17-4ff1-81dc-52378dc62814/pages/0_0?a=1433&x=184&y=1892&w=1239&h=616&store=1&accept=image%2F*&auth=LCA%20c488fe5fd719b1d9a1dd152ea8a0165cb347aa6c-ts%3D1448542384)

*Drawing 1: Example of state transition*
 
------------------
##Testing Use Cases
------------------

Use cases are a way of specifying functionality as business scenarios or
process flows.

The tests use case is a technique that helps identify test cases that
exercise the whole system transition to transition from beginning to
end.

A use case is a description of a particular use of the system by an
actor (a system user). Each use case describes interactions that the
actor has with the system for a specific task (or at least produce
something of value to the user). Actors are usually people but can also
be other systems. Use cases with a sequence of steps that describe the
interactions between the actor and the system.

Use cases are defined in terms of the actor, not the system, describing
it does and sees the actor, rather than inputs or outputs which expects
the system. Very commonly they use language and terms of business rather
than technical terms, especially when the actor is a business user. They
serve as a basis for developing test cases mostly in levels of system
testing and acceptance testing.

Use cases can uncover integration defects, defects caused by incorrect
interaction between different components.

Use cases describe the process flow through a use-based system more
likely. This makes the test cases derived from use cases are
particularly useful for finding defects in the actual use of the system
(eg defects that users are more likely to do the first time using the
system ).

Each use case has a dominant (or most likely) scenario and some
alternative branches (covering, for example, special cases or
exceptional conditions). Each use case must specify any preconditions
that have observable results and a description of the final state after
the use case has been successfully implemented system.

The PIN example we use for testing state transition could also be
defined in terms of use cases, as seen in the following table:

|                          |  Steps     |  Description                                        | 
|:------------------------ |:----------:| ---------------------------------------------------:|
| Main success scenario <br>  A: Actor  <br>   S:System   | 1          | A: Insert Card                                      |
|                          | 2          | S:Validate card and ask for the PIN                 |
|                 | 3          | A: Insert Pin                                       |
|                          | 4          | S: Validate Pin                                     |
|                          | 5       | S: Allow access to account       |
| Extensions               | 2a      | Invalid Card.<br> S: It displays a message and rejects the card    | 
|                          | 4a      | Invalid Pin.<br> S: displays a message and asks again the PIN (twice)    |
|                          | 4b      | Invalid PIN 3 times.<br> S:is swallowed card and leaves       |


For testing use case scenario would have a successful test and a test
for each extension. In this example, we will give to the extension 4b a
higher priority than the 4th from the point of view of safety.

The system requirements can be specified as a set of use cases. This
will be made easier involvement of users in the process of defining
them.

------------------
##Based on the structure (white box)
------------------

It provides the most sophisticated techniques, incrementally, complete
code coverage. In some applications this is essential. In a system where
security is critical, it is vital to be sure to run the code will be
problems. Measures such conditions coverage or coverage of multiple
conditions are used to measure the probability that the code has
unpredictable behavior in complex scenarios.

Coverage also applies to other types and levels of structure. For
example, level of integration, it is useful to know the percentage of
tested modules within the package or test connections. Structure-based
techniques are often used to measure coverage of the tests. The
technical design of evidence-based structure are a good way of
generating additional test cases other than the evidence, thus ensuring
a wider range of tests.

These techniques explore the structure of the programs. Rather than test
the entire code, simply ensure that a particular set of code elements
are working properly. Simple test cases can be run for an initial survey
before starting detailed functional testing, or also be interpreted the
results of the tests performed by the developers to ensure that the code
tested properly.

Therefore, the starting point is the code.

The real programming languages have a wide variety of forms and
structures, so it is not feasible to cover them all. The advantage of
pseudocode is that has a simple structure.

\
There are three ways of structuring executable code:

 

* Sequence: Consists of executing the instructions one to one as they
    appear in the code.  

* Selection: In this case the computer has to decide if a condition
    is true or false. If true, that route is taken, it would take a
    different route.  

* Iteration is to run a piece of code more than once. 

-------------
##Tests sentence
-------------

The purpose of testing sentence is try different judgments throughout
the code. If each and every code executable statements are tested, there
will be full coverage decision. It is important to remember that these
tests only focus on executable statements when measuring coverage.It is
very useful to use graphical data flow to identify such sentences -
which are represented by rectangles.  
Generally, coverage of judgments is too weak to be considered an
appropriate measure to prove the effectiveness.


-------------
##Testing decision
-------------

The objective of these tests is to ensure that decisions are properly
program made. The decisions are part of the selection and iteration
structures, for example, appear in constructs such as IF THEN ELSE, or
DO WHILE, or REPEAT UNTIL. To test a decision, you need to run when the
condition is associated it is true and when it is false. In this way,
you ensure that all possible outcomes of the decision have been tested.

As evidence of judgments, decision tests have a measure of coverage
asociad ae tries nc onsegu go 100% of the cov ra decision.

-------------
##Based on experience
-------------

Techniques based on experiences are those which are used when there is
no adequate specification from which to create test cases based
specification, or enough to run the full test suite structure time.

Techniques based on experience using the experience of users and testers
to determine the most important areas of a system and bringing these
areas so that they are consistent with the use that is expected to have.

There is a wide range of testing techniques, from the most sophisticated
to the simplest, but in all the knowledge and experience of the testers
are decisive factors for their success.

Two types of techniques based on experience are as follows:

* Guessing errors  

* Exploratory testing 


-------------
##Exploratory testing
-------------

Exploratory testing is a technique that combines the experience of the
testers with a structured approach to testing specifications are missing
or are inadequate, and where there is a lot of pressure over time.

Exploratory tests require minimal planning and maximum test execution.
The design and execution of testing activities are normally executed in
parallel without any formal documentation for test conditions, test
cases and test scripts. Thus, exploratory testing maximize the number of
tests that can be performed in a given time frame, while meeting the
objectives of the evidence on the most important areas.

This does not mean some kind of more formal testing techniques are not
used. If used eg boundary value analysis, the values most important
border would be tested without writing. During the exploratory test
session notes for more before generating a report would be taken.

As its name suggests, exploratory tests try to explore the software
(what does, what does not, its weaknesses ...). The technical trial is
constantly making decisions about what will be the next to try, when
performing the test and how much time is available to do it. Thus the
screening tests can be used to validate the formal testing process,
ensuring that the most serious defects were found.
___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
