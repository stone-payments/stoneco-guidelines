# JAVA Best Practices

In this section we are going to describe how we work with JAVA at BEEVA.

![BEEVA](https://github.com/beeva/beeva-best-practices/blob/master/static/horizontal-beeva-logo.png "BEEVA")
![JAVA](static/java.png "JAVA")

## Index

* [Introduction](#java-introduction)
* [Choosing the proper names inside our code](#choosing-proper-names-inside-our-code)
* [Function design](#functions-design)
* [Comments and documentation](#comments-and-documentation)
* [Formatting and code styling](#formatting-and-code-styling)
* [Encapsulation](#encapsulation)
* [Exception handling](#exception-handling)
* [Log traces](#log-traces)
* [Code testing](#code-testing)
* [Hints about code optimization](#hints-about-code-optimization)
* [References](#references)

## Introduction

This document sets some principles and recommendations for developing JAVA applications.

The most important thing that we, as developers, must have in our minds is that our code is written for other persons, and not for compilers. For this reason, we really care about readability, clarity and well structured code.

It is also very important to backup our code with a good automated test battery, raising confidence level when complex refactors or other  improvements need to be performed.

This is not an static document, but a living one. We will be adding new hints and sections as our experience with JAVA grows.

---

## Choosing the proper names inside our code

---

When we choose a name for variables, functions, arguments, classes, etc, it is important to apply a set of rules that will help us to make our code more consistent, easier to read and understand. Below are some hints or rules that we can consider when choosing proper names:

### Meaningful names

The name of a variable, function or class should answer a number of basic questions: why does it exist? what does it do? how is it used?

We should choose names that reveal intentions, enhancing understandability and modifications over the code. For example, if we have the following variable to store a number of days since the last modification:

```java
int d;
```

It is extremely difficult to predict what the variable 'd' does. Maybe a better name would be something more specific like:

```java
int daysSinceModification;
```

Additionally, we should full descriptors that describe the variable, the field or the class properly. For example, an appropriate name for a field that defines the name of a user, it would be *firstName* or *userName*. Short names (for example *x1* or *f1*), although they are easier to type, don't provide any information of what they represent and consequently result in a poorly understandable, maintainable or/and improvable code.

### Avoid disinformation

We should avoid words whose meanings vary from our intended meaning. For example, we do not have to put *customerList* as a variable name, if it is not a list, because for a developer the word *list* has a very particular meaning.

We should avoid names that are too similar aswell, or that differ only in uppercase or lowercase. For example, *persistentObject* and *persistentObjects*, or *anSqlDatabase* and *anSQLDatabase*, should not be used together as they create some confusion to other developers and maybe even for ourselves.

We should define our names in a way that allows the reader to appreciate differences. Avoid number-series or noise words, because if the names have to be different, they must also have a different meaning. Numerical series and noise words do not provide information. For example, if we have the class *Product*, and we add another class with the name *ProductData*, we will have two classes with different names but with the same meaning (*Data* is a noise word that not provides any meaning).

### Pronounceable names 

Always try to use names that the reader can pronounce, easing him/her to explain or to ask questions about the code to other persons, even when the code is not in a screen (for example, on a phone call). For example, the name of the class *DtaRcrd104* cannot be pronounced (can you imagine a phone conversation speaking about this particular variable?)

### Searchable names

You should use names that can be easily searched for in a text editor. Letter names or numeric constants are not easy to locate in the text. The length of a name must correspond to the size of our scope. If a variable or constant is used in several points of our code, we must assign a name that can be looked for.

### Abbreviations

In general, they should be avoided. But if you have to use them, do it with moderation and intelligence. This means that we must maintain a standard list of short forms (abbreviations), choose them wisely and use them in a consistent manner. For example, if we want to use an abbreviation for the word *number*, we can use *nbr*, *no* or *num*, but recording the register used (no matter what) and using only that one.

### Encodings

As rule of thumb, avoid encoding names... they are unpronounceable and are usually incorrectly written. In JAVA there is no need to encode types like other languages with the Hungarian Notation (HN consists in prefixes in lowercase added to the names of the variables, and that indicate its type; the rest of the name indicates, as clearly as possible, the function that performs the variable), so we have to avoid this encoding as it makes it more difficult the readability of the code, may confuse the reader, and makes it harder to change the name or the type of a variable or class.

### Uppercase/lowercase

Use uppercase and lowercase letters to have more legible names. In general, we must use lowercase letters in our names, except on the first letter of the names of the classes and interfaces, which must be in uppercase. Each subsequent word inside the name should be capitalized, according to the CamelCase naming convention. as well as the first letter of any not initial word (naming convention **CamelCase**).

Use uppercase in the first letter of standard acronyms. The names will generally have standard abbreviations, such as SQL by Standard Query Language. Names such as *sqlDatabase* for an attribute or *SqlDatabase* for a class are much easier to read than *sQLDatabase* and *SQLDatabase*.

### Verbs and nouns

Class and object names should be nouns or phrases of nouns. For example, *Customer* or *BankAssistant*. The name of a class should not be a verb.

On the other hand, method names should include a verb. For example, *save* or *retrieveResult*. The access methods and predicates must have as name its value and use as a prefix *get*, *set*, and *is*. For example:

```java
    String name = client.getName( );
```

### Consistency

- Choose a word for each abstract concept and maintain it across your code. It is very confusing to use different names (*get*, *retrieve*, ...) for equivalent methods from different classes, making harder to remember which method corresponds to each class. Function names must be independent and consistent in order to choose the correct method without need of additional searches. A coherent lexicon is a great advantage for developers who have to use our code.

- Avoid using the same word for two different purposes. Consider the example of having several classes in which a method *add* creates a new value by adding two existing values, and then we create a new class with a method that adds a value to a list. We could name this method *add*, but since there is a difference in semantics, we should use another name such as *insert*. We should always try to ease code's understandability.

### Use existent terminology 

- Try to use terminology in the domain's scope in which our code will live. Reuse computer terms, algorithms, patterns names, and other mathematical terms, when possible and build new ones when there is none appropriate. For example, if our users name their consumers as customers, it is strongly recommended to use the term *Customer* and not *Client*.

### Adding context to names

- Although some names have a meaning by themselves, generally this is not true and we need to add some context to names for classes, functions and methods. For example, consider the variables *firstname*, *lastname*, *street*, *number*, *city* and *country*. When combined, it becomes obvious that they refer to an address, but if the variable *number* is used in isolation on a method, we might not be able to identify that is a part of an address. In this case, the best course of action would be to create the *Address* class, so it would be clear that the variables belong to a broader concept.

### Length

- Short names are preferred, as long as they are clear enough. But if we need it, **don't hesitate using long names for the sake of your code readability**. For example, the names *AccountAddress* and *ClientAddress* are perfect for instances of the class *Address*, but do not serve as the class name. *Address* serves better as the class name.

Several communities have established and proposed their own conventions for JAVA identifier naming. In the following link, you can check Sun Microsystems' conventions:

[http://www.oracle.com/technetwork/java/codeconventions-135099.html](http://www.oracle.com/technetwork/java/codeconventions-135099.html)

---

## Function design

---

Functions are the first level of organization in any program. A function has to be easy to read and understand by other programmers. Here, you'll find some recommendations in order to assure that yours will have a good design.

A function should be **small**: there is not a standard size for a function. The recommendation has changed over time. In the 80's lines should not exceed 150 characters length and functions should not exceed 100 lines. Currently, functions should hardly ever be 20 lines long. But to reach transparency you could even create functions with only three or four lines.

**Use Descriptive names**: The function's name should provide information about the function's intent and describe what it does. If you have small functions with a single purpose it is easier to set descriptive names.
A very nice way to choose a function name is to use a verb and a noun. 

For example, this function name *boolean existFile(nameField)* is better than *boolean exist(nameField)* because the name provides information about the internal functionality.

Remember: Don’t be afraid of using long names, as it is better to have a long and descriptive name than a short and ambiguous one. The most important thing is making the function's intention clear.

Functions should **do one thing** and just one thing... and they should do that thing well. This is an important concept that helps you achieve other recommendations. Additionally, a function should not have side effects. When we break these rules and, for example, we add functionality in a function and we do not update its name accordingly, it can result in unexpected behaviors, incomplete tests, unnecessary coupling and after all, errors in the program.

Below is an example in which the *unregister* function does more than one thing and has an important side functionality.

``` java
public void unregisterUser(User user){
        userDao.unregisterUser(user);
        userDao.deleteUser(user);
}
```

It is clearly better to divide the function in other 2 functions:

``` java
public void unregisterUser(User user){
        userDao.unregisterUser(user);
}

public void deleteUser(User user){
        userDao.deleteUser(user);
}
```


Or at least, change the function's name to reflect its real behaviour (but this is a worse option):

``` java
public void unregisterAndDeleteUser(User user){
        userDao.unregisterUser(user);
        userDao.deleteUser(user);
}
```

How do we define our functions? We should try to build functions thinking that they have to do the necessary steps in the current level of abstraction, and delegate the following abstraction levels to other functions.

Always **use a single level of abstraction inside a function**, and avoid mixing levels of abstraction when coding, as it can be very confusing for others readers. For example, a function that retrieves a list of objects should not return the details for those objects too.

How should you organize all functions in your code? using the **Stepdown Rule** that lets others read the code from top to bottom. To organize the code like this, you have to place the functions followed by those at the next level of abstraction.

``` java
public void unregisterAndDeleteUser(User user){
        unregisterUser(user);
        deleteUser(user);
}


public void unregisterUser(User user){
        userDao.unregisterUser(user);
}

public void deleteUser(User user){
        userDao.deleteUser(user);
}
```
This practice is very important because it helps us to do short functions and to make sure that they do one thing and keeping the abstraction level consistent.


### Function Arguments
A function can be categorized depending on its number of arguments: 

- *niladic* function: zero arguments
- *monadic* function: one argument
- *dyadic* function: two arguments
- *triadic* function: three arguments
- *polyadic* function: more than three arguments (not recommended in most cases)

It is considered as a good practice to use the least possible number of input parameters. Not only it makes a function easier to understand, but arguments also severely affect to code testing. The more arguments a function has, more test cases must be done to cover all argument combinations. More than three of them complicates matters exponentially.

Using a *boolean input parameter* in a function is a terrible practice. Usually means that the method does more than one thing (one for each flag value). A good alternative to this is creating two separate functions.

### Common Monadic Forms (monads)

There are 3 forms:

- Asking a question about the argument 

``` java
boolean userExists(1178);
```

- Transforming the argument into something else and returning it.

``` java
InputStream fileOpen(“File”);
```
- Altering system's state instead of returning a value (less frequent)

``` java
void passwordAttemptFailedNtimes(int attempts);
```

No matter form, you should choose names that make the distinction clear, as stated in previous section.

Also, avoid mixing these forms, as it could lead to confusion. If you have a function that is going to transform the input argument, the result should be in the output argument even if it just returns the input argument:

```java
    StringBuffer transform(StringBuffer in)
```

and not: 

```java
    void transform(StringBuffer out)
```

### Dyadic Functions

Two argument functions are harder to understand than monadic functions. However, sometimes they are totally appropriate. A good example for this are functions working with coordinates.

However, beware of they come at a cost to the readers and maybe it would be recommended to try to convert them to monads.

### Triadic functions

Functions with three arguments are particularly complicated to the reader. You should take care and think if you really need a triad function.

### Polyadic functions

When there is a function that seems to need more than two or three arguments, the situation suggests that some of the arguments may be involved in a class that identifies them, using then an object as argument.

``` java
Circle createCircle(double x, double y, double radius);
Circle createCircle(Point center, double radius);
```

If you can't do this and you need to transfer a variable number of arguments, a good solution is to use a *single argument of type List*.

### Exceptions vs Returning Error Codes

Using return error codes in a function implies the use of *if statements* in the code, and can produce convoluted structures. Using exceptions enables us to separate error processing code from happy path code. 

Using *try/catch blocks* can confuse the code structure. A good practice is extracting try/catch blocks' body into functions, providing a nice separation, making the code easier to understand and modify.

``` java
public void delete(User user) {
       try {
              deleteUserAndAllTransactions(user);
       }
       catch (Exception e) {
              logError(e);
       }
}
private void deleteUserAndAllTransactions(User user) throws Exception {
       deleteUser(user);
       deleteTransactions(user);
}

private void logError(Exception e) {
       logger.log(e.getMessage());
}
```

*Error Handling Is One Thing*: A function that handles errors should not do others things.

## Comments and documentation

---

### Introduction
 
There is always controversy around code documentation and comments: some people prefers a more verbose approach by writing a lot of comments inside code and creating large documents where everything is explained in detail. For other people, source code should remain as neater as possible and be auto-explanatory, i.e. include as less comments and docs as possible, since they are not needed if the code is clean and structured. Some goes even further and states that comments are code smell. 

As in many other aspects, the best choice may be to meet both sides halfway, and that is our recommendation... to have a trade off between both edges.

### Documenting your code

Let us begin by stating the obvious: a public API needs to be well-described. Of course there are plenty of tools in the market to help you with this tedious but necessary task to document your application, but if you’re coding JAVA, then we think javadocs should be your way to go.

JAVAdoc generates API documentation automatically from source code with specially formatted documentation comments, more commonly known as doc comments. But furthermore javadoc is powerful because it is way better than a simple "//comment" :

It is recognized by most IDEs and used to display a pop-up when you move your cursor on top of one of your - javadoc-ed - function.
It can be parsed by external tools (like xdoclet)

Below is an example:

``` java
/**
 * Returns an Image object that can then be painted on the screen. 
 * The url argument must specify an absolute {@link URL}. The name
 * argument is a specifier that is relative to the url argument. 
 * <p>
 * This method always returns immediately, whether or not the 
 * image exists. When this applet attempts to draw the image on
 * the screen, the data will be loaded. The graphics primitives 
 * that draw the image will incrementally paint on the screen. 
 *
 * @param  url  an absolute URL giving the base location of the image
 * @param  name the location of the image, relative to the url argument
 * @return      the image at the specified URL
 * @see         Image
 */
 public Image getImage(URL url, String name) {
        try {
            return getImage(new URL(url, name));
        } catch (MalformedURLException e) {
            return null;
        }
 }

``` 

Using JAVAdoc acknowledges that there are two distinct questions a reader can ask about code:
 - what is this supposed to do? (answered only by the javadoc and method header)
 - how does it try to do it? (answered only by the implementation)

If JAVAdoc is properly written, then one can understand exactly what services are offered by a method ("what is this supposed this do?"), without having to look at its implementation ("how does it try to do it?"). Reading an implementation usually takes a lot more effort than reading javadoc.

The implementation can be checked for correctness versus the specification. That is, some bugs can be found just by reading the code, as opposed to executing it.

It is not the idea of this section to show JAVAdoc tool in depth, all details about it can be found in Sun’s JAVAdoc Guide  “How to Write Doc Comments”

### Comments

JAVAdoc comments and self-documenting code (and in-code comments) have two very different target audiences: 

JAVAdoc comments are typically for users of the API -also developers-, but they don't care about the internal structure of the system, just the classes, methods, inputs, and outputs of the system. The code is contained within a black box. These comments should be used to explain how to do certain tasks, what the expected results of operations are, when exceptions are thrown, and what input values mean. Given a JAVAdoc-generated documentation set, anyone should be able to fully understand how to use your interfaces without ever looking at a line of your code.

On the other hand the code and comments that remain in the code file are for developers. You want to address their concerns here, make it easy to understand what the code does and why the code is the way it is. The use of appropriate variable names, methods, classes, and so on (self-documenting code) coupled with comments achieves this.

As mentioned before it is sometimes said that most comments are just code smell. We think that what they are really referring to is that comments which do not bring anything interesting to our program should be avoided. Some wrong behaviours would be:

1. Redundancy in instance/class names   
   ```public SellResponse beginSellItem(SellRequest sellRequest) throws ManagedComponentException```
2. State the obvious like   
   ```i++; // increment i```
3. Commented-out code, if a version control tool is used, they are not necessary.
4. Comments right after closing a brace
5. Misplace (as in source control)
6. In general any noise to the code

To minimize the probability to fall in one of those bullet cases above, as a simple rule of thumb, it is best to try to keep it simple and write as few comments as possible. At least, think twice before write, see if the code can be written in a way that can elude the comment. And as usual, nothing like a good example to illustrate easier and better what we are trying to explain:

Let’s take a look at a typical example that can be easily found in many references across the web and which uses a Newton formula to calculate displacement.

```java
float a, b, c; a=9.81; b=5; c= .5*a*(b^2);
```

Most of readers could not take a look at this code and figure out a minimal idea about what the excerpt is pursuing, let alone if no other context is provided. One could be tempted to simply add some comments to fix it and write something like this:

```java
float a = 9.81; //gravitational force 
float b = 5; //time in seconds 
float c = (1/2)*a*(b^2) //multiply the time and gravity together to get displacement.
```

Although this is clearly much better than the initial one, it looks like it’s still kind of lame. 

```java
/* compute displacement with Newton's equation x = vₒt + ½at² */ 
float gravitationalForce = 9.81; 
float timeInSeconds = 5; 
float displacement = (1 / 2) * gravitationalForce * (timeInSeconds ^ 2)
```

Again better than before, this code is fine, but it could be rewritten in an equally informative way without any comment, for instance:

```java
float accelerationDueToGravity = 9.81;
float timeInSeconds = 5; 
float displacement = NewtonianPhysics.CalculateDisplacement(accelerationDueToGravity, timeInSeconds);
```

This code is now cleaner and self-explanatory, but this is of course totally subjective.

Anyways, many books and authors tend to preach that, quoting Robert C. Martin here, “when you find yourself in a position where you need to write a comment, think it through and see whether there isn’t some way to turn the tables and express yourself in code”.

And why do they say that?, you may wonder. Well, there is a problem with comments, a big one: comments -like code- need to be maintained, and if not, they often get old too quickly, so it might -it will- become really annoying to go through them. Or even worse, when not maintained the comment will rot and get “old” and end up confusing -in the best case scenario, or even “lying” in a worse one- while the code keeps changing.

Why would we even bother writing a comment when it can be explained through the code itself!? furthermore, efforts spent in maintaining comments are efforts that should be spend refactoring the code instead. 

Sometimes comments are good and/or necessary. Just be careful when using them, because often they are pointless if one takes a small pause and think a bit slower. 

And as it often happens, everything’s connected so, as it’s been explained before in previous sections, giving proper names to our variables and methods is essential to reach the goal and keep the code legible and self-documented. And so it is giving good format and style, as it will be explained in the next section.

## Formatting and code styling

---

Both code styling and format are very important, as they make the code much more maintainable and easy to scale.

### Vertical Formatting

When we review some piece of code, our eyes search for the first lines after a break line. Code should be structured with correct vertical formatting, allowing the code to be much clearer.

#### Vertical whitespace [blank lines]

Should be used between consecutive members of a class: fields, constructors, methods, nested classes, static initializers, instance initializers. It is not recommended to perform two consecutive blank lines.    

Example without break line:

``` java
package examples.java
public class Bicycle {
    public int cadence;
    public int gear;
    public int speed;
    public Bicycle(int startCadence, int startSpeed, int startGear) {
        gear = startGear;
        cadence = startCadence;
        speed = startSpeed;
    }
    public void setCadence(int newValue) {
        cadence = newValue;
    }
    public void setGear(int newValue) {
        gear = newValue;
    }
    public void applyBrake(int decrement) {
        speed -= decrement;
    }
    public void speedUp(int increment) {
        speed += increment;
    }
        
}
```

Example with break line:

```java
package examples.java

public class Bicycle {
        
    public int cadence;
    public int gear;
    public int speed;
        
    public Bicycle(int startCadence, int startSpeed, int startGear) {
        gear = startGear;
        cadence = startCadence;
        speed = startSpeed;
    }
        
    public void setCadence(int newValue) {
        cadence = newValue;
    }
        
    public void setGear(int newValue) {
        gear = newValue;
    }
        
    public void applyBrake(int decrement) {
        speed -= decrement;
    }
        
    public void speedUp(int increment) {
        speed += increment;
    }
        
}
```

#### Distance between variables
- **Local variables** should be declared as close to their usage as possible, enhancing code readability. It is not practical to keep on scrolling up just to look for the variables. Additionally, control variables for loops should be declared within the loop statement.

```java
//Declared within the loop
for (ObjectMember member : mapObjectMember.values()) {
    nodeGroup.setId(member.getId());
    nodeGroup.setName(member.getMember());
    }
}
```

- **Instance variables** should be declared at the top of the class. For example:

```java
public class Employee{

   private String name;
   private double salary;
  
   public String getName() {
      return name;
   }
   public void setName(String name) {
      this.name = name;
   }
   public double getSalary() {
      return salary;
   }
   public void setSalary(double salary) {
      this.salary = salary;
   }
}
```

#### Dependent Functions.
- If one function calls another, they should be vertically close, and the caller should be above the called function.   
Dependent function example:

```java
...
   public void a() {
     b();
   }
  
   public void b() {
     c();
   }
   
   public void c() {}
...
```

#### Ordering
- The following are the three basic points for ordering code excerpts:   
  - **Direct dependence:** when a function calls another. (See previous example)
  - **Affinity:** Set of functions that performs similar operations.
  - **Descending order:** creates a flow down the source code module from high level to low level.

### Horizontal Formatting
- **Line Length**, A line with more than 120 characters is not recommended, because they are not properly handled by many terminals and tools.
- **Wrapping Lines**, When an expression can't fit in a single line, break it according to these general principles: after a comma, before an operator and prefer higher-level breaks.

```java
//example of break after comma
    methodA(param1, param2, param3, 
        param4, param5)  


//example of breaking an arithmetic higher-level expression
  var1 = var2 * (var3 
      + var4) - var5;
  
  var1 = var2 * (var3 + var4) 
      - var5; //This is better than previous one.
```

- Line wrapping for "if": Double indentation should be used. 

```java
//double indentation
if (booleanA || booleanB || 
        booleanC || booleanD || 
        booleanE) {
    System.out.println("***");
}
```

- If you do not use braces for a "if", you should do a break line with indentation.

```java
if (booleanA) System.out.println("***");  // NO!

if (booleanA) 
   System.out.println("***");  // YES!
```

- **Declaration alignment**, It is recommended to declare a single variable per line, and it is not recommended to align the variable name.
Example:

```java
//not recommended
boolean var1;
int     var2;
float   var3;
int     var4, var5;

//this is better 
boolean var1;
int var2;
float var3;
int var4; 
int var5;
```

- **Blank Space**: Blank space should be used in the following situations:
  - A keyword followed by a parenthesis should be separated by space.
  - A blank space should appear after commas in arguments lists.
  - Binary operators.

```java
// Keyword example
if (condition) { //YES!!
  setA(x);
}
if(condition) { //NO!!
  setA(x);
}

//Arguments example
method(x, y, z); //YES!!
method(x,y,z); //NO!!

//binary operators example
a = (b + c) * (d + f); // YES!!
a = (b+c)*(d+f); // NO!!
```

- ***Indentation***, use four spaces for indentation to indicate nesting of control structures. Without indentation, programs would be virtually unreadable by humans.

Indentation example:

```java
class Example {
  int[] myArray = { 1, 2, 3, 4, 5, 6 };
  int theInt = 1;
  String someString = "Hello";
  double aDouble = 3.0;

  void foo(int a, int b, int c, int d, int e, int f) {
    switch (a) {
    case 0:
      Other.doFoo();
      break;
    default:
      Other.doBaz();
    }
  }

  void bar(List v) {
    for (int i = 0; i < 10; i++) {
      v.add(new Integer(i));
    }
  }
}

enum MyEnum {
  UNDEFINED(0) {
    void foo() {
    }
  }
}

@interface MyAnnotation {
  int count() default 1;
}
```

- Nowadays, common IDEs (Eclipse, IntelliJ, ...) allow us to format code automatically. IDEs establish a lot of parameters like indentation, braces, white spaces, blank lines, control statements, line wrapping, comments etc. When someone starts a new project, it is recommended to define these parameters, so all developers will have the same style and format.

## Encapsulation

---

Encapsulation allows data abstraction inside an object. For example, if an object needs to modify its internal behaviour, it will keep its interface intact. Objects do not have to expose every member, some of them can be hidden and not exposed through accessors.

In JAVA, POJOs (Plain Old JAVA Objects) that does not have any extra logic expose their fields through getter and setter methods.   

In the next example, we can see a bean with a simple constructor and all its fields exposed through getters.

```java
public class User {
	private String name;
	private String email;
	private Date dateOfBirth;

	public User(String name, String email, Date dateOfBirth){
		this.name = name;
		this.email = email;
		this.dateOfBirth = dateOfBirth;
	}

	public String getName(){
		return name;
	}

	public String getName(){
		return name;
	}

	public String getName(){
		return name;
	}
}
```

To preserve integrity, it is considered a good practice that every field inside an object is private, and let interactions with them to have place only through getters and setters. Getters and setters enable data enveloping, validation, transformation, synchronization, etc.

```java
import java.math.BigDecimal;
import java.math.RoundingMode;

public class Rectangle {
	private double height;
	private double width;

	public void setHeight(double height){
		if (height <= 0) throw new IllegalArgumentException();
	    this.height = getRounded(height);
	}

	public void setWidth(double width){
		if (width <= 0) throw new IllegalArgumentException();
	    this.width = getRounded(width);
	}

	private double getRounded(double value){
		BigDecimal bd = new BigDecimal(value);
	    bd = bd.setScale(2, RoundingMode.HALF_UP);
	    return bd.doubleValue();
	}

	public double getArea() {
		return height * width;
	}
}
```

### Law of Demeter (LoD)

It is a guideline to develop loosely coupled software. It states that a module should not know about the internal workings of the objects it uses. Internal structure and implementation details should not be exposed for consumers, which only know about external interface that defines the object behaviour.

Let us consider an object A which has an instance of object B, which in turn has an object C. A should not be able to directly perform calls to object C through B, unless B's interface allows it explicitly

The Law of Demeter says that a method m of a class C should only call methods of:
* C
* Objects created by m
* Objects as arguments on m
* Objects as variables on C

Sometimes, this law can not be applied strictly, specially when we are using third party libraries which do not allow us to apply the rule completely. LoD should be applied, whenever possible, to follow the encapsulation definition.

In summary, objects **expose behaviour** and **hide data**, the object's interface should isolate the internal data of that object.

## Exception handling

---

Nobody likes exceptions but the fact is that we have to deal with them. The good part is that JAVA Exception Handling Framework is very robust and easy to understand and use. Exceptions can come up from different kind of situations: wrong data entered by user, hardware failure, network connection failure, database server error and so on.

JAVA is a OOP language, so when a error occurs while executing a statement, creates an **exception object** and then the normal flow of the program halts and tries to find someone that can handle the raised exception. The exception object contains a lot of debugging information such as method hierarchy, line number where the exception occurred, exception type... When the exception occurs in a method, the process of creating the exception object and handing it over to runtime environment is called **throwing the exception**.

Once runtime receives the exception object, it tries to find the handler for the exception. Exception handler is the block of code that can process the exception object. The logic to find the exception handler is simple – starting the search in the method where error occurred, if no appropriate handler found, then move to the caller method and so on. So if methods call stack is A->B->C and exception is raised in method C, then the search for appropriate handler will move from C->B->A. If appropriate exception handler is found, exception object is passed to the handler to process it. The handler is said to be *catching the exception*. If there are no appropriate exception handler found then program terminates printing information about the exception.

### Keywords

JAVA provides specific keywords for exception handling purposes:

- **throw**: We know that if any exception occurs, an exception object is getting created and then JAVA runtime starts processing to handle them. Sometimes we might want to generate exception explicitly in our code, for example in a user authentication program we should throw exception to client if the password is null. **throw** keyword is used to throw exception to the runtime to handle it.

- **throws:** When we are throwing any exception in a method but we want that exception to be propagated outside, then we need to use **throws** keyword in method signature to let caller program know the exceptions that might be thrown by the method. The caller method might handle these exceptions or propagate it to it’s caller method using throws keyword. We can provide multiple exceptions in the throws clause and it can be used with main() method also.

- **try-catch:** We use try-catch block for exception handling in our code. **try** is the start of the block and **catch** is at the end of try block to handle the exceptions. We can have multiple catch blocks with a try and try-catch block can be nested too. catch block requires a parameter that should be of type Exception.

- **finally:** finally block is optional and can be used only with try-catch block. Since exception halts the process of execution, we might have some resources open that will not get closed, so we can use finally block. finally block gets executed always, whether exception occurred or not.

The following example shows the use of the keywords to handle exceptions:

```java
package com.beeva.examples;

import java.io.FileNotFoundException;
import java.io.IOException;

public class ExceptionHandling {

	public static void main(String[] args) throws FileNotFoundException, IOException {
		try {
			testException(-5);
			testException(-10);
		} catch(FileNotFoundException e) {
			e.printStackTrace();
		} catch(IOException e) {
			e.printStackTrace();
		} finally {
			System.out.println("Releasing resources");			
		}

		testException(15);
	}

	public static void testException(int i) throws FileNotFoundException, IOException {
		if (i < 0) {
			throw new FileNotFoundException("Negative Integer " + i);
		} else if (i > 10) {
			throw new IOException("Only supported for index 0 to 10");
		}
	}
}
```

The output of the program is:

``` 
java.io.FileNotFoundException: Negative Integer -5
  at com.journaldev.exceptions.ExceptionHandling.testException(ExceptionHandling.java:24)
  at com.journaldev.exceptions.ExceptionHandling.main(ExceptionHandling.java:10)

Releasing resources

Exception in thread "main" java.io.IOException: Only supported for index 0 to 10
  at com.journaldev.exceptions.ExceptionHandling.testException(ExceptionHandling.java:27)
  at com.journaldev.exceptions.ExceptionHandling.main(ExceptionHandling.java:19)
```

Notice than *testException(-10)* never get executed because of exception *testException(-5)* and then execution of finally block after try-catch block is executed.

### Types of Exceptions

JAVA Exceptions are hierarchical and inheritance is used to categorize different types of exceptions. Throwable is the parent class of JAVA Exceptions Hierarchy and it has two child objects – Error and Exception. Exceptions are further divided into checked exceptions and runtime exception.

* **Errors:** Errors are exceptional scenarios that are out of scope of application and it’s not possible to anticipate and recover from them, for example hardware failure, JVM crash or out of memory error. That’s why we have a separate hierarchy of errors and we should not try to handle these situations. Some of the common Errors are OutOfMemoryError and StackOverflowError.

* **Checked Exceptions:** Checked Exceptions are exceptional scenarios that we can anticipate in a program and try to recover from it, for example FileNotFoundException. We should catch this exception and provide useful message to user and log it properly for debugging purpose. Exception is the parent class of all Checked Exceptions and if we are throwing a checked exception, we must catch it in the same method or we have to propagate it to the caller using throws keyword.

* **Runtime Exception:** Runtime Exceptions are caused by bad programming, for example trying to retrieve an element from the Array. We should check the length of array first before trying to retrieve the element otherwise it might throw ArrayIndexOutOfBoundException at runtime. RuntimeException is the parent class of all runtime exceptions. If we are throwing any runtime exception in a method, it’s not required to specify them in the method signature throws clause. Runtime exceptions can be avoided with better programming.

### Exception methods

Exception and all of it’s subclasses do not provide any specific methods and all of the methods are defined in the base class Throwable. The exception classes are created to specify different kind of exception scenarios so that we can easily identify the root cause and handle the exception according to it’s type. Throwable class implements Serializable interface for interoperability.

Some of the useful methods of Throwable class are:

* **public String getMessage():**

* **public String getLocalizedMessage():** This method is provided so that subclasses can override it to provide locale specific message to the calling program. Throwable class implementation of this method simply use getMessage() method to return the exception message.

* **public synchronized Throwable getCause():** This method returns the cause of the exception or null id the cause is unknown.

* **public String toString():** This method returns the information about Throwable in String format, the returned String contains the name of Throwable class and localized message.

* **public void printStackTrace():** This method prints the stack trace information to the standard error stream, this method is overloaded and we can pass PrintStream or PrintWriter as argument to write the stack trace information to the file or stream.

### Recommendations

#### Categorize exceptions by cause

Since exceptions come with a *stacktrace*, it is more useful to categorize them by subsystem causing failure, rather than by which application module the failure occurred in. For example, categorizing exceptions into SQL, file access, or configuration types is generally far more useful than separate types for Customer, Account, and Order modules.

#### Simple exception hierarchy

A simple hierarchy is easy for developers to use and throw, making it obvious to find *the right exception*. It should offer basic broad categories for diagnosis & handling.

Overly complicated hierarchies, non-obvious naming, or per-module exceptions leave developers scratching their head looking round for what to use. It should not be that hard. Library code which is genuinely separate from the application body may deserve it’s own exceptions, but don’t go overboard.

A clean and effective hierarchy may look like this:

* FailureException extends RuntimeException
  * AppSQLException
  * AppFileException
  * AppConfigException
  * AppDataException
  * AppInternalException


* RecoverableException extends RuntimeException
  * UserException
  * ValidationException

In this hierarchy, exceptions a developer needs to rethrow will be under an “App*” exception classname. This makes it easy for developers to find and throw the correct type.

#### Converting Checked Exception into RuntimeException

This is one of the techniques used to limit use of checked Exception in many of frameworks like Spring, where most of checked Exceptions which stem from JDBC, are wrapped into DataAccessException, an unchecked Exception.

This JAVA best practice provides benefits, in terms of restricting specific exception into specific modules, like SQLException into DAO layer and throwing meaningful RuntimeException to client layer.

#### Use Standard Exceptions

Using standard Exception instead of creating own Exception every now and then is much better in terms of maintenance and consistency. Reusing standard exception makes code more readable, because most of JAVA developers are familiar with standard RuntimeException from JDK like, *IllegalStateException*, *IllegalArgumentException* or *NullPointerException*, and they will immediately be able to know purpose of Exception, instead of looking out another place on code or docs to find out purpose of user defined Exceptions.

#### Catch at the outermost level

Exceptions must be reported to the business/external world, and this is done by returning a 500 “error response” or displaying an error in the UI.

Since such ‘catch’ block or exception handler requires access to the outside to respond, it means exceptions must be caught and handled at the outermost level. Simultaneously, the final handler should log the exception and full *stacktrace* for further investigation.

**Catch blocks** in internal code should be avoided and their use minimized as they interfere with the reliable propagation of exceptions to the outermost handler.

#### Rethrow with a cause

In most projects, the most common exception handling code is actually just to rethrow the exception. While the guide lines above should help you drastically reduce the number of catch-blocks you code, it’s crucial to code the remaining ones correctly.

First and most important, **always include the cause**. Constructing and throwing a wrapper exception must always provide full details of the underlying failure.

Logging should generally be left to the outermost handler. This may seem counter-intuitive, but if your outermost handlers are comprehensive and correct, all exceptions will be logged there. Avoid duplication.

In some methods, it is perfectly valid to **catch and rethrow** exceptions to provide a more informative message or additional diagnostic information.

#### Never use exceptions for flow control

The exceptions are expensive operations and as the name would suggest, exceptional conditions. Using exceptions for control flow is an anti-pattern, and it carries the following handicaps:

* Leads to more difficult to read and understand code.
* JAVA has existing control structures designed to solve the problems without the use of exceptions.
* The modern compilers tend to optimize with the assumption that exceptions are not used for control flow.

#### Add informative messages

While throwing runtime exceptions outward requires the minimal amount of code, we may sometimes want better information as to what action & data failures the program failed on.

The ideal, is for exception messages to be self-diagnosing. Any developer should be able to read the exception message and immediately understand what failed.

Great informative reporting requires only a few steps:

1. Throw a type, appropriate to the underlying cause.
2. Message stating what failed.
3. Include the query parameters for data being accessed.

#### Use logging

Again, exceptions should be logged at the outermost handler, to capture a comprehensive record of failures.

Methods throwing exceptions can also log error or warning lines to enrich the log output & increase the available information. Since major facts should be in the exception message, this is normally used to provide more minor & contextual detail.

As well as recording exceptions, logging should also record your program’s activity and decisions to understand why an exception occurred. Good practice is to log major business requests, decisions, outcomes and actions, these provide the context to understand what your program is doing and why.

---

## Log traces

JAVA logging is not an exact science since is left to the programmer several decisions based on his/her experience, for instance the log level to use, the format of the messages or displayed information, all this is very important since it is proven that JAVA logging affects to the efficiency of ours applications. Here we offer an outline of how to make good use of the java logs.

### First choose an appropriate tool for logging

We recommend you to use the abstraction layer SLF4J (Simple Logging Facade for JAVA), this facade give us a list of improvements:
* Loose coupling: using SLF4J we are not linking our classes to an implementation of logging in particular. Thus in a future if we change that implementation we don't need to modify our classes.
* The only dependency in application components should be on the SLF4J API, no class should reference any other logging interfaces.
* SLF4J's parameterized logging: SLF4J has a feature that help us to construct messages in a way much more attractive. Example: 

		logger.debug("There are " + numberOfBooks + " of " + kind); //Log4J
		logger.debug("There are {} of {}", numberOfBooks, kind);//SLF4J
	
	As we can see, the second form is shorter and easier to read, it is also more efficient thanks to the way SLF4J build messages

### Logging levels
For each message, we have to think carefully which level is the most appropriate. Logging affects our application's performance because each log entry can result in a file IO operation. Log4J provides 6 log levels:

**FATAL:** for critical messages, usually the application will abort after save the message

**ERROR:** designates error events that might still allow the application to continue but it has to be investigated quickly.

**WARN:** used for messages of alert that we want to save but the application still will follow running

**INFO:** provides information about the progress and the status of the application very useful for the final user 

**DEBUG:** this level is used to get useful information for developers to debug the application. Commonly this level is only used in development environments

**TRACE:** used to show an information more detailed than debug

### Is Log4j isDebugEnabled() necessary?
This method is only worth of use it if we are not using SLF4J and we can prove that the construct of the specified log is expensive. Example of use:

         if (log.isDebugEnabled()) {
   	 		log.debug("Something happened");
		 }
	
### Use rotation policies
Logs can take up a lot of space. Maybe you need to keep years of archival storage, but the space is limited and expensive. So, we have to set up a good rotation strategy and decide whether to destroy or back up your logs but always it has to allow the analysis of recent events.

For example, to create daily rolling log files, we have to configure log4j, in that case log4j provides the DailyRollingFileAppender class. Here is an example of a log4j’s properties configuration file 

    log4j.appender.Appender2=org.apache.log4j.DailyRollingFileAppender
    log4j.appender.Appender2.File=app.log
    log4j.appender.Appender2.DatePattern='.'yyyy-MM-dd

### Be concise and descriptive
It's important to log in simple English, it should make sense and human readable. Usually trace log entries include data and description in a single line.
Example: 

    log.debug(“Ending”); //Only description, no data
    log.debug(status); //Only data, no description
    log.debug(“Ending. status is {}”, status); //Is better to put data and description together

### Be careful logging
We have to keep attention that we are logging and avoid typical mistakes.

* Avoid null pointer exceptions:
    ``` java    
        log.debug(“Correct insertion for the user {} ”, user.getId());
    ```
    
    Are we sure that user is not nullpointer? 

* Avoid logging collections:
    ``` java
        log.debug(“Inserting users {} ”, users);
    ```
    
    A lot of errors can happen: object users not initialized, thread startvation, ouf of memory errors... It is better to log only the size of the collections or the id of each iteration.

* Never log sensitive information as password, credit car numbers or account number

### Log exceptions properly
The usual rule is to not log any exceptions, but there is an exception; if we throw exceptions for some remote service that is capable of serializing exceptions. There are two basic rules to throw an exception:
* If you re-throw an exception, don't log it. For example:

    ```  java
            try {
    			/ …..
    		} catch (IOException ex) {
    			log.error(“Error: {}”, ex);
    			throw new MyCustomerException(ex);
    		}
    ```
    
    This is wrong, we would be duplicating traces of the same error in the logs. Log, or wrap and throw back, never both,

* In order to log an exception the first argument is always the text message, write something about the nature of the problem, and the second argument is the exception itself.
``` java
        log.error("Error reading configuration file", e);
```        

---

## Code testing
---

### Introduction

We strongly believe that an application is incomplete unless it has a good battery (and ideally, automated) test to ensure that its intended purpose and functionality is fulfilled. Moreover, catching bugs early is really important because the effort put to solve a bug in production is overwhelmingly greater than in development stages. Finally, a good battery test provides a high confidence for developers when it comes to do some complex refactors and maintenance in the application.

A common mistake is to believe that there is a lack of time to build tests for the applications. But if we get used to backup our developments with tests (applying the TDD philosophy) we will realize that is not that expensive and the benefits are so big that this is a worthy task to do.

### Are my tests good?

For us, a good test should satisfy the following guidelines:

- Tests one and only one feature
- Is fast, a slow test usually is a bad designed test
- Does not depends on the order in which is executed related to other tests
- Does not depends on the state of the test environment, in other words could be executed everywhere
- Abstract unnecessary complexity using mocks or stubs
- Does not affect to "real" environments' state
- Should externalize common steps to a centralized point, for example a **setUp()** method
- Follow the AAA pattern (Arrange - Act - Assert)
    - Arrange : prepare test data
    - Act : execution of Code Under Test
    - Assert : verifications to check if test did pass or not
- Is well structured to enhance readability
    - For the sake of readability, sometimes is goo to delegate each AAA phase to a separate method with a proper name

### Test types

We use different types of tests:

- Unitary tests
    - Their purpose is to test classes or methods in isolation (mocking or stubbing external dependencies)
    - We should check that the execution of the test effectively follows the expected flow
    - Infrastructure should be mocked or simulated to increase isolation level (for example, use an in-memory database or mocking the repository classes that access that data)
- Integration tests
    - Their purpose is to test several functional blocks working
    - Do not use mocks or stubs
- Acceptance tests
    - Usually they are specified or defined by the end user
    - There are some tools to implement this type of tests, like cucumber/gherkin
    - These tests are beyond the scope of this document at the moment
- Stress tests
    - Ensure that the whole environment in which the application lives is able to handle a minimum incoming traffic (e.g. requests)
    - These tests are beyond the scope of this document at the moment

### Tools

We use the following tools to implement our tests:

- JUnit
- Mockito
- Wiremock
    - It is beyond of the scope of this guide to document the use of Wiremock, please visit its [official website](http://wiremock.org/) to find out more information about this excellent mocking tool
- Spring test
- Cucumber JVM
- Selenium (for tests that involve some front-end management)
- JMeter and Stem (for stress tests)

### Continuous integration

It is strongly recommended to complement our test batteries with a CI tool, like Jenkins. When possible, we should trigger those batteries whenever a commit is performed on the version control repository and have some feedback mechanism to alert about broken tests (for example, an email distribution list or a slack channel).

We also add to the Continuous Integration flow a Sonar analysis to ensure a minimal code quality in our developments.

### Tests in Agile environments

It is **very important** to include test revision in our Definition Of Done (DoD) and, when possible, to make a cross check with another developer in the team. Could be a good idea to include a new state in our scrum taskboard for this purpose (for example, PENDING > WORK IN PROGRESS > PLEASE TEST > PLEASE QA > COMPLETED)

Also, for complex tasks it is recommended to build a battery test plan together with one or more other members of our team (pair programming or mob programming). This is the only way to ensure that our battery test is good enough to reduce the bugs to the minimum.

### Examples

The following examples use Spring to code tests.

#### Integration test with mock

``` java

    import transfer.TransferApp;
    import transfer.TransfersRequest;
    import transfer.TransfersResponse;
    import com.github.tomakehurst.wiremock.WireMockServer;
    import com.github.tomakehurst.wiremock.core.WireMockConfiguration;
    import org.junit.After;
    import org.junit.Assert;
    import org.junit.Before;
    import org.junit.Test;
    import org.junit.runner.RunWith;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.test.SpringApplicationConfiguration;
    import org.springframework.test.context.ActiveProfiles;
    import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
    import org.springframework.test.context.web.WebAppConfiguration;

    import static org.hamcrest.Matchers.equalTo;

    /**
     * Tests for Transfer service.
     * This tests run a Wiremock server
     *
     * @author BEEVA
     */
    @RunWith(SpringJUnit4ClassRunner.class)
    @SpringApplicationConfiguration(classes = TransferApp.class)
    @WebAppConfiguration
    @ActiveProfiles("test")
    public class TransferServiceTest {
        private WireMockServer wireMockServer;

        @Autowired
        TransferService transferService;

        @Before
        public void setUp() {
            WireMockConfiguration wmc = new WireMockConfiguration();

            wmc.withRootDirectory("src/test/resources/wiremock");   // Wiremock mapping files
            wmc.port(9999);

            wireMockServer = new WireMockServer(wmc);
            wireMockServer.start();
        }

        @Test
        public void sendTransferOK() throws Exception {
            /**
             * Arrange
             */
            TransfersRequest TransfersRequest = new TransfersRequest();
            TransfersRequest.getReceiver().getAccount().getFormats().setCcc("01824000690201927865");
            TransfersRequest.getReceiver().getCustomer().setName("National test");
            TransfersRequest.getAmount().getCurrency().setId("EUR");
            TransfersRequest.getAmount().setAmount("100.00");
            TransfersRequest.getSender().getAccount().setId("ES0182002000000000000000000034211780XXXXXXXXX");
            TransfersRequest.getSender().getCustomer().setId("58987989E76356194I2015284");
            TransfersRequest.setDescription("Send money to someone");

            /**
             * Act
             */
            TransfersResponse response = transferService.sendMoney(TransfersRequest);


            /**
             * Assert
             */
            Assert.assertThat(response.getId(), equalTo("15500006201041"));
        }

        @After
        public void tearDown() {
            wireMockServer.stop();
        }
    }
```

> **Notes**

    - Always try to use hamcrest matchers together with assertThat() method instead of assert()

    - We only show happy path test here, error cases omitted

#### Unit test with Mockito

``` java

    import rest.service.StatusService;
    import rest.service.impl.StatusServiceImpl;
    import org.junit.Assert;
    import org.junit.Before;
    import org.junit.Test;
    import org.junit.runner.RunWith;
    import org.mockito.InjectMocks;
    import org.mockito.Mock;
    import org.mockito.Mockito;
    import org.mockito.runners.MockitoJUnitRunner;
    import org.springframework.data.mongodb.core.MongoOperations;
    import org.springframework.http.HttpEntity;
    import org.springframework.http.HttpMethod;
    import org.springframework.http.HttpStatus;
    import org.springframework.http.ResponseEntity;
    import org.springframework.web.client.RestTemplate;

    import java.util.HashSet;

    import static org.mockito.Matchers.*;
    import static org.mockito.Mockito.when;

    @RunWith(MockitoJUnitRunner.class)
    public class TestStatusService {

        @Mock
        private RestTemplate restTemplateMock;

        @Mock
        private MongoOperations mongoTemplateMock;

        @InjectMocks
        private StatusService statusService = new StatusServiceImpl();

        HashSet<String> response;

        @Before
        public void setUp() throws Exception {
            response = new HashSet<>();

        }

        @Test
        public void testGeneralStatusOk() throws Exception {
            /**
             * Arrange
             */

            when(mongoTemplateMock.getCollectionNames()).thenReturn(response);
            when(restTemplateMock.exchange(startsWith("http://localhost:8086"), eq(HttpMethod.GET), any(HttpEntity.class), any(Class.class)))
                    .thenReturn(new ResponseEntity<byte[]>(HttpStatus.OK));

            /**
             * Act
             */
            String status = statusService.getGeneralStatus();

            /**
             * Assert
             */
            Assert.assertTrue("OK".equals(status));
            Mockito.verify(mongoTemplateMock).getCollectionNames();
            Mockito.verifyZeroInteractions(restTemplateMock.getForEntity(Mockito.anyString(), Mockito.any(Class.class), Mockito.anyVararg()));
        }
    }
```

## Hints about code optimization

---

One of the essential aspects in today's programming techniques is source code optimization. Code's quality has direct impact on the needed resources for its implementation (memory, disk, bandwidth, etc.) and is fully decisive in the final performance of the application.

In order to get a high quality source code, it is essential to have a phase of powerful technical design, where complex situations that require a detailed study of the solution (applications requiring synchronization mechanisms especially complex, critical performance needs, etc.) are foreseen.

In order to meet high quality standards, it is interesting to also have Code Review stages, where solutions can be studied and possible breaches on the technical design can be detected.

### General recommendations

#### Basic types

##### Working with text strings

When working with strings, usually small mistakes are made. If this small mistakes are used extensively in the code, overall application performance can be affected. These are some of the most common errors:

###### Unnecessary String creation

JAVA reuses String constants in a very efficient way. For this reason, sometimes is better to directly assign a String constant than instantiate a String object.
 
 ``` java
    String myString = new String("myValue"); // Not recommended
    String myString = "myValue"; // Recommended
 ```

###### Using strings to compare characters

It is much more efficient to use *charAt()* method than *substring()* when performing validations over a single character in a given string.

``` java
    myString.substring(i, i+1).equals(" "); // Not recommended
    myString.charAt(i).equals(' '); // Recommended
```

###### Concatenation of strings using String

The concatenation of *String* objects impacts on performance because this concatenation triggers creation of new temporary objects, that can consume a lot of memory. The reason is that *String* instances are immutable objects in JAVA. It is much more efficient to use a StringBuffer and when all concatenations are completed, convert it to a String.

> Immutable objects are the ones that, once created, can not be modified

```java
	// This excerpt has a poor efficiency
	for (int i=0; i<10; i++) {
		exampleString = exampleString + computeSuffix(i);
	}
```

```java
    // Much better approach
	StringBuffer exampleStringBuffer = new StringBuffer();
	for (int i=0; i<10; i++) {
		exampleStringBuffer.append(computeSuffix(i));
	}
	exampleString = exampleStirngBuffer.toString ();
```

###### Using the StringBuffer class

The StringBuffer class uses a char array underneath to store its content. If not specified, default size for a just created StringBuffer is 16 positions. Whenever is necessary to increase the StringBuffer capacity, a new array with higher capacity is created and initialized with the elements of the original array. Finally the new array is assigned to the StringBuffer and the original one is discarded. This process is heavy and consumes memory and CPU time.

To avoid this, usually a proper capacity is specified when instantiating the StringBuffer object, according to your needs.

Additionally, when obtaining the StringBuffer size, you should not convert it to a String:

``` java
    myStringBuffer.toString().length(); // Not recommended
    myStringBuffer.length(); // Recommended
```

###### Misuse or disuse of *intern()*

From JAVA version 2, the constant and literal *String* are canonical: this means that a single copy of each *String* is automatically saved into an internal table for re-use in all instances in the execution.

Taking advantage of this implementation, one efficient way to compare two strings is to use this internal table and compare references instead of the contests of each String.

To access this internal table, JAVA provides the *intern()* method, that returns the reference in the table. Suppose two String defined as *s1* and *s2*, it holds that ```s1.intern() == s2.intern() if and only if s1.equals(s2) = true```.

Instead of comparing like this:

```java
	Boolean compareDayOfTheWeek (String s)
	{
		if (s.equals("Monday")) { ...	} 
		else if (s.equals("Tuesday")) { ... }
	}
```

It's more efficient to do it like this:

```java
	Boolean compareDayOfTheWeek (String s)
	{
		String s2 = s.intern ();
		if (s2 == "Monday") {	...}
		else if (s2 == "Tuesday") {...}
	}
```

This optimization is recommended only when comparing a restricted set of values of String objects (days of the week, seasons of the year, etc.), since intern has a significant cost associated with: seeks the chain on the inner table, and if the string does not exist, it is recorded on the table.

###### Using the StringTokenizer

The use of *StringTokenizer* implies a high consumption of resources, so it is advisable to avoid it in unnecessary cases. Instead of this class, the use regular expressions is recommended or, when possible, the split method.

###### Copying strings "manually"

Instead of performing a loop to copying arrays

```java
	int len = arr1.length;
	for (int i = 0; i< len; i++) {
		arr2[i] = arr1[i];
	}
```

The use of the ```System.arraycopy()``` method is advised, because it is efficient and it is a proven solution.

```java
	System.arraycopy(arr1, 0, arr2, 0, arr1.length);
```

##### Collections

It is recommended to use the collections implemented in the Standard JAVA libraries, since they are efficient and are properly tested:

* *ArrayList*for sequences
* *HashSet* for sets
* *HashMap* for associative arrays
* *LinkedList* for both heads (better than *Stack*) and tails.

Many of the standard collections are synchronized, and should be used with special care and taking notice of the inner mechanisms of synchronization that they use. For example, the *Vector* and *HashTable* collections are synchronized on the access to its data structures and should be used in specific scenarios, not in general ones.

In addition, in order to leverage polymorphism, make use of the available interfaces:

* *ArrayList* as a *List*
* *HashSet* as *Set*
* *HashMap* as *Map*

There are also classes that provide algorithms for handling of collections:

* *Arrays* provides algorithms for handling operations on arrays.
* *Collections* allows to get fully synchronized data structures from other data structures. Special attention must be put when using them (see the section dedicated to synchronization).

It is convenient to **stablish the size of the collections correctly**, making correct use of provided builders, in a way that will save resources at run time. For example:

* For the *Vector* class, the preferred builder is the one which allows establishing the initial capacity and sets a parameter with the desired default increase: ```Vector (int initialCapacity, int capacityIncrement)```.
* For the *HashMap* class, a similar situation arises. Of all the available constructors, it is recommended to use the one which allows establishing an initial size and load factor (percentage of occupation that triggers a resize of the hash table): ```HashMap (int initialCapacity, float loadFactor)```. The bigger the load factor is, the less memory is occupied by the collection, but more expensive is the search for elements, affecting the *get()* and *put()* methods.

Another often neglected aspect is to keep in-memory collections that are not going to be used anymore, consuming large amounts of resources unnecessarily. To avoid this situation we recommend using:

* ```Collection.clear()``` if it is supported.
* ```Vector.setSize (0)``` for collections of *Vector* instances.

##### Date management

A common practice in managing dates is to use the *SimpleDateFormat* class. The creation of a *SimpleDateFormat* is more expensive both in memory consumption and CPU, than the formatting of a date with the parse method of the same class. If you frequently use SimpleDateFormat it is recommended to have a pool of objects and reusing them.

```java
	exampleFormater = PoolSimpleDateFormat.getFormater();
	exampleFormater.applyPattern (pattern);
	exampleFormater.parse ();
```

On methods that are used frequently, and this being possible, ```System.currentTimeMillis ()``` must be used, instead of using ```java.util.Date ()``` or ```java.util.GregorianCalendar```, because it is much less expensive. For example, to calculate the elapsed time between two instants, it is much more efficient to perform the calculation in milliseconds (long type) than instantiating two Date objects and comparing them.

> ```System.currentTimeMillis()``` returns the number of milliseconds since January 1, 1970

Another example, could be controlling when a cached data expires. The expiration time can be calculated by adding the number of milliseconds from the current date plus the validity time in milliseconds.

Not optimized solution:

```java
	GregorianCalendar expiration = new GregorianCalendar();
	expiration.add (GregorianCalendar.SECOND, validityTimeInSeconds);
	cacheObject.setExpiration (expiration);
	
	// Check if it has expired
	if (cacheObject.getExpiration().before( new GregorianCalendar())) {
	   // It has expired
	}
```

Optimized solution:

```java
	cacheObject.setExpiration(System.currentTimeMillis () + validityTimeInMillis);
		
	// Check if it has expired
	if (cacheObject.getExpiration () > System.currentTimeMillis ()) {
	   // It has expired
	}
```

Note: JAVA 8 includes a totally new Date API, inspired on JodaTime, that is very convenient to use if possible.

#### Basic operations

##### Casting

Casting operations impact on performance and in the majority of cases there are alternatives with better performance.

If it is necessary to perform multiple casting operations on the same object, it is recommended to create a temporary object and make a unique casting, instead of performing the casting each time that is needed:

```java
	if (myObj instanceof MyClass) {
		return ((MyClass) myObj).method1() + ((MyClass) myObj).method1();
	}
```

A better solution would be minimize casting operations:

```java
	if (myObj instanceof MyClass) {
		MyClass temp = (MyClass) myObj;
		return temp.method1() + temp.method1();
	}
```

##### The use of Static

The properties of objects of a class that are common to all instances must be defined at class level (*static*). In particular, the constant data must be defined as a JAVA constant (*static final*).

```java
	public class Order {
		private String tableName;
		public String getTableName();
	}
	...	
	Order order = new Order ();
	order.getTableName()
```

On this example, the "order" object is created specifically to call the *getTableName()* method. If that method is independent of the attributes of the calling object instance, this other approach should be used:

```java
	public class Order {
		private static String tableName;
		public static String getTableName();
	}
	...
	Order.getTableName();
```

##### Serialization

In general, **serialization is very expensive**. You should consider using *transient* modifier for variables that are not essential to retrieve when deserializing. This way, object tree references are pruned and serialization process has a reduced cost.   

In some cases, it could be more efficient to override serialization/deserialization methods (overwriting the *writeObject()* and *readObject()* methods).

##### Speculative Casting

You should not use exceptions to validate conditions: 

```java
	try {
		((SomeObj) o).someOperation();
	} 
	catch (ClassCastException ccx) {
		try {	
			((SomeObj2)o).SomeOperation2();	
		}	
		catch(ClassCastException ccx) {...}
	}
```

Instead, it is better to use the *instanceof* operator:

```java
	if (o instanceof SomeObj1) {
		((SomeObj1) o).someOperation();
	}
	else if (o instanceof SomeObj2) {
		((SomeObj2) o).someOperation2();
	}
```

In general, it is not acceptable to get a performance improvement in exchange of a worse design.

##### Unnecessary calculations and code

When coding, it is important to reduce repetitive calculations.

For example, data type conversion usually is performed wherever is needed:

```java
	calculation = performCalculation();
	System.out.println(calculation.toString());
	theKey = calculation.toString() + "_001_" + type;
	filename = calculation.toString() + "_"+timestamp + ".xml";
```

But it should be better to do it once, and reuse the converted value:

```java
	calculation = performCalculation();
	calculationSt = calculation.toString(); // Just one toString()
	System.out.println(calculationSt);
	theKey= calculationSt + "_001_" + type;
	filename= calculationSt+"_" + timestamp + ".xml";
```

Similarly, we should avoid performing operations in loop conditions:

```java
	for (int i = 0; i < myList.size(); i++) {
		System.out.println(myList.get(i).toString());
	}
```

The calculation of the termination condition will run on each iteration of the loop, degrading performance. It would be much better if the calculation is only performed once:

```java
	int size = myList.size();
	for (int i = 0; i < size; i++) {
		System.out.println(myList.get(i).toString());
	}
```

Unnecessary expensive function calls must be avoided. For example, an expensive function is invoked and then depending on a condition its result is used or not:

```java
	public int sumLists(List l1, List l2)
	{
		FormattedTable t1 = new FormattedTable(l1);
		FormattedTable t2 = new FormattedTable(l2);
		if (l1==null) return;
		temp1 = sum(t1);
		if (l2 == null) return;
		temp2 = sum(t2);
		return temp1 + temp2;
	}
```

Reorganizing the conditions, the creation of the tables and in some cases, the first addition operation can be avoided:

```java
	public int sumLists(List l1, List l2) 
	{
	    if (l1 == null || l2 == null) return;
	    FormattedTable t1 = new FormattedTable(l1);
	    FormattedTable t2 = new FormattedTable(l2);
	    temp1 = sum(t1);
	    temp2 = sum(t2);
	    return temp1 + temp2;
	}
```

###### Creating objects

It is recommended to delay object instantiations to the moment they are needed. 

###### Data type conversion

We should provide overloaded methods inside objects for all argument's needed types, this way we can avoid performance degradation caused by type conversions.  

##### Unnecessary recursion

Recursion creates simple and elegant code, but it can be inefficient if not used properly. Please, think your solution twice before using it.

##### Reusing objects

Sometimes, code's performance is degraded due to object repetitive creation. For example:

* Conversions to JAVA objects from XML can employ high memory or CPU
* *SimpleDateFormat* instances
* graphical objects such as *Rectangle* and *Graphics*

To reduce the impact of the creation of this kind of objects, several alternatives are proposed, according to the characteristics of the objects.

###### Objects for which only one instance is needed

Some objects are not modified once they have been created and, in multi-threaded applications, they can be used by multiple threads concurrently (e.g. the passing of externalized XML information to JAVA data structures).

There are several techniques that provide a single instance of the object, in order to avoid the expensive process of creating object instances:

* **Object caching**: instead of creating a new object, the object is requested to the object cache (if the object doesn't exist, a new one is created and added to the cache for forthcoming requests). The cache is accessed using a key that identifies the object.

* **Singleton Design Pattern**: this pattern avoid creation of an object that never varies

```java
	private static Type value;
	
	public static Type getValue()
	{
	    if (value == null) {
	        // calculate the value
	    }	
	    return value;
	}
```

* **Canonical Objects**: another approach is to create a named copy of each object (a prototype) that can be reused, and then accessed by name, rather than creating new objects identical one to another.

```java
	public class IntegerHelper {
		public static final Integer ZERO = new Integer(0);
		public static final Integer ONE = new Integer(1);
		public static final Integer TWO = new Integer(2);
	}
	
	public class Tester {
		public void doIt(Integer i) {
			if (i == IntegerHelper.ONE) {
				doSomething();
			} else if (i == IntegerHelper.TWO) {
				doSomethingElse();
			} else {
				...
			}
		}
	}
```

##### Using object Pools and Caches

Caching and pooling mechanisms can help us to improve application's performance.

###### Pooling

Pooling implies **reserving *n* fully created resources**, available at any time that is needed. Usually, pools implement mechanisms that limit the number of resources used at the same time, avoiding excessive resource consumption.

Pool size should not be too large, but to handle work load peaks, it could be acceptable to allow some extra resources that are never included in the pool (use and throw resources).

Main advantages using pools:

* Object preallocation, removing creation time when the object is needed
* Limited resource usage, avoiding resource depletion.

Main disadvantages:

* Pool synchronization can lead to some inefficiency, being this problem greater as the concurrency level grows.
* Resource misuse, specially if pool is oversized. In other words, we could have object instances that are never used, wasting resources. Dynamic pools could be very convenient to solve this problem.

###### Caching

When object reuse is frequent, a cache is very convenient to be used. As a potential problem, we have to deal with data staleness and properly design eviction time and refreshing interval time.

#### Synchronization

When dealing with concurrency, a synchronization mechanism for resources could be very useful. However, if not used properly, this can degrade performance.

We should keep synchronized blocks as small as possible.

```java
	public void synchronized writeTrace(int level, String component, String message) {
		boolean traceEnabled = isTraceEnabled(level, component);
		if (traceEnabled) {
			// write the trace
		}
	}
```

It is more efficient this way:

```java
	public void writeTrace(int level, String component, String message) {
		boolean traceEnabled = isTraceEnabled(level, component);
		if (traceEnabled) {
			// write the trace
			writeTraceSync(level, component, message);
		}
	}
	
	public synchronized void writeTraceSync(int level, String component, String message) {
		// write the trace
	}
```

There are situations in which a poor synchronization may penalize performance significantly:

* In an application server many requests run concurrently. Small synchronizations will affect negatively on performance. 
* Accessing a resource to perform multiple reads or a single write.

###### Using of iterators in a concurrent scenario

Be careful when working with collections and iterators in a concurrent scenario, specially when using *put()* or *remove()*. Eventually, a *ConcurrentModificationException* can be raised, even in synchronized collections. 

To control this situation the *ConcurrentModificationException* exception can be captured and properly treat the situation properly.

#### Accessing external resources

##### Access to databases

###### Connection Pools

On applications that access databases and that need connections repeatedly during short periods of time, a pool of connections must be used, instead of opening and closing a connection every time that it is needed. The following example shows the use of a pool of connections to Database obtained through a JNDI resource:

```java
	import javax.naming.InitialContext;
	import javax.sql.DataSource;
	import java.sql.Connection;
	...
	
	// Lookup the DataSource and use it to obtain a Connection
	InitialContext context = new InitialContext();
	DataSource ds = context.lookup("java:comp/env/jdbc/MySource");
	Connection conn = ds.getConnection();
	
	// Use the connection
	...
	// Release the connection back to the pool
	conn.close();
```

###### Using *PreparedStatements*

When a static statement is used several times, it must be used with *PreparedStatement* class instead of *Statement*, since the last one is not very optimal.

> An static statement is the kind of whose structure is fixed and from one execution to another only changes the value of the parameters

```java
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery("SELECT COL1, COL2 WHERE COL3 = 'VALUE1'");
```

On the previous example, the values of the parameters are combined with the query ("VALUE1"), performing a one-time-only query.

The advantage provided by using a *PreparedStatement* versus a *Statement* is that it allows performing the step of preparation only once and carry out the execution many times. The *PreparedStatements* are associated with a connection to the database so they are useful in scenarios where, for a single connection, the same sentence is executed repeatedly.

In addition, since the JDBC driver processes established parameters by *setString()* method, a potential **SQL Injection attack can be avoided.**

```java
	PreparedStatement pstmt = conn.prepareStatement("SELECT COL1, COL2 WHERE COL3 = ?");
	pstm.setString(1, "VALUE1");
	ResultSet rs = pstmt.executeQuery();
```

> PreparedStatements must be defined with the fixed part of the sentence, replacing variables with question marks.

When executing an statement, two processes take place:

* **Preparation**: text interpretation and transformation into something that database can run.
* **Execution**: the requested sentence is executed.

It might seem that *prepareStatement()* prepares each statement's execution, but this is not true. On the first request the sentence is prepared and is then stored on a cache. On forthcoming executions the sentence is reused from the cache.

###### Managing connection parameters

It is interesting to cache access parameters to every database used by the application. If accessed through connection pools that are registered in JNDI, the name of the JNDI resource, the user and the password can be cached, if it's not defined by default on the pool.

###### Managing connections

It is important to pay attention to used resources, as many of them once used must be released to avoid causing a performance problem by depletion of available resources. This is the case of database connections, that must be closed once used, or if a connection pool is being used, returning them to the pool. In the case of a database connection that is closed or returned to a pool, if *commit* or *rollback* has not been done for an executed statement, depending on the configuration of the connection (if *autocommit *has false value) and the implementation of the pool, an exception may be produced.

> autocommit is a configuration parameter that allows the programmer to "forget" writing commit y close

The following is a general pattern to perform a connection to a database:

```java
	try {
	    // get the connection from the pool
	    // executing database sentences
	} catch( ... ) {
	    // manage exceptions
	} finally {
	    if (thereIsConection) {
		    try {
		       if (executionsOk) {
		       	// commit
		       }
		       else {
		       	// rollback
		       }
		    } finally {
		       // release the connection
			 }
		 }
	}
```

Write accesses to a database produce locks that have an impact on performance. During a transaction execution, the number of locks and admitted anomalies will depend on isolation degree, so this should be configured carefully.

> The Isolation Level is the setting that fine-tunes the balance between performance and reliability, consistency, and reproducibility of results when multiple transactions are making changes and performing queries at the same time

There are several alternatives to implement access to databases from JAVA applications. For example, from performance's point of view, it could be better to use Stored Procedures, so that code executes in DBMS (possibly optimized) and it prevents the transfer of commands or sentences to run between the JAVA application and the DBMS. JDBC also offers, as part of its API, methods for batch execution of a command set in the DBMS, which also prevents the transfer of information to the server, and can improve performance. However, in either of these cases, there are other development implications that must be taken into account before settling on one or another alternative.

##### Accessing files and other resources

When resources are obtained or created (as pool database connections, open files or network connections) in order to free the consumed resources, the *finally* clause must be used to ensure that they are released and not avoided by a thrown exception.

A method doesn't have to capture or declare that it throws exceptions inherited from *RuntimeException*. Failure to use the *finally* block could throw this kind of exception that is not controlled such as *NullPointerException* or *ArrayIndexOutOfBoundsException*, and the resource can remain unreleased. It also allows to simplify the code since it is not necessary to repeat the sentences for releasing the resource at the end of the try and in the catch of the exceptions.

The recommended procedure is the following:

```java
	try {
		// obtain or create a resource
		// use the resource
	} 
	catch(...) {
		// manage exceptions
	} 
	finally {
		if (resourceCreated) {
			// freeResource
		}
	}
```

Starting on JAVA 7, it is advisable to use the try-with-resource statements as it is a way to ensure that opened resources are automatically closed at the end of the statement without programming it. The try-with-resource statements can include one or more resources. Any object that implements `java.lang.AutoCloseable`, which includes all objects which implement `java.io.Closeable`, can be used as a resource. Using the try-with-resource statement the previous example can be transformed into the following one:

```java
	try (/* obtain or create a resource */) {
		// use the resource
	} 
	catch(...) {
		// manage exceptions
	}
```

For example, to read the first line of a file, we can use the following piece of code:

```java 
	try (BufferedReader br = new BufferedReader(new FileReader(path))) {
        	return br.readLine();
	} catch (Exception ex) {
    		// Manage exception
	}
```

When accessing files, a very inefficient common pattern is opening the file, writing and closing the file repeatedly. It is much more efficient to open the file at the beginning of the execution and to keep it open as long as necessary in order to write and close it only at the end of the execution (including the abnormal exits caused by exceptions). The connections to database behave in a similar way. In a monothread application the same pattern should be followed. In a web application where a pool of connections is available, the pool manages the opening and closing of connections.

In file or network information reading and writing operations, buffered classes should be used such as *BufferedInputStream*, *BufferedOutputStream*, *BufferedReader* and *BufferedWriter*, because the number of readings is reduced and performance is increased.

For example, to read a binary file the following code can be used:

```java
	FileReader myReader = new FileReader(filepath";
	while (!eof) {
		myReader.readLine();
	}
```

But it is much more efficient to use:

```java
	FileReader myReader = new FileReader(filepath);
	BufferedReader myBufferedReader = new BufferedReader(myReader);
	while (!eof) {
		myBufferedReader.readLine();
	}
```

This recommendation is especially efficient in a multithread system (for example, a web application) where different threads write to the same file. As it is necessary to use some synchronization mechanism for the concurrent write access to a file, the buffered alternatives provide a faster write access in most of the cases (a write to memory is synchronized), and only when the buffer is full, it is transferred to disk.

On this classes the main disadvantage is that, if the system crashes, the latest data may remain unwritten because the last contents of the buffer may not have been yet transferred. This drawback can be decisive to rule out the use of buffer depending on the requirements of the application (for example, this would be unacceptable in a bank transfer log). When it comes to asynchronous writings the same problem is present, since on a system crash, it is possible that the last asynchronous write request has not been executed.

Another alternative for a multithread system, is to implement a mechanism that writes to an intermediate structure in memory, with a separate thread with lower execution priority that transfers the contents of this structure to disk when other threads with more priority are not active.

Since JDK 1.4, *FileChannel* and *MappedByteBuffer* API can be used, in order to use Memory Mapped Files according to the facilities provided by the operating system. This alternative is recommended only for relatively large files.

##### Treating XML files

XML is standard, readable and with a neutral format; it is used for defining documents with a self-defined structure, suitable for countless applications: exchange of information on the web, information exchange between applications, configuration files, application data, etc. However, XML usage has a significant impact on performance, so it must be used only when its benefit is clear.

There are some recommendations that must be followed in order to maintain application performance:

* **Avoid unnecessary externalization** of information with XML format, since there are other alternatives that can satisfy the requirements. For example, instead of parsing an XML file, there are cases in which such information may be reflected on a JAVA class, replacing the expensive parsing with an instantiation of a JAVA object.
* It is essential to make sure that the same XML is **not parsed several times** (even if it comes from a file or from a string of characters) since it is an especially expensive processing task. When the XML is located on a text file, a cache with XML DOM objects can be implemented, and only if file is modified parse it again.
* Another possible cause of parsing an XML multiple times is when some method receives as input/output parameter an XML, and that **internally parse the XML to DOM** to access its information. In a sequence of calls to these kind of methods, each method parses the XML and after performing the corresponding process, serializes the DOM to XML to return the response. This sequence of processing is very inefficient.
* It is recommended to **create methods that work directly with DOM objects**, receiving and returning DOM objects. Likewise, when third party libraries or components are used, it is advisable to select those methods with the appropriate signature to avoid unnecessary processing with the XML items.
* Sometimes applications use DOM only as an intermediate format to pass information externalized to XML to JAVA data structures. In these cases, if data representation in a DOM tree is not required and is not used once the JAVA data structure is created, is recommended to release it because DOM objects occupy a lot of memory. In particular, if a DOM cache is used in these conditions, it is interesting to consider using a JAVA object cache in the destination format instead, since it takes much less memory and would avoid the unnecessary process of constructing of the JAVA object from the DOM at each access to the cache. This can present some difficulties: it may occur that these JAVA objects have a state that varies throughout the execution so they are not directly susceptible to be contained in a cache and should implement a mechanism to store in the cache prototype objects, which are then copied or cloned to create instances that may have their own state.

In general, since working with XML is expensive (parsers, transformers, etc), it 's advised to look for the most efficient API for each situation.

###### Reusing objects for XML processing

The *DOMBuilderFactory* object is used to obtain instances of *DOMBuilder* class. Creation of both objects is expensive.
 
The former is thread safe, reason for which it is recommended to reuse it amongst all threads. The latter is not thread safe, and every thread must use its own instance, usually is a good choice to use a pool for this objects to be reused.

##### Other recommendations

###### Avoid using *final* modifier to improve a method performance

A method must be defined as *final* to indicate to the compiler that no subclass will overwrite this method in a more specialized way. One reason for this, is that method implementation requires maintaining a consistent state of the object. Only when the application runs correctly and if a profiling tool shows that the method is very expensive, *final* should be used to improve the efficiency.

###### Avoid calling to *System.out.println()* and *System.err.println()*, since they are expensive

These are slow synchronous operations, and normally remain in code as forgotten debugging traces. For these intent, the use of a logging library is advised (log4j, JAVA Logging API, etc.).

###### Use Reflection API (*java.lang.reflect package*) with caution

This API allows to dynamically obtain information from fields and methods of classes and objects, and operating with them. It is powerful but also expensive, so it is not recommended for repetitive actions.

For example, a common use case relies on using this API to load database tables into java objects. This simplifies development, but in massive processes when working with many rows it is very heavy.

###### Take advantage of polymorphism and inheritance

Some developers often code using type-checking conditions, deciding which code to execute depending on the detected type. This situation is not easy to detect since it is not an explicit type or class check. Usually this situation can be improved with inheritance and polymorphism with a much better, more extensible and reliable code.

For example, suppose an implementation of figures like the following:

```java
	Class Figure {
		public static final int CIRCLE = 0;
		public static final int SQUARE = 1;
		int type;
		
		public Figure (int figureType) {
			type = figureType;
		}
	
		public int getArea() {
			if (type == CRICLE) {
				area=PI * r * r;
			} 
			else if(type == SQUARE) {
				...
			} 
		}
	}
	
	public static Main(String args[]) {
		Figure figure = new Figure(Figure.CIRCLE);
		System.out.println(figure.getArea());
	}
```

Or like the following one:

```java
	Class Figure {
		public int getArea() {
			if (this instanceof Circle) {
				area=PI * r * r;
			}
			else if(this instanceof Square) {
				...
			}
		}
	}
	
	Class Circle extends Figure {};
	Class Square extends Figure {};
```

The first example defines a single class that has the responsability of knowing how to perform the operations for all the figures that are being defined on it. There are several problems with that, including:

* Adding a new Figure impacts directly on the code of the Figure class.
* Cyclomatic complexity, and therefore performance, is directly affected by the number of figures represented on the Figures class.

The second example, implements a solution that uses inheritance, but very poorly. It defines a class hierarchy for different data types, but still does an explicit class type-checking on the parent class. It is mostly the same situation of the first example.

Best solution is using inheritance and method overloading:

```java
	Class Figure {
		public abstract int getArea() {}
	}
	
	Class Circle extends Figure {
		public int getArea() {
			return PI * r * r;
		}
	}
	
	Class Square extends Figure {
		public int getArea() {
			return r * r;
		}
	}
	
	public static Main(String args[]) {
		Circle circle = new Circle();
		Figure figure = circle;
		System.out.println(figure.getArea());
	}
```

###### Avoid calling Garbage Collector explicitly

JAVA Garbage Collector can be invoked running *System.gc()*.

However, this does not benefit the implementation, increases the execution time unnecessarily and interferes with the proper operation of the Garbage Collector.

###### Use the type *int* if possible, rather than other types

Access to *int* type is much faster than access to other data types. In particular, it is best to use int than other types of data as an index in loops.

###### Prevent memory leaks

Objects that remain in memory when they should have freed from memory (and eventually freed by the Garbage Collector) cause Memory Leaks. This memory occupation increases on and on with the operation of the program, causing severe performance problems. 

Having limited JVM memory, the Garbage Collector has to run more frequently, impacting on performance and occasionally throwing *java.lang.OutOfMemory* exceptions. If the JVM has no memory limit, the size of the heap grows occupying more and more machine resources and causing that the Garbage Collector periods are longer and longer, since they must check more memory every time.

Memory leaks may occur in different situations:

* Objects that can be released along a logical operation but that are not released until just some operation finishes, with which they occupy memory unnecessarily. This situation is worse as operation duration increases.
* Another common situation is when there are objects that are referenced by data structures that have ceased to be logically accessible in the application.
* There may occur Memory Leaks in HTTP sessions: memory that remains referenced, that was created for the previous session, but is no longer accessible logically by the program.

###### Avoid code duplication

Having two distinct classes that run **the same functionality** creates a maintenance problem, and to a lesser extent, overhead in JVM memory that must maintain a copy of those two classes. JAVA has mechanisms that allow to modify the functionality of a set of classes without having to duplicate all of them (inheritance, interfaces,...).

Having methods that do **almost the same** with much of the code in those classes duplicated, is a symptom of a bad design. The recommendation is to create basic class methods, which are then invoked from other methods with a more specific functionality. The problem is maintainability, and the overhead of very large classes.

###### Avoid the use of very complex data structures

It reflects a poor design, and probably not all their functionality can be reused. 

###### Avoid the use of methods with very long argument lists

They make the code less readable and less maintainable.

### Recommendations for JEE applications

The following recommendations refer exclusively to the web container, including Servlets and JSPs (EJBs recommendations are not included).

There are certain specific features of the JEE application development that have particular implications regarding performance.

#### Execution Scopes on Web containers

A common problem that impacts performance severely on JAVA applications is the excessive consumption of memory and CPU, result of a massive object creation. In the case of a web application this problem may be even more critical because the JVM memory is shared between several users, and each users' requests are handled in different threads. In this special execution environment, performance can be increased by trying to create the minimum number of objects. Depending on each objects execution scope, different measures can be can de adopted.

* Some objects are needed **through the entire application**, i.e. are needed on different requests and can be reused by all of them. For example, the application's configuration. This application scope objects must be reused, never copied.
* Other objects must be used **across all the requests** on the same session. This information must be stored in the session (*javax.servlet.http.HttpSession*) and not obtained on each request. For example, the information of the user logon.
* Finally, there are objects whose **duration scope is the request** and that after the request is closed, they are destroyed. Some of these objects are expensive to create and are used at various spots in the process of the request handling. For these objects, it is recommended to create them once and reusing them on the whole request process. The request object (*javax.servlet.http.HttpRequest*) is often available in different methods of the request process, and provides an API for storing and retrieving attributes (*setAttribute()*/*getAttribute()*) that can be used as a container for these expensive objects. 

For example, if the request contains data in XML, it is a good idea to save the associated DOM object and reusing it in other methods during the request process. Another example is to use *setAttribute* to pass data to JSP response. 

> A common mistake is to use the session scope instead of the request scope, causing collateral effects on different requests (mixing user information, for example)

Some objects can not be shared by several requests because they are not threadsafe. In some cases the creation of this objects is expensive, so it is recommended creating a pool of objects. An example might be a database connection pool.

Generally speaking about web applications, some web application components are hidden by the architecture itself. In particular, it's common the existence of a context manager, that encapsulates access to global, session and request contexts. In this case, it is advised to properly select the context of each element from the application, to avoid creating more objects than needed.

#### The Web Session

JAVA Servlet API provides the *javax.servlet.http.HttpSession* class to simulate the concept of session between Client and Server, that does not exist on the underlying HTTP protocol. That is, access and store specific state information from the client that must persist between different requests.

Session must store only user dependent information, necessary on multiple requests. Session stored objects must be **serializable**. This allows sharing the session between application servers using persistent sessions, making possible that if a server ceases service, other servers can treat its requests.

Session size **should be small**, to reduce serializing process time. Application servers provide mechanisms to optimize access and object serialization, but in any case, it is strongly recommended to use small objects.

Always close sessions properly, since this is a common memory leak. Closing session logic should be provided to free resources and explicitly close a session (e.g. by a logoff servlet). Furthermore, JEE defines a timeout so unused sessions will be automatically released. This timeout must be correctly established to avoid resource wasting.

If it is necessary to free up resources (e.g. connections to a database or opened files) when a session is closed, the *valueUnbound()* method of the *HttpSessionBindingListener* interface can be used, implementing this interface on the resource that it has to be released.

###### JAVA Server Pages and the *Session*

The JSPs obtain a reference to the session of the request. When associated request with the JSP is not using the session, the JSP creates it nevertheless, with the consequent unnecessary resource consumption. If the application uses frames and each frame is a JSP, the session will be accessed for each JSP. This is solved using the following directive on the JSP:

```java
	<%@ page session="false" %>
```

#### Obtaining JNDI resources

When using JNDI (**J**AVA **N**aming and **D**irectory **I**nterface) resources such as database connection pools, *EJBHomes* and JMS resources, creation of the JNDI's initial context and search method (*lookup*) are costly tasks. It is important to perform these operations only once, save the obtained objects, and reuse them later.

#### Minimizing the use of synchronization in Servlets

Usually the application server (it's web container) handles simultaneous requests on the same servlet and several threads run service methods from a single instance of the servlet concurrently. For this reason the servlets instance variables (attributes) are shared by all concurrent executions, and **access to these should be synchronized** using any of the JAVA available mechanisms. 

As described in the section dedicated to synchronization, access to synchronized variables shared by several threads is expensive, so it is recommended to avoid the use of instance variables, for example replacing them with local variables in servlet methods.

The servlet API offers the possibility of not using multithreading with the *SingleThreadModel* interface. Despite the fact that synchronization problems can be solved using this model, server's efficiency with a single thread is much lower.

#### Other recommendations

Expensive processes should not be used online, because if multiple requests are received at the same time, the rest of the requests can be affected and the server may collapse. For this situations, batch processes can be used, and prepare them to be run at times where the server is less loaded. Sometimes batch processes' performance is better because structures are initialized, connections are created, etc. one single time and not one time for each request.

> The colloquial word "online" refers to processes that are consumed, that perform some operations and return the result of that operation to the caller. The opposite to online processing is batch processing, where the result of the operations is not returned directly, but through another techniques (callbacks, publish-subscribe queues, etc.).

Another plausible solution for some scenarios is to defer logic to asynchronous workers. A decoupling queue can be used to schedule tasks. 

---

## References
---

* Martin, Robert Cecil (2009). Clean code: a handbook of agile software craftsmanship

___

[BEEVA](http://www.beeva.com) | 2016
