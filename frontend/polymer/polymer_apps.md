# Polymers Apps

Some tips to makes polymer apps.

Local DOM lets you control composition. The element’s children can be distributed so they render as if they were inserted into the local DOM tree.

Make the composition of your polymers elements, to make your elements reusables.

Use data binding in the composite polymers, send data from the parent to the children, using carefully one-way or two-way, send data out of polymers with events (data go down on bindings and go outside of polymers with events).

Use data stores to get de data and send the data to the polymers.

Polymer automatically builds a map of instance nodes stamped into its local DOM, to provide convenient access to frequently used nodes without the need to query for (and memoize) them manually. Any node specified in the element's template with an id is stored on the this.$ hash by id.

* Use inline styles to reserve app “regions”.
* Vulcanize and crush the element bundles (excluding Polymer itself).
* Conditionally and async load the Web Components lite polyfill.
* Async load the element bundles. (This will also set up a race for Polymer itself).

Use mediator pattern in polymer.

Minimize property reflection.

Minimize the elements rendered.

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
