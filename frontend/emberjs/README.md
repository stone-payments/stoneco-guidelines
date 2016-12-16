# Emberjs Style Guide

![alt text](static/ember_logo.png "Ember.js")

## Index

* [The Ember Way](#the-ember-way)

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

