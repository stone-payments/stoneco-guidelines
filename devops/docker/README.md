![alt text](static/docker-logo.jpg "DOCKER-LOGO")

# Docker best practices

## Index

* [Docker Essentials](#docker-essentials)
	* [Optimize your dockerfiles](#optimize-your-dockerfiles)
	* [Create small-sized containers](#create-small-sized-containers)
	* [Design your application thinking about Docker](#design-your-application-thinking-about-docker)
	* [Security](#security)
* [Docker Orchestration](#docker-orchestration)
	* [Docker for Developers](#docker-for-developers)
		* [Docker-Compose](#docker-compose)
  	* [Docker for testing](#docker-for-testing)
	* [Docker CI](#docker-ci)
* [References](#references)

## Docker Essentials

### Optimize your dockerfiles

Images can be built automatically following the instructions defined in a Dockerfile. These are general guidelines for writing dockerfiles:

* Each Docker image consists of a series of layers. Docker makes use of union file systems to combine these layers into a single image. When you change a Docker image, rather than replacing the whole image or entirely rebuilding, only that layer is added or updated. In a Dockerfile, each command generates a layer, thus organize your Dockerfile so that common commands that you doesn't expect to change are located at the beginning.

```
	#FROM and CMD command are not expected to change, so they come first
	FROM debian:latest
	CMD ["nodejs", "main.js"]

	#Package installation may change eventually
	RUN apt-get update \
		    && apt-get install -y --no-install-recommends curl \
		    && curl -sL https://deb.nodesource.com/setup | bash - \
		    && apt-get install -y --no-install-recommends nodejs

	# Application specific files and packages will change with each release, so they come last
	COPY main.js main.js
	COPY log4js.json log4js.json
	COPY package.json package.json

	RUN npm install
```

* Use a .dockerignore file to specify excluded files and directories to increase the build performance.

* Keep layers to a minimum: too many layers makes things unnecessarily complicated. The trick is to find a good balance between readability and the lowest number of layers possible. Only add additional layers when there is a strategic reason for doing so.

* Sort multiline arguments alphanumerically to avoid duplication of packages and to improve readability.
```
	RUN apt-get update && apt-get install -y --no-install-recommends \
	  	bzr \
		cvs \
	  	git \
	  	mercurial \
	  	subversion
```

* Be specific about tags: Docker Build will generate a tag that is easily read by people and this helps you manage the images more easily later so use the ```-t``` option for the Docker Build feature.


### Create small-sized containers

Keep the image as minimal as posible:

* Use small base images (e.g. *debian* or *alpine*)

* Don’t install unnecessary packages: This reduces the file size, lessens the complexity of dependencies, and cuts down on build times. Use ```--no-install-recommends``` with *apt-get*

* Take advantage of .dockerignore: DockerIgnore is a handy way to exclude unnecessary files and directories from the build context and final image.

* Remember to delete packages used to install your application after uncompressing them.

### Design your application thinking about Docker

* Use only one container per process: Decouple applications into separate containers — one for each process. This makes horizontal scaling easier and allows you to recycle containers. To handle services that are dependent on each other, use the container linking feature instead of housing them in the same Docker container.

* Build containers that are portable and easy to replace: Keep in mind that the docker containers produced by the images defined in your Dockerfile should be ephemeral. So they can be stopped, destroyed or rebuilt with minimal setup and configuration. In particular, containers should be stateless, and should not contain specific data:

	* Configuration parameters or files: Any information that the application needs to run that can change between environments (such as endpoints, usernames and passwords) shouldn't be hardcoded into the container. The recommendation is to prepare your application to get that info from environment variables (and supply those variables when running the container) or using external configuration files mounted as data volumes.

	* Don't mix Docker logs with application logs: Docker containers collect the output of the running process stdout into their Docker logs. This logs are ephemeral, and can grow indefinitely. It is recommended to never mix your application logs into Docker logs. Put the application logs into a file mounted as a volume on the host. This way, logs can be properly treated and rotated.

	* Application specific data: Any application specific data, such as database files, should be mounted as a volume on a separated container, using Docker link functionality.

### Security

You can use the following tools to check security issues on docker images and containers:
 * [Docker bench for security](https://github.com/docker/docker-bench-security): It is a Script to check potential vulerabilities and best practices on docker deployments based on the [CIS Docker 1.6 benchmark document](https://benchmarks.cisecurity.org/tools2/docker/CIS_Docker_1.6_Benchmark_v1.0.0.pdf)

## Docker Orchestration

### Docker for Developers

Maintain Docker environment clean, use ```--rm``` when running interactive containers.

#### Docker-Compose
Docker-compose is a tool that allows us to define multiple docker-containers using a configuration file and run them with a single command.

This is an example of a docker-compose.yml configuration file:
```yaml
mongodb:
  image: mongodb
  command: '--smallfiles'
  ports:
    - "27017:27017"

zookeeper:
  image: zookeeper
  ports:
    - "2181:2181"
  environment:
    ZK_DATADIR: '/tmp/zk/data'

kafka:
  image: kafka
  ports:
    - "9092:9092"
  links:
    - zookeeper:zk
  environment:
    KAFKA_CREATE_TOPICS: "topic1:1:1,topic2:1:1"
    KAFKA_ADVERTISED_HOST_NAME: 172.17.42.1
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock

```

You can run the containers with the command (by default containers are recreated if already exist)

````
docker-compose up
````

Docker compose generates an isolated enviroment when launching based on the name of the project directory. You can set a custom project name by using the ```-p``` command line option or the COMPOSE_PROJECT_NAME environment variable

````
docker-compose -p myproject up
````

You can also specify the number of containers to run for a service. In the following example three containers will be used to run *myservice*
````
docker-compose scale myservice=3
````

### Docker for testing

#### Consistent and Reproducible Environments

Using Docker can alleviate some frustations associated with testing, first we need a consistent environment, as we have seen in the previous section, [Dockerfiles](#optimize-your-dockerfiles) are used to define an exact template for all application needs, from operating system to libraries to open ports. In the git repository for each of our projects we include a Dockerfile right along with the source code, thus anyone who pulls the project can get it up and running with a few simple commands, this way anybody will have to install all the dependencies manually and then hope it works on their own computer, since this will all be taken care of in the Docker container. This means getting up and running is fast since the host machine requires nothing installed but the Docker service itself. Along with [Docker-Compose](#docker-compose) we will obtain a **consistent and reproducible environment** very easily.

### Docker CI

* Make Use of Trusted Builds

Docker deployment solutions.

## References

* https://docs.docker.com/compose/
* https://docs.docker.com/engine/articles/dockerfile_best-practices/
* https://docs.docker.com/engine/introduction/understanding-docker/

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies

