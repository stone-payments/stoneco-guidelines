# Correctly used Data binding, observers and listeners:


### HTML construction

The polymer HTML must have a semantic markup, use semantic Classes  Beyond appropriate element names, classes and IDs are semantic: they describe themselves without specifying.

If we detect a node of the DOM that will have a lot of access and this node isn't inside a DOM-IF or a DOM-REPEAT, we recommend labeling it with an id, because polymer indexes those nodes. We can access them with ```this.$.id```.

Make our component accessible, use ARIA-ROLES correctly.

We always must test our web components in all available browsers and, when possible, on mobile devices or simulators.

### JS construction

Our polymers should be simple to use and boast a simple coding.

Our Web components are like API's. To develop polymers we must comment the methods and properties in detail, to make it useful for our partners, helping them to learn how to manage and integrate say components.

The properties that our polymer uses must be declared in the corresponding section.

If the property is simple we can define it in a single line beside its type , however if it's a complex property, it must use the complex notation.

```javascript
Polymer({

  is: 'x-custom',

  properties: {
    user: String,
    isHappy: Boolean,
    count: {
      type: Number,
      readOnly: true,
      notify: true
    }
  }....

```

Our components must be operable from keyboard when necessary.

JavaScript is **not** always the answer. We have to think if our solution is the correct one or if we could use CSS techniques and apply them properly.

Of course, all of our components must be tested. WCT ( web component tester) includes Chai and Mocha for this goal. In this aspect, 
we recommend building unit, functional and integration test.

For other uses, we will follow the recommendations of javascript guideline, such as defining variable we use above methods and not abusing searches in the DOM.

### Polymer and lifecycles

The life cycle of polymer components is as follows:

* Created callback
* Local DOM initialized
* Ready callback
* FactoryImpl callback
* Attached callback

We must bear in mind that this order may vary depending on whether the browser includes native support for web components.

If you need to access items that are not prepared in the lifecycle yet, you can do it from the life cycle attached with async .

```javascript
attached : function ( ) {
   this.async (function ( ) {
      // Access sibling or parent elements here
   } ) ;
}
```

If one of our polymers uses or needs attributes, we recommend initializing them in creation phase and they must be declared in properties through *hostAttributes*.

### Polymer Communication: Data binding

Data binding binds the property or sub-property of a custom element (the host element) to a property or attribute of an element in its local DOM (the child or target element).

A binding is created with a binding annotation in the host element’s local DOM.

First of all, we must know what kind of Data binding we need:

A binding annotation consists of a property name or subproperty name enclosed in curly brackets ({{}}) or square brackets ([[]]).

* Square brackets ([[]]) create one-way bindings. Data flow is downward, host-to-child, and the binding never modifies the host property.

* Curly brackets ({{}}) create automatic bindings. Data flow is one-way or two-way, depending whether the target property is configured for two-way binding.

When we make a binding on a polymer, a set function is created in the target, dealing with the dirty-checking, applying property-effects to the property of the binding and launching an 'name'-changed event. Also, if our binding is "two-way", polymer establishes an eventListener to detect changes and to apply them upwards. For this reason, when establishing bindings in our application, we will take into account the following considerations:

* If the data will be read from linked lists , we will always use a "one-way" binding.
* If the created property only produces data, this property shall be marked with the read-only flag , as it avoids the creation of the setter.
* When we do bindings to objects and we want to modify a subproperty, we will never overwrite the entire object, instead we will use the methods given by polymer, which already use 'notifyPath' to notify the changes.
* The 'DOM-IF' helpers must be used to reduce the rendering of the DOM. The function of these helpers is to leave part of the template without rendering when your property is false. If we want features to show and hide, use the *Hidden* attribute given by polymer.
* When handling Array's binding if we want to reflect changes or update any member of an array, we must update the property with an 'observer' or 'Computed bindings'.


### Observers in Polymer

The use of properties observer from inside properties and outside Observers is different. 

The first one is used for simple properties and to detect changes, and its function will always receive the old value and the new one. On the second case, however, observers used for arrays and objects can also listen to changes in several properties at once.

This kind of array observers allow us to:

* Observe two properties at a time and react when the two are complete. If one of the two is undefined , the function assigned will not run, and wait until both attributes have a set value.

* In this type of observers when we use a "_ * _ " (deep )we will receive an object (change record) in the function with the following properties : path (path of the property has changed) , value ( the new value ) and base ( the part not included in the _ _ * ). We recommend using this object.

### Listeners in Polymer

To add event listeners, we should use the listeners array provided by polymer:

```javascript
Polymer({

     is: 'x-custom',

     listeners: {
       'tap': 'regularTap',
       'special.tap': 'specialTap'
     },

     regularTap: function(e) {
       alert("Thank you for tapping");
     },

     specialTap: function(e) {
       alert("It was special tapping");
     }

   });
```

If you need to add EventListeners manually in our code, the document should be able to remove them when required or always if a lifecycle 'detached' occurs. This has to be done in this way because polymer espects that components detached are not tied to asynchronous functions, since it could lead to memory leaks. We must also remember that, if it's necessary use the *this* context we, must pass it through our function by different means available (i.e. by the use of bind).

We may also use on-event annotations. In the particular case oftouch events, such as on-tap, it is sctrongly recomended to make use of the on-click listener instead, since it has a better performance.

```html
<dom-module id="x-custom">

  <template>
    <button on-tap="handleClick">Kick Me</button>
  </template>

  <script>

    Polymer({

      is: 'x-custom',

      handleClick: function() {
        alert('Ow!');
      }

    });

  </script>

</dom-module>
```


Shadow DOM has a feature called “event retargeting” which changes an event’s target as it bubbles up, such that target is always in the receiving element’s light DOM. On the other hand, Shady DOM does not do event retargeting, keep in mind that so events may behave differently depending on which local DOM system is in use.

In order to have a regular behavior in all cases, consider the use of Polymer.dom(event). The event object will be normalized, providing equivalent target data on both shady DOM and shadow DOM. Specifically, the normalized event has the following properties:

* rootTarget: The original or root target before shadow retargeting (equivalent to event.path[0] under shadow DOM or event.target under shady DOM).

* localTarget: Retargeted event target (equivalent to event.target under shadow DOM)

* path: Array of nodes through which event will pass (equivalent to event.path under shadow DOM).
___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
