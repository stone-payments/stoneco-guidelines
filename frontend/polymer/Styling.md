## 5. Web Components Styling
There are two hard problems when talking of css styling:

1. They minimize unpredictability by reducing unwanted selector matches (i.e. false positives).
2. They maximize code reuse by identifying and codifying recurring visual patterns.

Web components solve these problems:

1. Web components give us real style scoping and encapsulation. We can add elements to the page and won't be affected by the existing CSS.
2. We can abstract away presentational elements by putting them in the shadow DOM.


### 5.1. New Specs
There are three new specs when working with web components:
* **Custom Elements**: developers can define their own DOM element with their custom styling and functionality.
* **Shadow DOM**: a subtree of DOM nodes that are rendered to the page but dont appear in the source.
* **HTML Imports**: `require()` for the browser. Package up scripts, styles, and custom elements into a single bundle.

### 5.2. Styling local DOM
Polymer uses [Shadow DOM styling rules][shadow] for providing scoped styling of the element’s local DOM. Scoped styles should be provided via `<style>` tags placed inside the element’s local DOM `<template>`.

```html
<dom-module id="my-element">
  <template>
    <style>
      :host {
        display: flex;
        border: 1px solid blue;
      }
      #child-element {
        background: yellow;
      }
    </style>
    <div id="child-element">In local DOM!</div>
    <div><content></content></div>
  </template>
  ...
</dom-module>
```

### 5.3. Styling Distributed Children
Under shady DOM, the `<content>` tag doesn’t appear in the DOM tree. Styles are rewritten to remove the `::content` pseudo-element, and any combinator immediately to the left of `::content`. 

This implies:

1. You must have a selector to the left of the `::content` pseudo-element.

    ```css
    :host ::content div
    ```
    Becomes, being `my-element` the custom elements name:

    ```css
    my-element div
    ```

2. To limit styles to elements inside the `::content` tag, add a wrapper element around the  `<content>` element. This is especially important when using a child combinator (>) to select top-level children.

  ```html
  <dom-module id="my-element">
    <template>
      <style>
        .content-wrapper > ::content .mystyle {
          background: orange;
        }
      </style>
      <div class="content-wrapper"><content></content></div>
    </template>
  </dom-module>
  ```

### 5.4. Custom CSS Properties
Custom CSS properties can be defined as part of an element's API and will inherit from the point of definition down the composed DOM tree.
If a same element is used with different styles, a custom property can be exposed and assigned to a css property. By defining this variable in a CSS rule anywhere up the tree, the value of the property will inherit down to where it's defined.

We have a header custom element with a title. Its titles color property has a custom property assigned called `--my-header-title-color`.
```html
<dom-module id="my-header">
  <template>
    <style>
      :host {
        display: flex;
        background-color: none;
        margin: 2rem;
      }
      .title {
        color: var(--my-header-title-color);
      }
    </style>
    <span class="title">{{title}}</span>
  </template>
  <script>
    Polymer({
      is: 'my-header',
      properties: {
        title:{
         type: String,
         value: 'My title'
        }
      }
    });
  </script>
</dom-module>
```

It would be used the following way:

```html
<dom-module id="my-element">
  <template>
    <style>
      /* All header titles in this host will be blue by default */
      :host {
        --my-header-title-color: blue;
      }
      /* All headers with main class will be green*/
      .main {
        --my-header-title-color: green;
      }
    </style>      

    <my-header title="This title is blue."></my-header>
    <my-header title="This title is blue too."></my-header>
    <my-header class="main" title="This title is green."></my-header>
  </template>

  <script>
    Polymer({
      is: 'my-element'
    });
  </script>
</dom-module>
```

The `--my-header-title-color` property only affects the color of the title element encapsulated in `my-header` internal implementation. In the future the `my-header` title class can be renamed or internal details can be restructured without changing the custom property exposed to users.

### 5.5. Custom CSS Mixins
Polymer introduces an experimental extension which enables passing entire style blocks to the element using `@apply()` syntax.

```css
@apply(--my-mixin);
```
A mixins value is an object that defines one or more rules:
```css
selector {
  --my-mixin: {
    /* rules */
  };
}
```

Lets set an example:
```html
<dom-module id="my-header">
  <template>
    <style>
      :host {
        display: flex;
        background-color: none;
        margin: 2rem;
        @apply(--my-header-theme); /* header theme mixin */
      }
      .title {
        @apply(--my-header-title-theme);
      }
    </style>
    <span class="title">{{title}}</span>
  </template>
  ...
</dom-module>
```
And, if we apply this to our `my-element` custom element, we would have something like this:

```html
<dom-module id="my-element">
  <template>
    <style>
      /* Apply custom theme to headers */
      :host {
        --my-header-theme: {
          display: flex;
          border-radius: .5rem;
          border: 1px dashed blue;
        };
        --my-header-title-theme: {
          color: yellow;
        };
      }

      /* Only headers with the .main class green and bold */
      .main {
        --my-header-title-theme: {
          color: green;
          font-weight: bold;
        };
      }
    </style>

    <my-header title="This one is yellow."></my-header>
    <my-header title="This one is yellow too."></my-header>

    <my-header class="main" title="This one is green."></my-header>
  </template>

  <script>
    Polymer({
      is: 'my-element'
    });
  </script>
</dom-module>
```

### 5.6. Custom-Style
Another way for custom styling is using experimental `<style is="custom-style">` custom element that is provided for defining styles in the main document. These can take advantage of several special features of Polymer’s styling system, always having in mind that the `custom-style` extension should only be used for defining document styles, outside of a custom element’s local DOM.

For example:
```html
<html>
  <link rel="import" href="components/polymer/polymer.html">
  <style is="custom-style">
    /* Wont affect local DOM of Polymer elements */
    * {
      box-sizing: border-box;
    }
    /* Custom properties that inherit down the document tree may be defined */
    :root {
      --my-header-title-color: green;
      
      --my-header-title-theme: {
          color: --my-header-title-color;
          font-weight: bold;
        };
      
    }
  </style>
</head>
<body>
    ...
</body>
</html>
```


### 5.7. Shared styles and external stylesheets
Sharing style declarations between elements by packaging them into a set of style declarations is also posible doing this inside a `<dom-module>` element.

These style modules declare a named set of style rules that can be imported into an element definition, or into a custom-style element. Its defined inside an HTML import.
```html
<dom-module id="shared-styles">
  <template>
    <style>
      .warning {
        color: red;
        font-weight: bold;
      }
    </style>
  </template>
</dom-module>
```

The **id** attribute specifies the name you’ll use to reference your shared styles. Style module names use the same namespace as elements, so your style modules must have unique names.

To use a style module in an element, we must import the module using `<link>` tag and include our custom style in a `<style>` tag:

```html
<link rel="import" href="../shared-styles/shared-styles.html">
<dom-module id="my-element">
  <template>
    <style include="shared-styles"></style>
    <style>
      :host {
        display: block;
      }
    </style>
    This is my element
  </template>
  <script>
    Polymer({
      is: 'my-element'
    });
  </script>
</dom-module>
```

[//]: # (Reference links)

   [shadow]: <http://www.html5rocks.com/en/tutorials/webcomponents/shadowdom-201/>

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
