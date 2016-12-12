# Angular Style Guide

![alt text](static/angular-logo.png "Angular")

## Index

* [Preface](#preface)
  * [Guide's Scope](#guides-scope)
  * [Angular's Lifecycle](#angulars-lifecycle)
* [General](#general)
* [Controllers](#controllers)
* [Directives](#directives)
* [Components](#components)
* [Filters](#filters)
* [Services](#services)
* [Other stuff](#other-stuff)
  * [`$watch` expressions](#dont-overuse-watch-expressions)
  * [`$templateCache`](#use-templatecache-to-compile-your-views)
  * [JSON resources for pro](#inject-your-jsons-in-production-via-constants)
  * [Start using Angular with ES6](#start-using-angular-with-es6)
  * [ES6 with WebPack](#es6-with-webpack)
* [Testing](#testing)
* [Miscellaneous](#miscellaneous)

# Preface

Thank you for reading this guide, on how to get the best possible outcomes out of your astonishing Angular app. This guide contains procedures and advices, collected from our experience on the tool over time. Every single item should have not only the *what*, but also the *why* using such specific method shall give you better results.

## Guide's Scope

This guide covers development techniques tightly related to Angular JS. Even if them rules could be abstracted into many other tools, you shall see the specific guide for such tool for further best practises.

The content of this guide lays on top of Frontend's best practises, whose contents should be taken into account too when developing an Angular application.

## Angular's Lifecycle

In order to fully understand the practises defined here, it would be really useful to have certain knowledge about how Angular deals with things. So here you'll find brief details on Angular's `phases`.

### Startup

#### Config

During app startup, Angular first calls to its declared `config` procedures. On these tasks your application should configure all stuff required to initialise your app. Amongst other thigs, this phase usually contains:

* Route configuration.
* i18n configuration.
* Global `$http`, `$location`, and other provider's configurations.
* Your custom config.

#### Run

The `run` process is another configuration phase. But this time around your app will be fully prepared and actually running. This could be a good place to load your transversal resources, configure app's language, ...

#### Config vs Run

Whilst the `run` process is engaged once the app is configured (and all stuff will be loaded and ready), during the `config` phase the application is still loading, and hence Angular hasn't inject your dependencies in order for you to use them. Therefore, during the `config` phase you will have available this:

| Dependency type | Availability                                                     |
| --------------- | ---------------------------------------------------------------- |
| constants       | Constants are available throughout all cycles of Angular's life. |
| providers       | Angular providers are `singletons` (just as any other services) that are not yet initialised during `config`. However, providers provides you (LOL) with a direct access to the declared function before init. |

### Routing

When you request Angular to load a route, you're internally triggering some tasks to verify and load your route, and several events will be fired.

* `$routeChangeStart`: This event is fired once a new route is requested. If you listen to this event you could intercept all route changes, and make some controlling within (verify authorization for the requested path, log information...).
* `$stateChangeSuccess`: Once your new route is loaded and if everything went smooth, you'll get this event triggered.
* `$routeChangeError`: If anything went south this event will be dispatched.

_NOTE:_ All above-menctioned events are documented [here](https://docs.angularjs.org/api/ngRoute/service/$route).

Once this flow finishes, and if everything went ok, your new route will be loaded. Usually `routing` processes are followed up by `rendering` processes.

### Rendering & data-binding

Rendering is the phase in which Angular takes your views and templates and `$compile`s them. During this lap, all your directives will be engaged, your bindings linked and synced, and your application freed to the user to interact with it. This is all achieved via the `$digest` cycle.

This rendering flow is in most cases completely automatic. Thanks to Angular's `dirty checking`, once something changes within your binded model, Angular will internally launch a `$digest` cycle, in which all targeted values will be checked and updated, and your view should immediately reflect your model updates. There are some cases though in which Angular does not now something has changed, and you need to notify its core to perform a new `$digest`. This is achieved via the `$apply` method.

_NOTE:_ As word of advice, read *carefully* the section about bindings and expressions. Is not usually a good practise to override Angular's native cycle through manual `$apply` calls, and most of the times this could be overcome with a slightly different approach.

# General

## Write obfuscation-ready code

When you inject some dependencies into yours, Angular recognises what you're intending to do by the name of your dependency. Once obfuscation process is through, your variable names would be messed up, and hence Angular would not have a clue about what to inject where.

Angular's solution is to explicitely define dependencies into an array, before declaring your dependency function. In fact, your dependency function will be the last item of such array, and it will receive as arguments all other earlier items.

```javascript
/*
 * Do this
 */
angular.module('myFancyApp')
 .controller('myFancyCtrl', ['$scope', '$filter', 'otherDependency', function($scope, $filter, otherDependency) {
  ...
 }]);

/*
 * InsteadOf this
 */
angular.module('myFancyApp')
 .controller('myFancyCtrl', function($scope, $filter, otherDependency) {
  ...
 });
```

_NOTE:_ On some examples below we have ommited this syntax. Our only purpose is to keep this guide short.

## Atomic development

As in any other development language/tool/technique, atomicity gives you great leverage on reading/understanding/refactoring your code. If you don't avoid having thousands lines files with many dependencies within them, using your code will eventually be a nightmare.

```javascript
/*
 * Do this
 */

// SampleDirective.js
angular.module('myFancyApp').directive('sampleDirective', [..., function(...) {
 ...
}]);

// AnotherDirective.js
angular.module('myFancyApp').directive('anotherDirective', [..., function(...) {
 ...
}]);

// --------

/*
 * InsteadOf this
 */

// Directives.js
angular.module('myFancyApp').directive('sampleDirective', [..., function(...) {
 ...
}]).directive('anotherDirective', [..., function(...) {
 ...
}]);

```

## Angular's modules

### Setting and getting

Angular modules are defined by invoking the `module` function, passing through a name for the module, and the array of dependencies it must be able to inject. Afterwards, modules are got via the same function call, but giving it just the _name_ attribute. You must avoid setting up modules more than once.

```javascript
/*
 * Do this only once!
 */

//Setting up a module
angular.module('myFancyApp', ['ngRoute', 'ngAnimate', ...]);

/*
 * Once your module is set up, you can just get it anywhere you want
 */

// Getting the module
angular.module('myFancyApp')
```

### Avoid global variables

Using global variables is always a discouraged technique. `True` they will be available all along your app, but precisely, you could cause collisions among your different files. If you want more information about this topic, please go to Douglas Crockford's article on [why global variables are *evil*](http://yuiblog.com/blog/2006/06/01/global-domination/).

```javascript
/*
 * Do this
 */

// Setting up
angular.module('myFancyApp', [...]);

// Getting
angular.module('myFancyApp')
 .controller(...);

/*
 * InsteadOf this
 */

// Setting up
var myFancyApp = angular.module('myFancyApp', [...]);

// Getting
myFancyApp.controller(...);


```

## Modularise your app

In almost every project you will be facing some feature development that doesn't belong to your project's core, or that could be otherwise extracted from central functionalities.

If you extract these features outside your core, you will ease code understanding, and you could reuse all modularised functionalities into other projects that suit, as they will be component-ready for direct-importing.

> Let's assume your application needs to handle users, and you need to provide several tools for audits.

```javascript
/*
 * Do this
 */
angular.module('myFancyApp.users', [...]) ... // Users' stuff
angular.module('myFancyApp.tools', [...]) ... // Audit tools
angular.module('myFancyApp', ['myFancyApp.users', 'myFancyApp.tools']) ... // General stuff

/*
 * InsteadOf this
 */
angular.module('myFancyApp', [...])
 .directive('userStuff', function() {...})
 .provider('auditTools', function() {...})
```

# Controllers

## Use `controllerAs`

When you declaring a controller within a view, you will immediately be provided with its scope, for direct use under your views (in other words, the `$scope` of such controller will be the namespace of the view, just as if all view were nested within a `with($scope)` clause).

This is cool. However, for non-complex types you could be facing reference problems when your model updates, specially if you are using a variable from an inner `$scope`. Your solution's name is `controllerAs`.

```html
<!-- Do this -->
<div ng-controller="myFancyCtrl as fancy">
 {{ fancy.variable }}
</div>

<!-- InsteadOf this -->
<div ng-controller="myFancyCtrl">
 {{ variable }}
</div>
```

This will also help you while using nested controllers, as you won't need to follow-up hierarchy to arrive at your target variable:

```html
<!-- Do this -->
<div ng-controller="myFancyCtrl as fancy">
 <div ng-controller="myChildCtrl as child">
  {{ fancy.variable + child.variable }}
 </div>
</div>

<!-- InsteadOf this -->
<div ng-controller="myFancyCtrl">
 <div ng-controller="myChildCtrl">
  {{ $parent.variable + variable }}
 </div>
</div>
```

## Nesting controllers

### Know Angular's `$scope` hierarchy

As Angular documentation states:

> Scope is an object that refers to the application model. It is an execution context for expressions. Scopes are arranged in hierarchical structure which mimic the DOM structure of the application. Scopes can watch expressions and propagate events.

Due to this `$scope` inheritance, all parameters defined in upper scopes will be propagated to lower ones. This could be a source of performance leaks, and you should fairly know how Angular's scopes need to work (See the guide about [`$scopes`](https://docs.angularjs.org/guide/scope) and the [`$rootScope`](https://docs.angularjs.org/api/ng/type/$rootScope.Scope) documentation.

### Don't abuse `$rootScope`

`$rootScope` is the highest-level `$scope` of your app. There's only one, accessible and mutable by all child controllers. Hence, every attribute and method defined within `$rootScope` will be propagated downwards to every single controller. Be wise about what you put inside it.

- [x] Common, view-accessible methods
- [ ] ~~Configuration attributes~~
- [ ] ~~Other things?~~

# Directives

## Use `restrict`

Directive's `restrict` parameter lets you define in which form your directive would be recognized. There are four types of directive restrictions:

* `E`: Your directive would be a DOM element (i.e. `<my-directive></my-directive>`).
* `A`: You will assign the directive to an element via an html attribute (i.e. `<any my-directive></any>`).
* `C`: You can use a css class to identify your directive (i.e. `<any class="my-directive"></any>`).
* `M`: Declare your directive with a html comment (i.e. `<!-- my-directive --><!-- /my-directive -->`).

Using the last two is not recommended, as first could be messed-up via dynamic class assignment, and the last could (and should) be removed by your code minifier.

```javascript
/*
 * Do this
 */
angular.module('myFancyApp')
 .directive('myDirective', function() {
  return {
   restrict: 'E', // or 'A' or 'EA'
   ...
  };
 });
```

### Replace your content if using '`E`'

When you use element-restricted directives (i.e. `E`), your DOM will render a `<my-directive>` tag in it. While this is cool for development purposes (as it keeps the html simple and more readable) it does not comply with HTML standards, and thus some browsers (e.g. our truly loving friend IE) won't execute your application properly. The solution? Replacing directive's content.

```javascript
angular.module('myFancyApp')
 .directive('myDirective', function() {
  return {
   ...
   restrict: 'E',
   replace: true
  };
 })
```
**WARNING:** When using `replace`, the template of your directive **must** lay into one sole root element. Otherwise you will get an exception thrown.

__NOTE:__ It seems that Angular has deprecated the `replace` attribute, and won't be available on 2.0 release. Shame on you, older IEs!


## Use `templateUrl` insteadOf `template`

Angular directives let you declare their templates either by an inline html structure (i.e. `template`) or via a view's URL (i.e. `templateUrl`). The latter the better, as therefore you will keep each language within its proper file.

```javascript
/*
 * Do this
 */
angular.module('myFancyApp')
 .directive('myDirective', function() {
  return {
   ...
   templateUrl: '/path/to/your/view.html'
  };
 })

/*
 * InsteadOf this
 */
angular.module('myFancyApp')
 .directive('myDirective', function() {
  return {
   ...
   template: '<div class="my-content"></div>'
  };
 })
```

## Leverage directive priority

When your application grows big you could end up having several different directives on the very same DOM element, each of which with a duty given. In some cases you may need one particular directive to be compiled after another. For that purpose Angular gives us a directive priority configuration (see more on [`$compile`](https://docs.angularjs.org/api/ng/service/$compile) documentation).

```html
<div my-directive1 my-directive2></div>
```

```javascript

// Directive 1 (more priority -> compiled first)
angular.module('myFancyApp')
 .directive('myDirective1', function() {
  return {
   ...
   priority: 1
  };
 })

// Directive 2 (less priority -> compiled last)
angular.module('myFancyApp')
 .directive('myDirective2', function() {
  return {
   ...
   priority: 0
  };
 })

```

## Use _object hash_ isolated scopes

Directives are directly nested down on DOM's structure, and hence on the `$scope` hierarchy. Thus, a directive will inherit by default all `$scope` attributes available on the context the directive's at.

Directive isolation lets you define which attributes the directive could use, and even tell angular how.

```javascript
/*
 * Do this
 */
angular.module('myFancyApp')
 .directive('myDirective', function() {
  return {
   ...
   scope: {
    inheritValue: '=', // Value obtained from upper scopes
    plainValue: '@', // Value given directly via String
    functionValue: '&', // Function call value
    renamedValue: '=otherValue', // Value set up as 'other-value' within the HTML, renamed to 'renamedValue'
    optionalValue: '=?' // If followed-up by a question mark, your parameter will be optional
   }
  };
 })

 /*
  * InsteadOf this (full isolated scope)
  */
 angular.module('myFancyApp')
 .directive('myDirective', function() {
  return {
   ...
   scope: true
  };
 })

 /*
  * Or this (no isolated scope)
  */
 angular.module('myFancyApp')
 .directive('myDirective', function() {
  return {
   ...
   scope: false
  };
 })
```

## Don't declare a directive's controller (normally)

You can include controller functionality under the `link` or `compile` methods. This is on most cases enough to cover your needs.

Angular directives could also define a controller to be directly engaged to the directive's template, in which you could also include features. This is not the best practise. At least not normally.

If your directive features intention are to be shared, an explicit controller might be your solution. On any other cases, `link` methods will do just fine.

```javascript
/*
 * Do this
 */
angular.module('myFancyApp')
 .directive('myDirective', function() {
  return {
   link: function postLink(scope, element, attrs) {
    // your code
   }
  };
 })

 /*
 * InsteadOf this
 */
angular.module('myFancyApp')
 .directive('myDirective', function() {
  return {
   controller: function() {
    // your code
   }
  };
 })
```

# Components

A component is a special kind of directive that uses a simpler configuration which is suitable for a component-based application structure.

It has been supported in Angular since 1.5 version, but [Todd Motto has back-ported it to 1.3+](https://toddmotto.com/angular-component-method-back-ported-to-1.3/). You can get the [polyfill here](https://github.com/toddmotto/angular-component).

Writing components directives will make it easier to upgrade to Angular 2 (and other frameworks like React or EmberJS), and it sticks with the actual web development standards.

With a component based architecture, it's easier to predict when data changes and what the state of a component is, due to the fact that components implements a clearly defined API based on inputs and outputs, and minimize two-way data binding.

## Components `best practices`.

* Components only control `their own View and Data`. Only the component that owns the data should modify it. Components should never modify any data or DOM that is out of their own scope. For component communication and state management between components, you need to use component defined API through inputs & outputs.

* Sticky with `$ctrl` as default `controllerAs name` convention for managing component controller inside template.

* Initialize components on `$onInit()` event. It's called on each controller after all the controllers on an element have been constructed and had their bindings initialized.

* React to component bindings changes on `$onChanges(changesObj)` event. It's called when one-way bindings are updated, and it contains a hash whose keys the names of the bound properties that have changed, and the values are an object of the form `{ currentValue, previousValue, isFirstChange() }`.

* Start designing your application as a `tree of components`. Ideally, the whole application should be a tree of components that implement clearly defined inputs and outputs, and minimize two-way data binding. That way, it's easier to predict when data changes and what the state of a component is.

* Try to not nest more than 2 levels deep of components inside a component, or you are going to get messy with components events callbacks.

## When `not to use components`.

* for directives that need to perform actions in `compile and pre-link functions`, because they aren't available

* when you need advanced directive definition options like `priority, terminal, multi-element`.

* when you want a directive that is triggered by an `attribute or CSS class`, rather than an `element`.

## Suggested approach to structure your component-based application.

* It's recommended to define an initial/starter component called 'app'. If you need to retrieve some initial data for your application, use $onInit() component hook.

* Store all your general application components inside a common folder called components (with their respective module definition inside of it).

* Store all your specific route/feature components inside a folder with their name (that will match route/feature url), and with their respective module definition inside of it.

* Store all your specific component-components inside a folder called `components` on their respective `component` folder.

```
src/
├── app/
│   ├── about/
│   │   ├── about.component.js
│   │   ├── about.module.js
│   │   ├── about.state.js
│   │   └── about.html
│   ├── components/
│   │   ├── app-side-nav/
│   │   │   ├── app-side-nav.component.js
│   │   │   └── app-side-nav.html
│   │   ├── app-toolbar/
│   │   │   ├── app-toolbar.component.js
│   │   │   └── app-side-nav.html
│   │   │── search-box/
│   │   │   ├── search-box.component.js
│   │   │   └── search-box.html
│   │   └── components.module.js
│   ├── home/
│   │   ├── components/
│   │   │   ├── home-header
│   │   │   │   ├── home-header.component.js
│   │   │   │   └── home-header.html
│   │   │   ├── home-dashboard
│   │   │   │   ├── home-dashboard.component.js
│   │   │   │   └── home-dashboard.html
│   │   │   ├── home-footer
│   │   │   │   ├── home-footer.component.js
│   │   │   │   └── home-footer.html
│   │   ├── home.component.js
│   │   ├── home.module.js
│   │   ├── home.state.js
│   │   └── home.html
│   ├── info/
│   │   ├── info.component.js
│   │   ├── info.module.js
│   │   ├── info.state.js
│   │   └── info.html
│   ├── app.component.js
│   ├── app.config.js
│   ├── app.constants.js
│   ├── app.html
│   ├── app.module.js
│   ├── app.run.js
│   └── app.state.js
├── assets/
├── scripts/
└── index.html
```

## Routable components

ui-router provides a mechanism to directly fill in a route view with a component, eliminating the need to define a template and a controller, allowing our routes/features to be directly provided by a component, giving us the chance to have a clean state definition, a true modular approach, and a separation of concerns.

ui-router also allows to pass resolved properties to component input bindings, giving us the chance to define a clean architecture where the data flow is clearly defined on state resolve process.

Let's suppose that we have a route called 'courses' that needs to fetch some remote data and pass it down to the component.

**courses.state.js**
```javascript
(function() {
  'use strict';

  angular
    .module('app.courses')
    .config(appConfig);

    appConfig.$inject = ['$stateProvider'];

    function appConfig($stateProvider) {
      var states = getStates();

      states.forEach(function(state) {
          $stateProvider.state(state);
      });
    }

    function getStates() {
      return [
          {
            name: 'courses',
            url: '/courses',
            component: 'courses',
            resolve: {
              courses: ['dataService', function(dataService) {
                  return dataService.getCoursesList();
              }],
              searchEnabled: function() {
                return true;
              }
            },
            data: {
              title: 'COURSES LIST'
            }
          }
      ];
    }
})();
```

**courses.component.js**
```javascript
(function() {
  'use strict';

  angular
    .module('app.courses')
    .component('courses', {
      template:
      '<search-box ' +
        'ng-if="$ctrl.searchEnabled" ' +
        'title="\'Search your course...\'"' +
        'on-change="$ctrl.search($event.text);"> ' +
      '</search-box> ' +
      '<course-gallery ' +
        'layout="row" layout-wrap ' +
        'courses="$ctrl.courses" ' +
        'filter="$ctrl.filter"> ' +
      '</course-gallery>',
      bindings: {
        //inputs
        courses: '<',
        searchEnabled: '<'

        //outputs
      },
      controller: CoursesController
    });

    function CoursesController() {
      var $ctrl = this;

      $ctrl.onInit = function() {
        $ctrl.filter = '';
      }

      $ctrl.search = function(value) {
        $ctrl.filter = value;
      }
    }
})();
```

# Filters

## Use `predefined filters`. They are localized

Angular provides you many filters that can help you to show formatted values to the users. It's better to use these filters than process data in the controllers.

If you use date or currency filters, Angular translate automatically the values to the language you are using in your application.

E.g. the markup `{{ 12 | currency }}` formats the number 12 as a currency using the currency filter. The resulting value is $12.00 if you are using US language. If you are using Spanish language, result will be 12€ for the same sentence.


## Use `custom filters` instead of controller processing

Sometimes you need to show certain values from the database, but you need to parse these values before showing them to the users. You must use filters for this purpose.

You can make filters to parse boolean, custom currencies or long texts values, for example:  

```javascript
/*
 * Do this for show Yes or No instead of true or false
 */
angular.module('myFancyApp')
  .filter('yesNo',['$translate', function ($translate) {
    return function (input) {     
      var st = input ? 'YES' : 'NOT';
      st = $translate('COMMON.'+st);

      return st;        
    };
  }]);
 });
```

#Services

## Know all service types

Angular provides several kinds of services, having them some differences among each others. Angular's documentation on [providers and recipes](https://docs.angularjs.org/guide/providers) there's an explanation about the peculiarities of each type.

### Use `factories` for data management

Factories are yet another recipe for defining a service in angular. Due to its name (and given that `factories` are often use to manage data) seems just reasonable to use this kind of service for such purpose.

#### Use `$resource` to connect to web services

Angular gives you a great system for managing web service connections (i.e. `angular-resource`). Via a `$resource` you can natively consume any RESTFUL service, and define all methods required for your custom operations. See the [`$resource`](https://docs.angularjs.org/api/ngResource/service/$resource) documentation for further info.

### Use `providers` for configuration matters

As we talked before in our [Config vs. Run](#config-vs-run) chapter, during configuration phases not all dependency types would be available. Thus, if you need to execute some behavior on a service during your config phase, it **must** be a `provider`.

**Example:**

> If you have a complex `locale` management, you shall want to execute something on `config` phase (e.g. loading your languages hashes, determining default language, etcetera. Then during execution you'd also want to consume some of the behaviors defined there. A provider is just what you need.

### Don't ever mutate `constants`

Angular constants are mutable. Weird? Yeah, but true. It's therefore your sole responsibility to keep standard procedures and **never** ever modify a constant after it's defined. `Values` would serve you well for this mutable variables.

#Other stuff

## Don't overuse `$watch` expressions

Watch expressions engage your `$scope` and view together, syncing changes bi-directionally, via `dirty checking`. Hence, once you start using a `$watcher`, all changes on the view model will be reflected autommatically in the view, and vice-versa. Watchers could be defined within a view (via the double-curly syntax - i.e. `{{ watcher }}`), or directly declared over your `$scope` (i.e. `$scope.$watch('scopeParam', ...)`).

As using a watcher means listening to every change performed, overloading your app with an excessive amount of watchers could trigger a dramatic perfomance leak.

As stated by Ben Nadel on his article [_Counting the number of watchers in Angular_](http://www.bennadel.com/blog/2698-counting-the-number-of-watchers-in-angularjs.htm), you **must keep your `watcher` count under 2,000**.

## Use `$templateCache` to compile your views

When you define a view, it is a plain HTML file stored apart from scripts and other resources. Thus, when Angular tries to load some view, it has to perform an XHR request to get your view loaded. ¿The problem? The timing. While your view is loading asynchronously your application will be already rendered, and hence you can feel a lack of integrity or a time-consuming loading for a single purpose.

To overcome this, Angular provides us with the `$templateCache`. When you request a view load, Angular first tries to resolve it's path within the cached templates. If (and only if) none is found there, an XHR request is triggered.

**WARNING:** Having templates cached is cool, but developing already cached templates (inline HTML) is an awkward procedure. Leverage `Grunt` or `Gulp` tasks (i.e. `angular-templates` or `ng-templates`) to compile your views at build time.

```javascript
// Gruntfile.js -EXAMPLE CONFIGURATION-

...
ngtemplates: {
  main: {
    cwd: '<%= yeoman.app %>',
    src:  [ 'views/{,*/}*.html', 'templates/**/*.html' ],
    dest: '<%= yeoman.dist %>/views.js',
    options: {
      prefix: '/', // Include a preffix to every view loaded
      module: 'myFancyApp'
    }
  }
},
...
```

## Inject your JSONs in production via `constants`

When you deploy your app into productive environments timing is of the essence. Normal minification procedures cover the obfuscation, concatenation, minification and compression of all your resources into <one-lined> one file. Your JSON resources that represent static files on your filesystem shall be minified too, and even converted into an Angular-ready format (avoiding the XHR calls to retrieve them on startup). For that purpose both `Grunt` and `Gulp` offer you tools (`angular-constants` or `ng-constants`) to convert such JSON files into Angular constants that could be directly injected into your app as another dependency. Nice and neat, you're avoiding `N` service calls with this approach.

```javascript
// Gruntfile.js -EXAMPLE CONFIGURATION-

...
ngconstant: {
options: {
  space: '  ',
  name: 'myFancyApp.config', // Name of the module
  wrap: '"use strict";\n\n {%= __ngModule %}',
  dest: '<%= yeoman.dist %>/config.js',

  // Global constants
  constants: {
    config: { // -> Constant name
      profiles:  grunt.file.readJSON('app/resources/availableProfiles.json'),
      global:             grunt.file.readJSON('app/resources/globalConf.json'),
      infoData:           grunt.file.readJSON('app/resources/infoData.json'),
      langList:           grunt.file.readJSON('app/resources/langList.json'),
      roleList:           grunt.file.readJSON('app/resources/roleList.json'),
      routes:             grunt.file.readJSON('app/resources/routes.json')
    },

    i18n: { // -> Constant name
      en:     grunt.file.readJSON('app/i18n/en.json'),
      en_US:  grunt.file.readJSON('app/i18n/en_US.json'),
      es:     grunt.file.readJSON('app/i18n/es.json'),
      es_ES:  grunt.file.readJSON('app/i18n/es_ES.json'),
    }
  }
},
...
```

**WARNING:** When injecting your i18n resources this way, you might find your texts messed-up. To overcome this, be sure the `config.js` file generated with such resources is loaded into the app with its proper encoding and mime-type.

## Start using Angular with ES6

ES6 allows our codebase to be cleaner, modular, and more concise, eliminating the need to define 'angular modules' and start using real modules through one of main ES6 features: named & default exports.

ES6 provides several useful features that allows to write a clear, cleaner, and DRY code, through the use of class, arrow functions, string templates, default params values on functions, variable destructuring, constants, etc...

### BEFORE ES6
```javascript
src/
└── app/
    └──components/
        ├── search-box
        │   ├── search-box.component.js
        │   └── search-box.html
        └── components.module.js
```

**search-box.component.js**
```javascript
(function() {
  'use strict';

  angular
    .module('app.components')
    .component('searchBox', {
      templateUrl: 'app/components/search-box/search-box.html',
      controller: SearchBoxController,
      bindings: {
        //inputs
        title: '<',

        //outputs
        onChange: '&'
      }
    });

  function SearchBoxController() {
    var $ctrl = this;

    $ctrl.onSearch = function(value) {
      $ctrl.onChange({
        $event: {
          text: value
        }
      });
    }
  }
})();
```

**search-box.html**
```javascript
<div layout="row" layout-margin>
  <md-input-container flex>
    <label ng-if="$ctrl.title">{{$ctrl.title}}</label>
    <input ng-change="$ctrl.onSearch($ctrl.searchValue);"
        ng-model="$ctrl.searchValue"
        ng-model-options="{ debounce: 500 }" />
  </md-input-container>
</div>
```

**components.module.js**
```javascript
(function() {
    'use strict';

    angular
        .module('app.components', []);
})();
```

### ES6
```javascript
src/
└── app/
    └── components/
        ├── search-box
        │   └── search-box.component.js
        └── components.module.js
```

**search-box.component.js**
```javascript
const template = `
  <div layout="row" layout-margin>
    <md-input-container flex>
      <label ng-if="$ctrl.title">{{$ctrl.title}}</label>
      <input ng-change="$ctrl.onSearch($ctrl.searchValue);"
          ng-model="$ctrl.searchValue"
          ng-model-options="{ debounce: 500 }" />
    </md-input-container>
  </div>
`;

export class SearchBoxController {
  constructor() {

  }

  onSearch(value) {
    this.onChange({ $event: { text: value } });
  }
}

export default {
  template,
  bindings: {
    //inputs
    title: '@',

    //outputs
    onChange: '&'
  },
  controller: SearchBoxController
}
```

**components.module.js**
```javascript
import { loadNg1Module, ngmodule } from '../bootstrap/ngmodule'; // custom boilerplate to easily load all modules & dependencies from WebPack.

import appSideNav from './app-side-nav/app-side-nav.component'; // not used in example
import appToolbar from './app-toolbar/app-toolbar.component'; // not used in example

import buttonEnrollCounter from './button-enroll-counter/button-enroll-counter.component'; // not used in example
import buttonLikeCounter from './button-like-counter/button-like-counter.component'; // not used in example

import searchBox from './search-box/search-box.component';
import totalEnrollCounter from './total-enroll-counter/total-enroll-counter.component'; // not used in example
import totalLikeCounter from './total-like-counter/total-like-counter.component'; // not used in example

const componentsModule = {
  components: { appSideNav, appToolbar, buttonEnrollCounter, buttonLikeCounter, searchBox,
    totalEnrollCounter, totalLikeCounter }
};

loadNg1Module(ngmodule, componentsModule);
```

### ES6 bootstrap & loadNg1Module

ui-router sample offers a simple & modular way to load & combine all our ES6 modules on a single angular module (app) through the use of import & exports, reducing all the boilerplate needed to craft a big and robust scalable angularjs app with ES6.

[You can check it here](https://github.com/ui-router/sample-app-ng1).

```javascript
src/
└── app/
    └── bootstrap/
        ├── bootstrap.js
        └── ngmodule.js
```

**bootstrap.js**
```javascript
/**
 * This file is the main entry point for the entire app.
 *
 * If the application is being bundled, this is where the bundling process
 * starts.  If the application is being loaded by an es6 module loader, this
 * is the entry point.
 *
 * Point Webpack or SystemJS to this file.
 *
 * This module imports all the different parts of the application which registers them with angular.
 * - Submodules
 *   - States
 *   - Components
 *   - Directives
 *   - Services
 *   - Filters
 *   - Run and Config blocks
 *     - Transition Hooks
 * - 3rd party Libraries and angular1 module
 */

 // import all the app sub modules
 // Each module registers it states/services/components, with the `ngmodule`
import '../app.module';
import '../components/components.module';
import '../courses/courses.module';

 // Import CSS (WebPack will inject it into the document)
 import 'angular-material/angular-material.css';
```

 **ngmodule.js**
 ```javascript
 /**
 * This file imports the third party library dependencies, then creates the angular module "demo"
 * and exports it.
 */

// External dependencies
import * as angular from 'angular';

import uiRouter from 'angular-ui-router';
import stateEvents from 'angular-ui-router/release/stateEvents';
import angularMaterial from 'angular-material';

// Create the angular module "app".
//
// Since it is exported, other parts of the application (in other files) can then import it and register things.
// In bootstrap.js, the module is imported, and the components, services, and states are registered.
export const ngmodule = angular.module('app', [uiRouter, 'ui.router.state.events',  angularMaterial]);

const BLANK_MODULE = {
  states: [],
  components: {},
  directives: {},
  services: {},
  filters: {},
  configBlocks: [],
  runBlocks: []
};

/**
 * Register each app module's states, directives, components, filters, services,
 * and config/run blocks with the `ngmodule`
 *
 * @param ngModule the `angular.module()` object
 * @param appModule the feature module consisting of components, states, services, etc
 */
export function loadNg1Module(ngModule, appModule) {
  let module = Object.assign({}, BLANK_MODULE, appModule);

  ngModule.config(['$stateProvider', $stateProvider => module.states.forEach(state => $stateProvider.state(state))]);

  Object.keys(module.components).forEach(name => ngModule.component(name, module.components[name]));

  Object.keys(module.directives).forEach(name => ngModule.directive(name, module.directives[name]));

  Object.keys(module.services).forEach(name => ngModule.service(name, module.services[name]));

  Object.keys(module.filters).forEach(name => ngModule.filter(name, module.filters[name]));

  module.configBlocks.forEach(configBlock => ngModule.config(configBlock));

  module.runBlocks.forEach(runBlock => ngModule.run(runBlock));

  return ngModule;
}
```

## ES6 with WebPack

WIP.

# Testing

_NOTE:_ This chapter covers exclusively Angular ways of testing. There's a broad greater set of best practises on the particular [Testing & QA](../../qa_testing) section of the guide.

## Use Angular mocks

When defining unit testing, you often need to inject dependencies that won't be available on testing phases. Angular mocks let you inject such services, and train them to return sample values of your choice. Take a look at Angular's [unit testing](https://docs.angularjs.org/guide/unit-testing) documentation for fully detailed information.

**Angular mocks example**
```javascript
// Initialize the controller and a mock scope
beforeEach(inject(function ($controller, $rootScope) {
  scope = $rootScope.$new();
  ManagementServiceManagementCtrl = $controller('ManagementServiceManagementCtrl', {
    $scope: scope
    // place here mocked dependencies
  });
}));
```

## Use Karma and Jasmine

Karma and Jasmine let you write atomic behavioral test specs that fullify the unit testing of your app. They're awesome tools.

**Sample test file**
```javascript
'use strict';

describe('Controller: ManagementServiceManagementCtrl', function () {

 // load the controller's module
 beforeEach(module('myFancyApp'));

 var ManagementServiceManagementCtrl,
   scope;

 // Initialize the controller and a mock scope
 beforeEach(inject(function ($controller, $rootScope) {
   scope = $rootScope.$new();
   ManagementServiceManagementCtrl = $controller('ManagementServiceManagementCtrl', {
     $scope: scope
     // place here mocked dependencies
   });
 }));

 it('should attach a list of awesomeThings to the scope', function () {
   expect(ManagementServiceManagementCtrl.awesomeThings.length).toBe(3);
 });
});
```

## Use Istanbul for coverage

Moving around sprints of your project you stepped back at some point, leaving unused some code. Code coverage lets you graphically see what code is being run or not, once executed your unit tests. Is fully graphical and gives you great insights about your code execution.

You can use keywords to ignore several content, that wouldn't apply for general code coverage reports.

See Istanbul documentation [here](https://github.com/gotwarlost/istanbul)

## Use Protractor for E2E tests

E2E tests allow you to simulate user's behavior executing certain tasks. Plus is cool to see your app moving back and forth magically.

Protractor leverages web drivers (just as Selenium or other tools do) to launch your favorite web browser and execute the tasks you've automated first. With this tool you can assure compliance of all covered behaviors, which is a really handy information before deploying into production environments, at the very least.

## Miscellaneous

### Be patient

Angular is a great tool, but its learning curve could be tricky. It's full of complex stuff and it's so complete, that along with your experience gaining you'll feel stuck somewhere. Don't panic, and try to keep going. Eventually you'll overcome its rollercoaster learning curve:

![alt text](static/feelings-angular.png "Experience on Angular over time")
_Image provided by Ben Nadel on his article [My experience with AngularJS](http://www.bennadel.com/blog/2439-my-experience-with-angularjs---the-super-heroic-javascript-mvw-framework.htm)_

### Trust the community

Angular is awesome, right. But most of its awesomeness is that finding someone that had already dealt with some challenge your facing is an almost-sure thing. Plus, its [documentation](https://docs.angularjs.org/guide/concepts) is neat.

### Provide to the community

Once you evolve with Angular you'll be capable of great-helping others, that could be struggling with some problem you've already solved.

We cannot say nothing about the public community, as open source contributions are completely optional and altruist, but you shall spend some time around our internal front-end community, to give and get as much as you can :).

### Further Readings

* [Angular Site](https://angularjs.org) API, SDK, News & Documentation
* [ng-newsletter](http://www.ng-newsletter.com) Newsletter about the angular community
* [ng-book](https://www.ng-book.com) Book about Angular 1.4
* [Angular John Papa's Styleguide](https://github.com/johnpapa/angular-styleguide)
* [CodeSchool free MOOC] (https://www.codeschool.com/courses/shaping-up-with-angular-js)

___

[BEEVA](http://www.beeva.com) | 2016
