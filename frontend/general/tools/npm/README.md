![alt text](../../../../static/horizontal-beeva-logo.png "BEEVA")

# Front-end Development Best Practices

<img src="../static/npm-logo.png" height="60px"/>

## NPM

* [Introduction](#introduction)
* [Installation](#installation)
* [Package Configuration File](#package-configuration-file)
* [Packages](#packages)
  * [Local Packages](#local-packages)
  * [Global Packages](#global-packages)
  * [Publishing Packages](#publishing-packages)
* [Links](#links)
 
----
## <a name='introduction'>Introduction</a>


NPM is the package manager for node.js and is two things:

  - <b>Online Repository</b>, for the publishing of open-source Node.js packages.
  
  - <b>Command-line Utility</b>,for interacting with said repository. NPM help you in package installation, version management, and dependency management.

## <a name='installation'>Installation</a>

The first step is install the last version of node.js:

  - OS X / Windows.   The best way to install Node.js is to use one of the installers from nodejs.org (https://nodejs.org/en/download/).

  - Linux. You can use the installer, or you can check NodeSource’s binary distributions (https://github.com/nodesource/distributions).

  - Installing Node.js via package manager. (https://github.com/nodejs/node-v0.x-archive/wiki/installing-node.js-via-package-manager)

By default, the node.js installation includes a version of npm. To check the version installed node and npm we can use the following command.

```bash 
$ node -v
v0.10.41

$ npm -v
v2.1.8
```

To complete the installation must update the npm version with the following command.

```bash
$ sudo npm install npm -g
```

## <a name='package-configuration-file'>Package Configuration File</a>

#### package.json

The best way to locally manage the dependencies of your project is through the configuration file "package.json":

  - First, it serves as documentation of all the units of our project.
  
  - Second, it facilitates the management the versions of the dependencies.
  
  -  Third, it facilitates the reproduction of the environment to the developers.

#### Creating a package.json

To create the "package.json" file of our project we can use the following command.

```json
& npm init --yes
Wrote to /home/emoreno/beeva_package/package.json:
 
{
  "name": "beeva_package",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "beeva-emoreno",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/beeva/beeva_package.git"
  },
  "bugs": {
    "url": "https://github.com/beeva/beeva_package/issues"
  },
  "homepage": "https://github.com/beeva/beeva_package"
}
```

Once created the file, we indicate the values for each of the fields

  - name: defaults to author name unless in a git directory, in which case it will be the name of the repository.
  - version: always 1.0.0.
  - main: always index.js
  - scripts: by default creates a empty test script.
  - keywords: empty.
  - author: whatever you provided the CLI.
  - license: MIT.
  - repository: will pull in info from the current directory, if present.
  - bugs: will pull in info from the current directory, if present.
  - homepage: will pull in info from the current directory, if present.

#### Specifying Packages

There are 2 types of packages you can list in your package.json file:

  - "dependencies": these packages are required by your application in production.
  
  - "devDependencies": these packages are only needed for development and testing.
  
```
{
  "name": "beeva_package",
  "version": "1.0.0",
  "dependencies": {
    "my_dep": "^1.0.0"
  },
  "devDependencies" : {
    "my_test_framework": "^3.1.0"
  }
}
```

#### Add Dependencies 

To add dependencies  to your package.json is to use the command "npm install":

  - Dependencies.
    ```bash
    & npm install <package_name> --save
    ```

  - Development Dependencies.
    ```bash
    & npm install <package_name> --save-dev
    ```





## <a name='packages'>Packages</a>

The npm packages can be installed in two ways: locally or globally. We can choose which kind of installation to use based on how you want to use the package.

### <a name='local-packages'>Local Packages</a>

#### Installing
To do this, run npm install in the same directory as your package.json file.
```bash
$ npm install <package_name>
```

#### Updating
To do this, run npm update in the same directory as your package.json file.
```bash
$ npm update
```

#### Uninstalling
To do this, run npm uninstall  in the same directory as your package.json file.
```bash
$ npm uninstall <package_name>
```


### <a name='global-packages'>Global Packages</a>


#### Installing
To do this, run npm install:
```bash
$ sudo npm install -g <package_name>
```

#### Updating
To do this, run npm install:
```bash
$ npm install -g <package_name>
```

#### Uninstalling
To do this, run npm uninstall  in the same directory as your package.json file.
```bash
$ npm uninstall -g <package_name>
```


### <a name='publishing-packages'>Publishing Packages</a>
We can publish any directory that has a package.json file, e.g. a node module.

#### Creating a user
To publish, you must have a user on the npm registry. If you don't have one, create it with npm adduser.


#### Loggin user
If you created one on the site, use npm login to store the credentials on the client.


#### Publishing the package
Use npm publish to publish the package.


#### Updating the package
When you make changes, you can update the package using npm version <update_type>, where update_type is one of the semantic versioning release types, patch, minor, or major. This command will change the version number in package.json. Note that this will also add a tag with this release number to your git repository if you have one.

After updating the version number, you can npm publish again.


## <a name='links'>Links</a>

 -  Home... https://www.npmjs.com/
 -  Documentation... https://docs.npmjs.com/
___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies

