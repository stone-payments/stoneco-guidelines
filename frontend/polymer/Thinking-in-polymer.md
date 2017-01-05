## 1. Thinking in polymer

### 1.1. Atomic Design

Polymer follows the atomic design methodology for creating components. This is, applications are made up of small components, atomic elements, which can be combined together to form molecules and they can be combined further to form relatively complex organisms, that´s the basic idea of atomic design.

There are five different levels:

  1. Atoms
  2. Molecules
  3. Organisms
  4. Templates
  5. Pages

We will stick with the most common levels, which are **atoms, molecules** and **organisms**.

#### 1.1.1. Atoms
Atoms include basic HTML tags like labels, inputs, buttons, and all other elements that can´t be broken down any further. You can see a entire document of atoms following this [link][atoms].
* Label atom:

  ```html
  <label for="name">Name</label>
  ```
* Input atom:

  ```html
  <input type="text" name="name" id="name" value="Enter your name">
  ```
* Button atom:

  ```html
  <input type="submit" value="Send">
  ```
Atoms can also include more abstract elemental items like color palettes, font stacks, and  invisible elements like animations. Defining these elemental properties of our UIs helps promote consistency and cohesion.

#### 1.1.2. Molecules
Molecules are simple groups of atomic UI elements working together as a unit. For example, a form label, search input, and a button can be combined together to create a search form molecule.

```html
<form action="demo">
  <label for="name">Name</label>
  <input type="text" name="name" id="name" value="Enter your name">
  <input type="submit" value="Send">
</form>
```
When combined, these abstract atoms have a purpose. The label atom defines the input atom and the button atom now submits the form. The result is a simple, portable, reusable component that can be dropped in any form site functionality.

Therefore, creating simple UI molecules makes testing easier, encourages reusability, and promotes consistency throughout the application.

#### 1.1.3. Organisms
Organisms are relatively complex UI components composed of groups of molecules and even atoms. These organisms form distinct sections of an application.

Organisms can consist of similar or different molecule types. A body organism might consist of different elements such as a logo image, navigation list and personal data form. While some organisms might consist of different types of molecules, others might consist of the same molecule repeated over and over again.

### 1.2. Web Components
Web components are a set of atomic designed elements that enable developers to build applications in a declarative, composed way. There's a list of best practices to ensure elements are defined properly.

#### 1.2.1. Namespacing
Custom elements must have a dash character in their name:
```html
<my-element></my-element>
```

The text before the dash is, usually, a namespace. You should keep it short but also unique. Try not to overlap on someone else's prefix if possible, only use a prefix shorter than three characters if you already have lots of developer interest in your set of components.

#### 1.2.2. Polymer Template
A simple Polymer template has a defined structure:
```html
<link rel="import" href="polymer/polymer.html">
<dom-module id="my-element">
  <!-- scoped CSS for this element -->
  <style>
    /* Your custom style */
  </style>
  <template>
    <!-- any children are rendered here -->
    <content></content>
  </template>
  <script>
    Polymer({
      is: 'my-element'
      /* Your properties and methods */
    });
  </script>
</dom-module>
```

#### 1.2.3. Native DOM Elements
Components should act like native DOM elements, so avoid creating elements that throw JS errors from ordinary DOM interactions.
```html
<ul>
  <div>
</ul>
```
If you place a `<div>` inside a `<ul>` it may not behave or render properly but it shouldn't throw errors either.

#### 1.2.4. Attributes for data in
Use attributes to pass configuration in. Use boolean attributes for boolean values.
```html
<my-element selected></my-element>
```
Instead of:
```html
<my-element selected="true"></my-element>
```

#### 1.2.5. Events for data out
Use custom events to pass information out of components unless the information is large or changes extremely often. To fire a custom event from the host element use the fire method. You can also pass in data to event handlers as an argument to fire.
```html
<dom-module id="my-element">
  <template>
    <button on-click="handleClick">Click Me</button>
  </template>
  <script>
    Polymer({
      is: 'my-element',
      handleTap: function(e, detail) {
        this.fire('Pushed', {pushed: true});
      }
    });
  </script>
</dom-module>
```

#### 1.2.6. Include Dependencies
Include all the dependencies your component needs.
```html
<link rel="import" href="my-file.html">
```
It doesn't matter if you include redundant dependencies, if you set appropiate cache headers, these will only be loaded once.

#### 1.2.7. Document your Component
Document your component properly so that everyone knows how to use it. Components have many aspects that count as part of their API.

* If the element declares a `<dom-module>`, write the documentation as HTML comments immediately preceeding that `<dom-module>`.

  ```html
  <link rel="import" href="../polymer/polymer.html">

  <!--
  `<my-element>` injects awesome code into your page.
  -->

  <dom-module id="my-element">
  ```
* If your element lacks a `<dom-module>`, write documentation via a JSDoc comment attached to its Polymer() call.

  ```js
  /**
   * `<my-element>` injects awesome code into your page.
   *
   */
   Polymer({
      is: 'my-element',
  ```
* Attributes can be described concisely with example markup.
* If a component is designed to be used inside another one, show it being used in that context.

  ```html
  <my-header-element>
    <my-element></my-element>
  <my-header-element>
  ```
* Lists its JavaScript methods and properties

  ```js
  my-property
  /**
  * This is a description of my property.
  * @type {property: String}
  */
  ```
  ```js
  my-method();
  /**
  * This is a description of my method.
  * @params {String} data
  * @return {String} modified data.
  */
  ```
* List its events

  ```js
  /**
  * Fired when data changed.
  * @event change-data
  */
  ```

* Private methods should be prefixed with _

  ```js
  /** @return {string} My response */
  _myPrivateMethod: function() {  };
  ```

* When using Shadow DOM, the `<content>` element and `select` attribute allow you to select which nodes to put where.

  ```html
  <template>
    <content select=".content"></content>
  </template>
  ```
  If your component treats different elements specially in these selectors, you must      document it.

* If your component relates to a microdata format, document how to apply that microdata to your component.

#### 1.2.8. Control Shadow DOM
Shadow DOM allows you to put many complex stuff out of sight. However, you should not have as many DOM elements as you want in your shadow, as it will lead to worse performance. Semantic data doesn't go in your Shadow DOM.

#### 1.2.9. Reuse Custom Elements
If you have two similar custom elements and the only difference between them is a different visual structure/display of the same data, consider consolidating them into one element and create two different templates to switch between. Alternatively, elements can be extended rather than duplicating similar functionality in two separate elements.

To help, the Polymer team has a great guide on creating [reusable elements][reuse].

#### 1.2.10. Make it flexible
If you create a successfull component, it will be used in many different contexts and mixed with different components. You must be as encapsulated and flexible you can, try not to rely on any external frameworks or structure when possible.

#### 1.2.11. Work with Local DOM Nodes
Every Polymer element has a `this` property which is its local DOM and you should only instance local nodes.
Use:
```js
this.querySelector('');
```
Instead of:
```js
document.querySelector('');
```

### 1.3. Other Practices
A successfull web component will be user by many people in many different contexts, therefore there should be other aspects to have in count when using Polymer.

#### 1.3.1. Accessibility
Custom Elements present a fantastic opportunity to improve accessibility on the web. Make your component accessible by using appropriate [ARIA][aria] roles. In cases where inheritance from a semantic base element is for any reason impossible or infeasible, be sure to add a `role=""` attribute, if any apply.

##### Elements used with keyboard
Ensure that all functionality in your element can be reached by a keyboard. For this you must have in count some aspects:

1. Ensure you have a sensible focus target for each element.
* The **tabindex** attribute allows elements to be focused using the keyboard.

    ```html
    <my-element tabindex="0">
    ```
* Using **autofocus** attribute allows specifying that a particular element should automatically focus when the page is loaded.

    ```js
    this.querySelector('element').focus();
    ```
* Add keyboard interaction to provide a good story when an element is focused. The [ARIA design patterns guide][design-pattern] provides some guidance.

2. Ensure you have meaningful text alternatives.

    Wherever information about the name or purpose of an interactive element is conveyed visually, an accessible text alternative needs to be provided.

    ```html
    <my-icon aria-label="Settings"></my-icon>
    ```

    Any element which displays an image should provide a mechanism for providing alternative text for that image, analogous to the alt attribute.

3. Ensure you provide semantical information.

    Assistive technology conveys semantic information which is otherwise expressed to sighted users via visual cues such as formatting, cursor style, or position. Native elements have this semantic information built-in by the browser, but for custom elements you need to use ARIA and roles to add this information in.

    ```html
    <my-slider role="slider" aria-valuenow="3" aria-valuemin="0" aria-valuemax="6"></my-slider>
    ```

#### 1.3.2. Performance
If you use a callback-based API for long-running operations, don't block the main thread excessively. Debounce methods and logic loops that affect rendering performance using requestAnimationFrame as a queue. Respond to being removed from the tree by suspending expensive operations like animation and don't start expensive operations until you're actually inserted into the DOM.

#### 1.3.3. Responsive
Where possible, and applicable, design your components so that they responsively adapt to their environment.

#### 1.3.4. Testing
Custom elements, like components you author today, should ideally have unit tests that serve as a sanity check for your API.

[//]: # (Reference links)

   [atoms]: <https://developer.mozilla.org/en-US/docs/Web/HTML/Element>
   [reuse]: <https://www.polymer-project.org/0.5/docs/start/reusableelements.html>
   [design-pattern]: <http://www.w3.org/TR/wai-aria-practices/#aria_ex>
   [aria]: <http://www.w3.org/WAI/PF/aria/>
___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
