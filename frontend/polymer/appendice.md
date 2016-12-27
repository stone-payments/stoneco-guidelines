## Appendice
In this section we'll see some aspects related with polymer development routine (tools, common patterns...)

## Mediator pattern

When we need to communicate polymer elements inside a common context, we must use the [Mediator Pattern](https://en.wikipedia.org/wiki/Mediator_pattern).

> The essence of the Mediator Pattern is to "define an object that encapsulates how a set of objects interact" - Wikipedia

Then, we can use Polymer features in order to communicate info between polymers, also coordinate them.

### Background

In orther to implement mediator pattern in Polymer we need:

* A common context, like a polymer containing the other ones.
* Some polymers needing coordination and/or communication
* Some way to implement communication

The first two points are clear since it could be as simple as two polymers declared into their host template.

```html
  <dom-module id="host-element">
    <template>
      <guest-element-one></guest-element-one>
      <guest-element-two></guest-element-two>
    </template>
  </dom-module>
  <script>
    Polymer({
      is: 'host-element'
    });
  </script>
```

The last one has a flexible implementation, since it could be implemented using listeners, observers, data binding... and a combination of several Polymer features.

### Communication guest->host

First of all, it's importante to consider polymer elements as encapsulated autonomous entities they don't care about the context outside. If we try to use mediator pattern between some guest polymers they don't expose communication outside, maybe we can't do it, or they are not properly implemented regarding I/O communication.

A polymer element can use mainly two methods in order to communicate something outside (for example, to its host).

* **Databinding and observers**: You can bind a local variable on your host with a guest property. Then you can observe changes on it.

```html
  <dom-module id="host-element">
    <template>
      <guest-element guest-variable="{{bindedVariable}}"></guest-element>
    </template>
  </dom-module>
  <script>
    Polymer({
      is: 'host-element',
      properties: {
        bindedVariable: {
          type: String,
          value: 'someValue'
        }
      }
    });
  </script>
```

* **Listeners**: Is so common firing events from polymers when a relevant action is done. We an listen actions fired by guest from the host element in order to respond this action with a determinate consequent action.

  
```html
  <dom-module id="host-element">
    <template>
      <!-- Fires 'action-done' event -->
      <guest-element></guest-element>
    </template>
  </dom-module>
  <script>
    Polymer({
      is: 'host-element',
      listeners: {
        'action-done': '_handleAction'
      },
      _handleAction: function(event){
        // Your staff here
      }
    });
  </script>
```

Note you can also set the listener declaratively

### Communication host->guest

There're two ways for changing guest elements from hosts.

* **Databinding**: The required action could be just change a property. Then, the guest element can react to that change doing whatever he want.


* **Direct call**: Sometimes a method call is easier than change a property. Then, you must identify your guest in order to call a method on it with params if neccessary.

```html
  <dom-module id="host-element">
    <template>
      <guest-element id="guest"></guest-element>
    </template>
  </dom-module>
  <script>
    Polymer({
      is: 'host-element',
      ...
      _hostMethod: function(){
        this.$.guest.someGuestMethod();
      }
      ...
    });
  </script>
```


### Context

We can implement the mediator pattern by ussing a template where two or more Polymer elements can share info trought their host (the template owner):

```html
  <dom-module id="host-element">
    <template>
      <guest-element-one></guest-element-one>
      <guest-element-two></guest-element-two>
    </template>
  </dom-module>
  <script>
    Polymer({
      is: 'host-element'
      ...
      /* Listeners, obvservers... all the kind 
      of features you can use to mediate*/
      
    });
  </script>
```

In the example above the host (host element) contains two guest elements into its template. These elements can communicate using guest->host communication as explained above. The host must implement all the features needed to act as a mediator between the two guest, and then, use host->guest communication when required.

## Element structure

The best way to create a correct scaffold in Polymer is taking a look to seed-element or using yeoman (It will be explained next).

In every element you must see three important parts:

* **bower.json**: file to handle dependencies via bower tool
* **demo folder**: folder when you can allocate your demo, using [iron-component-page](https://github.com/PolymerElements/iron-component-page) to provide documentation polymer style
* **test folder**: test using [web-component-tester](https://github.com/Polymer/web-component-tester)

You should take into account that polymer implement docs using determinated meta tags in order to create their doc "catalog style". The best way to learn about is exploring examples of [Hydrolisis](https://github.com/Polymer/hydrolysis), the Polymer tool used to parse Polymer documentation.

## Tools for polymer
### Bower
Bower is a javascript dependency manager commonly used when developing polymer elements or apps.

Every polymer element (according to [seed-element](https://github.com/polymerelements/seed-element)) has a bower.json file with needed dependencies. you must take care of it and declare every dependency you could need on it.

### Yeoman
Yeoman is a tool that creates an scaffolding for your app, component...

Yeoman allow to install generators for creating different structures, from angular apps, to polymer elements, polymer apps... Generators are constantly evolving.

Polymer has developed a really good generator based on seed-element and Polymer Starter Kit, you can take a look [here](https://github.com/yeoman/generator-polymer)
___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
