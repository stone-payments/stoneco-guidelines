![alt text](../../../../static/horizontal-beeva-logo.png "BEEVA")


# Front-end Development Best Practices

<img src="../static/bower-logo.png" height="80px"/>

##  Bower 
* [Introduction](#introduction)
* [Integration Tools](#integration-tools)
	* [Grunt](#grunt)
	* [Gulp](#gulp)
	* [Java](#java)
 
----
## <a name='introduction'>Introduction</a>

Bower is an open source dependencies manager optimized for front applications created by Twitter.

Today these front are built with lots of graphics libraries, Javascript frameworks and other components that make it difficult to control versions of these packages and the compatibility between them.

Bower track of these packages in a manifest file, bower.json:

```json
{
  "name": "app-name",
  "version": "0.0.1",
  "dependencies": {
		"angular": "1.3.13",
		"angular-ui-router": "0.2.13",
		"angular-resource": "1.3.11",
	    ....
  },
  "devDependencies": {
	    "angular-mocks": "~1.2.0",
	    "angular-scenario": "~1.2.18"
	    ...
  },
  "resolutions": {
	    "angular": "1.3.13",
	    "angular-cookies": "1.3.13",
	    ...
  },
  "private": true
}
```
Bower is responsible for us:

 - Download from GitHub and install all dependecies included in bower.json.
 - Check possible collisions or incompatibilities between the dependecies.
 

## <a name='integration-tools'>Integration Tools</a>

Bower is used together with other tools to integrate with all sorts of setups and workflows.

### <a name='grunt'>Grunt</a>

 - <b>grunt-bower-concat</b>
	 Grunt task for automatically concat all installed Bower components.

 - <b>grunt-wiredep</b>
	 Inject your Bower components right into your HTML using Grunt.

 - <b>grunt-bower-requirejs</b>
	Automagically wire-up installed Bower components into your RequireJS config. Also available as a standalone CLI tool.

 - <b>grunt-bower-task </b>
Grunt plugin to automate Bower commands; allow the configuration of the files needed allowing to filter out the minimal in the project.

 - <b>grunt-preen</b>
A Grunt plugin to preen unwanted files and folders from packages installed via Bower.


### <a name='gulp'>Gulp</a>

 - <b>gulp-google-cdn </b>
	 Replaces script references with Google CDN ones, based on bower.json
	
 - <b>main-bower-files </b>
Iterates through dependencies and returns an array of files defined in the main property of the packages bower.json.
	 
 - <b>preen</b>
A Node.js module to preen unwanted files and folders from packages installed via Bower. Preen can also be used via the CLI.
	 
 - <b>gulp-bower-normalize </b>
A gulp plugin to copy files into a normalized file structure, arranged by package name and asset type.

### <a name='java'>Java</a>

 - <b>Dandelion</b>
Dandelion provides an integration with Bower. All Bower components are scanned and automatically converted into vendor bundles.

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies

