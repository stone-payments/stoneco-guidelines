# Front-end Development Best Practices

<img src="../static/protractor-logo-300.png" height="70px"/>

## Protractor
 
* [Introduction](#introduction)
* [How It Works](#how-it-works)
* [Installation & Configuration](#installation-configuration)
* [Links](#links)

----
## <a name='introduction'>Introduction</a>

Protractor is an <b>end-to-end test framework</b> for AngularJS applications and its main features are:

- Protactor is <b>open source</b> and is developed and maintained by Google team.

-  Protractor is a integrator solution</b> for testing, through combining powerful tools and technologies such as NodeJS, Selenium, webDriver, Jasmine, Cucumber and Mocha.

- Protactor has a lot of <b>customizations</b> from Selenium to easily create tests for AngularJS applications.

- Protactor allows <b>test like a real user</b>, using native events and browser-specific drivers to interact with your application as a user would.

- Protactor works with the most popular test frameworks: <b>Jasmine</b>, <b>Mocha</b>, <B>Cucumber</b>...

- Protactor can run the <b>test in real browsers</b>  through Selenium.


## <a name='how-it-works'>How It Works</a>
Protractor works in conjunction with Selenium to provide an automated test infrastructure that can simulate a user’s interaction with an Angular application running in a browser or mobile device.

![](https://angular.github.io/protractor/img/components.png "Protactor in Action")

When working with Protractor, it’s important to keep the following in mind:

 - Protractor is a wrapper around WebDriverJS, the JavaScript bindings  

 - WebDriver commands are asynchronus. They are scheduled on a control flow and return promises, not primitive values. 
 
 - Test scripts send commands to the Selenium  Server, which in turn communicates with the browser driver. 

####  **Process Communication**
A test using Selenium WebDriver involves three processes - the test script, the server, and the browser. The communication between these processes is shown in the diagram below.

![enter image description here](https://angular.github.io/protractor/img/processes.png)


## <a name='installation-configuration'>Installation & Configuration</a>

Protractor requires the installation and configuration of various things:

  - <b>Protractor</b> 
  Protractor is a Node.js program and to run Protactor must need to have Node.js installed.  Use npm to install Protractor globally or locally.
  
   The complete guide of Protactor installation and configuration can be found [here](https://angular.github.io/protractor/#/protractor-setup).
<br/>
  - <b>Selenium</b> 
In Protractor, you need to specify how to connect to the browser drivers which will start up and control the browsers you are testing on. You will most likely use the Selenium Server. The server acts as proxy between your test script (written with the WebDriver API) and the browser driver (controlled by the WebDriver protocols). 

  The server forwards commands from your script to the driver and returns responses from the driver to your script. The server can handle multiple scripts in different languages. The server can startup and manage multiple browsers in different versions and implementations. 

  The complete guide of Selenium installation and configuration can be found [here](https://angular.github.io/protractor/#/server-setup).

  - <b>Browsers Drivers</b> 
Protractor works with Selenium WebDriver, a browser automation framework:
   - Selenium WebDriver supports several browser implementations or drivers.     
   - Protractor supports the two latest major versions of Chrome, Firefox, Safari, and IE. 
   - Protractor allows use Mobile Browsers.   
   - Protractor includes a mechanism for adding Chrome-Specific Options.   
   - Protractor allow us testing against multiple browsers at the same time.

 The complete guide of browsers drivers installation and configuration can be found [here](https://angular.github.io/protractor/#/browser-setup).


  - <b>Frameworks</b> 
Protractor supports three behavior driven development (BDD) test frameworks: 

   - <b>Jasmine</b>.
   Jasmine is a behavior-driven development framework for testing JavaScript code. It does not depend on any other JavaScript frameworks. It does not require a DOM. And it has a clean, obvious syntax so that you can easily write tests.
   
		```javascript
		describe('Controller: BeevaApplicationController', function(){
		
		    beforeEach(module('beeva.angularApp'));
		    var NavigationCtrl, scope;
		
		    beforeEach(inject(function ($controller, $rootScope){
		        scope = $rootScope.$new();
		        NavigationCtrl = $controller('BeevaApplicationController', {
		            $scope: scope
		        });
		    }));
		
		    it('Test 1. Is system enabled?..', function (){
		        expect(scope.systemEnabled).toBe(true);
		    });
		
		    it('Test 2. Is there authenticated user?..', function (){
		        expect(scope.user!=null).toBe(false);
		    });
		});
		```

   - <b>Mocha</b>. 
  Mocha is a feature-rich JavaScript test framework running on Node.js and the browser, making asynchronous testing simple and easy. Mocha tests run serially, allowing for flexible and accurate reporting, while mapping uncaught exceptions to the correct test cases.
  
     If you would like to use the Mocha test framework, you'll need to use the BDD interface and Chai assertions with Chai As Promised.


		```javascript
		var assert = require('assert');
describe('Array', function() {
		  describe('#indexOf()', function () {
		    it('should return -1 when the value is not present', function () {
		      assert.equal(-1, [1,2,3].indexOf(5));
		      assert.equal(-1, [1,2,3].indexOf(0));
		    });
		  });
		});
  })
		```


   - <b>Cucumber</b>.
   Cucumber is a tool for the definition and execution of functional tests based on behavior. Cucumber lets describe how software should behave in plain text. The text is written in Gerkin, business-readable Domain-Specific Language and serves as documentation, automated tests and development-aid.
   
		```html		
		Feature: Some terse yet descriptive text of what is desired
		  In order to realize a named business value
		  As an explicit system actor
		  I want to gain some beneficial outcome which furthers the goal
		
		  Scenario: Some determinable business situation
		    Given some precondition
		    And some other precondition
		    When some action by the actor
		    And some other action
		    And yet another action
		    Then some testable outcome is achieved
		    And something else we can check happens too
		
		  Scenario: A different situation
		```
		
The complete guide of frameworks  installation and configuration can be found [here](https://angular.github.io/protractor/#/frameworks).


## <a name='links'>Links</a>

 -  Protactor Home
     http://angular.github.io/protractor
     
 -  Protactor Getting Started 
     https://angular.github.io/protractor/#/getting-started
     
 -  Jasmine Home 
	 http://jasmine.github.io/
	 
 -  Mocha Home
	 https://mochajs.org/
	 
 -  Selenium Home.. 
	 http://www.seleniumhq.org/
	 
 - WebDriverJs Wiki.. 
     https://github.com/SeleniumHQ/selenium/wiki/WebDriverJs
___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
