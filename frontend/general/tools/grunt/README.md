![alt text](../../../../static/horizontal-beeva-logo.png "BEEVA")
# Front-end Development Best Practices

<img src="../static/grunt-logo.png" height="80px"/>  

## GRUNT

* [Introduction](#introduction)
* [Gruntfile](#gruntfile)
* [Plugins](#plugins)
* [Links](#links)

----
## <a name='introduction'>Introduction</a>

Grunt, the JavaScript Task Runner is implemented with NodeJS and used for configuration and implementation of automated tasks for:

   - <b>Improving Productivity</b>, speed up the development workflow.

   - <b>Enhancing the Performance</b>, optimizing each byte.

   - <b>Carrying repetitive time-consuming tasks</b>, like minification, validation, documentation generation or hosting code upload.

   - <b>Increasing Quality</b>, through testing and documentation.

<br>
The Grunt ecosystem is huge and it's growing every day with hundreds of plugins to configure and automatize task with a minimum of effort for:

- Validation of the code (JS, CSS).

- Compression and Obfuscation of the code.

- Execution of automated test.

- Management and installation of dependencies.

- Generation of project documentation.

- ES6 workflow.

- And much more..


## <a name='gruntfile'>Gruntfile</a>

The configuration and execution of all tasks and plugins is done in the configuration file <b>Gruntfile</b>.

```javascript
module.exports = function (grunt) {

  // NODE MODULES GRUNT TASK
  grunt.loadNpmTasks('grunt-karma');
  grunt.loadNpmTasks('grunt-ngdocs');
  grunt.loadNpmTasks('grunt-bower-install');


  // GRUNT TASKS
  require('load-grunt-tasks')(grunt);
  require('time-grunt')(grunt);

  // APPLICATION CONFIG PATHS
  var appConfig = {
    app: require('./bower.json').appPath || 'app',
    dist: 'dist'
  };

  // GRUNT CONFIGURATION & TASK DEFINITIONS
  grunt.initConfig({

    // YEOMAN CONFIGURATION
    yeoman: appConfig,

    // NG-DOCS TASK (Task for documentation generation)
    ngdocs: {
      options: {
        dest: 'dist/docs',
        html5Mode: false,
        startPage: '/api',
        title: "Beeva Proyect",
        image: "app/images/logoBeeva.png",
        titleLink: "/api",
        bestMatch: true
      },
      tutorial: {
        src: ['content/tutorial/*.ngdoc'],
        title: 'Tutorial'
      },
      api: {
        src: ['app/**/*.js', '!app/**/*.spec.js'],
        title: 'API Documentation'
      },
      all: ['app/**/*.js']
    },

    // WATCH TASK (Task to observer files for changes and runs tasks based on the changed files)
    watch: {
      bower: {
        files: ['bower.json'],
        tasks: ['wiredep']
      },
      js: {
        files: ['<%= yeoman.app %>/scripts/{,*/}*.js'],
        tasks: ['newer:jshint:all'],
        options: {
          livereload: '<%= connect.options.livereload %>'
        }
      },
      jsTest: {
        files: ['test/spec/{,*/}*.js'],
        tasks: ['newer:jshint:test', 'karma']
      },
      styles: {
        files: ['<%= yeoman.app %>/styles/{,*/}*.css'],
        tasks: ['newer:copy:styles', 'autoprefixer']
      },
      gruntfile: {
        files: ['Gruntfile.js']
      },
      livereload: {
        options: {
          livereload: '<%= connect.options.livereload %>'
        },
        files: [
          '<%= yeoman.app %>/{,*/}*.html',
          '.tmp/styles/{,*/}*.css',
          '<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}'
        ]
      }
    },
    bowerInstall: {
      target: {
        src: [
          'app/index.html'
        ],
        cwd: '',
        dependencies: true,
        devDependencies: false,
        exclude: [],
        fileTypes: {},
        ignorePath: '',
        overrides: {}
      }
    },

    // GRUNT SERVER TASK CONFIGURATION
    connect: {
      options: {
        port: 9000,
        hostname: 'localhost',
        livereload: 35729
      },
      livereload: {
        options: {
          open: true,
          middleware: function (connect) {
            return [
              connect.static('.tmp'),
              connect().use(
                '/bower_components',
                connect.static('./bower_components')
              ),
              connect().use(
                '/app/styles',
                connect.static('./app/styles')
              ),
              connect.static(appConfig.app)
            ];
          }
        }
      },
      test: {
        options: {
          port: 9001,
          middleware: function (connect) {
            return [
              connect.static('.tmp'),
              connect.static('test'),
              connect().use(
                '/bower_components',
                connect.static('./bower_components')
              ),
              connect.static(appConfig.app)
            ];
          }
        }
      },
      dist: {
        options: {
          open: true,
          base: '<%= yeoman.dist %>'
        }
      }
    },

    // JS-HINT TASK (Task for javascript validation)
    jshint: {
      options: {
        jshintrc: '.jshintrc',
        reporter: 'jslint',
        //reporter: 'checkstyle',
        //reporter: require('jshint-stylish'),
        reporterOutput: 'dist/reports/JS-Validations/jshint.txt'
        //reporter: require('jshint-html-reporter'),
        //reporterOutput: 'dist/reports/JS-Validations/jshint.html'
      },
      all: {
        src: [
          'Gruntfile.js',
          '<%= yeoman.app %>/scripts/{,*/}*.js'
        ]
      },
      test: {
        options: {
          jshintrc: 'test/.jshintrc'
        },
        src: ['test/spec/{,*/}*.js']
      }
    },

    // CLEAN TASK (Task for clean distribution and temporal files)
    clean: {
      dist: {
        files: [{
          dot: true,
          src: [
            '.tmp',
            '<%= yeoman.dist %>/{,*/}*',
            '!<%= yeoman.dist %>/.git{,*/}*'
          ]
        }]
      },
      server: '.tmp'
    },

    // GRUNT CSS AUTO-PREFIXER (Task for management vendor prefixes of CSS3 properties)
    autoprefixer: {
      options: {
        browsers: ['last 1 version']
      },
      server: {
        options: {
          map: true
        },
        files: [{
          expand: true,
          cwd: '.tmp/styles/',
          src: '{,*/}*.css',
          dest: '.tmp/styles/'
        }]
      },
      dist: {
        files: [{
          expand: true,
          cwd: '.tmp/styles/',
          src: '{,*/}*.css',
          dest: '.tmp/styles/'
        }]
      }
    },

    // GRUNT WIREDEP (Task for inject Bower components into the app)
    wiredep: {
      app: {
        src: ['<%= yeoman.app %>/index.html'],
        ignorePath: /\.\.\//
      }
    },

    // GRUNT FILEREV TASK (Task for rename files based on its contents to caching purposes)
    filerev: {
      dist: {
        src: [
          '<%= yeoman.dist %>/scripts/{,*/}*.js',
          '<%= yeoman.dist %>/styles/{,*/}*.css',
          //'<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}',
          '<%= yeoman.dist %>/styles/fonts/*'
        ]
      }
    },

    // GRUNT USEMIN-PREPARE (Task for configure usemin task)
    useminPrepare: {
      html: '<%= yeoman.app %>/index.html',
      options: {
        dest: '<%= yeoman.dist %>',
        flow: {
          html: {
            steps: {
              js: ['concat', 'uglifyjs'],
              css: ['cssmin']
            },
            post: {}
          }
        }
      }
    },

    // GRUNT USERMIN
    usemin: {
      html: ['<%= yeoman.dist %>/{,*/}*.html'],
      css: ['<%= yeoman.dist %>/styles/{,*/}*.css'],
      options: {
        assetsDirs: [
          '<%= yeoman.dist %>',
          '<%= yeoman.dist %>/images',
          '<%= yeoman.dist %>/styles'
        ]
      }
    },

    // GRUNT CSSLINT (Task for CSS Validations)
    csslint: {
      options: {
        csslintrc: '.csslintrc',
        formatters: [
          {id: 'junit-xml', dest: 'dist/reports/CSS-Validations/csslint_junit.xml'},
          {id: 'csslint-xml', dest: 'dist/reports/CSS-Validations/csslint.xml'}
        ]
      },
      strict: {
        options: {
          import: 2
        },
        src: ['app/styles/*.css']
      }
    },

    // GRUNT CSSMIN (Task for CSS Minification)
    cssmin: {
      options: {keepSpecialComments: 0}
    },
    // GRUNT UGLIFY (Task for CSS/JS Minification)
    uglify: {
      dist: {
        files: {
          '<%= yeoman.dist %>/scripts/scripts.js': [
            '<%= yeoman.dist %>/scripts/scripts.js'
          ]
        }
      }
    },
    concat: {
      dist: {}
    },
    // GRUNT IMAGE-MIN (Task to images optimization)
    imagemin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>/images',
          src: '{,*/}*.{png,jpg,jpeg,gif}',
          dest: '<%= yeoman.dist %>/images'
        }]
      }
    },

    // GRUNT SVG-MIN (Task to SVG optimization)
    svgmin: {
      dist: {
        files: [{
          expand: true,
          cwd: '<%= yeoman.app %>/images',
          src: '{,*/}*.svg',
          dest: '<%= yeoman.dist %>/images'
        }]
      }
    },

    // GRUNT HTML-MIN (Task to HTML Optimization)
    htmlmin: {
      dist: {
        options: {
          collapseWhitespace: true,
          conservativeCollapse: true,
          collapseBooleanAttributes: true,
          removeCommentsFromCDATA: true,
          removeOptionalTags: true
        },
        files: [{
          expand: true,
          cwd: '<%= yeoman.dist %>',
          src: ['*.html', 'templates/{,*/}*.html', 'partials/directives/*.html', 'partials/widgets/{,*/}*.html'],
          dest: '<%= yeoman.dist %>'
        }]
      }
    },

    // GRUNT NG-ANNOTATE (Task for dependency injection of angular modules)
    ngAnnotate: {
      dist: {
        files: [{
          expand: true,
          cwd: '.tmp/concat/scripts',
          src: '*.js',
          dest: '.tmp/concat/scripts'
        }, {
          expand: true,
          cwd: '.tmp/concat/js',
          src: '*.js',
          dest: '.tmp/concat/js'
        }]
      }
    },

    // GRUNT COPY FILES
    copy: {
      dist: {
        files: [{
          expand: true,
          dot: true,
          cwd: '<%= yeoman.app %>',
          dest: '<%= yeoman.dist %>',
          src: [
            '*.{ico,png,txt}',
            '.htaccess',
            '*.html',
            '{,*/}*.html',
            'partials/widgets/{,*/}*.html',
            'partials/directives/*.html',
            'images/{,*/}*.{webp}',
            'styles/fonts/{,*/}*.*'
          ]
        }, {
          expand: true,
          cwd: '.tmp/images',
          dest: '<%= yeoman.dist %>/images',
          src: ['generated/*']
        }, {
          expand: true,
          cwd: 'bower_components/font-awesome',
          src: 'fonts/*',
          dest: '<%= yeoman.dist %>'
        },{
          expand: true,
          cwd: '<%= yeoman.app %>',
          src: '*fonts/*',
          dest: '<%= yeoman.dist %>'
        }]
      },
      styles: {
        expand: true,
        cwd: '<%= yeoman.app %>/styles',
        dest: '.tmp/styles/',
        src: '{,*/}*.css'
      }
    },

    // GRUNT CONCURRENT (Task for parallel execution of tasks)
    concurrent: {
      server: [
        'copy:styles'
      ],
      test: [
        'copy:styles'
      ],
      dist: [
        'copy:styles',
        'imagemin',
        'svgmin'
      ]
    },

    // KARMA TEST
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
  });

  // HTTP SERVER TASK
  grunt.registerTask('server', 'Compile then start a connect web server', function (target) {
    if (target === 'dist') {
      return grunt.task.run(['build', 'connect:dist:keepalive']);
    }
    grunt.task.run([
      'clean:server',
      'wiredep',
      'concurrent:server',
      'autoprefixer:server',
      'connect:livereload',
      'watch'
    ]);
  });

  // KARMA TEST TASK
  grunt.registerTask('test', [
    'clean:server',
    //'wiredep',
    'concurrent:test',
    'autoprefixer',
    'connect:test',
    'karma:unit'
  ]);

  // BUILD TASK
  grunt.registerTask('build', [
    'clean:dist',
    'jshint:all',
    'wiredep',
    'useminPrepare',
    'concurrent:dist',
    'autoprefixer',
    'concat',
    'ngAnnotate',
    'copy:dist',
    'csslint',
    'cssmin',
    'uglify',
    'filerev',
    'usemin',
    'htmlmin'
  ]);

  // DOCUMENTATION TASK
  grunt.registerTask('docs', ['ngdocs']);

  // DEFAULT TASK
  grunt.registerTask('default', [ 'test', 'build']);
};

```

## <a name='plugins'>Plugins</a>

Today there are hundreds official and unofficial of Grunt plugins for all kinds of tasks. Some of the most important plugins are:

<b>Most Used Plugins</b>

 - <b>contrib-copy:</b> Copy files and folders

 - <b>contrib-concat:</b> Concatenate files.

 - <b>contrib-clean:</b> Clean files and folders from the project.

 - <b>contrib-connect:</b> Start a connect web server.

 - <b>contrib-livereload:</b> Reload assets live in the browser

 - <b>contrib-watch:</b> Watch for file changes.

 - <b>contrib-uglify:</b> Minify files with UglifyJS.

 - <b>contrib-compress:</b> Compress files and folders.

 - <b>contrib-jade:</b> Compile Jade templates.

 - <b>ng-annotate:</b> Add, remove and rebuild AngularJS dependency injection annotations.

 - <b>wiredep:</b> Inject your Bower dependencies right into your HTML from Grunt.
<br/>

<b>Plugins for Validations</b>

 - <b>contrib-jshint:</b> Validate files with JSHint.

 - <b>contrib-csslint:</b> Lint CSS files.
 <br/>

<b>Plugins for Minify</b>

 - <b>contrib-cssmin:</b> Minify CSS.

 - <b>contrib-imagemin:</b> Minify images.

 - <b>contrib-htmlmin:</b> Minify HTML.
 <br/>

<b>Plugins for CSS Compilation</b>

 - <b>contrib-sass:</b> Compile Sass to CSS.

 - <b>contrib-less:</b> Compile LESS files to CSS.

 - <b>contrib-compass:</b> Compile Sass to CSS using Compass.

 - <b>contrib-stylus:</b> Compile Stylus files to CSS.
<br/>
<b>Plugins for JS Compilation</b>

 - <b>contrib-coffee:</b> Compile CoffeeScript files to JavaScript.
<br/>
<b>Plugins for Testing</b>

 - <b>contrib-jasmine:</b> Run jasmine specs headlessly through PhantomJS.

 - <b>contrib-nodeunit:</b> Run Nodeunit unit tests.

 - <b>contrib-qunit:</b> Run QUnit unit tests in a headless PhantomJS instance..

 - <b>karma: </b> Grunt plugin for karma test runner.

 - <b>protractor-runner:</b> A Grunt plugin for running protractor E2E test runner.

 - <b>selenium-webdriver:</b> Starts and stops selenium in webdriver or hub mode for use with 3rd party CI platforms where phantomjs / chromedriver can have issue with selenium.
<br/>
<b>Plugins for Documentation</b>

 - <b>ngdocs:</b> grunt plugin for angularjs documentation.

 -  <b>docular:</b> Extensible Documentation Generation Based on AngularJS's Documentation Generation</b>.
<br/>
<b>Plugins for ES6</b>

 - <b>babel:</b> grunt plugin for transforming ES6+ JavaScript to ES5 JavaScript.

 -  <b>traceur:</b> plugin to compile ES6 JavaScript to ES3.

 - <b>es6-module-transpiler:</b> plugin for transforming ES6 export syntax to the structure used by AMD, CommonJS among others.

 -  <b>regenerator:</b> grunt plugin to transpile ES6 generator functions to ES5 ones.

 - <b>defs:</b> ES6 const and let statements to ES3.

 - <b>ts:</b> grunt plugin to compile TypeScript to JavaScript.
<br/>

## <a name='links'>Links</a>

 -  Home... http://gruntjs.com
 -  The complete list of plugins is in... http://gruntjs.com/plugins
 -  Getting Started... http://gruntjs.com/getting-started

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
