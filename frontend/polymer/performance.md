# Performance Patterns

Talk about Performance is talk about time.

> How much time is ok? google has some tips about that, they call it RAIL:
https://developers.google.com/web/fundamentals/performance/rail

Let's focus on two kind of times to reduce.  Reduce Time === Improve Performance
* download time (js, html, css)
* Render time

### Download time

> USE THE PLATFORM. Use the browser.

One way to reduce download time is the use of the web components by themselves.

Using 'import' also reduce the number of downloads ('import' don't downloads the same file two times).

Minimize JS, HTML and CSS.

Make use of Service Workers.

#### PRPL

One more time let's take a look on a google concept
 https://developers.google.com/web/fundamentals/performance/prpl-pattern/
 https://www.polymer-project.org/1.0/toolbox/server

**P**ush critical resources for the initial route.

**R**ender initial route.

**P**re-cache remaining routes.

**L**azy-load and create remaining routes on demand.

##### **--Render**
    time to render = number of elements * cost of this elements (avg cost / elements)
> DO LESS BE LAZY

In order to reduce this ecuation we can focus in two actions:

1. less elements

2. load it efficially (less cost)

**Reduce number of elements**

  - Incremental Rendering:

    Render only neccesary content and let the rest occours in the background.

    In example using dom repeat with **< ... initial-count="N" >** will render the N first element only.

    Using iron-list that does it by default

  - Conditional Rendering:

    Optimize conditional sentences paying attention the cases, using dom-if for portions of code that we don't rendering usually.

    **dom-if  if="[[usuallyFalse]]"**

    If the content is simple and [[usuallyTrue]] is better use css or 'hidden' attribute

  - element upgrade:

    When uses a big sub component is betetr to set 'skeleton' element styled with css but empty previous to load the big subcomponent, with a 'loading...' text or similar and import the real element with a function called at 'ready'
``` javascript
ready: function() {
    _loadElement(){
       this.importHref(this.resolveUrl('../big-element/big-elemet.html'));
    }
}
```

>DO LESS BE LAZY

**Reduce Cost of elements**

To explain how to reduce the cost of an polymer element we're going to use a Polymer rating example.

This tips are perfect for small and high frecuency/commons components like atoms.

  >tools  (chrome extension):
  >
  >. polydev
  >
  >. polyperf

This is our first approach to a rating element based on star rating idea.
```html
  <rating element>

  <dom-module id="ratings-element">
    <template strip-whitespace> --> whitespace +1
      <style>/*...*/</style>
      <shadow-card>
        <span>*</span> --> star emoji +1
        <span>*</span>
        <span>*</span>
        <span>*</span>
        <span>*</span>
      </shadow-card>
    </template>
```
Is a god idea to use 'emojis' instead a svg or png image for the stars.
```javascript
Polymer({
  is: 'ratings-element',
  hostAttributes: { // sets attributes
    tabIndex: 0,
    role: 'slider'
  },
  listeners: { // adds event listeners
    keydown: '_keyHandler',
    down: '_downHandler'
  },
  properties: {
    rating: {
      reflectToAttribute: true, // sets attribute
      notify: true, // sends an event
      observer: '_ratingChanged', // calls this function
      value: 0 // all that happens when this is set
    }
  },
  ready: function() {
    this._ripple = document.createElement('paper-ripple');
  },
  _downHandler: function(e) {
    var i = Array.from(Polymer.dom(this.root).querySelectorAll('span')).indexOf(e.target);
    if (e.target.localName == 'span') {
      Polymer.dom(e.target).appendChild(this._ripple);
      this._ripple.uiDownAction(e);
    }
    this.rating = i + 1;
  },
  _keyHandler: function(e) {
    if (e.keyCode == 37) {
      this.rating = Math.max(this.rating - 1, 0);
    } else if (e.keyCode == 39) {
      this.rating = Math.min(this.rating + 1, 5);
    }
      },
  _ratingChanged: function() {
    Array.from(Polymer.dom(this.root).querySelectorAll('span')).forEach(function(n, i) {
      if (i < this.rating) {
        n.classList.add('checked');
      } else {
        n.classList.remove('checked');
      }
    }, this);
  }
});
```
With this code we can compare our rating element vs an input element

- Initial render
input 20 ms
star 129 ms

##### - reduce composition overuse
  This means, do not make an overcomplex element using thousands of subelements if you can do that by other way like CSS.

  In this case we ara using a <shadow-card> element to get a shadow but we can do it with css

  **replace a shadow element for a css**

- star 109 ms -> **20ms faster**

#####  - reduce work in ready/attached
  All that we do on 'ready' or 'attached' will delay the render of our component.

  Moves a function from 'readay' to the place where is used   --> more complexity on a method for better performance.

  **Nothing at 'ready'**

- star 69 ms ->  **40ms faster**

##### - use css more for dinamism
  CSS has evolve a lot, forget things like Js 'for' to set or remove a class from a list of elements or making animation with Js.

  **changes an observer and a 'forEach' span element add/remove className for a [rating] (CSS selector)**

- star 53 ms -> **16ms faster**

#####  - reduce use of defaults values
  When we set a default value Polymer will set that value before the render, setting the value also will fires an event and some things more delaying the first render.

  **removes a default '0' avoids set the value and send the event**

- star 42ms -> **11ms faster**

##### - defer work until after render
  Non critical for first render attributes and listeners can be sets after first render.

  From
```javascript
  hostAttributes: {
    tabIndex: 0,
    role: 'slider'
  },
  listeners: {
    keyDown: '_keyHandler',
    down: '_downHandler'
  }
```
  To
```javascript
  ready: function() {
    Polymer.RenderStatus.afterNextRender(this, function() {
      if (this.tabIndex < 0) {
        this.tabIndex = 0;
      }
      if (!this.role) {
        this.role = 'slider';
      }
      this.listen(this, 'down', '_downHandler');
      this.listen(this, 'keyDown', '_keyHandler');
    });
  }
```
**Moving non criticals to afterFirstRender**
- star 23ms

Finally we reduce load time from 129ms to 23ms.



This info was extracted from a Polymer Summit talk, you can see it here
https://www.youtube.com/watch?v=hHC9EOJzrQk

You can see full code at this repo
https://github.com/PolymerLabs/polyperf/tree/ratings-element/elements/ratings-element
