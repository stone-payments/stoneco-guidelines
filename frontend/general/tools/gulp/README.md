![alt text](../../../../static/horizontal-beeva-logo.png "BEEVA")
# Front-end Development Best Practices

<img src="../static/gulp.png" height="80px"/>

## Gulp

*  [Introduction](#introduction)
* [Gulpfile](#gulpfile)
* [Pluggins](#pluggins)
* [Links](#links)
 
----
## <a name='introduction'>Introduction</a>

Gulp is a open source  build system built on Node.js and used in the world of web development to automate tasks for: 

   - <b>Improving Productivity</b>, speed up the development workflow, making it faster and more efficient.
   
   - <b>Enhancing the Performance</b>, optimizing each byte. 
 
   - <b>Increasing Quality</b>, through testing and documentation.
   

The Gulp ecosystem is huge and it's growing every day with hundreds of plugins to implemented task with a minimum of effort for:

- Validation of the code (JS, CSS).

- Compression and Obfuscation of the code

- Execution of automated test.

- Management and installation of dependencies.

- Generation of project documentation

- And much more..


The main features of Gulp are:

- Streaming and piping for speed.  Gulp uses node.js streams, making it faster to build as it doesn’t need to write temporary files/folders to disk, 
  
- Code over configuration.  Gulp’s code-over-configuration makes it not only easy to write tasks for, but also much easier to read and maintain.


## <a name='gulpfile'>Gulpfile</a>

The  "gulpfile.js" file informs the task runner which plug-ins to load and defines the available tasks to perform as well as setting the order of any chained tasks. 

```javascript
// gulpfile.js

// Load plugins
var gulp = require('gulp'),
    sass = require('gulp-ruby-sass'),
    autoprefixer = require('gulp-autoprefixer'),
    minifycss = require('gulp-minify-css'),
    jshint = require('gulp-jshint'),
    uglify = require('gulp-uglify'),
    imagemin = require('gulp-imagemin'),
    rename = require('gulp-rename'),
    clean = require('gulp-clean'),
    concat = require('gulp-concat'),
    notify = require('gulp-notify'),
    cache = require('gulp-cache'),
    livereload = require('gulp-livereload'),
    lr = require('tiny-lr'),
    server = lr();

// Styles
gulp.task('styles', function() {
  return gulp.src('src/styles/main.scss')
    .pipe(sass({ style: 'expanded', }))
    .pipe(autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
    .pipe(gulp.dest('dist/styles'))
    .pipe(rename({ suffix: '.min' }))
    .pipe(minifycss())
    .pipe(livereload(server))
    .pipe(gulp.dest('dist/styles'))
    .pipe(notify({ message: 'Styles task complete' }));
});

// Scripts
gulp.task('scripts', function() {
  return gulp.src('src/scripts/**/*.js')
    .pipe(jshint('.jshintrc'))
    .pipe(jshint.reporter('default'))
    .pipe(concat('main.js'))
    .pipe(gulp.dest('dist/scripts'))
    .pipe(rename({ suffix: '.min' }))
    .pipe(uglify())
    .pipe(livereload(server))
    .pipe(gulp.dest('dist/scripts'))
    .pipe(notify({ message: 'Scripts task complete' }));
});

// Images
gulp.task('images', function() {
  return gulp.src('src/images/**/*')
    .pipe(cache(imagemin({ optimizationLevel: 3, progressive: true, interlaced: true })))
    .pipe(livereload(server))
    .pipe(gulp.dest('dist/images'))
    .pipe(notify({ message: 'Images task complete' }));
});

// Clean
gulp.task('clean', function() {
  return gulp.src(['dist/styles', 'dist/scripts', 'dist/images'], {read: false})
    .pipe(clean());
});

// Default task
gulp.task('default', ['clean'], function() {
    gulp.run('styles', 'scripts', 'images');
});

// Watch
gulp.task('watch', function() {

  // Listen on port 35729
  server.listen(35729, function (err) {
    if (err) {
      return console.log(err)
    };

    // Watch .scss files
    gulp.watch('src/styles/**/*.scss', function(event) {
      console.log('File ' + event.path + ' was ' + event.type + ', running tasks...');
      gulp.run('styles');
    });

    // Watch .js files
    gulp.watch('src/scripts/**/*.js', function(event) {
      console.log('File ' + event.path + ' was ' + event.type + ', running tasks...');
      gulp.run('scripts');
    });

    // Watch image files
    gulp.watch('src/images/**/*', function(event) {
      console.log('File ' + event.path + ' was ' + event.type + ', running tasks...');
      gulp.run('images');
    });

  });

});

```

The complete documentation of gulpfile.js can be found [here](https://github.com/gulpjs/gulp/blob/master/docs/API.md).



## <a name='pluggins'>Pluggins</a>

Today there are hundreds official and unofficial of Gulp pluggins for all kinds of tasks. Some of the most important pluggins are:

<b>Pluggins Most Used</b>
   
 - <b>gulp-concat: </b> Concatenate files.

 - <b>gulp-livereload: </b>Reload assets live in the browser

 - <b>gulp-uglify: </b> Minify files with UglifyJS.

 - <b>gulp-jade: </b> Compile Jade templates.
 
 -  <b>...</b>
<br/>

<b>Pluggins for Validations</b>
     
 - <b>gulp-jshint:</b> Validate files with JSHint.

 - <b>gulp-csslint</b> Lint CSS files.
 
 -  <b>gulp-scss-lint</b> Lint SCSS files.

 -  <b>...</b>
 <br/>

<b>Pluggins for Minify</b>
 
 - <b>gulp-minify-css: </b>Minify CSS.
 
 - <b>gulp-imagemin: </b>Minify images.
 
 - <b>gulp-minify-html: </b>Minify HTML.

 -  <b>...</b>
 <br/>

<b>Pluggins for CSS Compilation</b> 

 - <b>gulp-sass: </b> Compile Sass to CSS.
 
 - <b>gulp-less: </b>Compile LESS files to CSS.
 
 - <b>gulp-simple-compass: </b>Compile Sass to CSS using Compass.

 - <b>gulp-stylus: </b> Compile Stylus files to CSS.

 -  <b>...</b>

 
<br/>
<b>Pluggins for JS Compilation</b>
  
 - <b>gulp-coffee: </b> Compile CoffeeScript files to JavaScript.

 -  <b>...</b>


<br/>
<b>Pluggins for Testting</b>

 - <b>gulp-jasmine-phantom: </b> Run jasmine specs headlessly through PhantomJS.
 
 - <b>gulp-nodeunit-runner: </b> Run Nodeunit unit tests.
 
 - <b>gulp-qunit : </b> Run QUnit unit tests in a headless PhantomJS instance.
 
 - <b>gulp-mocha-selenium: </b> Run Selenium tests with wd and Mocha.
 
 - <b>gulp-karma-runner: </b> Gulp plugin for karma test runner.

 -  <b>...</b>

<br/>
<b>Pluggins for Documentation</b>

 - <b>gulp-ngdocs: </b> gulp plugin for angularjs documentation.

 -  <b>...</b>

<br/>


The complete list of Gulp pluggins can be found [here](http://gulpjs.com/plugins/).


## <a name='links'>Links</a>

 -  Home... http://gulpjs.com/
 -  The complete list of pluggins is in... http://gulpjs.com/plugins/
 -  Getting Started... https://github.com/gulpjs/gulp/blob/master/docs/getting-started.md
___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies

