![alt text](static/nodejs.png "Node.js")

# Node.js Style Guide & Best Pratices
At this point we're going to talk about Node.js, we're useing Node.js to develop lightweight and efficient network apps using an event-driven, non-blocking I/O on the top of Chrome's V8 JavaScript engine.

## Index

* [Introduction](#introduction)
  * [Challenges](#challenges)
  * [Purpose](#purpose)

* [Best Practices](#best-practices)

* [Frameworks](#frameworks)
  * [Express](#express)
  * [Hapi](#hapi)
  * [Restify](#restify)
  * [Comparative](#comparative)

* [DevOps](#devOps)
  * [Logging](#logging)
  * [Security](#security)
  * [Clustering](#clustering)
  * [Staging](#staging)

* [Testing](#testing)
  * [TDD with Sinon and Proxyquire](#tdd-with-sinon-and-proxyquire)
  * [BDD with Cucumber](#bdd-with-cucumber)
  * [Integration Testing with Mocha](#integration-testing-with-mocha)

## Introduction

Node.js like Python and other languages can be used to develop desktop/console tools or to develop highly scalable network applications.
**This guide will focus on using Node.js to develop network applications**.
Since developments are made in Javacript Node.js, we recommend reading the language specific section in this [guide](../../frontend/javascript/README.md).

### Challenges

The two main challenges to be resolved by a developer to program begins with Node.js are:

* Asynchrony: Although there are several ways to manage the async flow as libraries (i.e. [async](https://www.npmjs.com/package/async), [co](https://www.npmjs.com/package/co)), promises ([q](https://www.npmjs.com/package/q), [mpromise](https://www.npmjs.com/package/mpromise), ...) or conventions ([CPS](https://en.wikipedia.org/wiki/Continuation-passing_style)), it should handle them properly and avoid excessive nesting callbacks ([Pyramid of Doom](http://tritarget.org/blog/2012/11/28/the-pyramid-of-doom-a-javascript-style-trap/)) and the excessive reliance on a particular library. A major problem arises when we are trying to follow the execution flow of our code and the error handling. Initially it's difficult to adopt this way of work and can be perceived as a loss of control over it. However, it is a powerful tool that allows us to make better use of resources.

* Duality between Application and Server: When we are working with Node.js, we must understand that it's slightly different from those other familiar languages ​​like Java and PHP,  which for develop web applications usually have the support of Apache or Tomcat or other application servers. Although this is usually shielded by frameworks, we should not forget this part of work, which requires us to delve deeper into DevOps issues as the application log, error handling or profiling application issues ports and performance parameters.

### Purpose

The purpose of this guide is to share our knowledge in the development of network apps in Node.js. We choosed these areas because they are oriented to help in the built of apps scalable in a fast but reliable way.

These areas are:
* Use of Frameworks: They help us in the development of new apps through its tools and a design and struct proposal for our apps.

* DevOps: We've grouped here all the techniques oriented to easy deploy, mantain and monitorize the health of our Node.js apps

* Automated Testing with TDD & BDD: We offer a serie of advices in order to implement this testing philosophy in our developments.

## Best Practices

This brief section it's intended to give some easy and quick tips to rememeber during any Node.js development.

* Modularize developments as far as possible.
* Use [Javascript patterns](../../frontend/general/javascript/patterns) as possible.
* Strict mode, please. With this flag you can opt in to use a restricted variant of JavaScript. It eliminates some silent errors and will throw them all the time.
* Use tools for Static code analysis. Use either JSLint, JSHint or ESLint. Static code analysis can catch a lot of potential problems with your code early on.
* No eval, or friends. Eval is not the only one you should avoid, in the background each one of the following expressions use eval: setInterval(String, 2), setTimeout(String, 2) and new Function(String). But why should you avoid eval? It can open up your code for injections attacks and is slow (as it will run the interpreter/compiler).
* Use a framework that helps us to structure the project.
* Don't use deprecated versions of Express (for example 2.x and 3.x are no longer maintained). Security and performance issues in these versions won’t be fixed.
* Complete your developments with automated testing.
* Always use a CVS like GIT, SVN, and follow its best practices like GitFlow, Trunk, Branching,...

* Avoid using console.log() in your code.
* Using configuration files against variables for ports, ips of other machines, ...
* Implement differente logs for application and for Node.js.
* Use ES6 new features i.e. arrow function, to make the Scope safety and your code more concise and clarity. Check the examples in the Javascript section of this guide: [Arrow Functions](https://github.com/beeva/beeva-best-practices/tree/master/frontend/general/javascript/es6#arrow_functions).
* Use domains facing try-catch blocks for error handling.
* In public servers add a safety middleware as [helmet](https://www.npmjs.com/package/helmet) or [lusca](https://www.npmjs.com/package/lusca).

* Include and maintain [package.json](https://docs.npmjs.com/files/package.json) file with the version number (using *$npm init*).
* Mark the package as private: true to its release.
* For production applications control the version number of our units (according to criticity of the project set to minor or patch).
* Define and test entry points in the distribution file [package.json](https://docs.npmjs.com/files/package.json#scripts).
* Use *DevDependencies* and *Dependencies* sections of [package.json](https://docs.npmjs.com/files/package.json#dependencies).
* Use [retire](https://www.npmjs.com/package/retire) to verify outdated or unsafe dependencies.
* Do not install units in our global development environment.
* Before deployments delete the *node_modules* folder and check file dependencies [package.json](https://docs.npmjs.com/files/package.json).

* Use tools like [PM2](https://www.npmjs.com/package/pm2) or [forever](https://www.npmjs.com/package/forever) as a tool for application restart.

* [Use LTS versions of Node.js for Production](https://nodejs.org/en/blog/community/node-v5/), since 4.2.* all even versions are *LTS* and odd like 5.3.* are *Stable with latest features*.
* Install node and npm interperters localy through [NVN](https://github.com/creationix/nvm) without using sudo.
* Clear the local cache after each update NPM version: *$npm cache clean*

Another interesting point thinking on how web applications should be written it's follow [The Twelve-Factor application manifesto](http://12factor.net/).

* One codebase tracked in revision control, many deploys.
* Explicitly declare and isolate dependencies.
* Store config in the environment.
* Treat backing services as attached resources.
* Strictly separate build and run stages.
* Execute the app as one or more stateless processes.
* Export services via port binding.
* Scale out via the process model.
* Maximize robustness with fast startup and graceful shutdown.
* Keep development, staging, and production as similar as possible.
* Treat logs as event streams.
* Run admin/management tasks as one-off processes.

## Frameworks

In this section we're going to talk about three main frameworks that we are using on productive projects. Some of them are in microservices environments, RESTful APIs and web servers.
Finally we offer a comparative in order to help to choose a tool for future projects with Node.js.

The node frameworks are layers on the top of http and use Middleware plugins to interact with the requests and responses.
Middlewares are a powerful yet simple concept: the output of one unit/function is the input for the next.

At this point we're going to describe three popular node frameworks but there [are many others out there](https://www.devsaran.com/blog/10-best-nodejs-frameworks-developers).

### Express

![alt text](static/express.png "Express")

Express is a minimal and flexible Node.js web application framework that provides a robust set of features for web and mobile applications. With a myriad of HTTP utility methods and middleware at your disposal, creating a robust API is quick and easy.

Express provides a thin layer of fundamental web application features.

#### Application structure

One of the strengths of Express is the community and large number of application examples and proposals it has published on its [repository](https://github.com/strongloop/express/tree/master/examples).

Anyway one of the profits its the flexibility to divide the logic of our app.

##### Main file: src/index.js

```javascript
import express  from 'express'
import api_v1 from './controllers/api_v1'
import api_v2 from './controllers/api_v2'

export const app = express();

app.use('/api/v1', api_v1);
app.use('/api/v2', api_v2);

app.get('/', (req, res) => {
  res.send('Hello form root route.');
});

/* istanbul ignore next */
if (!module.parent) {
  app.listen(3000);
  console.log('Express started on port 3000');

```

##### A controller foreach version related with the endpoint i.e. src/controller/api_v1.js & src/controller/api_v2.js  

```javascript
import express from '../../..'

const apiv1 = express.Router();

apiv1.get('/', (req, res) => {
  res.send('Hello from APIv1 root route.');
});

apiv1.get('/users', (req, res) => {
  res.send('List of APIv1 users.');
});

export = apiv1;
```

```javascript
...
// Another different implementation
apiv2.get('/', (req, res) => {
  res.send('Hello from APIv2 root route.');
});
...

```

#### Security Best Practices

All these techniques are summarized and extracted from the creators of Express, check references for more detail.

* Don’t use deprecated or vulnerable versions of Express.
* Use TLS. If your app deals with or transmits sensitive data, use Transport Layer Security (TLS) to secure the connection and the data.
* Use security middleware as [helmet](#helmet) or [lusca](#lusca) and at a minimum, disable X-Powered-By header.
* Use cookies securely. To ensure cookies don’t open your app to exploits, don’t use the default session cookie name and set cookie security options appropriately.
* Ensure your dependencies are secure with [nsp](https://www.npmjs.com/package/nsp) or [requireSafe](https://www.npmjs.com/package/requiresafe).
* Implement rate-limiting to prevent brute-force attacks against authentication. You can use middleware such as express-limiter, but doing so will require you to modify your code somewhat.
* Use csurf middleware to protect against cross-site request forgery (CSRF).
* Always filter and sanitize user input to protect against cross-site scripting (XSS) and command injection attacks.
* Defend against SQL injection attacks by using parameterized queries or prepared statements.
* Use the open-source sqlmap tool to detect SQL injection vulnerabilities in your app.
* Use the nmap and sslyze tools to test the configuration of your SSL ciphers, keys, and renegotiation as well as the validity of your certificate.
* Use safe-regex to ensure your regular expressions are not susceptible to regular expression denial of service attacks.
* Revise the Node.js security [checklist](https://blog.risingstack.com/node-js-security-checklist).

#### Performance Best Practices

* Use gzip compression
* Don’t use synchronous functions
* Use middleware to serve static files
* Do logging correctly
* Handle exceptions properly:

Try-catch is a JavaScript language construct that you can use to catch exceptions in synchronous code. Use try-catch, for example, to handle JSON parsing errors as shown below.

```javascript
app.get('/search', (req, res) => {
  // Simulating async operation
  setImmediate(() => {
    const jsonStr = req.query.params;
    try {
      res.send(JSON.parse(jsonStr););
    } catch (e) {
      res.status(400).send('Invalid JSON string');
    }
  })
});
```

* Use promises

Promises will handle any exceptions (both explicit and implicit) in asynchronous code blocks that use then(). Just add .catch(next) to the end of promise chains. For example:

```javascript
 // Now all errors asynchronous and synchronous get propagated to the error middleware.
app.get('/', (req, res, next) => {
  // do some sync stuff
  queryDb()
    .then((data) => {
      // handle data
      return makeCsv(data)
    })
    .then((csv) => {
      // handle csv
    })
    .catch(next)
})

app.use((err, req, res, next) => {
  // handle error
})
```

### Hapi

![alt text](static/hapi.png "Hapi")

Hapi is a rich framework for building applications and services that allows developers to focus on writing reusable application logic instead of spending time building infrastructure.

Hapi's extensive plugin system allows us to quickly build, extend, and compose brand-specific features on top of its rock-solid architecture.

Here is a basic example in **Hapi** to launch an application and to open *http://localhost:8000/hello* in your browser:

```javascript
'use strict';

import Hapi from 'hapi ';

// Create a server with a host and port
const server = new Hapi.Server();
server.connection({
  host: 'localhost',
  port: 8000
});

// Add the route
server.route({
  method: 'GET',
  path:'/hello',
  handler: (request, reply) => reply('hello world');
});

// Start the server
server.start(() => {
  console.log('Server running at:', server.info.uri);
});
```

As we mentioned sooner, the Hapi's great power are the plugins. Hapi has an extensive and powerful plugin system that allows you to very easily break your application up into isolated pieces of business logic, and reusable utilities.'use strict';

There are a lot of plugins in the community but we can write our own plugin so easy. A very simple plugin looks like:

```javascript
exports.register = (server, options, next) => {
  // Code
  // ...

  next();
};

exports.register.attributes = {
  name: 'my-plugin',
  version: '1.0.0'
};
```

The **options** parameter is the custom configuration when you use the plugin. The **next** is a method to be called when the plugin has completed the steps to be registred. And the **server** object is a reference to the *server* your plugin is being loaded in.

Additionally, the **attributes** is an object to provide some additional information about the plugin, as name or version.

If we want to use a plugin, first at all we need register it in the server. For example:

```javascript
// load one plugin
server.register(
  {
    register: require('myplugin'),
    options: {
      key: 'value'
    },
  },
  (err) => {
    if (err) {
    console.error('Failed to load plugin:', err);
    }
  }
);

// load multiple plugins
server.register(
  [
    {
      register: require('myplugin'),
      options: {}
    },
    {
      register: require('yourplugin')
    }
  ],
  (err) => {
    if (err) {
      console.error('Failed to load a plugin:', err);
    }
  }
);
```

#### Application structure

To create a new API server with **Hapi** we can use the following structure:

```
+ server
| |
| + api
| | |
| | + my-endpoints
| |   |- my-endpoints.contoller.js
| |   |- index.js
| |
| + plugins
| | |- my-plugin.js
| |
| + config
| | |
| | + environment
| |   |- index.js
| |   |- development.js
| |   |- production.js
| |   |- other-environment.js
| |
| |- app.js
| |- routes.js
|
|- package.json
```

The **app.js** file is the main file of the application. We start the server here and configure all the plugins.

```javascript
import Hapi from 'hapi';
import config from './config/environment';

// Create a server with a host and port
const server = new Hapi.Server();
server.connection({ host: config.ip,  port: config.port , routes: { cors: true }});

// Register the server and start the application
server.register([
    {
      register: require('./routes') // config routes in external file
    },
    {
      register: require('hapi-mongodb'),
      options: {url: config.mongo.url}
    }
  ],
  {
    routes: {
      prefix: config.routes.prefix // prefix for all the api routes
    }
  },
  (err) => {
    if (err) throw err;

    server.start(() => {
      console.log('Server running at', server.info.uri);
    })
  }
);
```

In the **routes.js** file is configured all routes of the services. We define the routes as a plugin:

```javascript
/**
 * Main application routes
 */

'use strict';

exports.register = (server, options, next) => {
  import myEndPoints from './api/my-endpoints';
  myEndPoints(server);

  next();
};
exports.register.attributes = {
  name: 'my-routes',
  version: '0.1.0'
};
```

In **config/environment** we put the external configuration of the application by enviroments. The **plugins** folder contains all the custom plugins that we need: routes, scheduler, utils... And finally, in **api** folder there is all the endpoints/services of the application. Each set of endpoints is a individual folder with the *index.js* and the *controller.js*.

**index.js**
```javascript
'use strict';

import Assets from './assets.controller';

module.exports = (server) => {
  server.route({
    method: 'GET',
    path: '/assets',
    handler: (request, reply, next) => {
      Assets.getAssetsByAttributes(request, reply, next);
    }
  });

  server.route({
    method: 'POST',
    path: '/assets',
    handler: (request, reply, next) => {
      Assets.create(request, reply, next);
    }
  });

  server.route({
    method: 'PUT',
    path: '/assets/{key}',
    handler: (request, reply, next) => {
      Assets.modify(request, reply, next);
    }
  });

  server.route({
    method: 'DELETE',
    path: '/assets/{key}',
    handler: (request, reply, next) => {
      Assets.remove(request, reply, next);
    }
  });
}
```

**controller.js**
```javascript
'use strict';

export const getAssetsByAttributes = (req, res, next) => res([]).code(200);

export const create = (req, res, next) => res({}).code(201);

export const modify = (req, res, next) => res({}).code(200);

export const remove = (req, res, next) => res({}).code(200);
```

#### Plugins

There is a large set of plugins for Hapi, with which we can perform simple and configurable way a number of standard tasks. We will list the best known and used by the community and its primary mission:

**Authentication**

- Third-party login: [bell](https://github.com/hapijs/bell)
- JSON Web Token (JWT): [hapi-auth-jwt](https://github.com/ryanfitz/hapi-auth-jwt)
- Custom authentication: [hapi-auth-hawk](https://github.com/hapijs/hapi-auth-hawk)

**API documentation**

- Swagger: [hapi-swagger](https://github.com/glennjones/hapi-swagger)

**Logging**

- Multiple outputs: [good](https://github.com/hapijs/good)
- Health server: [hapi-alive](https://github.com/idosh/hapi-alive)
- Process dump and cleaning up: [poop](https://github.com/hapijs/poop)

**Templating**

- JSON view engine: [hapi-json-view](https://github.com/gergoerdosi/nesive-hapi-json-view)

**Utilities**

- Socket: [hapi-io](https://github.com/sibartlett/hapi-io)
- Routes loader: [hapi-router](https://github.com/bsiddiqui/hapi-router)

**Validation**

- Request parameters validation: [ratify](https://github.com/mac-/ratify)

**Other modules (no plugins)**

- HTTP-friendly errors: [boom](https://github.com/hapijs/boom)
- General purpose utilities: [hoek](https://github.com/hapijs/hoek)
- Schema description and validator: [joi](https://github.com/hapijs/joi)
- Testing utility with code coverage: [lab](https://github.com/hapijs/lab)
- Multi-strategy object caching: [catbox](https://github.com/hapijs/catbox)

#### API

Hapi has a fairly extensive [API](http://hapijs.com/api), that we can refer to develop new functionality on the applications.

The API is divided in four blocks:

* Server
* Request
* Response
* Plugins

### Restify

![alt text](static/restify.png "Restify")

Restify is a light framework similar to Express and very easy for building REST APIs. This is the easy way to create a REST API application:

``` javascript
import restify from 'restify';
const server = restify.createServer();

server.get('/hello/:name', (req, res, next) => {
	res.send('hello ' + req.params.name);
});

server.listen(3000, () => {
	console.log('Listening on port 3000');
});
```

#### Application Structure

This is one of desired structure for restify server application:

```
my-application/
	config.json # logging, repository and server properties file
	package.json # npm metadata and dependency info for application
	server.js # starting and stopping server functions file
	static-server.js # functions for listen connections to server
	bin/
		www # server starting function called from npm start
	node_modules/ # my-application dependencies
		restify/ # npm imported dependency for restify server
```
##### config.json

```javascript
{
	"name": "my-application", //server application context
	"urlResponse": "http://localhost", //server hostname
	"port": 3000, //server port
	"version": "0.0.1", //application module version
	"apiversion": "v1", //current api version
	"store": {
		//respository properties
	},
	"log": {
		//logging properties
	}
}
```

##### package.json

```javascript
{
  "name": "my-application", //application name
  "version": "0.0.1", //application module version
  "description": "my-application description.",
  "authors": [
	//application development team
  ],
  "keywords": [
	"npm"
  ],
  "license": "ISC",
  "dependencies": {
	"restify": "latest"
	//other application dependencies
  },
  "devDependencies": {
 	//development addtional dependencies
  },
  "engines": {
	"node": ">= latest" //node version
  },
  "scripts": {
	"test": "./node_modules/.bin/mocha --reporter spec --ui tdd ", //
	"start": "node bin/www" //
  },
  "repository": {
    //git repository connection properties
  }
}
```

##### server.js

1. Import 'restify', 'q' dependencies and 'static-server.js', '/lib/log/logger.js' user files.
2. Start function.
3. Restify's createServer function invocation.
4. Launch server database repository.
5. Set restify server functions like CORS filters, Oauth settings, parsers, etc...
6. Launch server listener for catching requests.
7. Stop function.

```javascript
import restify from 'restify'; //1
import Q from 'q';
import static_server from './static-server';
import extend from 'extend';
import logger from './lib/log/logger';

module.exports = (() => {
	let listener = null, store = null;

	process.on("error", () => {
		logger.error(arguments);
	});

	return {
		start: (config) => {//2
			const deferred = Q.defer();
			logger.init(config.log);
			const server = restify.createServer({//3
				name: config.name,
				version: require('./package.json').version
			});
			server.on('uncaughtException', (req, res, route, err) => {
				logger.error(err.message, {
					event: 'uncaughtException'
				});
				res.send(500, {
					handler: err
				});
			});
			store = require('./lib/store')(config);
			store.init().then((storage) => {//4
				config.storage = storage;
				logger.info("Storage initialized");
				server.use(restify.CORS());//5
				server.use(restify.acceptParser(server.acceptable));
				server.use(restify.queryParser());
				server.use(restify.fullResponse());
				server.use(restify.authorizationParser());
				server.use((req, res, next) => {
					req.rawBody = '';
					req.setEncoding('utf8');
					req.on('data', (chunk) => {
						req.rawBody += chunk;
						req.body = JSON.parse(req.rawBody);
					});
					req.on('end', () => {
						next();
					});
				});
				server.use((req, res, next) => {
					logger.info(req.method + ' - ' + req.url, req);
					next();
				});
				require('./lib/api')(server, config);
				listener = server.listen(config.port || 3000, () => {//6
					let static_config = extend(true, {}, config);
					static_config.port = (static_config.port + 5) || 3005;
					static_server.start(static_config).then((data) => {
						logger.info("Server " + server.name + " started, listening on " + config.port);
						deferred.resolve({
							name: server.name,
							url: server.url
						});
					});
				});
			}).fail((error) => {
				logger.error('Failure to start storage');
				deferred.reject(error);
			});
			return deferred.promise;
		},
		stop: () => {//7
			if (listener) {
				logger.info("Stopping service", {
					file: __filename
				});
				listener.close();
				static_server.stop();
				store.close();
				listener = null;
				store = null;
			}
		}
	};
})();
```

##### static-server.js

This file it's recommended for creating listener to server.

```javascript
import restify from 'restify';
import Q from 'q';

module.exports = (() => {
	var listener = null;

	return {
		start: (config) => {
			const deferred = Q.defer();
			config = config || {};
			config.port = config.port || 3005;
			const server = restify.createServer();
			listener = server.listen(config.port, () => {
				deferred.resolve(config);
			});
			return deferred.promise;
		},
		stop: () => {
			if (listener) {
				listener.close();
			}
		}
	};
})();
```

##### bin/www

This file it's recommended for starting application server.

```javascript
  import server from '../server');
	import config from '../config.json');
	import logger from '../lib/log/logger');

server.start(config).then((server) => {
		logger.info('%s listening at %s', server.name, server.url);
	}).fail((err) => {
		console.error(err);
		process.exit(1);
	}
);
```

### Comparative

#### When use Restify instead of Express

1. Exists to let you build "strict" API services that are maintanable and observable.

2. Comes with automatic DTrace support for all your handlers, if you're running on a platform that supports DTrace.

3. Is lighter than Express

#### When do not use Restify instead of Express

1. Express use case is targeted at browser applications and contains a lot of functionality, such as templating and rendering, to support that.

2. Restify does not support that. Express is more powerful on this.

3. More indicated when you have a large number of queries.

#### Conclusion Restify vs Express

Restify: If I need a framework that gave me absolute control over interactions with HTTP and full observability into the latency and characteristics of my applications.

Express: If you don't need absolute control over these interactions, or don't care about those aspect(s), and I need to manage a large number of queries.

You can see a perfomance comparison between Hapi, Express and Restify in the following [link](https://raygun.io/blog/2015/03/node-performance-hapi-express-js-restify/)

## DevOps

At this section we're going to cover the areas related with staging, logging security and clustering, all these issues are related with DevOps and due to the Node.js dual nature are important for developers and sysadmin.

### Logging

An important part for developers is the ability to do logs, to have control over the code was developed. The default form to do this in Nodejs is to use *console.log*. But isn't a good practices.
Don't write *console.log* all over the code to debug it and then commenting them out when they are no longer needed. For this purpose it's better to use a library to logging.

In some projects we're using a dual system of logging with:
#### [Morgan](https://www.npmjs.com/package/morgan) for the apache style logs.

Morgan is a HTTP request logger middleware for node.js.

Output example:
´´´bash
127.0.0.1 - frank [10/Jan/2016:13:55:36 -0700] "GET /favicon.ico HTTP/1.0" 200 2326
127.0.0.1 - frank [10/Jan/2016:13:55:36 -0700] "GET /index.html HTTP/1.0" 200 2326
´´´  
example of use:
```javascript
import morgan from 'morgan';

morgan('combined', { skip: (req, res) => { return res.statusCode < 400 } });
```

#### [Bunyan](https://www.npmjs.com/package/bunyan) for the business logic logs.
Bunyan is a simple and fast JSON logging library for node.js services.
Manifesto: Server logs should be structured. JSON's a good format. Let's do that. A log record is one line of *JSON.stringify*'d output.

Output example:
´´´bash
{"name":"myserver","hostname":"banana.local","pid":123,"req":{"method":"GET","url":"/path?q=1#anchor","headers":{"x-hi":"Mom","connection":"close"}},"level":3,"msg":"start request","time":"2012-02-03T19:02:46.178Z","v":0}

´´´
Note: Be careful with the content write to this kind of logs. the message it's fully customizable but export all the http request object or the full error stack could damage the performance.

example of use:

```javascript
import bunyan from 'bunyan';
const log = bunyan.createLogger({name: "myapp"});
log.info("hi");
```
*Features*

- Elegant log method API
- Extensible streams system for controlling where log records go (to a stream, to a file, log file rotation, etc.)
- Bunyan CLI for pretty-printing and filtering of Bunyan logs
- Simple include of log call source location (file, line, function) with src: true
- Lightweight specialization of Logger instances with log.child
- Custom rendering of logged objects with "serializers"
- Runtime log snooping via Dtrace support
- Support for browserify.


### Security

It's very important to check and verify these areas in any Node.js development, even if it still is not public:

* Authentication, user an session management.
* Configuration Management i.e. Security HTTP Headers
* Data Validation on client side
* Database injections,...
* Security Transmission
* Denial of Service
* Error Handling

All these areas are deeply covered in the security and hardening [section of this repository](../../it_security/security_hardening/README.md).

In this section we're going to show you some references and middlewares that are easy to include as first protection.

#### [Lusca](https://www.npmjs.com/package/lusca)

Lusca is Web application security middleware for Express. **It requires express-session**.

```javascript
  import express from 'express';
  const app = express();
  import session from 'express-session';
  import lusca from 'lusca';

//this or other session management will be required
app.use(session({
	secret: 'abc',
	resave: true,
	saveUninitialized: true
}));

app.use(lusca({
    csrf: true,
    csp: { /* ... */},
    xframe: 'SAMEORIGIN',
    p3p: 'ABCDEF',
    hsts: {maxAge: 31536000, includeSubDomains: true, preload: true},
    xssProtection: true
}));
```

You can opt into methods one by one:

```javascript
  app.use(lusca.csrf());
  app.use(lusca.csp({ /* ... */}));
  app.use(lusca.xframe('SAMEORIGIN'));
  app.use(lusca.p3p('ABCDEF'));
  app.use(lusca.hsts({ maxAge: 31536000 }));
  app.use(lusca.xssProtection(true));
```

#### [Helmet](https://www.npmjs.com/package/helmet)

Helmet can help protect your app from some well-known web vulnerabilities by setting HTTP headers appropriately.
Next, you can use helmet in your application (for example in Express):

Running app.use(helmet()) will include 6 of the 9, leaving out *contentSecurityPolicy*, *hpkp*, and *noCache*.

```javascript
import express from 'express';
import helmet from 'helmet';

const app = express();
    app.use(helmet());
```

Helmet is a collection of 9 smaller middleware functions that set security-related HTTP headers.
> - **contentSecurityPolicy** for setting Content Security Policy to help prevent cross-site scripting attacks and other cross-site injections.
> - **hidePoweredBy** to remove the X-Powered-By header
> - **hpkp** for HTTP Public Key Pinning to prevent man-in-the-middle attacks with forged certificates.
> - **hsts** for HTTP Strict Transport Security that enforces secure (HTTP over SSL/TLS) connections to the server.
> - **ieNoOpen** sets X-Download-Options for IE8+
> - **noCache** to disable client-side caching
> - **noSniff** to keep clients from sniffing the MIME type
> - **frameguard** to prevent clickjacking
> - **xssFilter** adds some small XSS protections in most recent web browsers.

You can also use each module individually:

```javascript
  app.use(helmet.noCache());
  app.use(helmet.frameguard());
```

### Clustering

Using the [Node.js Cluster API](https://nodejs.org/dist/latest-v4.x/docs/api/cluster.html) could boost the performance of our app. It's useful but must be used with care. Remember that this api it's stable only in versions greater than v.4

There are two ways of implement this api:

* PM2 Interface It adds the support automatically it's easy and fast to implement.

* Manually in our code. It's more flexible because the threads could share resources and messages between them.

It's recommendable to add one thread by core, and in case of extreme stability require, one less for the management.

It's useful to add a mechanism to respawn the threads and count the number of reboots to kill the app in case of unrecoverable problems, for the process management could restart the app.

### Staging

As any other server it's relevant to provide some profiling options. The common way to do this it's through a property file.

* Manually through merging files with lodash.

*config.json* managed by SysOps
```javascript

const config = {
    app : {
        name : 'Config Backend',
        url : 'http://192.168.0.77',
        port : 3002
    },
    db: {
    	ip: '192.168.0.78',
    	port: 6379
    }
}

module.exports = config;

````

*index.js* managed by Developers

```javascript
var config = {
    app : {
        name : 'Config Backend',
        url : 'http://127.0.0.1',
        port : 3001
    },
    db: {
    	ip: '127.0.0.1',
    	port: 6379
    }
}
````

*index.js* Logic to merge (same file):

```javascript

// ...
var systemConfig='/external/path/to/config.js'; // i.e. /var/properties/project-name/config.js

// First option: manual
if(process.env.CONFIG && fs.existsSync(process.env.CONFIG)){
    console.log('Cargada la configuración manual de la ruta: '+process.env.CONFIG);
    customConfig=require(process.env.CONFIG);
// Second option: external properties file
} else if(fs.existsSync(systemConfig)){
    console.log('Cargada la configuración estándar SISTEMAS de la ruta: '+systemConfig);
    customConfig=require(systemConfig);
// Third option: local config file
} else if(fs.existsSync(envConfig)){
    console.log('Cargada la configuración local');
    customConfig=require(envConfig);
}
// ...

// Merging the files overriding local config with the externals
config=_.merge(
    config,
    customConfig
);
````

* Through packages as [dotenv](https://github.com/motdotla/dotenv)

## Testing

In this section we're going to offer a way to implement TDD and BDD in your Node.js developments but if you want to go deeper, please visit the [testing section of this repository](../../qa_testing/testing/README.md).

### TDD with Sinon and Proxyquire

#### Focusing

Test-driven development (TDD), as many of you might know, is one of the main, agile development techniques. The genius of TDD lies in increased quality of code, faster development resulting from greater programmer confidence, and improved bug detection.

#### Structure for TDD

```
my-application/
	test/
		unit-test/
			routes-test/
                routes-test-file1.js # routes-unit-test files
                routes-test-file2.js # to test functions of
                routes-test-fileN.js # your application
            controllers-test/
                controllers-test-file1.js # controllers-unit-test files
                controllers-test-file2.js # to test functions of
                controllers-test-fileN.js # your application
            models-test/
                models-test-file1.js # models-unit-test files
                models-test-file2.js # to test functions and methods of
                models-test-fileN.js # your application

```

#### Dependencies

##### Installation

Sinon.js are available as a npm module, it should be install globally with:

``` shell
$ npm install sinon
```

Proxyquire.js are available as a npm module, it should be install globally with:

``` shell
$ npm install proxyquire
```

And also is necessary Chai.js and can be install locally as a development dependency with:

``` shell
$ npm install --save-dev chai
```

#### Develop and run test

##### Describes and it functions

The different test suite will be group into a describe functions, it consist in a description about the suite, and a function that contains inside the 'it' functions to include every single unit test case. Each 'it' function also contains the description of the single unit test and the function to test one component of your application (model, controller or route). If the complexity of file functions is greater probably will be necessary to use more describe functions inside another.

A structure example is the following:

```javascript
var chai       = require('chai');
var expect     = chai.expect;
var sinon      = require('sinon');
var proxyquire = require('proxyquire');

var model = require('../lib/daos/model1');
var controller = require('../lib/controllers/controller1');

var object = {
    counter : 1,
    id : "1234567890123456789012345",
    description : "New unit test for NodeJs"
};

var expectedResult = {
    ID : '1234567890123456789012345',
    DESCRIPTION : 'New unit test for NodeJs'
};

var error = new Error('ERROR');

var appMock =  {
    logger : {
        debug : sinon.spy()
    }
};

var controllerMock = proxyquire('../lib/controllers/controller1',
    {'../app':appMock});

describe('UNIT Test for CONTROLLER', function() {

    it('must exists', function () {
        var result = controller;
        expect(result).to.be.an('object');
        expect(result).to.include.keys(['createDE', 'store']);
    });

    it('Test should call all functions on createDE method', function () {
        var stub = sinon.stub(model.db, 'createDE');
        var callback = sinon.spy();

        controllerMock.createDE(callback);

        sinon.assert.calledOnce(stub);
        stub.restore();
    });

    it("Test should call all functions on save method - OK", function (done) {
        var args = {"ID": object.id, "DESCRIPTION": object.description};
        var stub = sinon.stub(model.db, 'save');
        stub.yields(null, expectedResult);

        controllerMock.store(args,function(err,data) {
            expect(data).to.be.an('Object');
            expect(data.ID).to.be.an('String');
            expect(data.ID).to.be.equal(object.id);
            expect(data.DESCRIPTION).to.be.an('String');
            expect(data.DESCRIPTION).to.be.equal(object.description);
            done();
        });
        stub.restore();
    });

    it("Test should call all functions on save method - Error", function (done) {
        var args = {"ID": object.id, "DESCRIPTION": object.description};
        var stub = sinon.stub(model.db, 'save');
        stub.yields(null, error);

        controllerMock.store(args,function(err,data) {
            expect(err).to.be.an('Object');
            expect(data).to.be.null;
            done();
        });
        stub.restore();
    });
});
```

#### Use cases

- To implement the different validations options you need to import the assert and expect libraries, you can do this with:
```javascript
var expect = require('chai').expect;
var assert = require('chai').assert;
```
And use in the response of your functions like this:
```javascript
expect(err).to.be.null;
expect(data).to.be.string;
```
- This Test uses different mocks for functions and methods. For example:
	- Proxyquire. This library override methods of a module behave like the original. The original method invokes the app.js file. The test mock this invocation.

        ```javascript
        var controllerMock = proxyquire('../lib/controllers/controller1',
        					{'../app':appMock});
        ```

	- Sinon. Stub it allows us to preprogram the output method. This method is very interesting because us can try differents outputs "Ok" or "Error".

        ```javascript
        var stub = sinon.stub(model.db, 'save');
        stub.yields(null, expectedResult);
        ```

        or

        ```javascript
        var stub = sinon.stub(model.db, 'save');
        stub.yields(null, error);
        ```

	- Sinon. Assert it allows us to know how many times we pass this method only once.

		```javascript
        sinon.assert.calledOnce(stub);
        ```

- It's good practice to use a callback function (done), inside the 'it' unit case function to try all the validations and to finish the case. And example is the following:
```javascript
controllerMock.store(args,function(err,data) {
    expect(data).to.be.an('Object');
    expect(data.ID).to.be.an('String');
    expect(data.ID).to.be.equal(object.id);
    expect(data.DESCRIPTION).to.be.an('String');
    expect(data.DESCRIPTION).to.be.equal(object.description);
    done();
});
```
- Another good practices is to use a "restore()" functions before finish test:
```javascript
stub.restore();
```

#### Recommendations and some tips and tricks

> - The same layer structure of files should be reflect in the test/unit directory. Example: If the app have directories with routes, controllers and models, is necessary to do the test for all the files.
> - It's necessary to do a it test case for each function of the original file (model, controller, route).

#### Hooks

Hooks are functions that can be used to prepare and clean the environment before and after each test suite is executed. Hooks can use callbacks to defined if the beginning and end of the test suite case works fine. It's necessary to use this hooks always in a test suite case.


The following example, are hooks to create mock that will be used in different test, before and after the execution of test suite case:

```javascript
before(function(done) {
	var stub = sinon.stub(model.db, 'save');
	stub.yields(null, expectedResult);
});

after(function(done) {
   sinon.assert.calledOnce(stub);
});
```

You can get more information about Mocha and Chai in detail from both [Sinon](http://sinonjs.org/) and [Proxyquire](https://www.npmjs.com/package/proxyquire)

### BDD with Cucumber

#### Structure for BDD

```
my-application/
	test/
		acceptance-test/
			features/
				step_definitions/
					stepdefinition-file1 # methods, helpers and
					stepdefinition-file2 # variables for describing
					stepdefinition-fileN # step definitions
				support/
					hooks.js # hooks functions for clean environment
					world.js # file with all properties and funcions to be used in step definitions
				feature-file1.feature # feature files with scenarios
				feature-file2.feature # and steps for all user histories
				feature-fileN.feature # defined in you application
			npm-debug.log # npm
			my-application.log # application acceptance-test logging file
		mocks/
			mocks-file1.js # methods and funcions
			mocks-file2.js # for mocking during unit
			mocks-fileN.js # tests in your application
		unit-test/
			unit-test-file1.js # unit-test files for testing
			unit-test-file2.js # functions and methods of
			unit-test-fileN.js # your application
```

#### Dependencies

##### Instalation

Cucumber.js is available as an npm module. Install globally with:

``` shell
$ npm install -g cucumber
```

Install as a development dependency of your application with:

``` shell
$ npm install --save-dev cucumber
```

##### Develop and run test

For checking response code and fields, maybe you also need:

* chai
* json-schema

#### Features

The acceptance-test features with user histories must be packed and stored in files with .feature extension. Must be stored in features folder. This Features are written using Gherkin language:

``` gherkin
# features/feature-file1.feature

Feature: Example feature
	As a user of cucumber.js
	I want to have documentation on cucumber
	So that I can concentrate on building awesome applications

	Scenario: Reading documentation
		Given I am on the Cucumber.js GitHub repository
		When I go to the README file
		Then I should see "Usage" as the page title
```

It's a best practice to store these files under /features in acceptance-test subfolder.

It isn't the purpose of this article how to describe correct features in Gherkin, but there are a set of recommendations:

1. Use Background and Scenario Outline if it's posible.
2. Don't write large feature files. You can pack these features in more files. For example, if you have 24 scenarios for testing two different application param values, yo can choose:
	* createnotification.feature (24 Scenarios). **NOT GOOD**
	* createnotification_app1.feature (the first 12 Scenarios) and createnotification_app2.feature (the remaining 12 Scenarios). **BETTER**
	* createnotification_app1_ok.feature (the first 2 Scenarios for app1), createnotification_app1_errors.feature (the remaining 10 Scenarios for app1), createnotification_app2_ok.feature (the first 2 Scenarios for app2) and createnotification_app2_errors.feature (the remaining 10 Scenarios for app2). **BEST**

You can check the official cucumber github repository for a beggining guide [Feature-Introduction](https://github.com/cucumber/cucumber/wiki/Feature-Introduction)

You can also check more examples how to describe Features using Gherkin in this [link](http://docs.behat.org/en/v2.5/guides/1.gherkin.html)


#### Step Definitions

Step definitions are defined in javascript files under my.application/features/step_definitions folder. This step definitions are

Best practices:
1. Don't write redundant or near Step definitions. Example:
``` gherkin
	Given(/^the following data for creating a notification:$/, function (table, callback) {
		//step code
	});

	Given(/^the following data for creating a notification:$/, function (table, callback) {
		//step code
	});
```
or

``` gherkin
	Given(/^the following data for creating a notification:$/, function (table, callback) {
		//step code
	});

	Given(/^the following data for create a new notification:$/, function (table, callback) {
		//step code
	});
```

You can use the same step definition for all of them.

2. Don't write ambiguos or near Step definitions:
``` gherkin
	Given(/^the following signature "([^"]*)"$/, function (signature, callback) {
		//step code
	});

	Given(/^the following "([^"]*)" signature$/, function (signature, callback) {
		//step code
	});
```
Those are the same definition for an unique step.

3. Group step definitions by functionality, and use only one for common step definitions. Example:

```
my-application/
	test/
		acceptance-test/
			features/
				step_definitions/
					createApp_stepdefinitions.js
					getApp_stepdefinition.js
					common_stepdefinitions.js
				createApp_ok.feature
				createApp_error.feature
				getApp_ok.feature
				getApp_error.feature

```

4. Gruop Given, When and Then step definitions in the same file section. Example:

``` gherkin
	Given(/^step 1 definition$/, function (callback) {
		//step code
	});

	Given(/^step 2 definition$/, function (callback) {
		//step code
	});

	When(/^step 3 definition$/, function (callback) {
		//step code
	});

	When(/^step 4 definition$/, function (callback) {
		//step code
	});

	Then(/^step 5 definition$/, function (callback) {
		//step code
	});

	Then(/^step 6 definition$/, function (callback) {
		//step code
	});

```

Here is a simple example:

``` javascript
var expect = require('chai').expect;

module.exports = function () {
	this.World = World = require("../support/world.js").World;
	var 	Given = this.Given,
		When = this.When,
		Then = this.Then;

	Given(/^the following data for creating a notification:$/, function (table, callback) {
		this.setData("notificationData", table.hashes()[0]);
		callback();
	});

	When(/^I try to create a notification$/, function (callback) {
		World.tryToCreateNotification.call(this, callback);
	});

	Then(/^the response must be "([^"]*)"$/, World.responseMustBe);

	Then(/^I receive all required info for creating notification$/, function (callback) {
		World.checkCreateNotificationResponseData.call(this, callback);
	});

	Then(/^the notification was created and stored$/, function (callback) {
		World.checkNotificationExists.call(this, callback);
	});
};
```
You can also check more examples how to describe Step definitions in this [link]
(https://github.com/cucumber/cucumber/wiki/Step-Definitions)

#### Support Files

Support files let you setup the environment in which steps will be run, and define step definitions. The most important support file is the World function, but you may need more functions for testing.

The secondary files you need to develop and store are the hooks functions. These two with other acceptance-test functions files must be stored in support subfolder.

#### World function

World is a constructor function with utility properties, destined to be used in step definitions. World function file should have this desired structure:

1. Require section for imports.

2. World function declaration.

3. Functions for setting, getting and cleaning data of every scenario.

4. Validation functions for checking JSON objects in responses.

5. Server properties and constants for making requests.

6. Functions for start and stop a mock server for acceptance-tests.

7. Requests functions to call server endpoints you wish to call.

8. Client-side response methods for check if you receive the expected responses.

9. Test description function where you can prepare the request to server endpoints.

This is one valid example for this structure:

```javascript
var	request = require('request'),//1
	zombie = require('zombie'),
	expect = require('chai').expect,
	async = require('async'),
	server = require('server'),
	extend = require('extend');

var	World = function World(callback) {//2
	var sharedData = {};

	this.setData = function (field, data) {//3
		sharedData[field] = data;
	};

	this.getData = function (field) {//3
		return sharedData[field];
	};

	this.clearData = function (field) {//3
		if (field) {
			delete sharedData[field];
		} else {
			shardData = {};
		}
	};

	this.validations = {
		validationOne: function (data) {//4
			expect(data).to.be.ok;
		}
	};

	var SERVER_URL = this.SERVER_URL = "http://localhost:3000/my-application";//5
	var VERSION = this.VERSION = "v1";//5

	var applicationUrls = this.urls = {//5
		endpoint: SERVER_URL + VERSION + '/{applicationId}'
	};

	var config = this.config = {//5
		//API properties
		name: 'my-application',
		port: 3000,
		version: "0.0.1",
		apiversion: "v1",
		//Store properties
		store: {
			type: "mongodb",
			url: "mongodb://localhost:27017/my-application_test",
			collection: "notifications",
			options: {}
		},
		//Logging properties
		log: {
			fileName: './my-application.log',
			console: false
		}
	};

	this.startServer = function () {//6
		return server.start(config);
	};

	this.stopServer = function () {//6
		server.stop();
	};

	logger.init(config.log);

	this.requestFunction = function (param1, param2, ..., paramN, callback) {//7
		request.post({
			url: url,
			json: json,
			headers: {
			}
		}, callback);
	};

	callback();
};

World.responseMustBe = function (expectedStatus, callback) {//8
	var statusCode = this.getData('response').statusCode;
	expect(statusCode).to.be.equal(Number(expectedStatus));
	callback();
};

World.followingRequest = function (items, callback) {//9
	async.eachSeries(items, function (item, callback) {
		this.requestFunction(item.param1, item.param2, ..., item.paramN, function (error, response, body) {
			expect(error).to.be.null;
			expect(response.statusCode).to.equal(201);
			callback();
		}.bind(this));
	}.bind(this), function (error) {
		expect(error).to.not.exist;
		callback();
	}.bind(this));
};

exports.World = World;
```

#### Hooks

Hooks are functions that can be used to prepare and clean the environment before and after each scenario is executed. Hooks can use callbacks, return promises, or be synchronous. The first argument to hooks is always the current scenario.

There are four different Hook function types:
1. Scenario hooks: will be run before/after the first/last step of each scenario. They will run in the same order of which they are registered.

2. Step hooks: will be run before/after every step of each scenario. Dos not work with scenarios which have backgrounds.

3. Tagged hooks: will be run before/after certain scenarios. You have to use tags for select subset of scenarios to run with this kind of hooks.

4. Global hooks: will be run once before any scenario is run.

Best practices for using Hooks, are:

* Pack all of them in a single file.
* Store this file with World function file.
* Use a little set of hooks.

The following example are hooks for clean data repository (in mongoDB) before every scenario, and start/stop server in every Scenario:

```javascript
var expect = require('chai').expect,
	MongoClient = require('mongodb').MongoClient;

var hooks = function () {
	var Before = this.Before,
		After = this.After,
		Around = this.Around;

	Before(function (done) {
		var that = this;
		this.startServer().then(function () {
			MongoClient.connect(that.config.store.url, function (error, db) {
				db.collection(that.config.store.collection).remove(function (error) {
					db.close();
					done();
				});
			});
		}).fail(function (error) {
			expect(error).to.be.null;
			done();
		});
	});

	After(function (done) {
		var that = this;
		this.stopServer();
		done();
	});
};

module.exports = hooks;
```

### Integration Testing with Mocha

#### Focusing
Integration testing is where we write end-to-end tests, verifying the state of the app/UI along the way.

#### Structure for Integration Testing

```
my-application/
	test/
		integration-test/
			lib/
				app-test.js # your application
			models-test/
				models-test-file1.js # models-integration-test files
				models-test-file2.js # to test functions and methods of
				models-test-fileN.js # your application

```

#### Dependencies

##### Installation

Mocha.js are available as a npm module, it should be install globally with:

``` shell
$ npm install -g mocha
```

And locally in your project as a development dependency of your application with:
``` shell
$ npm install --save-dev mocha
```

And also is necessary Chai.js and can be install locally as a development dependency with:
``` shell
$ npm install --save-dev chai
```

#### Develop an run test

##### Describes and it functions
The purpose of integration testing is to verify functional, performance, and reliability requirements placed on major design items. These "design items", i.e., assemblages (or groups of units), are exercised through their interfaces using black box testing, success and error cases being simulated via appropriate parameter and data inputs. Simulated usage of shared data areas and inter-process communication is tested and individual subsystems are exercised through their input interface. Test cases are constructed to test whether all the components within assemblages interact correctly, for example across procedure calls or process activations, and this is done after testing individual modules, i.e., unit testing. The overall idea is a "building block" approach, in which verified assemblages are added to a verified base which is then used to support the integration testing of further assemblages.

A structure example is the following:

```javascript
var assert = require('chai').assert;
var pg = require('pg');
var supertest = require('supertest');
var commons = require('commons');
var commonsUtils = commons.utils;

var app = require('../../../lib/app');
var config = require('../../../config/env');
var models = require('../model/object');

function checkQueues(client, data, done) {
    data.FEC_INI = commonsUtils.getTodayDate();
    data.FEC_FIN = commonsUtils.getTodayDate();
    checkQueue(client, config.queue.name, data, done);
}

function checkQueue(client, queueName, object, callback) {
    //Check message in next queue
    client.receiveMessage({qname: queueName}, function (err, message) {
        if (err) {
            callback(err);
        } else {
            if (message && message.id && message.message) {
                var data = JSON.parse(message.message);
                if (data.type === 'object') {
                    delete data.ID;
                    delete object.ID;
                    assert.deepEqual(object, data);
                    callback();
                } else
                    callback("Data is wrong type");
            } else
                callback('Empty message in next queue');
        }
    });
}

function clearCounter(data, callback) {
    pg.connect(config.postgres.url, function (err, db, done) {
        if (err) {
            callback(err);
        } else {
            db.query("delete from " + config.postgres.tables.counter + " where DES_OBJECT = \'" + data.DES_OBJECT + "\' and COD_OBJECT = \'" + data.COD_OBJECT + "\';", function (err, result) {
                done();
                if (err) {
                    callback(err);
                } else {
                    callback();
                }
            });
        }
    });
}

function init(callback) {
    commons.redisMQ.connect(config.redis, function (err, client) {
        if (err)
            callback(err);
        else {
            client.deleteQueue({qname: config.queue.name}, function (err, data) {
                client.createQueue({qname: config.queue.name}, function (err, data) {
                    if (err)
                        callback(err);
                    else
                        callback(null, client);
                });
            });
        }
    });
}

describe('INTEGRATION TEST - object', function () {
    this.timeout(0);

    var client, request;
    before('Creating Redis client, deleting queue, clear database, creating HTTP client', function (done) {
        init(function (err, cl) {
            if (err)
                done(err);
            else {
                client = cl;
                request = supertest('http://' + config.server.host);
                app.start(config.server.port);
                setTimeout(done, 5000);
            }
        });
    });

    describe('Testing Execute.', function () {

        beforeEach('Clearing counter in database', function (done) {
            clearCounter(models.data, done);
        });

        it('Should execute ok', function (done) {
            request.post('/api/execute')
                .set('Accept', 'application/json')
                .set('x-unique-id', '5115bcce-59bf-4948-9441-4bb1f2e2d388')
                .set('Content-Type', 'application/json')
                .send(models.args)
                .end(function (err, res) {
                    if (err)
                        done(err);
                    else {
                        assert.equal(res.status, 200);
                        setTimeout(function () {
                            checkQueues(client, models.data, done);
                        }, 10000);
                    }
                });
        });

        it('Should fail validate', function (done) {
            request.post('/api/execute')
                .set('Accept', 'application/json')
                .set('x-unique-id', '5115bcce-59bf-4948-9441-4bb1f2e2d388')
                .set('Content-Type', 'application/json')
                .send(models.argsError)
                .end(function (err, res) {
                    if (err)
                        done(err);
                    else {
                        assert.equal(res.status, 500);
                        done();
                    }
                });
        });
    });
});
```

#### Use cases

- To implement the different validations options you need to import the assert and expect libraries, you can do this with:

    ```javascript
var assert = require('chai').assert;
    ```

	And use in the response of your functions like this:

    ``` javascript
assert.equal(res.status, 200);
    ```

- It's good practice to use a callback function (done), inside the 'it' integration case function to try all the validations and to finish the case. And example is the following:

    ```javascript
.end(function (err, res) {
    if (err)
        done(err);
    else {
        assert.equal(res.status, 200);
        setTimeout(function () {
            checkQueues(client, models.data, done);
        }, 10000);
    }
});
    ```

- To do a test of a route file, to simulate a http call with methods get, post or another, you need the library supertest, you can install as development dependency with:

    ```javascript
$ npm install --save-dev supertest
    ```

- You can import with:

    ```javascript
var supertest = require('supertest');
var request = supertest('http://' + config.server.host);
    ```
- And you can use this library to try a url with http method post in a it test case function like this example:

	```javascript
it('Should execute ok', function (done) {
    request.post('/api/execute')
        .set('Accept', 'application/json')
        .set('x-unique-id', '5115bcce-59bf-4948-9441-4bb1f2e2d388')
        .set('Content-Type', 'application/json')
        .send(models.args)
        .end(function (err, res) {
            if (err)
                done(err);
            else {
                assert.equal(res.status, 200);
                setTimeout(function () {
                    checkQueues(client, models.data, done);
                }, 10000);
            }
        });
});
	```

- Also it's a good practice to do a test cases with wrong data to try the error exceptions like this example:

    ```javascript
it('Should fail validate', function (done) {
    request.post('/api/execute')
        .set('Accept', 'application/json')
        .set('x-unique-id', '5115bcce-59bf-4948-9441-4bb1f2e2d388')
        .set('Content-Type', 'application/json')
        .send(models.argsError)
        .end(function (err, res) {
            if (err)
                done(err);
            else {
                assert.equal(res.status, 500);
                done();
            }
        });
});
    ```

#### Recommendations and some tips and tricks

> - For model test you need to create a test enviroment with diferent information about start port, database name, etc... because the execution of tests can't interrupt or save data in a execution enviroment. Example: config.server.port
> - Use a mock file to get some fake data to store and delete in a test database to try the model functions of crud operations.

You can get more information about Mocha and Chai in detail from both [Mocha](https://mochajs.org/) and [Chai](http://chaijs.com/)

### References

Node.js and Best Practices
* [Node.js Oficial WebSite](http://www.nodejs.org)
* [Node.js design patterns](https://blog.risingstack.com/fundamental-node-js-design-patterns/)
* [Risingstack Best Practices](https://blog.risingstack.com/node-js-best-practices)
* [ES6 & callback-promise Best Practices](https://blog.risingstack.com/how-to-become-a-better-node-js-developer-in-2016)
* [Heroku Best Practices](https://devcenter.heroku.com/articles/node-best-practices)

Cheatsheets
* [Overapi Cheatsheet](http://overapi.com/nodejs)
* [NPM Cheatsheet](http://browsenpm.org/help)

Frameworks
* [Express Framework](http://expressjs.com)
* [Express Performance best practices](http://expressjs.com/en/advanced/best-practice-performance.html)
* [Express Security best practices](http://expressjs.com/en/advanced/best-practice-security.html)
* [Hapi Framework](http://hapijs.com)
* [Restify Framework](http://restify.com)

DevOps
* [package.json full example](http://browsenpm.org/package.json)
* [Joyent Production Best Practices](https://www.joyent.com/developers/node)

Security
* [OWASP Web Application Security Testing Cheat Sheet](https://www.owasp.org/index.php/Web_Application_Security_Testing_Cheat_Sheet)
* [Node.js Security Checklist](https://blog.risingstack.com/node-js-security-checklist)

___

[BEEVA](http://www.beeva.com) | 2016
