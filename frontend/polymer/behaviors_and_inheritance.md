# Behaviors and inheritance

In this section we'll see about behaviors (called mixins on previous versions), and how they can be used to reuse code between different components or simulate inheritance.
  
## Reusing code by behaviors
Behaviors are reusable modules following the Polymer prototype structure, similar to mixing concept on other languages.

When you need to share functions, listeners or properties between different components, being this shared code someway generic, you could use a behavior for that.

First good practice you must know about behaviors is that you should define a namespace for them. Then, you will not collide another behaviors.

Example:

```html
  <script>
    var MathsBehaviors = MathsBehaviors || {};
    MathsBehaviors.FormatBehaviors = {};
    
  </script>
```

Now, if you need to do more Math related behaviors, you can add them to this namespace. On the other hand, you could use the same sub name in other namespaces, for example: **StringTransformationBehaviors.FormatBehaviors** will not collide your previous behavior since their namespaces are different.

## A real case

Let's imagine we have two web components for two different purposes having the requirements below:

 * The component must save on a property the current time when it's attached.
 * The component needs a private function to check if DNI is valid or not.
 
Facing this requirements we can assume we have three options:

### Copy Paste (BAD SMELL)

We can just copy and paste code from one component to the other, breaking the DRY concept and making your code less maintainable.

Then we could have some polymer like below:

```javascript
...
  is: 'polymer-one',
  attached: function(){
    this.set('timestamp', Date.now());
  },
...
  checkDNI: function(value){
    // Whatever...
  }
...    

```

And then, we can copy our required code into the next one:

```javascript
...
  is: 'polymer-two',
  attached: function(){
    this.set('timestamp', Date.now());
  },
...
  checkDNI: function(value){
    // Whatever...
  }
...

```

That's not so maintainable since you must change every occurrence of code if you need to modify it.

### Make a Polymer from that (BAD SMELL)

We can create a polymer element in order to use it every time we need to. 

```javascript
...
  is:'common-staff',
  attached: function(){
    this.set('timestamp', Date.now());
  },
...
  checkDNI: function(value){
    // Whatever...
  }
...

```

It could seem useful to use the **<common-staff></common-staff>**, but it's not required to have a component for something that, though generic, it's so specific.

### Behavior way

You can create behaviors for that. For example, you can create a behavior called timeStamperBehavior and other behavior called validationUtilsBehavior.

#### time-stamper-behavior.html

Life cycle callbacks declared at behaviors are executed just before the client one that it's using the behavior.

```html
  <script>
    TimeStamperBehavior = {
      checkDNI: function(value){
        // Whatever...
      }
    };
  </script>

```

#### validation-utils-behavior.html

Functions and properties declared on behaviors are included into the client's prototype. If there're already a function or property with the same name in the client, the behavior function is overwritten.

```html
  <script>
    ValidationUtilsBehavior = {
      attached: function(){
        this.set('timestamp', Date.now());
      }
    };
  </script>
```

#### Using behaviors

You can also extend the behaviors if you need, having all the related logic encapsulated and modularized by behaviors.

Now, if you need to use the behaviors above, you can use both, or just one of them, like this:

```html
  <link rel="import" href="time-stamper-behavior.html">
  <link rel="import" href="validation-utils-behavior.html">

  <script>
    ...
    behaviors: [TimeStamperBehavior, ValidationUtilsBehavior],
    ...
  </script>
```
  
## Using behaviors as interfaces

We can use behaviors as interfaces in order to abstract some methods to be implemented by our components.

As an example, imagine we have a behavior able to listen to a certain type of events. Maybe we want to delegate into client component the way this event is handled:

```html
  <script>
    var BoomTrigger = {
      listeners: {
        'boom': 'boomTrigger'
      },
      
      boomTrigger: function(event){
      	// Abstract method to be implemented by client
      	console.log('boomTrigger method is not implemented, you must implement it');
      }
    };
  </script>
```

If we implement the 'boomTrigger' method in a client, the 'abstract' method will be overwritten, but it still will be called when boom event is listened.

## Inheritance emulation


Sometimes we could need extend one behavior with another one. Since behaviors can be extended from another, we can obtain reusables behaviors easily. We must take care about the hierarchy of behaviors as they are declared (the right one is the one that has the preference).

Let's suppose we have a behavior that contains a function for obtaining how much cost a bag of apples depending on the weight.


```html
  <script>
    var AppleCostCalculatorBehavior = {
    
      properties: {
        _appleKgCost: {
          type: Number,
          value: 5,
          readOnly: true
        }
      },
    
      getCost: function(weight){
        return this._appleKgCost * weight;
      }
    };
  </script>
```

### Adding by extension

We can add functions by extending the behavior:

```html
  <link rel="import" href="apple-cost-calculator-behavior.html">

  <script>
  
  	var ApplePriceInformerImpl = {
  	  getApplePrize: function(){
  	    console.log('Apple prize: ' + this._appleKgCost + ' / Kg');
  	  }
  	};
  
    var ApplePriceInformerBehavior = [AppleCostCalculatorBehavior, ApplePriceInformerImpl];  
  </script>
```

Now you can just use this behavior in the client.

```javascript
  behaviors: [ApplePriceInformerBehavior];
```

### Overwriting properties

We can modify properties:

```html
  <link rel="import" href="apple-cost-calculator-behavior.html">

  <script>
  
  	var ApplePriceExpensiveImpl = {
  	  properties: {
        _appleKgCost: {
          type: Number,
          value: 9,
          readOnly: true
        }
      },
  	};
  
    var ApplePriceExpensiveBehavior = [AppleCostCalculatorBehavior, ApplePriceExpensiveImpl];  
  </script>
```

Now you can just use this behavior in the client.

```javascript
  behaviors: [ApplePriceExpensiveBehavior];
```

### Overwriting methods

We can modify methods:

```html
  <link rel="import" href="apple-cost-calculator-behavior.html">

  <script>
  
  	var ApplePriceDiscountImpl = {
  	  getCost: function(weight){
        return AppleCostCalculatorBehavior.getCost(weight) * 0.9;
      }
  	};
  
    var ApplePriceDiscountBehavior = [AppleCostCalculatorBehavior, ApplePriceDiscountImpl];  
  </script>
```

Now you can just use this behavior in the client.

```javascript
  behaviors: [ApplePriceDiscountBehavior];
```

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
