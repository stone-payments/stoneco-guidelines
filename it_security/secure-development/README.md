
# **Secure development**

## **1.1 General aspects**

Here are some general aspects that we must always keep in mind when we build our applications. It's very important to consider these basics for our web applications meet security standards.

**Validate inputs**

We should always monitor the input data in the application, in its origins (parameters, form fields, etc.). We should not assume what we will receive and all entries of the application must be validated both syntactically and semantically, that is expected to receive and the format expected

**Escape outputs**

We should always validate and control the output of our application or might be vulnerable to attacks on the client side of our application such as XSS, is very important that all non-alphanumeric characters that our implementation of output, are validated and escaped properly depending on the context in which they appear.

**Check error messages**

It’s important to localize and control error messages of our application, thus avoiding providing information to a potential attacker could force errors to obtain useful information (filesystem paths, names of databases or tables, variable names, etc.)

**Use HTTPS**

Whenever your application return confidential information, or manages passwords, authentication, sensitive data, etc. we should use HTTPS instead of HTTP so our data trip encrypted and to prevent a potential attacker from access these data.

**Session control**

We must have a proper management policy sessions in our application. It is advisable to delegate the management of sessions in specialized Framework.

**Use updated products**

All third-party products used by our applications (CMS, libraries, Framework, etc.) must be safe and have no known vulnerabilities, we must follow the security lists the products we use to keep up and patch or raise version of our product when affected by security vulnerabilities.

**Protect cookies**

We should follow a policy of proper management of cookies:

* Never store critical data in cookies

* Establish life cycle, beginning and end of validity

* Avoid Using persistent cookies

* Try To use the secure and our cookies policy httponly

## **1.2 Cookies and Session Management**

A session is a set of transactions of HTTP requests and responses associated to the same user.

Any complex application today requires keeping in time information between the browser and the application server associated with the user. Unfortunately, HTTP protocol does not have session management, so these have been relegated to the application layer.

It is responsibility of the application applying the proper management of sessions. Once a user is authenticated the application assigns a session id or session token that will be responsible for identifying communications between browser and server (in some applications unauthenticated connections are also tracked).

Once a user is authenticated and assigned a session, the authentication system will be as strong as the system of sessions it is, no matter the application has a two-factor authentication or RSA tokens of a single use, if you have access to the session shall be the same as having infringed the authentication system.

Every HTTP request we do, the session token traveling to the application server can identify the user unequivocally.

There are dozens of possible attacks on the sessions that we must avoid theft, prediction, fixing, etc.

**Features of the session id or session token**

There are a number of features that the session token (see sessionid, jsessionid, phpsession, etc.) must meet in order to avoid possible attacks, we will detail the most important.

**Session Token Fingerprinter**

The session token should not disclose information about the technologies used by the application, we recommend replacing the names of the tokens session default (jsessionid, phpsession, etc) for a generic name that does not reveal information about the framework construction the application, for example sessionid

**Session Token length**

The session token should be long enough to be resistant to brute force attacks possible. You should have a length of at least 128 bits.

**Session Token Entropy**

The session token should not be predictable, it must be generated with pseudorandom techniques. To be predictable (for example sequential) an attacker could find out valid session states

**Session Token Content**

The session token, should not contain meaningful information to prevent disclosure attacks, the session token must be a simple identifier between the client and server side application and the server side is where it should be stored information on the session (IP, user ID, privileges, roles, etc ...).

**Session Management**

We will establish certain criteria when recommended to implement session management

**Exchange mechanism and session storage**

There are multiple ways of implementing the exchange and storage of sessions, but the most accepted and widespread is the use of cookies.

In particular we must avoid mechanisms that reflect the session identifier in the URL because it can be the target of multiple attacks to be recorded in the same infinity of sites (browser history, bookmarks, and proxy server logs, links, search engines, etc ...)

Many frameworks provide mechanisms to manage sessions (J2EE, ASP, .NET, PHP, etc.), we recommend using these instead of establishing our own, as these have been developed and tested by a large community behind them.

It’s important that the session has a validity period after which it expires. Whenever there is a change of roles or permissions of a user in an application you must renew your session ID, expiring old and assigning a new one.

It’s important that the application have a mechanism end of session (logout). It’s very important that all requests containing information about the user's session, be encrypted using SSL, is not enough to encrypt the login form, you need to encrypt each subsequent request associated with this session to ensure their safety. Get the session ID is for all purposes the same as knowing the password for that user.

It’s recommended to use some kind of monitoring tools sessions, scan and detect abnormalities in the same: simultaneous logins, access the same session from different locations, attempts to use brute force, etc ...

**Cookie Management**

As noted, we consider cookies as the best mechanism for the exchange and storage of session, as a result, we will deepen recommended safety measures when working with them.

We recommend using the secure attribute in the cookie, this cookie prevents tampering under HTTP protocol, forcing it to make HTTPS protocol.

We recommend using the domain and path attributes cookies to define domains and paths where the cookie should be sent.

You must use the max-age and expires attributes to define the period of validity of the cookie

## **1.3 SQL Injection**

SQL injection is a particular case of injection attacks. Such attacks occur when an application sends untrusted unfiltered information to a parser.  Injection can be performed on all types of interpreters: SQL engines, LDAP, parsers XML or JSON.

SQL injection is a method of infiltration arbitrary code that uses a computer vulnerability in an application on the level of input validation to query a database.

The source of vulnerability lies in the wrong check and / or filtering of the variables used in a program that contains or generates SQL code. It’s, in fact, an error of a more general class of vulnerabilities that can occur in any programming language or script that is embedded within another.

It should be noted that although the SQL injection is the most widely known and used, there are all kinds of code injections, which should be protected: LDAP injection, log injection, command injection, etc…

**SQL injection prevention**

Below we will summarize the main measures to prevent SQL injection type attacks we must take.

The full list and additional information can be obtained at:

[https://www.owasp.org/index.php/SQL_Injection_Prevention_Cheat_Sheet](https://www.owasp.org/index.php/SQL_Injection_Prevention_Cheat_Sheet)

**Using prepared statetments (parameterized queries)**

The use of prepared statements requires us to separate the logic of SQL code, input data therein, providing the database to distinguish between code and data and helping to prevent input data from becoming unwanted code.

Statements prepared using guarantees that the construction of their queries, can not be modified by an attacker, provided these are well built.

According to the programming language we recommend the following data structures

* Java EE – use PreparedStatement() with bind variables

* .NET – using parameterized queries como SqlCommand() o OleDbCommand() with bind variables

* PHP – using PDO with strongly typed parameterized queries (using bindParam())

* Hibernate - using createQuery() with bind variables (called named parameters in Hibernate)

* SQLite - using sqlite3_prepare() to create a statement object

Then we put two examples of using Java PreparedStatement generation and hibernate:

**_JAVA_**

```java
String custname = request.getParameter("customerName"); // This should REALLY be validated too
// perform input validation to detect attacks
String query = "SELECT account_balance FROM user_data WHERE user_name = ? ";
PreparedStatement pstmt = connection.prepareStatement( query );
pstmt.setString( 1, custname);
ResultSet results = pstmt.executeQuery( );
```

**_HIBERNATE_**

First an example of a definition insecure
```java
Query unsafeHQLQuery = session.createQuery("from Inventory where productID='"+userSuppliedParameter+"'");
```
The same example safely
```java
Query safeHQLQuery = session.createQuery("from Inventory where productID=:productid");
safeHQLQuery.setParameter("productid", userSuppliedParameter);
```

**Use stored procedures**

As in the case of prepared statements, the use of stored procedures requires us to separate the data logic.

The difference between the statement prepared and stored procedures is that in the latter logic resides in the database instead of in the application as in the case of the statement prepared.

These techniques prevent attacks provided the code is correctly generated, that is, do not include dynamic SQL generation.

Example java code using stored procedures

```java
String custname = request.getParameter("customerName"); // This should REALLY be validated

try {
   	CallableStatement cs = connection.prepareCall("{call sp_getAccountBalance(?)}");
   	cs.setString(1, custname);
   	ResultSet results = cs.executeQuery();      	
   	// … result set handling

} catch (SQLException se) {                	
   	// … logging and error handling
```

**Escape and validate all user input**

In case you can’t use any of the 2 above techniques and that for reasons of performance or functionality you need to manually create dynamic queries, there will always escape and validate input data before executing the queries.

This can be done using libraries intended for such purpose as ESAPI, currently it supports Oracle and MySQL.

An example to validate and would encode a query to Oracle:

```java
ESAPI.encoder().encodeForSQL( new OracleCodec(), queryparam );*
```

If you need to manually validate data entry, there will always be to use methods whitelist (explicitly define which allow) to the detriment of blacklisting (we define what we do not allow) to ensure greater safety.

## **1.4 XSS**

XSS (Cross-site scripting) is a type of security flaw typical of Web applications, which allows a third party to inject JavaScript code in web pages viewed by the user, avoiding control measures such as the same origin policy.

These errors can be found in any application that has the ultimate objective of presenting information in a web browser. It's not limited to web sites, as it may be vulnerable to XSS local applications, or even the browser itself. The problem is that usually the input data used in applications is not properly validated. This vulnerability may be present directly (also called persistent) or indirectly (also called reflected).

**XSS types:**

* **Direct** (Persistent): Consists in embedding dangerous HTML code in places that permit it; thus including tags like \<script\> or \<iframe\>.

* **Indirect** (reflected): This type of XSS consists in modifying values that the Web application uses to pass variables between pages without using sessions and happens when there is a message or a URL path in the browser in a cookie, or any other HTTP header (in some browsers and web applications, this could extend the browser DOM).

**XSS Prevention**

Based on the recommendations of the OWASP project we have compiled a number of recommendations that we apply as a standard, in order to avoid XSS vulnerabilities in your applications. Here are the most significant measures.

You can see the full document:

[https://www.owasp.org/index.php/XSS_Prevention_Cheat_Sheet](https://www.owasp.org/index.php/XSS_Prevention_Cheat_Sheet)

**Never insert unreliable source data in our HTML output**

Try to avoid, whenever possible, inserting unreliable data source (data received from external sources) in our HTML output. This includes block \<script\> in comments in CSS attribute names (divs), labels, etc.

When you can not avoid it, functionality or for any other reason, we must consider the following points depending on which is where we insert the data.

**Escape HTML**

It can be done using the ESAPI library:

```java
String safe = ESAPI.encoder().encodeForHTML( request.getParameter( "input" ) );
```
**Escape Attributes**

To enter data unreliable source on attributes such as width, name, value, etc. you have to escape them, this does not apply to complex attributes href, src, style, or events like onmouseover grabbers.

Except for alphanumeric characters, escape all ASCII characters with the format  &#xHH.

It can be done using the ESAPI library:

```java
String safe=ESAPI.encoder().encodeForHTMLAttribute(request.getParameter("input"));*
```

**Escape JS**

With regard to dynamically generated JavaScript code, the only safe place to put data from untrusted sources is within a quoted value variable. This applies to both script blocks, and events grabbers.

Except for alphanumeric characters, escape all characters with the format \xHH. Keep in mind that entering data unreliable origin javascript certain functions, it can be dangerous even if these are properly escaped, we will individually analyze the danger of these actions.

It can be done using the ESAPI library

```java
String safe = ESAPI.encoder().encodeForJavaScript( request.getParameter( "input" ) );
```

**Escape CSS**

CSS is surprisingly powerful and can be used for a wide range of attacks, it’s important to only insert data into the value CSS properties.

Except for alphanumeric characters, escape all characters in the form \HH

It can be done using the ESAPI library

```java
String safe = ESAPI.encoder().encodeForCSS( request.getParameter( "input" ) );
```

**Escape URLS**

This rule applies to the parameters sent in the URL using the GET method. It is one of the most important considerations to keep in mind because usually these parameters are the entry point of the user data.

Except for alphanumeric characters, escape all characters with the format %HH

It can be done using the ESAPI library 

```java
String safe = ESAPI.encoder().encodeForURL( request.getParameter( "input" ) );
```

**HTML libraries use policies to validate and clean HTML output**

We recommend using libraries with cleaning validation policies and the HTML generated, for example:

*OWASP AntiSamy*

```java
 import org.owasp.validator.html.*;
 
 Policy policy = Policy.getInstance(POLICY_FILE_LOCATION);
 AntiSamy as = new AntiSamy();
 CleanResults cr = as.scan(dirtyInput, policy);
 MyUserDAO.storeUserProfile(cr.getCleanHTML()); // some custom function
```
*OWASP Java HTML Sanitizer*

```java
 import org.owasp.html.Sanitizers;
 import org.owasp.html.PolicyFactory;
 
 PolicyFactory sanitizer = Sanitizers.FORMATTING.and(Sanitizers.BLOCKS);
 String cleanResults = sanitizer.sanitize("<p>Hello, <b>World!</b>");
```

**Use HTTPOnly flag in cookies**

We recommend using the flag HTTPOnly in cookies. HttpOnly is a security mechanism used to avoid writing / reading cookies in languages that run the client side, such as JavaScript. Although not an anti XSS “per se”, that lessens the impact of the vulnerability, not being accessible from js cookies, session hijacking is prevented including through XSS.

## **4. Input / Output parameter management**

A large percentage of security problems in web applications, are caused by improper validation of input parameters to the application. It’s therefore very important to always validate all input data to the application, especially those introduced by users through forms or other input methods. As a general rule, we must validate all data input and output of the application.

The validation we always performing both server and browser. The validation on the client side, the server saves work by filtering information before reaching the server, helping to improve the performance of application servers and avoiding most of the incorrect data reach. Faced with a possible malicious user validations by javascript or similar they are completely insufficient to be easily avoided by using proxies or intermediate specialized tools, so we must also always check the validity of the data on the server end

The considerations in validating the fields should be at least:

* Validity of data type, we must check the data type entered matches the expected data type (text, numeric, alphanumeric, etc ...).

* Validity of size, we must validate the size of the input fields match the expected and the variables and database fields to be stored.

* Validity range, in some cases, we have to validate the data entered is within the expected range, such that the day field is between 1 to 31 and do not introduce 0 or 32 or higher values, or a text field one containing the characters [aA | zZ | 0-9] and contains other ASCII characters.

We should always validate the fields using whitelists, that is, specify explicitly what we allow instead of specifying what we deny. This is done in order to avoid possible omissions when not deny or something dangerous ignorance of their risk.

## **1.5 CSRF**

The browsers automatically send credentials such as session cookies, an attacker can create malicious websites that forged requests made indistinguishable from the real.

Prevention:

* Include an unpredictable token for each HTTP request, which must be at least unique for each user session. This token is validated server with every request from the client.

* Preferably, the token will be included in a hidden form field. You can also go to the URL, although there is the danger of being exposed to an attacker.

* "CSRF Guard" OWASP can automatically include the secret tokens.

* "CSRF Protection" Spring Security.

* Another option is to require the user to log in again requests sensitive nature.

## **1.6 Data canonicalization**

Before you validate entries, you must normalize or canonize the data. This is the process of converting data to its simplest or standard form.This is necessary to prevent that malicious data with certain encodings can pass our validations.

● Filesystem path normalization

/pub/www/images/../../../etc/passwd

After normalization:

/etc/passwd -> Not permitted path

First we normalize the absolute path, and then validate that the path is legal (whitelist of valid routes)

● Encoded data normalization

Uncoded input:

```java
<script>alert('XSS');</script>
```
Encoded input (Unicode encoding):

```java
%3Cscript%3Ealert(%27XSS%27)%3B%3C%2Fscript%3E
```

● Multiples times encoded data normalization

Some attacks are based on encoding two or more times the input, with the same or different coding system to overcome "naive" normalization schemes.

```java
<script>alert('XSS');</script>
```
First URI encoding:
```java
%3Cscript%3Ealert(%27XSS%27)%3B%3C%2Fscript%3E
```
Second URI encoding:

```java
%253Cscript%253Ealert(%2527XSS%2527)%253B%253C%252Fscript%253E
```

The function canonicalize ESAPI launch an IntructionException data to detect double URI encoding, as this is never a valid case of legitimate user input.

It's not always easy to determine whether an entry been coded several times, which can lead to false positives. It will be necessary to study the types of input data to determine where we can make an automatic standardization and where we should make it "manually".

● Markup languages normalization

The input entries in languages such as HTML and XML should also be normalized.

Dangerous injection in XML parser

● Character encoding normalization

In Unicode, you can change the same character in several different ways. Prior to the validation entries must be normalized to Unicode encoded characters to remain the simplest form possible.

It should explicitly define the charset encodings to be used (UTF-8, ISO 8859-1 ...) depending on the needs of the application, and configure the JVM, the application server and the application accordingly.

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies

