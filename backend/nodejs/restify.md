![alt text](static/nodejs.png "Node.js") ![alt text](static/restify.png "Restify")

# Node.js Style Guide & Best Pratices: Restify

Restify is a light framework similar to Express and very easy for building REST APIs. This is the easy way to create a REST API application:

In this guide we're going to cover these areas about using Restify in our apps:

* [Hello World](#hello-world)
* [Application Structure](#application-structure)

## Hello World

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

## Application Structure

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
### config.json

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

### package.json

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

### server.js

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

### static-server.js

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

### bin/www

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

___

[BEEVA](http://www.beeva.com) | 2016
