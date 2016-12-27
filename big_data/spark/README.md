![alt text](static/spark-logo.png "SPARK")

# Spark Best Practices

## Index

* [Writing applications](#writing-applications)
* [Packing applications](#packing-applications)
* [Launching applications](#launching-applications)
* [Testing](#testing)
* [Tuning and debugging](#tuning-and-debugging)
* [Spark on EMR](#spark-on-emr)
* [References](#references)

### Writing applications

#### SparkContext

SparkContext object represents a connection to the spark computing cluster. Every spark application needs to configure and intialize a SparkContext. A SparkConf class instance can be created and passed to configure SparkContext initialization.

````scala
val conf = new SparkConf()
conf.set("spark.app.name", "MyApp")
conf.set("spark.ui.port", "36000")
val sc = new SparkContext(conf)
````
The list of properties that can be defined can be found [here](http://spark.apache.org/docs/latest/configuration.html#spark-properties)

Note that these properties can also be set as arguments of spark-submit


#### Transformations and actions

Do not return all the elements of a large RDD back to the driver. Avoid using collect and count on large RDDS, use instead take or takeSample to control the number of elements returned. Be careful using actions like  countByKey, countByValue, collectAsMap.

Avoid using groupByKey. Consider using the following two functions instead:
* combineByKey can be used when you are combining elements but your return type differs from your input value type.
* foldByKey merges the values for each key using an associative function and a neutral "zero value".
* reduceByKey is preferred to perform an associative reduction operation. For example, rdd.groupByKey().mapValues(_.sum) will produce the same results as rdd.reduceByKey(_ + _) but the latter will perform local sums before sending the values to combine after shuffling.

Avoid using reduceByKey when the output value type differs from the input type of elements to reduce. To reduce all elements into a collection of elements consider using aggregateByKey instead.

Avoid using the flatMap + join + groupBy pattern. When two datasets are already grouped by key and you want to join them and keep them grouped, you can just use cogroup.

Chose the transformations in order to minimize the number of shuffles. Use shuffle operations to increase or decrease the level of parallelism by repartition rdds instead of calling repartition alone.

One exception to the general rule of trying to minimize the shuffles is when you force them to increase parallelism. For example, when you process a few large unsplittable files and after loading them they have not been splitted into enough partitions to take advantage of all the available cores. In this scenario invoking repartiton with a high number of partitions is preferred.

#### Broadcast variables and accumulators

[Broadcast variables](http://spark.apache.org/docs/latest/programming-guide.html#broadcast-variables) allow the programmer to keep a read-only variable cached on each machine rather than shipping a copy of it with tasks. They can be used, for example, to give every node a copy of a large input dataset in an efficient manner. Spark also attempts to distribute broadcast variables using efficient broadcast algorithms to reduce communication cost.

Broadcast variables are created on the driver, and are read-only from executors. The distribution of these variables across the cluster is made through an efficient p2p broadcast algorithm, so they can be used to distribute large input datasets in an efficient manner. Take into account that once one variable has been defined and broadcasted, its value can't be updated.

Usage example: If you have huge array that is accessed from Spark Closures, for example some reference data, this array will be shipped to each spark node with closure. For example if you have 10 nodes cluster with 100 partitions (10 partitions per node), this Array will be distributed at least 100 times (10 times to each node). Using a broadcast variable you'll get huge performance benefit.

[Accumulators](http://spark.apache.org/docs/latest/programming-guide.html#accumulators-a-nameaccumlinka) are variables that are only “added” to through an associative operation and can therefore be efficiently supported in parallel. They can be used to implement counters (as in MapReduce) or sums. Spark natively supports accumulators of numeric types, and programmers can add support for new types. If accumulators are created with a name, they will be displayed in Spark’s UI. This can be useful for understanding the progress of running stages (NOTE: this is not yet supported in Python).


#### Spark Streaming

Spark Streaming is not a pure streaming architecture. If the microbatches do not provide a low enough latency for your processing, you may need to consider a different framework, e.g. Storm, Samza, or Flink.

It is much more efficient for large windows to use the extended windowed transformations passing an inverse function like:
* reduceByWindow(reduceFunc: (T, T) ⇒ T, invReduceFunc: (T, T) ⇒ T, windowDuration: Duration, slideDuration: Duration): DStream[T]
* reduceByKeyAndWindow(reduceFunc: (V, V) ⇒ V, invReduceFunc: (V, V) ⇒ V, windowDuration: Duration, slideDuration: Duration, partitioner: Partitioner, filterFunc: ((K, V)) ⇒ Boolean): DStream[(K, V)].


Use the pattern foreachRDD-foreachPartition to reuse external connections.

Bad:
````scala
dstream.foreachRDD { rdd =>
  val connection = createNewConnection()
  rdd.foreach { record =>
    connection.send(record) // executed at the worker
  }
}
````

Good:
````scala
dstream.foreachRDD { rdd =>
  rdd.foreachPartition { partitionOfRecords =>
    val connection = createNewConnection()
    partitionOfRecords.foreach(record => connection.send(record))
    connection.close()
  }
}
````

Even better:
````scala
dstream.foreachRDD { rdd =>
  rdd.foreachPartition { partitionOfRecords =>
    val connection = ConnectionPool.getConnection()
    partitionOfRecords.foreach(record => connection.send(record))
    ConnectionPool.returnConnection(connection)  // return to the pool for future reuse
  }
}
````

Windowed stateful transformations requires enabling checkpointing. Checkpointing also can be optionally enabled for recovery from driver failures. To enable checkpointing you need to use StreamingContext.getOrCreate as follows:
````scala
def functionToCreateContext(): StreamingContext = {
    val ssc = new StreamingContext(...)   
    val lines = ssc.socketTextStream(...)
    ...
    ssc.checkpoint(checkpointDirectory)
    ssc
}

val context = StreamingContext.getOrCreate(checkpointDirectory, functionToCreateContext _)
````

If the cluster resources is not large enough for the streaming application to process data as fast as it is being received, the receivers can be rate limited by setting a maximum rate limit in terms of records/sec. This can be achieved setting the configuration parameter spark.streaming.receiver.maxRate (spark.streaming.kafka.maxRatePerPartition for Direct Kafka approach). From spark 1.5 you can set spark.streaming.backpressure.enabled to let Spark Streaming automatically figure out the rate limits and dynamically adjust them if the processing conditions change.

### Packing applications


If your code depends on other projects, you will need to package them alongside your application in order to distribute the code to a Spark cluster. To do this, create an assembly jar (or “uber” jar) containing your code and its dependencies. Both sbt and Maven have assembly plugins. When creating assembly jars, list Spark and Hadoop as provided dependencies; these need not be bundled since they are provided by the cluster manager at runtime. Once you have an assembled jar you can call the bin/spark-submit script as shown later while passing your jar.

build.sbt example:

````scala
import AssemblyKeys._

name := "ExampleApp"

version := "1.0"

scalaVersion := "2.10.4"

val SPARK_VERSION = "1.5.2"

libraryDependencies += "org.apache.spark" %% "spark-core" % SPARK_VERSION
libraryDependencies += "org.apache.spark" %% "spark-mllib" % SPARK_VERSION
libraryDependencies += "org.apache.spark" %% "spark-sql" % SPARK_VERSION
libraryDependencies += "org.apache.spark" %% "spark-streaming" % SPARK_VERSION
libraryDependencies += "com.google.code.gson" % "gson" % "2.3"
libraryDependencies += "commons-cli" % "commons-cli" % "1.2"

resolvers += "Akka Repository" at "http://repo.akka.io/releases/"

assemblySettings

mergeStrategy in assembly := {
  case m if m.toLowerCase.endsWith("manifest.mf")          => MergeStrategy.discard
  case m if m.toLowerCase.matches("meta-inf.*\\.sf$")      => MergeStrategy.discard
  case "log4j.properties"                                  => MergeStrategy.discard
  case m if m.toLowerCase.startsWith("meta-inf/services/") => MergeStrategy.filterDistinctLines
  case "reference.conf"                                    => MergeStrategy.concat
  case _                                                   => MergeStrategy.first
}
````

For Python, you can use the --py-files argument of spark-submit to add .py, .zip or .egg files to be distributed with your application. If you depend on multiple Python files we recommend packaging them into a .zip or .egg.

### Launching applications

#### Driver/executors

Spark applications run as independent sets of processes on a cluster, coordinated by the SparkContext object in your main program (called the driver program).

Specifically, to run on a cluster, the SparkContext can connect to several types of cluster managers (either Spark’s own standalone cluster manager, Mesos or YARN), which allocate resources across applications. Once connected, Spark acquires executors on nodes in the cluster, which are processes that run computations and store data for your application. Next, it sends your application code (defined by JAR or Python files passed to SparkContext) to the executors. Finally, SparkContext sends tasks to the executors to run.

<p align="center"><img source="static/cluster-overview.png"/></p>

There are several useful things to note about this architecture:

* Each application gets its own executor processes, which stay up for the duration of the whole application and run tasks in multiple threads. This has the benefit of isolating applications from each other, on both the scheduling side (each driver schedules its own tasks) and executor side (tasks from different applications run in different JVMs). However, it also means that data cannot be shared across different Spark applications (instances of SparkContext) without writing it to an external storage system.
* Spark is agnostic to the underlying cluster manager. As long as it can acquire executor processes, and these communicate with each other, it is relatively easy to run it even on a cluster manager that also supports other applications (e.g. Mesos/YARN).
* The driver program must listen for and accept incoming connections from its executors throughout its lifetime (e.g., see spark.driver.port and spark.fileserver.port in the network config section). As such, the driver program must be network addressable from the worker nodes.
* Because the driver schedules tasks on the cluster, it should be run close to the worker nodes, preferably on the same local area network. If you’d like to send requests to the cluster remotely, it’s better to open an RPC to the driver and have it submit operations from nearby than to run a driver far away from the worker nodes.


#### Cluster manager types

The system currently supports three cluster managers:

* Standalone – a simple cluster manager included with Spark that makes it easy to set up a cluster.
* Apache Mesos – a general cluster manager that can also run Hadoop MapReduce and service applications.
* Hadoop YARN – the resource manager in Hadoop 2.

#### Spark-submit options

A common deployment strategy is to submit your application from a gateway machine that is physically co-located with your worker machines (e.g. Master node in a standalone EC2 cluster). In this setup, client mode is appropriate. In client mode, the driver is launched directly within the spark-submit process which acts as a client to the cluster. The input and output of the application is attached to the console. Thus, this mode is especially suitable for applications that involve the REPL (e.g. Spark shell).

Alternatively, if your application is submitted from a machine far from the worker machines (e.g. locally on your laptop), it is common to use cluster mode to minimize network latency between the drivers and the executors. Note that cluster mode is currently not supported for Mesos clusters. Currently only YARN supports cluster mode for Python applications.

[Click here](http://spark.apache.org/docs/latest/submitting-applications.html) for more information about this topic

Examples:
````shell
# Run application locally on 8 cores
./bin/spark-submit \
  --class org.apache.spark.examples.SparkPi \
  --master local[8] \
  /path/to/examples.jar \
  100

# Run on a Spark standalone cluster in client deploy mode
./bin/spark-submit \
  --class org.apache.spark.examples.SparkPi \
  --master spark://207.184.161.138:7077 \
  --executor-memory 20G \
  --total-executor-cores 100 \
  /path/to/examples.jar \
  1000

# Run on a Spark standalone cluster in cluster deploy mode with supervise
./bin/spark-submit \
  --class org.apache.spark.examples.SparkPi \
  --master spark://207.184.161.138:7077 \
  --deploy-mode cluster
  --supervise
  --executor-memory 20G \
  --total-executor-cores 100 \
  /path/to/examples.jar \
  1000

# Run on a YARN cluster
export HADOOP_CONF_DIR=XXX
./bin/spark-submit \
  --class org.apache.spark.examples.SparkPi \
  --master yarn-cluster \  # can also be `yarn-client` for client mode
  --executor-memory 20G \
  --num-executors 50 \
  /path/to/examples.jar \
  1000

# Run a Python application on a Spark standalone cluster
./bin/spark-submit \
  --master spark://207.184.161.138:7077 \
  examples/src/main/python/pi.py \
  1000

````

### Testing
For testing you can create fixtures that initializes the spark context and loads the data/creates the streams to start processing each test. If you are using python you need to explicitly load the pyspark path prior to the initialization of the SparkContext. You can use the following function to load pyspark into the python path:

````python
def add_pyspark_path(spark_home):
    """Add PySpark to the library path based on the value of SPARK_HOME. """
    try:
        os.environ["SPARK_HOME"] = spark_home
        sys.path.append(os.path.join(spark_home, 'python'))
        py4j_src_zip = glob(os.path.join(spark_home, 'python',
                                         'lib', 'py4j-*-src.zip'))
        if len(py4j_src_zip) == 0:
            raise ValueError('py4j source archive not found in %s'
                             % os.path.join(spark_home, 'python', 'lib'))
        else:
            py4j_src_zip = sorted(py4j_src_zip)[::-1]
            sys.path.append(py4j_src_zip[0])
    except KeyError:
        print("""SPARK_HOME was not set. please set it. e.g.
        SPARK_HOME='/.../spark' ./bin/pyspark [program]""")
        exit(-1)
    except ValueError as e:
        print(str(e))
        exit(-1)
````
For python applications, you need to specify all the dependencies of the application using the --py-files argument of spark-submit. As there is no "assembly with all dependencies included" solution, if you have a lot of dependencies you can also set the enviromental variables PYSPARK_PYTHON on the executors and PYSPARK_DRIVER_PYTHON on the driver to customize the python binary executable to use (Where you can pre-load all the dependencies).

### Tuning and debugging

#### Data Serialization

By default, Spark serializes objects using Java’s ObjectOutputStream framework, and can work with any class you create that implements java.io.Serializable. You can also control the performance of your serialization more closely by extending java.io.Externalizable. Java serialization is flexible but often quite slow, and leads to large serialized formats for many classes.

Spark can also use the Kryo library (version 2) to serialize objects more quickly. Kryo is significantly faster and more compact than Java serialization (often as much as 10x), but does not support all Serializable types and requires you to register the classes you’ll use in the program in advance for best performance. This setting configures the serializer used for not only shuffling data between worker nodes but also when serializing RDDs to disk. The only reason Kryo is not the default is because of the custom registration requirement, but we recommend trying it in any network-intensive application.

To register your own custom classes with Kryo, use the registerKryoClasses method.

````scala
val conf = new SparkConf().setMaster(...).setAppName(...)
conf.registerKryoClasses(Array(classOf[MyClass1], classOf[MyClass2]))
val sc = new SparkContext(conf)
````

#### Memory Tuning

This topic is discussed [here](http://spark.apache.org/docs/latest/tuning.html#memory-tuning)

#### Level of Parallelism

Clusters will not be fully utilized unless you set the level of parallelism for each operation high enough. Spark automatically sets the number of “map” tasks to run on each file according to its size (though you can control it through optional parameters to SparkContext.textFile, etc), and for distributed “reduce” operations, such as groupByKey and reduceByKey, it uses the largest parent RDD’s number of partitions. You can pass the level of parallelism as a second argument (see the spark.PairRDDFunctions documentation), or set the config property spark.default.parallelism to change the default. In general, we recommend 2-3 tasks per CPU core in your cluster.

#### Memory Usage of Reduce Tasks

Sometimes, you will get an OutOfMemoryError not because your RDDs don’t fit in memory, but because the working set of one of your tasks, such as one of the reduce tasks in groupByKey, was too large. Spark’s shuffle operations (sortByKey, groupByKey, reduceByKey, join, etc) build a hash table within each task to perform the grouping, which can often be large. The simplest fix here is to increase the level of parallelism, so that each task’s input set is smaller. Spark can efficiently support tasks as short as 200 ms, because it reuses one executor JVM across many tasks and it has a low task launching cost, so you can safely increase the level of parallelism to more than the number of cores in your clusters.

#### Broadcasting Large Variables

Using the broadcast functionality available in SparkContext can greatly reduce the size of each serialized task, and the cost of launching a job over a cluster. If your tasks use any large object from the driver program inside of them (e.g. a static lookup table), consider turning it into a broadcast variable. Spark prints the serialized size of each task on the master, so you can look at that to decide whether your
tasks are too large; in general tasks larger than about 20 KB are probably worth optimizing.

#### Data Locality

Data locality is how close data is to the code processing it. There are several levels of locality based on the data’s current location. In order from closest to farthest:

* PROCESS_LOCAL data is in the same JVM as the running code. This is the best locality possible
* NODE_LOCAL data is on the same node. Examples might be in HDFS on the same node, or in another executor on the same node. This is a little slower than PROCESS_LOCAL because the data has to travel between processes
* NO_PREF data is accessed equally quickly from anywhere and has no locality preference
* RACK_LOCAL data is on the same rack of servers. Data is on a different server on the same rack so needs to be sent over the network, typically through a single switch
* ANY data is elsewhere on the network and not in the same rack

Spark prefers to schedule all tasks at the best locality level, but this is not always possible. In situations where there is no unprocessed data on any idle executor, Spark switches to lower locality levels. There are two options: a) wait until a busy CPU frees up to start a task on data on the same server, or b) immediately start a new task in a farther away place that requires moving data there.

What Spark typically does is wait a bit in the hopes that a busy CPU frees up. Once that timeout expires, it starts moving the data from far away to the free CPU. The wait timeout for fallback between each level can be configured individually or all together in one parameter; see the spark.locality parameters on the configuration page for details. You should increase these settings if your tasks are long and see poor locality, but the default usually works well.

#### Tuning links

[Tuning and performance optimization guide for Spark 1.5.2](http://spark.apache.org/docs/latest/tuning.html)

[Spark Streaming programming guide and tutorial for Spark 1.5.2](http://spark.apache.org/docs/latest/streaming-programming-guide.html#performance-tuning)

[How-to: Tune Your Apache Spark Jobs (Part 1) - Cloudera Engineering Blog](http://blog.cloudera.com/blog/2015/03/how-to-tune-your-apache-spark-jobs-part-1/)

[How-to: Tune Your Apache Spark Jobs (Part 2) - Cloudera Engineering Blog](http://blog.cloudera.com/blog/2015/03/how-to-tune-your-apache-spark-jobs-part-2/)

#### Debugging spark applications

Set spark.executor.extraJavaOptions to include: “-XX:-PrintGCDetails -XX:+PrintGCTimeStamps” and look for long GC times on executor output

Use jmap to perform heap analysis:
* jmap -histo [pid] to get a histogram of objects in the JVM heap
* jmap -finalizerinfo [pid] to get a list of pending finalization objects (possible memory leaks)

Use jstack/ jconsole/ visualvm or other JVM profiling tool. Configure JVM arguments setting spark.executor.extraJavaOptions


### Spark on EMR
#### Launching applications

You can use Amazon EMR Steps to submit work to the Spark framework installed on an EMR cluster. In the console and CLI, you do this using a Spark application step, which will run the spark-submit script as a step on your behalf. With the API, you use a step to invoke spark-submit using script-runner.jar.

[Here](http://docs.aws.amazon.com/ElasticMapReduce/latest/DeveloperGuide/emr-spark-submit-step.html) you can find detailed information about this topic.

#### Connecting to EMR cluster instances
* Access to SparkUI:

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[1) Setup an ssh tunnel to the EMR master node](http://docs.aws.amazon.com/ElasticMapReduce/latest/DeveloperGuide/emr-ssh-tunnel.html)

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[2) Install foxyproxy plugin in your browser](http://docs.aws.amazon.com/ElasticMapReduce/latest/DeveloperGuide/emr-connect-master-node-proxy.html)

* [Default ports used](http://docs.aws.amazon.com/ElasticMapReduce/latest/DeveloperGuide/emr-web-interfaces.html)
* YARN web UI: http://public-ip:9026/cluster
* Spark app web UI: http://{public-ip}:9046/proxy/{app-id}/

#### EMR and S3

If you terminate a running cluster, any results that have not been persisted to Amazon S3 will be lost and all Amazon EC2 instances will be shut down so you should persist all the information you want to keep to S3. It isn't a good practice to write intermediate RDDs to S3 due to IO performance.

EMRFS is an implementation of HDFS used for reading and writing regular files from Amazon EMR directly to Amazon S3. EMRFS provides the convenience of storing persistent data in Amazon S3 for use with Hadoop while also providing features like Amazon S3 server-side encryption, read-after-write consistency, and list consistency.

Note
Previously, Amazon EMR used the S3 Native FileSystem with the URI scheme, s3n. While this still works, we recommend that you use the s3 URI scheme for the best performance, security, and reliability.

Example: s3://bucket-name/path-to-file-in-bucket


### References

* [Learning spark](http://shop.oreilly.com/product/0636920028512.do)
* [Spark best practices by databricks](https://databricks.gitbooks.io/databricks-spark-knowledge-base/content/best_practices/README.html)
* [Advanced spark training](https://databricks-training.s3.amazonaws.com/slides/advanced-spark-training.pdf)
* [Spark programming guide](http://spark.apache.org/docs/latest/programming-guide.html)
* [Spark streaming programming guide](http://spark.apache.org/docs/latest/streaming-programming-guide.html)

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
