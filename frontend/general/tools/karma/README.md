![alt text](../../../../static/horizontal-beeva-logo.png "BEEVA")
# Front-end Development Best Practices

<img src="../static/karma.png" height="60px"/>

## Karma
  
*  [Introduction](#introduction)
* [Karma Configuration File](#karma-configuration-file)
* [Browsers](#browsers)
* [Preprocessors](#preprocessors)
* [Pluggins](#pluggins)
  * [Instalation](#instalation)
  * [Loading Pluggins](#loading-plugins)
* [Karma + Grunt](#karma-grunt)
* [Links](#links)

 
----
## <a name='introduction'>Introduction</a>

Karma is a test runner developed by the team of angular and its main objective is to provide a productive testing environment to developers that fits all their needs. 

The main advantages and characteristics of karma are:

   - <b>Testing Framework Agnostic</b>. Karma works with tests developed in Jasmine, Mocha, QUnit, and allows write a simple adapter for any framework you like.

   - <b>Continuous Integration</b>. Simple integration with Jenkins, Travis, Semaphore, Bamboo.
   
   - <b>Test on Real Browsers</b>. Such as Google Chrome, Firefox, Internet Explorer, PhantomJS.
   
   - <b>Test on Real Devices</b>.  Such as phones, tablets or desktop.
   
   - <b>Open Source</b>.  Developed for and maintained by the open source community at GitHub.
   


## <a name='karma-configuration-file'>Karma Configuration File</a>

Karma need to know certain information regarding our project concerning  framework adapters, reporters, preprocessors and launchers. All this is done in the configuration file <b>karma.conf.js</b>.

The Karma configuration file can be written in JavaScript or CoffeeScript and is loaded as a regular Node.js module. 

```javascript
// karma.conf.js
module.exports = function(config) {
  config.set({
    basePath: '../..',
    frameworks: ['jasmine'],
    //...
  });
};
```
```javascript
// karma.conf.coffee
module.exports = (config) ->
  config.set
    basePath: '../..'
    frameworks: ['jasmine']
    # ...
```
</br>

The complete list with the  configuration options  can be found [here](http://karma-runner.github.io/0.13/config/configuration-file.html). 

## <a name='browsers'>Browsers</a>

karma can work with most popular browsers on the market and for that we indicate in the configuration file browsers where we want to run the test.

```javascript
// karma.conf.js
browsers: ['Chrome','IE','Safari','Firefox']
```

The browser launchers need to be instaled and loaded as plugins. Available browser launchers:

  - <b>Chrome and Chrome Canary</b> (karma-chrome-launcher)
  - <b>Firefox</b> (karma-firefox-launcher first)
  - <b>Safari</b> (karma-safari-launcher first)
  - <b>PhantomJS</b> (karma-phantomjs-launcher)
  - <b>Opera</b> (karma-opera-launcher first)
  - <b>IE</b> (karma-ie-launcher first)
  - <b>SauceLabs</b> (karma-sauce-launcher)
  - <b>BrowserStack</b> (karma-browserstack-launcher)

The complete information about the browsers options can be found [here](http://karma-runner.github.io/0.13/config/browsers.html).

## <a name='preprocessors'>Preprocessors</a>

Preprocessors in Karma allow you to do some work with your files before they get served to the browser. These are configured in the preprocessors block of the configuration file:

```javascript
// karma.conf.js
preprocessors: {
  '**/*.coffee': ['coffee'],
  '**/*.tea': ['coffee'],
  '**/*.html': ['html2js']
},
```

The preprocessors need to be instaled and loaded as plugins.


## <a name='pluggins'>Pluggins</a>

The pluggins that allows easily extend the functionality of karma. The existing preprocessors, reporters, browser launchers and frameworks also are plugins.

Some of the most important pluggins are:

  - <b>Frameworks</b>
    - karma-jasmine
    - karma-mocha
    - karma-requirejs
    - ...
    
  - <b>Reporters</b>
    - karma-growl-reporter
    - karma-junit-reporter
    - karma-html-reporter
    - ...

  - <b>Launchers</b>
    - karma-chrome-launcher
    - karma-phantomjs-launcher
    - karma-firefox-launcher
    - ...

  - <b>Preprocessors</b>
    -  karma-coffee-preprocessor
    - karma-ng-html2js-preprocessor  
    - ...
    



The complete list of karma pluggins can be found [here](https://www.npmjs.com/browse/keyword/karma-plugin).

### <a name='instalation'>Instalation</a>

The pluggins installation is also very easy. Karma plugins are NPM modules, so the recommended way to install them are as project dependencies in your package.json:

```javascript
//package.json:
{
  "devDependencies": {
    "karma": "~0.10",
    "karma-mocha": "~0.0.1",
    "karma-growl-reporter": "~0.0.1",
    "karma-firefox-launcher": "~0.0.1"
  }
}
```

Therefore, a simple way to install a plugin is:

```
npm install karma-<plugin name> --save-dev
```


### <a name='loading-plugins'>Loading Plugins</a>

Karma automatically loads all sibling NPM modules which have a name starting with karma-*. 

In addition,  karma allows explicitly list plugins you want to load via the plugins configuration setting.

```javascript
//karma.conf.js
plugins: [
  // Karma will require() these plugins
  'karma-jasmine',
  'karma-chrome-launcher'

  // inlined plugins
  {'framework:xyz': ['factory', factoryFn]},
  require('./plugin-required-from-config')
]
```


## <a name='karma-grunt'>Karma + Grunt</a>

Karma is easily integrated with Grunt through the pluggin <b>[grunt-karma](https://github.com/karma-runner/grunt-karma)</b>. Thanks to this pluggin we can automate the execution of the test in karma as a task of Grunt.


To do this, first we install the necessary plugins as nodejs packages using NPM.

```javascript
//package.json
{
  "name": "BeevaProyect",
  "version": "1.0.0",
  "dependencies": {
  //...
/** asa*/
  },
  "repository": {
  //...
  },
  "devDependencies": {
  //...
    "grunt": "  ^0.4.5",
    "grunt-karma": "^0.9.0",    
    "karma": "^0.12.23",
    "karma-jasmine": "^0.1.5",
    "karma-phantomjs-launcher": "^0.1.4",
    "karma-chrome-launcher": "~0.1",
    "karma-coverage": "~0.1",
    "karma-growl-reporter": "~0.1",
    "karma-html-reporter": "~0.1",
    "karma-junit-reporter": "~0.2",    
    //...
  },
  "engines": {
    "node": ">=0.10.0"
  },
  "scripts": {
    "test": "grunt test"
  }
}
```

Then we have to configure the task to karma in the configuration file of grunt.

```javascript
// Gruntfile.js
'use strict';

module.exports = function (grunt) {

  // NODE MODULES GRUNT TASK
  grunt.loadNpmTasks('grunt-karma');
  grunt.loadNpmTasks('...');

  // GRUNT CONFIGURATION & TASK DEFINITIONS
  grunt.initConfig({
    //... 
    // KARMA - UNIT CONFIGURATION
    karma: {
      unit: {
        configFile: 'test/karma.conf.js',
        reporter: 'html',
        htmlReporter: {
          outputFile: 'dist/reports/JS-Test/karma-test-result.html',
          pageTitle: 'Beeva Proyect',
          subPageTitle: 'Página con los resultados de ejecución de los test Jasmine con Karma'
        }
      }
    }
    //... 
  });
};
  //.... 

  // KARMA -  TEST TASK
  grunt.registerTask('test', [
    'clean:server',
    //'wiredep',
    'concurrent:test',
    'autoprefixer',
    'connect:test',
    'karma:unit'
  ]);
};
```

And finally, we must configure the test in the karma configuration file.
```javascript
// karma.conf.js
'use strict';
module.exports = function(config) {

  config.set({
    autoWatch: true,
    reporters: ['dots', 'growl', 'coverage', 'progress', 'html', 'junit'],
    preprocessors: {
      'app/**/*.js': ['coverage']
    },
    coverageReporter: {
      type : 'html',
      dir : 'dist/reports/JS-Coverage'
    },
    junitReporter: {
      outputFile: 'dist/reports/JS-Test/junit-results.xml',
      suite: ''
    },
    basePath: '../',
    frameworks: ['jasmine'],
    files: [
      'bower_components/**/*.js',      
      'app/scripts/**/*.js',
      'test/mock/**/*.js',
      'test/spec/controllers/*.js'
    ],
    exclude: [],
    port: 9090,
    browsers: [
      'Chrome',
      'PhantomJS'
    ],
    plugins: [
      'karma-phantomjs-launcher',
      'karma-chrome-launcher',
      'karma-coverage',
      'karma-growl-reporter',
      'karma-html-reporter',
      'karma-junit-reporter',
      'karma-htmlfile-reporter',
      'karma-jasmine'
    ],
    singleRun: true,
    colors: true,
    logLevel: config.LOG_DEBUG    
  });
};

```

## <a name='links'>Links</a>
 -  Home... http://karma-runner.github.io/0.13/index.html
 -  The complete list of pluggins is in... (https://www.npmjs.com/browse/keyword/karma-plugin).
___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies

