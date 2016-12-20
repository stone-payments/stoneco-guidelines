# Emberjs Style Guide

![alt text](static/ember_logo.png "Ember.js")

## Index

* [The Ember Way](#the-ember-way)
* [Templates](#templates)
* [Order of Declaration](#order-of-declaration)
* [Testing](#testing)
* [Resources](#resources)

## The Ember Way

Use [computed properties](https://guides.emberjs.com/v2.4.0/object-model/computed-properties/) whenever applicable.

---

Use [setProperties](http://emberjs.com/api/#method_setProperties) when you want to set multiple properties on an object with a single method call.

**Do this:**

```javascript
this.setProperties({
  'model.foo1': 'bar1',
  'model.foo2': 'bar2',
  'model.foo3': 'bar3'
});

Ember.setProperties(model, {
  foo1: 'bar1',
  foo2: 'bar2',
  foo3: 'bar3'
});
```

**Don't do this:**

```javascript
this.set('model.foo1', 'bar1');
this.set('model.foo2', 'bar2');
this.set('model.foo3', 'bar3');

model.set('foo1', 'bar1');
model.set('foo2', 'bar2');
model.set('foo3', 'bar3');
```

---

Always use `Ember.computed.readOnly` when you don't need to set the property.

---

Use `Ember.computed.oneWay` instead of `Ember.computed.alias` unless there is a
specific reason for propagating changes back to the source. If you change this
property, it will diverge from the original one.

---

Use ES6 object destructuring for commonly used helpers, i.e.

```javascript
const { computed, get, set, inject } = Ember;
```

---

Use `.` as a separator for the Ember resolver. Use `/` only for templates.

**Do this for templates:**

```javascript
export default Ember.Component.extend({
  layoutName: 'components/my-widget/widget',
});
```

**Do this for the Ember resolver:**

```javascript
export default Ember.Controller.extend({
  indexCtrl: Ember.inject.controller('main-widgets.index'),
});
```

---

## Actions

Use camel case for action properties.

**Do this:**

```html
{{my-component model=project onSave=(action "saveThings")}}
```

**Don't do this:**

```html
{{my-component model=project onsave=(action "saveThings")}}
```

---

Use closure actions whenever applicable.

**Prefer**

```html
<!-- template.hbs -->
{{my-component model=project onSave=(action "saveThings")}}

<!-- my-component.hbs -->
<button {{action attrs.onSave}}>Save</button>
```

**Over**

```html
<!-- template.hbs -->
{{my-component model=project onSave="saveProject"}}

<!-- my-component.hbs -->
<button {{action "save"}}>Save</button>
```

```javascript
// my-component.js
Ember.Component.extend({
  actions: {
    save: function() {
      this.sendAction('onSave');
    }
  }
});
```

---

When using closure actions, access the passed closure using `this.attrs`

```html
<!-- template.hbs -->
{{my-component model=project onSave=(action "doSomething")}}

<!-- my-component.hbs -->
<input type="text" oninput={{action "doIt" value="target.value"}} />
```

```javascript
// my-component.js
Ember.Component.extend({
  actions: {
    doIt: function(value) {
      this.attrs.onSave(value);
    }
  }
});
```

## Templates

Use double quotes for HTML content, for Handlebars/HTMLBars syntax use simple quotes.

**Do this:**

```html
<div class="foo">
  {{my-component data-id='foo' (action 'saveFoo')}}
</div>
```

**Don't do this:**

```html
<div class='foo'>
  {{my-component data-id="foo" (action "saveFoo")}}
</div>
```

---

The order of declaration for a component is always properties, and then actions.

---

Use a single line when the parameter list is short.

**Do this:**

```html
{{my-component foo=bar onSave=(action "saveFoo")}}
```

**Don't do this:**

```html
{{my-component
  foo=bar
  onSave=(action "saveFoo")}}
```

---

Use "Clojure" style formatting when the parameter list is very long (>120 characters).

**Do this:**

```html
{{my-component
  title=name
  details=accountName
  resourceId=id
  resourcePath="client/contacts"}}
```

**Don't do this:**

```html
{{
  my-component
  title=name
  details=accountName
  resourceId=id
  resourcePath="client/contacts"
}}
```

## Order of Declaration

The highest level order is:

* 1) Services;
* 2) Native Properties; and
* 3) Custom Properties.

Lifecycle hooks (e.g. model, setupController) should be in order of execution.

### Components:
* 1) Services;
* 2) Native component properties;
* 3) Passed / custom properties;
* 4) Lifecycle hooks;
* 5) Computed properties;
* 6) Any native functions; and
* 7) Actions.

Create a newline after each, and always line separate actions. So for example:

```javascript
export default Ember.Component.extend({
  tagName: 'li', // Native property

  classNames: 'list-items', // Native property

  title: 'Passed title', // Passed property

  didInsertElement() { // Lifecycle hook
    // code...
  },

  funnyTitle: computed('title', function() { // Computed property
    const title = this.get('title');

    return `FUNNY ${title}!`;
  },

  actions: {
    actionOne() {
      // code...
    },

    actionTwo() {
      // code...
    }
});
```

### Routes:
* 1) Service declarations;
* 2) Lifecycle hooks;
* 3) Any custom functions; and
* 4) Actions


### Models:
* 1) Service declarations
* 2) attrs;
* 3) Relationships;
* 4) Computed Properties; and
* 5) Custom functions.

```javascript
export default Model.extend({
  title: attr('string'),

  subTitle: attr('string'),

  comments: hasMany('comment'),

  author: belongsTo('user'),

  someProperty: computed('title', function() {
    // do something
  });
});
```

## Testing

[TBW]

## Resources

**Learning Ember.js**

  - [Ember Guides and Tutorials](https://guides.emberjs.com/v2.10.0/)
  - [EmberCLI](https://ember-cli.com/)
  - [The Ember Way](https://emberway.io/)
  - [Yoember](http://yoember.com/)
  - [Global Ember Meetup](https://vimeo.com/globalembermeetup)

**Ember Addons**

  - [Ember Observer](https://emberobserver.com/)

**Testing Ember**

  - [Ember QUnit](https://github.com/emberjs/ember-qunit)
