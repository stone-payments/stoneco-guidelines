# Polymer Style Guide

![Polymer logo](https://www.polymer-project.org/images/logos/lockup.svg "BEEVA")

Polymer is a library created to help develop web components in that can be composed into apps. It relies on the Web Components standard from W3C. It is supported by Google and, as of now, the latest released version is 1.3.1

Since Polymer is based on Web Components it has two different contexts:

* **Component context:** when you develop standalone components to be used by other web components, or component based apps.
* **App context:** When you use web components to compose your app, taking care on how they interact.

In this document we're going to introduce some common good practices for developing polymer components, and also polymer based apps.

## Index

* [Think in polymer](Thinking-in-polymer.md):

  - Best practices about how to compose using atomic design, without monolithic code

* [Observers and data binding](data_binding_observers_listenes.md):

  - Notify readOnly

  - {{}} vs [[]]

  - declarative vs imperative

  - life cycle

* [Behaviors and inheritance](behaviors_and_inheritance.md):

  - Reusing code by mixins

  - Inheritance emulation

* [Styling well](Styling.md):

* [Polymer apps](polymer_apps.md):

* [Performance](performance.md):

* [Appendice](appendice.md):
  - Mediator pattern
  - Element Structure
  - Tools for polymer
    - Bower
    - Yeoman


### References

* [Web Polymer](https://www.polymer-project.org): Polymer project website
* [WebComponents](http://webcomponents.org/): Info about Web Components
* [Catalog](https://elements.polymer-project.org/): Element catalog
* [Thinking in Polymer](https://www.youtube.com/watch?v=ZDjiUmx51y8): One of the most interesting and useful talks about Polymer from Polymer summit (2015)
* [Polymer Starter Kit](https://github.com/PolymerElements/polymer-starter-kit): Sample scaffold for starting with Polymer
* [Polyserve](https://github.com/PolymerLabs/polyserve): Simple server for deploying a Polymer element stand alone locally
* [Polymer Yeoman Generator](https://github.com/yeoman/generator-polymer): Yeoman generator for developing Polymer elements and apps
* [Polycasts collection](https://github.com/Polymer/polycasts): Polycasts listed at github repository
* [Polymer guides](https://www.polymer-project.org/1.0/docs/devguide/feature-overview.html): Guides for developing Polymer
* [Polymer Roadmap](https://github.com/Polymer/project/blob/master/Roadmap.md): Polymer general feature roadmap
* [Polymer Summit videos](https://www.youtube.com/playlist?list=PLNYkxOF6rcICdISJclfQhj2S8QZGjXV8J): Entire Polymer Summit 2015 video collection

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
