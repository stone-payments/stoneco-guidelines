![alt text](static/redshift-logo.png "REDSHIFT")

# Amazon Redshift Best Practices

## Index

* [Overview](#overview)
  * [Usage Patterns](#usage-patterns)
  * [Architecture](#architecture)
  * [Columnar Storage and Compression](#columnar-storage-and-compression)
  * [Workload Management](#workload-management)
* [Designing Tables](#designing-tables)
  * [Distribution Style](#distribution-style)
  * [Sort Key](#sort-key)
  * [Encoding](#encoding)
  * [Constraints](#constraints)
* [Loading Data](#loading-data)
  * [Copy Command](#copy-command)
* [User Defined Functions](#user-defined-functions)
* [Security](#security)
  * [Authentication and Authorization](#authentication-and-authorization)
  * [Encryption](#encryption)
* [Maintenance](#maintenance)
* [References](#references)

### Overview

Amazon Redshift is a cloud-based massively parallel processing (MPP) columnar data warehouse for SQL data analytics over datasets ranging from
few hundreds of gigabytes to petabytes.

Redshift's three main design concepts are:
 - Parallel/distributed architecture
 - Columnar storage
 - Automation of common administrative tasks (provisioning, monitoring, backing up, securing...)

#### Usage Patterns

Redshift **ideal use case is large dataset online analytical processing (OLAP)** with BI tools or SQL clients.

You **SHOULD NOT** use it for:

 - **Small datasets (<100 GB)**: Redshift is architected for parallel and distributed processing over large amounts of data. For small datasets you'll get better performance using other technologies like PostgreSQL, MySQL, Aurora, etc...
 - **Transactional / Operational repositories (OLTP)**: Redshift is intended for analytical purposes and informational data. If you need a transactional system, it would be better to choose a RDMS or NoSQL database.
 - **Unstructured data**: data stored in Redshift must be defined by a formal structured schema. If you want to analyze/explore unstructured data or develop ETL tasks it is better to choose technologies like EMR, Spark, Pig, Hadoop, etc...
 - **BLOB data**: Redshift is no designed for binary data storing. If you want to store binary objects there are better alternatives such as Amazon S3.
 - **SELECT * FROM customers WHERE customer_id=123**: The Horror! The Horror! Redshift is designed for analytical workloads and uses columnar storage. Accessing arbitrary specific rows and retrieving all columns at the same time is not what you want to be doing with Redshift. For applications that access data this way there are better alternatives like RDMS or NoSQL databases.

#### Architecture

Redshift has a **Master-Slave architecture pattern** where client applications (e.g. BI tools or SQL clients) connect via **JDBC/ODBC** with
a **Leader node** that manages communication, executes query plans and distributes workloads among compute nodes.

![alt text](static/redshift-architecture.png "REDSHIFT")

**Compute nodes** store data and execute the compiled code returning intermediate results to the leader node for final aggregation. Each one has
its own dedicated CPU, memory and disk. Data is replicated across the cluster and automatically backed up in S3 for fault-tolerance purposes. Compute nodes are connected in a high-bandwidth private network with close proximity that client applications can never access directly.

Each compute node is partitioned into **slices** depending on the node size of the cluster. The number of slices determines the parallelism level of the cluster. There are two instance families for compute nodes:

 - **Dense Storage (DS)**: intended for huge datasets where disk capacity is key driver for your architecture (less slices per GB)
 - **Dense Compute (DC)**: in exchange for less disk capacity, these instances provide SSD disks and more RAM and CPU. Thus, you should use
 DC nodes when computing capacity is more important than disk capacity (more slices per GB)

In order to scale-out/in/up/down your cluster you can perform a **Resize** at any time. This process will:

 1. Put your cluster in read-only mode
 2. Provision a new cluster with the desired capacity in parallel (you only pay for the active cluster)
 3. Copy all data from the old cluster to the new one
 4. Redirect your URL to point to the new cluster (it doesn't change)
 5. Drop the old cluster

##### Columnar Storage and Compression

Columnar storage is a key design principle for the majority of analytical databases and it drastically improves performance in OLAP use cases with large datasets.

Row-wise databases save data as tuples where data blocks are stored sequentially and contain every field (column) of that row. This model is well suited for OLTP operational applications where transactions frequently read or write one or a few rows at a time and use most of the fields of that rows.

On the other hand, OLAP informational applications tend to read to large amounts of rows using a few fields as dimensions and/or aggregations. Thus, a column-wise
schema, where data is stored in blocks that contain values of the same column for different rows, is a better alternative as it **avoids reading non necessary columns and reduces the amount of data that needs to be retrieved**.

In addition to this, **this model lets us choose the best compression algorithm for each column type** reducing the volume of the data at rest, transit and memory usage. For instance, a text column could be compressed as LZO while a numeric column could use a DELTA encoding.

##### Workload Management

In order to manage concurrency and resource planning Redshift provides execution queues. Each queue can be configured with the following parameters:

 1. **Slots**: number of concurrent queries that can be executed in this queue.
 2. **Working memory**: percentage of memory assigned to this queue.
 3. **Max. Execution Time**: the amount of time a query is allowed to run before it is terminated.

Queries can be routed to different queues using Query Groups and User Groups. As a rule of thumb, is considered a best practice to have separate queues for long running resource-intensive queries and fast queries that don't require big amounts of memory and CPU.

By default, Amazon Redshift configures one queue with a **concurrency level of five**, which enables up to five queries to run concurrently, plus one predefined Superuser queue, with a concurrency level of one. You can define up to eight queues. Each queue can be configured with a maximum concurrency level of 50. The maximum **total concurrency level for all user-defined queues (not including the Superuser queue) is 50.**

### Designing Tables

Working with large datasets requires a high degree of resource optimization and we often find I/O, CPU, Memory or Disk bottlenecks due to wrong table designs.

In order to optimize your cluster you should understand and properly design your tables with these three concepts in mind:

 1. Data distribution (sharding)
 2. Sorting
 3. Encoding (compression)

#### Distribution Style

Table distribution style determines **how data is distributed across compute nodes** and we have three options:

##### Key

A single column acts as distribution key (DISTKEY). As a rule of thumb you should choose a column that:

 1. **Is uniformly distributed.** Otherwise skew data will cause unbalances in the volume of data that will be stored in each compute node leading to undesired situations where some slices will process bigger amounts of data than others and causing bottlenecks.
 2. If this table is related with dimensions tables (star-schema), it is better to **choose as DISTKEY the field that acts as the JOIN field with the larger dimension table.** This way, related data (same join-field values) will reside in the same node, **reducing the amount of data that needs to be broadcasted through the network**.

##### Even

Default. **Data is distributed automatically using a round-robin algorithm.** This is better when the table does not take part in joins or it is not clear which column can act as DISTKEY.

##### All

The whole **table is replicated in every compute node**. This distribution style is intended for small tables that don't change too often. For instance, small dimension tables are good candidates. Having data available in each compute node reduces the amount of data that needs to be broadcasted through the network when executing joins.

#### Sort Key

Sort keys define in which order data will be stored. You can define only one sort key per table, but it can be composed with one or more columns. The are two kinds of sort keys in Redshift: Compound and Interleaved.

When you load data in a table for the first time it will be stored in order and Redshift will register metadata with max and min sortkey values for each disk block in a **zone map**. This zone map will be used for the query planner to prune the search tree and drastically improve execution plans for range-restricted queries.

If you add unsorted rows to a table that is already sorted is a best practice to perform **VACUUM SORT ONLY [tablename]** in order to obtain the maximum performance from your sortkey.

##### Compound Keys

This is the default mode. You can specify more than one column as SORTKEY. Data will be sorted using SORTKEY definition order: first column will act as the first order key, second column next and so on.

Zone maps with compound keys provide better performance when pruning occurs in the leading columns and decreases if we use the trailing ones. Thus, this kind of keys are recommended when there is a clear column candidate mostly used for sorting and filtering data.

As rule of thumb, you should select columns with range or equality filtering in WHERE clauses. For instance, timestamp columns in fact tables tend to be good candidates. It is also considered a best practice to use the primary key (id) as the sortkey for secondary dimension tables.

##### Interleaved Sort Keys

Performing ad-hoc multi-dimensional analytics often requires pivoting, filtering and grouping data using different columns as query dimensions. This leads to scenarios where compound key ordering is not flexible enough and performance decreases.

Interleaved Sort Keys is Amazon Redshift implementation for **Z-order curve** ordering. This model is preferable when dealing with muli-dimensional analytics as it provides worst performance than compound keys for the leading columns but better average performance for the whole sortkey if we use different arbitrary.

#### Encoding

As discussed above, columnar storage let us chose the best compression/encoding model for each row. There are two ways to setup encodings:

1. If you load data into an empty table the for the first time with the **COPY command**, then Redshift will automatically apply the best compression based in a sample of the data (be sure that this data is a good sample of the whole dataset for that table).

2. You can run the **ANALYZE COMPRESSION [tablename]** command at any moment to obtain a list of recommended encodings for your table. This is useful when the COPY command is not an option (for instance, SELECT INSERT). As a best practice, you can load a sample of your data into an empty table, then run ANALYZE COMPRESSION, then create a new table with the recommended encodings and load your dataset into the new table.

**You cannot change column encodings once created**.

#### Constraints

You can create **UNIQUE, PRIMARY KEY and FOREIGN KEY** constraints in Redshift but only with informational purposes. **Redshift does not perform integrity checks for these constraints**. Anyway, creating constraints is a best practice since it provides useful information for the query planner in order to optimize executions.

You can also create **NOT NULL** constraints. **Redshift does enforce NOT NULL column constraints.**

### Loading Data

You can load data in your tables using the three following methods:

1. Using Multi-Row INSERT
2. Using Bulk INSERT
3. Using COPY command

It's strongly recommended to use COPY command in the mayority of the cases and avoid the use of Multi-Row inserts. Specially when you need to load large amount of data from outside cluster.

#### Copy Command

You can use COPY command to load data from Amazon DynamoDB , Amazon EMR , Amazon S3 or from many hosts by ssh protocol in parallel. Copy command load data more efficiently than inserts and store the data more efficiently too.

There are some best practices that you can use in order to improve your COPY commands performance

##### Use a Single COPY Command to Load from Multiple Files

If you want to load multiple files into a table you should use a single copy command and Redshift automatically will load those files in parallel. If you specify multiple COPY commands to load one table from multiple files, Amazon Redshift is forced to perform a serialized load, which is much slower.

##### Split Your Load Data into Multiple Files

You can parallelize your loads by split your data into multiple files. Using this method the COPY command divides the workload among the nodes in your cluster. If you try to load all the data form a single large file Redshift is force to perform a serialized load wich is much slower.

It is a good practice to divide your data in multiple files with equal size ( between 1MB and 1GB ) and that the number of files be a multiple of the number of **slices in your cluster**. In this way the workload is distributed uniformly in your cluster.

##### Use a Manifest File

Amazon S3 provides **eventual consistency** for some operations, so it is possible that new data will not be available immediately after the upload, which could result in an incomplete data load or loading stale data. You can manage data consistency by using a manifest file to load data. In addition with the Manifest file you can specify different S3 locations in a more efficient way that with the use of S3 prefixes.

##### Compress Your Data Files

If you have to load large amount of data ( more that 50MB ) in a Redshift table is a good practice to compress that data. If your priority is to reduce the time spent by COPY commands you should use **LZO compession**. In the other hand if your priority is to reduce the size of the files in S3 and your network bandwitch you should use **BZ2 compression**.

Avoid to use compression if you have small amount of data because the benefit of compression would be outweighed by the processing cost of decompression.

##### Load Data in Sort Key Order

Load your data in sort key order to avoid needing to vacuum.

As long as each batch of new data follows the existing rows in your table, your data will be properly stored in sort order, and you will not need to run a vacuum. You don't need to presort the rows in each load because COPY sorts each batch of incoming data as it loads.

##### Load Data using IAM role

In order to avoid to expose your AWS Access Key and Secret Key in your queries it is a good practice to use a IAM Role.  

You must follow the next steps in order to use COPY command with a IAM Role:

1. Create an IAM role for use with your Amazon Redshift cluster.
2. Associate the IAM role with the cluster.
3. Include the IAM role's ARN when you call the COPY command.

### User Defined Functions

TBD

### Security

Security is an important point to keep in mind specially if your cluster work with sensitive data. It is important to protect your data and control efficiently how your cluster is accessed.

Like other AWS services network access to your cluster is managed by VPCs and security grops, it is a best practice to open your cluster SG only to some specific AWS Services and IPs and not open your cluster to the Internet.

#### Authentication and Authorization

Like other databases Redshift can grant different permission to different database users over one or multiple tables and schemes. If you have multiple users with different roles is a good practice to define groups with different users and grant permissions to that groups and not to singular users.

You should avoid the use or distribution of database owner user credentials in production clusters. You must create *superusers* with the same privileges as database owner and use that credentials only for some maintenance tasks.


#### Encryption

It is a good practice to enable encryption in your cluster specially if you store sensitive data in your cluster. When you enable encryption the data blocks , system metadata and backups are encrypted.

You can choose between AWS Key Management Service (AWS KMS) or a hardware security module (HSM) to manage the top-level encryption key. In the mayority of the cases AWS KMS is the best option becase are automatically integrated with Redshift.

**If you want to go from an encrypted cluster to an unencrypted cluster or the other way around, you must unload your data from the existing cluster and reload it in a new cluster with the chosen encryption setting.**

### Maintenance

It is a best practice to define weekly or daily maintenance task for your clusters. Running ANALYZE and VACUUM regularly is important in order to keep statistics up to date, data sorted and free and reclaim disk space occupied by rows that were marked for deletion.

### References

- [Amazon Redshift Documentation](https://aws.amazon.com/documentation/redshift/ "Amazon Redshift Documentation")
- [Optimizing for Star Schemas and Interleaved Sorting on Amazon Redshift](https://blogs.aws.amazon.com/bigdata/post/Tx1WZP38ERPGK5K/Optimizing-for-Star-Schemas-and-Interleaved-Sorting-on-Amazon-Redshift "Optimizing for Star Schemas and Interleaved Sorting on Amazon Redshift")
- [Understanding Interleaved Sort Keys in Amazon Redshift](https://blog.chartio.com/blog/understanding-interleaved-sort-keys-in-amazon-redshift-part-1 "Understanding Interleaved Sort Keys in Amazon Redshift")
- [Top 10 Performance Tuning Techniques for Amazon Redshift](https://blogs.aws.amazon.com/bigdata/post/Tx31034QG0G3ED1/Top-10-Performance-Tuning-Techniques-for-Amazon-Redshift "Top 10 Performance Tuning Techniques for Amazon Redshift")
- [Best Practices for Micro-Batch Loading on Amazon Redshift](http://blogs.aws.amazon.com/bigdata/post/Tx2ANLN1PGELDJU/-Best-Practices-for-Micro-Batch-span-class-matches-Loading-span-on-Amazon-Redshi "Best Practices for Micro-Batch Loading on Amazon Redshift")
- [Z Order Curve](https://en.wikipedia.org/wiki/Z-order_curve "Z Order Curve")
- [Amazon Redshift Best Practices for Loading Data](http://docs.aws.amazon.com/redshift/latest/dg/c_loading-data-best-practices.html "Amazon Redshift Best Practices for Loading Data")
- [Copy Unload IAM Role](http://docs.aws.amazon.com/redshift/latest/mgmt/copy-unload-iam-role.html "Copy Unload IAM Role")
- [Redshift Database Benchmarks: COPY Performance with Compressed Files](https://blog.stitchdata.com/redshift-database-benchmarks-copy-performance-with-compressed-files-2041b8098366#.lkaltc20l "Redshift Database Benchmarks: COPY Performance with Compressed Files")
- [Amazon Redshift Database Encryption](http://docs.aws.amazon.com/redshift/latest/mgmt/working-with-db-encryption.html "Amazon Redshift Database Encryption")
