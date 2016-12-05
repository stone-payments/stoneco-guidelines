![alt text](static/nodejs.png "Node.js")
![alt text](static/express.png "Express")

# Node.js Style Guide & Best Pratices: Express

Express is a minimal and flexible Node.js web application framework that provides a robust set of features for web and mobile applications. With a myriad of HTTP utility methods and middleware at your disposal, creating a robust API is quick and easy. Express provides a thin layer of fundamental web application features.

In this guide we're going to cover these areas about using Express in our apps:

* [Application structure](#application-structure)
* [Security](#security)
* [Performance](#performance)

## Application structure

One of the strengths of Express is the community and large number of application examples and proposals it has published on its [repository](https://github.com/strongloop/express/tree/master/examples).

Anyway one of the profits its the flexibility to divide the logic of our app.

### Main file: src/index.js

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

### A controller foreach version related with the endpoint i.e. src/controller/api_v1.js & src/controller/api_v2.js  

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

## Security

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

## Performance

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

___

[BEEVA](http://www.beeva.com) | 2016
