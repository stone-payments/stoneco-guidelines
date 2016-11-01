![alt text](static/mongodb-logo.png "MongoDB")

# MongoDB Best Practices

## Index

* [Introduction](#introduction)
* [Best Practices](#best-practices)
* [References](#references)

## Introduction

MongoDB is an open-source document database that provides high performance, high availability, and automatic scaling.

A record in MongoDB is a document, which is a data structure composed of field and value pairs. The values of fields may include other documents, arrays, and arrays of documents.

The advantages of using documents are:
* Documents (i.e. objects) correspond to native data types in many programming languages.
* Embedded documents and arrays reduce need for expensive joins.
* Dynamic schema supports fluent polymorphism.

## Best Practices

### Create indexes

One of the most important things in any data base system are indexes. They are very important to improve query performance, so indexes should be created to support queries.
In the other hand, indexes spend space and, more important, maintaining much indexes makes lower inserting performance, so don’t create indexes that queries do not use.

### Always use replica sets

A replica set in MongoDB is a group of mongod processes that maintain the same data set. 
Replication provides high availability of your data if node fails in your cluster. Replica Set provides automatic failover mechanism. If your primary node fails, a secondary node will be elected as primary and your cluster will remain functional. 
In some cases, replication can provide increased read capacity as clients can send read operations to different servers.
In a replica set there always is a primary node that receives write operations and some secondaries that replicate the data thorught an oplog, applying operations asynchronously.
You should replicate with at least 3 nodes in any MongoDB deployment.

If the primary node goes down, a secondary must be elected to be the new primary. This is done with an election where each node emites a vote. Therefore, it is highly recommended to have an odd number of nodes.
If you have an even number of nodes in your replica set, and you do not want to increase your hardware for break down elections, use an arbiter node. An arbiter is a node of the replica set that do not maintain data but takes part in the election. An arbiter do not maintain data, so it is not elegible to be the primary, thus you do not need a great hardware on it.

### Your working set should fit in memory

The working set is the set of data and indexes accessed during normal operations. Proper capacity planning is important for a highly performant application
Being able to keep the working set in memory is an important factor in overall cluster performance.
MongoDB works best when the data set can reside in memory. Nothing performs better than a MongoDB instance that does not require disk I/O. 
Whenever possible select a platform that has more available RAM than your working data set size.
If you notice the number of page faults increasing, there is a very high probability that your working set is larger than your available RAM.
When this happens, you should increase your instance RAM size. If you can do it, consider using sharding to increase the amount of available RAM in a cluster.

### Scale up if your metrics show heavy use

If your instance shows a load over 60% - 65%, you should consider scaling up. Your load should be consistently below this threshold during normal operations. This also impacts recovery and vertical scaling scenarios.
At the moment you identify that you wanted to scale, you should consider sharding. By sharding, MongoDB distributes the data across sharded cluster.

### When to shard

In addition to mentioned previously, you should consider sharding if you anticipate a large data set.
Sharding may also help write performance so it is also possible that you may elect to shard even if your data set is small but requires a high amount of updates or inserts.
...

### Every mongo instance on its own machine

Mongo instances always try to use as resources as it can. So you should not run more than one instance on the same machine.
If you run more than one mongo instance in a single machine, all of that instances will fight for the same recourses.
...

###Turn journaling on by default

MongoDB supports write-ahead journaling of operations to facilitate crash recovery and node durability.
Journaling basically holds write-ahead redo logs, in the event of crash, the journal files will be used for recovery and this enables data consistency and durability.
Journal process differs depending on storage engine. Journaling is recommended storage engines that make use of disk, like MMAPv1 or the newer WiredTiger.
Nevertheless, for the new In-Memory Storage Engine of MongoDB Enterprise version 3.2.6, there is no separate journal, because its data is kept in memory.


...

## References

* [MongoDB documentation](https://docs.mongodb.com/manual/)
