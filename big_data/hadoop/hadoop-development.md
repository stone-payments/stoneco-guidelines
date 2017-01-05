![alt text](static/hadoop_logo.png "Hadoop")

# HADOOP Development & Best Practices
At its core, Hadoop is a distributed data store that provides a platform for implementing powerful parallel processing frameworks. 

There are a number of file formats and compression formats. Each has particular strengths that make it better suited to specific applications. Additionally, although Hadoop provides the Hadoop Distributed File System (HDFS) for storing data, there are several commonly used systems implemented on top of HDFS, such as HBase for additional data access functionality and Hive for additional data management functionality. Such systems need to be taken into consideration as well.

This document defines some architectural patterns and guidelines to apply in determining how to optimally store your data in any batch Hadoop applications.

![alt text](https://github.com/beeva/beeva-best-practices/blob/master/static/horizontal-beeva-logo.png "BEEVA")

## Index

* [Data storage options](#data-storage)
	* [File format](#format)
	* [Compression](#compression)</br>
	* [Data storage system](#storage)</br>
* [How to select the correct file format](#how-formats)
	* [Metadata: data about the data](#metadata)
	* [Choosing a solution](#choosing)
* [HBase Schema Design](#hbase)
* [Data life cycle](#lifecycle)


<a name="data-storage"/>
## Data storage options

Hadoop allows data storage in any format, no matter whether it’s text, binary, images, etc.
Hadoop also provides built­in support for a number of formats optimized for Hadoop storage and
processing. It’s preferable to use one of the Hadoop specific container formats. You can also
store source data in its raw form to perform new processing and analytics with the data as
requirements change. This means users have complete control and a number of options for how data is stored in Hadoop.

<a name="format"/>
### File format

There are multiple formats that are suitable for data stored in Hadoop. They can be classified in two groups:

**Standard formats**

* Text data​: mainly csv, tsv but also emails, etc. There is an overhead of type conversion associated with storing data in text format.
* Structured text Data​: XML, JSON. Splitting XML and JSON files for processing is tricky,
and Hadoop does not provide a built­in Input-Format for either of these formats. You can
use a library designed for processing XML or JSON files (XMLLoader of PiggyBank
library or Elephant Bird project).
* Binary data: ​Used to process binary files such as images. Using a container format such
as SequenceFile is preferred. If the splittable unit of binary data is larger than 128 MB,
you may consider putting the data in it’s own file, without using a container format.
Depending on the use case, binary data can also be stored in HBase.


**Hadoop file formats**

Hadoop file formats offer splittable, agnostic compression (the file can be compressed with any
compression codec, without readers having to know the codec. This is possible because the
codec is stored in the header metadata of the file format).
* File based data structures: Sequence files, MapFiles, SetFiles, ArrayFiles,
BloomMapFiles.
* Serialization formats: Thrift, Avro.
* Columnar format: RCFiles and Parquet.

<a name="compression"/>
### Compression
File compression brings two major benefits: it reduces the space needed to store files, and it speeds up data transfer across the network or to or from disk
<dl>
<dt>gzip</dt> 
gzip is naturally supported by Hadoop. gzip is based on the DEFLATE algorithm, which is a combination of LZ77 and Huffman Coding.

<dt>bzip2</dt> 
bzip2 is a freely available, patent free (see below), high-quality data compressor. It typically compresses files to within 10% to 15% of the best available techniques (the PPM family of statistical compressors), whilst being around twice as fast at compression and six times faster at decompression.

<dt>LZO</dt> 
The LZO compression format is composed of many smaller (~256K) blocks of compressed data, allowing jobs to be split along block boundaries.  Moreover, it was designed with speed in mind: it decompresses about twice as fast as gzip, meaning it’s fast enough to keep up with hard drive read speeds.  It doesn’t compress quite as well as gzip — expect files that are on the order of 50% larger than their gzipped version.  But that is still 20-50% of the size of the files without any compression at all, which means that IO-bound jobs complete the map phase about four times faster.

<dt>Snappy</dt> 
Snappy is a compression/decompression library. It does not aim for maximum compression, or compatibility with any other compression library; instead, it aims for very high speeds and reasonable compression. For instance, compared to the fastest mode of zlib, Snappy is an order of magnitude faster for most inputs, but the resulting compressed files are anywhere from 20% to 100% bigger. On a single core of a Core i7 processor in 64-bit mode, Snappy compresses at about 250 MB/sec or more and decompresses at about 500 MB/sec or more. Snappy is widely used inside Google, in everything from BigTable and MapReduce to our internal RPC systems.

</dl>
<a name="storage"/>
### Data storage system

While all data in Hadoop rests in HDFS, there are decisions around what the underlying storage manager should be—for example, whether you should use HBase or HDFS directly to store the data. Additionally, tools such as Hive and Impala allow you to define additional structure around your data in Hadoop.

<a name="how-formats"/>
## How to select the correct file format?

To select the correct file format, you should consider the following topics:

**What processing and query tools will you be using?**

It is expected that most of the tools will end up supporting most of the popular formats,
but you must do double­check before you make any final decision.

**Will your data structure change over time?**
Do you want to add and delete fields from a file and still be able to read old files with the
same code?.

**How important is file format “splittability”?**

Since Hadoop stores and processes data in blocks you must be able to begin reading
data at any point within a file in order to take fullest advantage of Hadoop’s distributed
processing. For example, CSV files are splittable since you can start reading at any line
in the file and the data will still make sense; however, an XML file is not splittable since
XML has an opening tag at the beginning and a closing tag at the end. You cannot start
processing at any point in the middle of those tags.

**Does block compression matter?**

Since Hadoop stores large files by splitting them into blocks, it’s best if the blocks can be
independently compressed. If a file format does not support block compression then, if
compressed, the file is rendered non­splittable. When processed, the decompressor
must begin reading the file at its beginning in order to obtain any block within the file. For
a large file with many blocks, this could generate a substantial performance penalty.

**How big are your files?**

If your files are smaller than the size of an HDFS block, then splittability and block
compression don’t matter. You may be able to store the data uncompressed or with a
simple file compression algorithm. Of course, small files are the exception in Hadoop and
processing too many small files can cause performance issues. Hadoop wants large,
splittable files.

**Are you more concerned about processing or query performance?**
* Write performance​: how fast can the data be written.
* Partial read performance​: how fast can you read individual columns within a file.
* Full read performance​: how fast can you read every data element in a file.

**Other considerations to take in mind**​:
* Hadoop Distribution:​Cloudera and Hortonworks support/favor different formats.
* Schema Evolution​: Will the structure of your data evolve? In what way?. Avro is great if
your schema is going to change over time, but query performance will be slower than
ORC or Parquet.
* Processing Requirements​: Will you be crunching the data and with what tools?.
* Read/Query Requirements​: Will you be using SQL on Hadoop? Which engine?.
* Extract Requirements​: Will you be extracting the data from Hadoop for import into an
external database engine or other platform?.
* Storage Requirements​: Is data volume a significant factor? Will you get significantly
more bang for your storage buck through compression?.
* Query performance:​If query performance against the data is most important, ORC
(HortonWorks/Hive) or Parquet (Cloudera/Impala) are optimal, but these files will take
longer to write.
* Data extraction: ​CSV files are excellent if you are going to extract data from Hadoop to
bulk load into a database.

## Error handling for corrupted files cases
Each file format has particular advantages or disadvantages in failure handling event which
consists as follows per file type format:

* **Columnar formats**,while often efficient, do not work well in the event of failure, since
this can lead to incomplete rows.
* **Sequence files** will be readable to the first failed row, but will not be recoverable after
that row.
* **Avro** provides the best failure handling; in the event of a bad record, the read will
continue at the next sync point, so failures only affect a portion of a file.


## When compression should be used?

Several compression codecs are available for Hadoop. Some codecs compress and
uncompress fast, but don’t compress aggressively. Other, compress smaller files, but take
longer to compress and uncompress and require more CPU. Usually, small files overload the
namenode. Since the MapReduce framework splits data for input to multiple tasks, splitability is
a major consideration in choosing a compression codec, as well as file format.
Compression pros:
* Reduce storage requirements.
* Improve performance of data processing.
* Enable compression of MapReduce intermediate output decreasing the amount of
intermediate data that needs to be read and written to and from disk.
Compression cons:
* Compression adds CPU load.
* Not all compression codecs supported on Hadoop are splittable.
Other considerations:
* Often, ordering data so like data is close together will provide better compression levels.
* Snappy: High compression speeds with reasonable compression. Should be used with a
container format like SequenceFiles used with a container format like SequenceFiles or
Avro.
* Consider other where Hadoop is being used mainly for active archival purposes: LZO,
Gzip, bzip2.


When using Hadoop, there are many challenges in dealing with large data sets. Regardless of
whether you store your data in HDFS the fundamental challenge is that large data volumes can
easily cause I/O and network bottlenecks.
To take the decision for use or not use compression, and the way to do it, you should consider
the following topics:


## Working with small files

A small file can be defined as any file that is significantly smaller than the Hadoop block size. If a
file is not at least 75% of the block size, it is a small file.

If a large number of files in your Hadoop cluster are marginally larger than an increment of your
block size you will encounter the same challenges as small files. For example if your block size
is 128 MB but all of the files you load into Hadoop are 136MB you will have a significant number
of small 8MB blocks. Although number of rows can impact MapReduce performance, it is much
less important than file size when determining how to write files to HDFS.


There are two main reasons why Hadoop has a problem with small files: NameNode’ s memory
management and the performance of MapReduce:

### The NameNode memory problem

Every directory, file, and block in Hadoop is represented as an object in memory on the
NameNode. As a rule of thumb, each object requires 150 bytes of memory. If you have 20
million files each requiring 1 block, your NameNode needs 6GB of memory.

When a NameNode restarts, it must read the metadata of every file from a cache on local disk.
This means reading 300GB of data from disk that likely causing a quite delay in startup time.


In normal operation, the NameNode must constantly track and check where every block of data
is stored in the cluster. This is done by listening for data nodes to report on all of their blocks of
data. The more blocks a data node must report, the more network bandwidth it will consume.
Even with highspeed
interconnects between the nodes, simple block reporting at this scale
could become disruptive.

### The MapReduce performance problem 

The first reason is that a large number of small files means a large amount of random disk IO.
Disk IO is often one of the biggest limiting factors in MapReduce performance. One large
sequential read will always outperform reading the same amount of data via several random
reads. If you can store your data in fewer, larger blocks, the performance impact of disk I/O is
mitigated.

#### Hadoop Archive Files

Hadoop archive files alleviate the NameNode memory problem by packing many small files into
a larger HAR file, similar to TAR files on Linux. This causes the NameNode to retain knowledge
of a single HAR file instead of dozens or hundreds of small files. Note that a rchiving does not
compress the files. The files within a HAR file can be accessed using the “har://” prefix instead
of “hdfs://”.

If your small files are primarily kept for archival purposes and these files are infrequently
accessed, then HAR Files are a good solution. If the small files are part of your normal
processing flow, you may need to rethink your design.
To archive files you can issue the archiving tool command. The archiving tool uses MapReduce
to efficiently create Hadoop Archives in parallel. The tool can be invoked using the command:
```
$ hadoop archive -archiveName archive.har -p /path/to/parent/folder
relative/path/to/parent/folder1 relative/path/to/parent/folder2 …
relative/path/to/parent/folderN /path/to/outputdir
```

The archive exposes itself as a file system layer. So all the fs shell commands in the archives
work but with a different URI. Also, note that archives are immutable. So, rename, delete and
create commands return an error. Once created, the structure of a .har archive is as follows:
```
archive.har/
_masterindex //stores hashes and offsets
_index //stores file statuses
part[1..n] //stores actual file data
```
The **archiving tool uses MapReduce** to efficiently create the archive in parallel: a list of files is
generated by traversing the source directories recursively `/path/to/parent/folder
relative/path/to/parent/folder[1..N]` , and then the list is split into map task inputs.
Each map task creates a part file (about 2 GB, configurable) from a subset of the source files
and outputs the metadata. Finally, a reduce task collects metadata and generates the index
files.

URI for the generated archive is:
`har://nameNodeIP:nameNodePort/archive.har/fileinarchive`

If no scheme is provided it assumes the underlying filesystem. In that case the URI would look
like:
`har:///archive.har/fileinarchive`

Using Hadoop Archives in MapReduce is as easy as specifying a different input filesystem than
the default file system. If you have a Hadoop archive stored in HDFS in “/path/to/archive.har”
then for using this archive for MapReduce input, all you need to specify the input directory as
“har:///path/to/archive.har”. Since an a rchive is exposed as a filesystem, MapReduce will be
able to use all the logical input files in Hadoop Archives as input. N evertheless, it means
disadvantages:

* You can only point to an archive as unit on a MapReduce input program. That is, Hadoop
does not read folders of archives but archives themselves. If a folder contains files and
archives, files will be read and archives will be ignored.

* Append: As above mentioned, archives are immutable so you cannot append files to a
.har archive as you would do with UNIX/Linux .tar archives. The only way to add new
files to a .har archive is unarchive and archive again putting the new files to add in a path
relative to the parent folder as previously explained.

* Source files: Source files remain unchanged so still remain occupying space in the
memory of the NameNode. Consequently, as for small files, these should be deleted
after archiving them, otherwise, with merely archiving, you are not actually solving the
problem of the numerous small files in HDFS.

**Archives in Hive**
Archiving in Hive should be considered an advanced technique due to the caveats involved.
However, archiving in Hive pays off under some circumstances. By archiving in Hive, we mean
**archiving partitions of tables in the Hive warehouse**. A rchiving a whole table does not make
sense; as you cannot append files to a .har file as remains unalterable after archiving, the table
becomes unalterable itself which is pointless in the vast majority of cases.

Three settings should be configured in HiveQL when archiving is performed:
```
-- To enable archiving operations:
SET hive.archive.enabled=true;
-- To inform Hive whether the parent directory can be set while creating
-- the archive.
SET hive.archive.har.parentdir.settable=true;
-- To control the size of the files that make up the archive: The
archive
-- will contain size_of_partition/har.partfile.size files, rounded up.
-- Higher values mean fewer files, but will result in longer archiving
times
-- due to the reduced number of mappers.
SET har.partfile.size=1099511627776;
```

To archive, spawn the command:
```
ALTER TABLE table_name ARCHIVE PARTITION (partition_col1 =
partition_col_value1, partition_col2 = partiton_col_value2, …,
partition_colN = partition_col_valueN)

```
This sentence creates a data.har file in HDFS under the path:
`/user/hive/warehouse/database_name.db/table_name/partition_col1=partition_c
ol_value1/.../partition_colN=paratition_col_valueN/data.har`

Moreover, as for hierarchy, you can archive at any level or partitioning. For example, if you
issued the command:
```
ALTER TABLE table_name ARCHIVE PARTITION (partition_col1 =
partition_col_value1)
```
you would create the following data.har file containing anything under the
partition_col1=partition_col_value1 directory:

`/user/hive/warehouse/database_name.db/table_name/partition_col1=partition_c
ol_value1/data.har`

Internally, when a partition is archived in Hive, in comparison to the command line archiving tool,
original files are deleted and only the data.har file is kept. Nevertheless, this is not a matter of
great concern because when the partition is unarchived the files and directories archived are
restored. To unarchive a partition, just issue the unarchive command
```
ALTER TABLE table_name UNARCHIVE PARTITION (partition_col1 =
partition_col_value1, partition_col2 = partiton_col_value2, …,
partition_colN = partition_col_valueN)
```
Querying archived partitions is absolutely straightforward, in fact, nothing changes in
comparison to querying unarchived partitions. However, the tradeoff
is that queries may be
slower due to the additional overhead in reading from .har archives, which makes sense.
Archiving implies some advantages but it is worth pointing out some caveats:
* Only partitioned tables in the Hive warehouse. Archiving applies only to tables partitioned
in the Hive warehouse at the moment. For nonpartitioned
tables, archiving does not
make much sense and, in fact, this is not allowed. In addition, Hive does not support
archiving partitions of EXTERNAL tables.
* INSERT OVERWRITE sentence: Archived partitions cannot be modified, consequently,
the INSERT OVERWRITE sentence is not allowed.
* If two processes attempt to archive the same partition at the same time, bad things could
happen. (It is needed the implementation of concurrency support.)

* INSERT sentence: Inserting new records in partitionedarchived
data is possible, y et it
implies negative side effects. For example, if you insert data in a table corresponding to
an archived partition and after that point the partition is unarchived for any reason, new
added data is deleted and replaced by old data from the archive.

* Archived and unarchived data can coexists in the same table and even in the same
partition. N onetheless, the former is d angerous for the integrity of your data a nd we
by no means encourage to mix archived and unarchived information corresponding to
the same partition.

* Successful INSERT or INSERT OVERWRITE sentence: Unarchive, insert or insert
overwrite data and then archive again, otherwise, your data will suffer the
aforementioned consequences.

To summarize, archive old information when data is going to be punctually read and adding new
rows is rather unlikely or will never happen.

### Solving the MapReduce Performance Problem
There are many courses of action by which to attack the problem:

#### Change the ingestion Process/Interval

Investigate changing your source system to generate a few large files instead, or possibly concatenating files when ingesting into HDFS. If you are only ingesting 10 MB of data every hour, determine if it’s possible to only ingest once a day. You’ll create 1x240MB file instead of
24x10MB files.

#### Batch File Consolidation

With this option you periodically run a simple, consolidating MapReduce job to read all of the small files in a folder and rewrite them into fewer larger files. For example, with a simple Pig program. There is also a prewritten application designed specifically for this task, called File Crush. This option does not maintain the original file names.


#### Sequence Files

In this solution, the filename is stored as the key in the sequence file and the file contents are stored as the value. Sequence files support block compression, and are splittable. That meaning that MapReduce jobs would only launch one map task per 128MB block instead of one map task per small file. However, if you are only ingesting a small number of small files at a time the sequence file does not work as well because Hadoop files are immutable and cannot be appended to.

#### HBase
 If you are producing numerous small files, storing your data as files in HDFS may not be the best
solution. Instead you might consider using an HBase column store. Using HBase changes your
ingestion process from producing many small HDFS files to writing individual records into HBase
tables.

If your data access pattern is based on welldefined, randomaccess
lookups, HBase may be
your best alternative. It is architecturally tuned for highvelocity
data record inserts, highvolume,
individual record lookups and streaming based analytics. However, if your data access pattern
tends toward full file/table scans, then HBase may not be optimal.It is possible to create a Hive
table that maps to HBase data; however, query performance in this design will vary.

Hive on HBase will shine when a single row or a range of rows is selected, but if your queries
tend toward full table scans HBase is very inefficient. Most analytical queries, especially those
using group bys, require full table scans.HBase provides the best ability to stream data into
Hadoop and make it available for processing in real time. However, balancing the needs of
HBase with other cluster processes can be challenging and requires advanced system
administration.

Additionally, HBase performance is largely dependent on data access patterns and these should
be carefully considered before choosing HBase to solve the small file problem.

#### S3DistCp
 This solution is only available for users of Amazon EMR. Amazon EMR clusters are designed to
be short lived, persisting their data in Amazon S3.

S3DistCp is a utility provided by Amazon for distributed copying of data from S3 to ephemeral
HDFS or even other S3 buckets. The utility provides the capability to concatenate files together
through the use of “groupBy” and “targetSize” options. This is useful when you have thousands of small files stored in S3 that you want to process using Amazon EMR.

#### Using a CombineFileInputFormat

The CombineFileInputFormat is an abstract class provided by Hadoop that merges small files at
MapReduce read time.

The merged files are not persisted to disk. Instead, the process reads multiple files and merges
them “on the fly” for consumption by a single map task. You gain the benefits of not launching
one map task per file and not requiring that multiple files be merged into a single persisted file as
part of a preparatory step.

This solves the problem of a MapReduce job launching too many map tasks; however, since the
job is still reading in multiple small files random disk IO is still a problem. Additionally, most
implementations of the CombineFileInputFormat do not account for data locality and will often
pull data from a variety of data nodes over the network. In order to implement this, the
CombineFileInputFormat must be extended in Java for different file types.

This requires significant development expertise to develop your custom input format classes.
However, once written, you can configure a maximum split size and it will merge files until this
size is met.

Note that since the merged data is not persisted in HDFS, the CombineFileInputFormat does not
alleviate the NameNode memory problem.

#### Hive Configuration Settings

If you notice that Hive creates small files in your Hadoop cluster through “create table as” or
“insert overwrite” statements, you can adjust a few Hive specific configuration settings to
mitigate.

When used, these settings tell Hive to merge any small files that were created into larger files.
However, there is a penalty. Hive will launch an additional MapReduce job, postquery,
to perform the merge. Further, the merge is done before Hive indicates to the user that the query
has finished processing instead of occurring asynchronously.

It should be noted that these settings only work for files that are created by Hive. If, for example,
you create files outside of Hive using another tool such as Sqoop to copy into the Hive table
using a ‘hdfs fs –mv’ command, Hive will not merge the files. Therefore, this solution does not
work when the files ingested into Hadoop are small.

This solution is only recommended in Hivecentric
architectures where a small performance
penalty in insert overwrite and create table as statements is acceptable.
<table>
  <tr>
    <th>Property</th>
    <th>Description</th>
    <th>Default Value</th>
    </tr>
  <tr>
    <td>`hive.merge.mapfiles`</td>
    <td>Merge small files that are produced from
maponly
jobs.</td>
    <td >true</td>
    
  </tr>
  <tr>
    <td >`hive.merge.mapredfiles`</td>
    <td > Merge small files that are produced from mapreduce jobs.</td>
    <td>false</td>
    
  </tr>
   <tr>
    <td>`hive.merge.size.per.task`</td>
    <td >When merging small files the target size for the merge files at the end of the job.</td>
    <td>256000000 bytes</td>
  </tr>
  <tr>
    <td >hive.merge.smallfiles.avgsize</td>
    <td >When the average size of the output files is less than this number, Hive will execute an
additional MapReduce job to merge the files based on hive.merge.mapfiles and hive.merge.mapredfiles.</td>
    <td>16000000 bytes</td>
  </tr>
  
</table>

#### Using Hadoop’s Appender Capabilities
Append was added in July of 2008 as part of Hadoop 0.19. However, after implementation (as
early as October 2008) many issues were found and append was disabled in 0.19.1. However,
in order to support HBase without risk of data loss append capabilities were added back to
Hadoop in 0.20.2. So, finally, after 0.20.2 it was technically possible to perform appends in
Hadoop.

Append may be available, but **none of the major tools in the Hadoop ecosystem support it**:
Flume, Sqoop, Pig, Hive, Spark, and Java MapReduce.

MapReduce enforces a rule that the output location of a MapReduce job must not exist prior to execution. Due to this rule it is
obviously not possible for MapReduce to append to preexisting
files with its output. Since
Sqoop, Pig, and Hive all use MapReduce under the covers it is also not possible for these tools
to support append. Flume does not support append largely because it operates under the
assumption that after a certain period either in terms of seconds, bytes, number of events, or
seconds of inactivity, Flume will close the file and never open it again. The Flume community
has deemed this sufficient and not demanded append support.

If you truly must use appends in Hadoop, you have to write your own system to perform the
ingestion and append to existing files. Additionally, if any of your incluster
processing requires
appending to existing files, you will not be able to use Spark or MapReduce. Therefore using
HDFS append capabilities is very complex and should only be used by the most technologically
savvy organizations. Without a significant engineering team and support commitment, this option
is not recommended.

<a name="choosing"/>
### Choosing a solution
Choosing the best solution for working with small files depends on a variety of questions. It may
be necessary to use a combination of these solutions based on access patterns and data
requirements. The questions that should be considered include:
* At what point in the data flow are the small files being generated? Are the small files
being created at ingestion, or via incluster
processing?
* What tool is generating the small files? Can changing tool configuration reduce the
number of small files?
* What level of technical skill exists within your organization? Do you have the capabilities
to maintain input formats or writing your own ingestion engine?
* How often are the small files being generated? How often can small files be merged in
order to create large files?
● What sort of data access is required to these small files? Do the files need to accessible
through Hive?
● What type of administrative periods might exist where processes can be run inside the
cluster to alleviate small files?
* What level of latency is acceptable from MapReduce processes?

<a name="schema"/>
## HDFS Schema Design

The data stored in HDFS is intended to be shared among many departments and teams.
Take into account:
* Standard directory structure.
* Staging data in a separate location.
* Standardized organization of data.
* Standardized locations.
* The version of Hive may only support table partitions on directories that are named a
certain way. This will impact the schema design in general and how you name your table
subdirectories.

### Location of HDFS & Staging files

This sections shows the configuration of both the staging host and the HDFS file systems under
the aforementioned guidelines.


Within the workflow, there are directories for each stage of every single process running, input
directories for the landing zone where the raw data arrives (black zone), others where the
processing and transforming actually occurs in one or more stages (grey zone), output
directories for final results and ‘bad’ directories, where records or even complete files that were
rejected by ETL processes are stored.

Take care about these considerations:

* Differentiate between Staging and HDFS.
* Differentiate between application resources and data.
* Differentiate between temporary and permanent folders.
* Logs in separates folder.

**Staging directory structure in the staging host**:

Taking the root level, which corresponds with the data area, as starter directory in both S taging
and HDFS systems, the structure of the folder for each area is as follows:


### Techniques for decomposing large data sets into more manageable subsets
The schema design is highly dependent on the way the data will be queried.
* We will need to know which columns will be used for joining and filtering before deciding
on partitioning and bucketing of the data.
* In cases when there are multiple common query patterns and it is challenging to decide
on one partitioning key there is the option of storing the same data set multiple times,
each with different physical organization.
* Data is typically writeonce,
and few updates are expected.
* Joins are often the slowest operations and consume the most resources from the
cluster.Reduceside
joins, in particular, require sending entire tables over the network.

#### Partitioning

* **Phases of the data cycle, to compact the files**.
In ingestion phases, if too many files are given at same time and have less size than
block size, it is recommended to compact these files at the ending of this stage. In other
hand, could be good do a compacting task after cleansing and normalization phases in a
temporary cycle. For example, every month or year.

As a resume, the next table shows when to use this techniques, taking in consideration the
ingestion frequency, number and size of files even query requirements:

TABLE

**Partitions advantages and disadvantages**
Partitioning feature is very useful in Hive, however, a design that creates too many partitions
may optimize some queries, but be detrimental for other important queries.
Other drawback is having too many partitions is the large number of Hadoop files and directories
that are created unnecessarily and overhead to NameNode since it must keep all metadata for
the file system in memory.

#### Bucketing
Bucketing is another technique for decomposing data sets into more manageable parts.
For example, suppose a table using the date as the toplevel
partition and the person_id as the secondlevel partition leads to too many small partitions. Instead, if you bucket the people table and use person_id as the bucketing column, the value of this column will be hashed by a userdefined number into buckets.
Records with the same person_id will always be stored in the same bucket. Assuming the
number of person_id is much greater than the number of buckets, each bucket will have many
person_id.

While creating table you can specify like ‘CLUSTERED BY’ (person_id) INTO <the number of
buckets> BUCKETS.

Bucketing has several advantages. The number of buckets is fixed so it does not fluctuate with
data. If two tables are bucketed by person_id, Hive can create a logically correct sampling.
Bucketing also aids in doing efficient mapside
joins etc.

For example, suppose that you specify 32 buckets in the ‘CLUSTERED BY’ clause and the
‘CREATE TABLE’ statement also contains the ‘PARTITION BY’ clause. As a hive table can have
both partitioning and bucketing (non for the same column). Based on the partition clause, for
each partition will have 32 buckets created.

Is likely that the resulting number of partitions may be too large and resulting files may be too
small in size. A solution is to use a hashing function to map an element into a specified number
of subsets or buckets.

Files should not be so small that you’ll need to read and manage a huge number of them, but
also not so large that each query will be slowed down by having to scan through huge amounts
of data.

When both data sets being joined are bucketed on the join key and the number of buckets of one
data set is a multiple of the other it is enough to join corresponding buckets individually without
having the need to join the entire data sets. If the data in the buckets is sorted, it is also possible
to use merge join and not store the entire bucket in memory when joining.

It is recommended to use both sorting and bucketing on all large tables that are frequently joined
together, using the join key for bucketing.


#### Denormalizing
Joins are often the slowest operations and consume the most resources from the cluster.
Create prejoined
data sets minimize the amount of work that will be done by queries by doing
as much as possible of the required work in advance.

<a name="metadata"/>
### Metadata: data about the data
This includes information like the location of a data set (directory in HDFS or the HBase table
name), schema associated with the data set, partitioning and sorting properties of the data set, if
any, format of the data set, if applicable (CSV, TSV, SequenceFile, etc.). Metadata is usually
stored in a separate metadata repository.

Hive stores this metadata in a relational database called the Hive metastore . Hive also includes
a service called the hive metastore service that interfaces with the Hive metastore database. To
enable the usage of Hive metastore outside of Hive, you can use a separate project called
**HCatalog**.
HCatalog is a part of Hive and serves a very important purpose of allowing other tools (like Pig
and MapReduce) to integrate with the Hive metastore. (REST API to the Hive metastore via the
**WebHCat server**).

Hive metastore can be deployed in 3 modes: embedded metastore, local metastore and
remote metastore. Using the Hive metastore in remote mode is a requirement for using
HCatalog on top of the Hive metastore. **Databases that are supported as Hive metastore databases are MySQL, PostgreSQL, Derby and Oracle**.

Reusing the existing database instance instead of creating a new one depends on usage
patterns: On one hand, it’s good from an operational perspective not to have a new database
instance for every new application (in this case the Hive metastore service handles metadata in
the Hadoop ecosystem) but on the other hand, it makes sense not to have your Hadoop
infrastructure crossdepending data rather than uncoupled.

**Limitations of Hive metastore and HCatalog**:
* Problems with high availability: In order to provide High Availability (HA) for Hive
metastore, you have to provide high availability for the metastore database as well as the
metastore service. However, at the time of this writing, that can lead to concurrency
issues related to DDL statements and other queries being run at the same time 5 . The
Hive community is working towards fixing these issues.
* Fixed schema for metadata: If it doesn’t make sense to represent your data set as a
table, say if you have image or video data, you may still have a need for storing and
retrieving metadata but Hive metastore may not be the right tool for it.
* You have to worry about keeping the metastore service up and securing it if/like you
secure the rest of your Hadoop infrastructure.

**Other ways of storing metadata**:
* Embedding metadata in file paths and names: we recommend embedding some
metadata in data set locations for organization and consistency. For example, in case of
a partitioned data set, the directory structure would look like: `<data set
name>/<partition_column_name=partition_column_value>/{files}`
* Storing the metadata in HDFS: create a hidden directory, say .metadata inside the
directory containing the data in HDFS. you will have to create, maintain and manage
your own metadata.
* You may, choose to use something like Kite SDK 6 to store metadata.

<a name="hbase"/>
## HBase Schema Design
HBase is a huge hash table. Just like a hash table, you can associate values with keys and
perform fast lookup of the values based on a given key.
A row key in HBase is like the key in a hash table. In HBase, all the row keys are sorted and
each region stores a range of these sorted row keys.
HBase reads records in chunks of 64KB from the disk. Each of these chunks is called an HBase
block.

When an HBase block is read from the disk, it will be put into the block cache. A wise selection
of row key can be used to collocate related records in the same region. A record can have a
million columns and the next record can have a million completely different columns. This isn’t
recommended, but it’s definitely possible.

HBase stores data in a format called HFile. Each column value gets its own row in Hfile.
* We can get one column at a time independently of the other column
* We can modify just each column independently of the other
* Each column will age out with a TTL independently

A column family is essentially a container for columns. Two Column Families makes sense for
the following reasons: 
* Lower Compaction Cost, Better Use of Block Cache
* Timetolive (TTL): the older records are removed as a part of the normal upkeep of the table

<a name="lifecycle"/>
## Data life cycle
The following figure shows the general data life cycle on the Hadoop platform. To some extends,
the purpose of this document consist on a comprehensive discussion on concepts and ideas
involved in the life cycle

1. **Ingestion into HDFS or Data ingestion**: Units of data are collected, aggregated, and
moved to the Hadoop platform. **Files are the incoming units of data**: these can arrive
as files themselves, the result of an Sqoop importation command on a relational
database or the outcome of a continuous Flume ingestion.

2.  **Cleanse, normalise and move into permanent repositories**: Data is ingested into
permanent data repositories. Related to this, data must be cleanse, normalise and even
compacted and compressed, thereby meeting the formats and folder organization in
HDFS expected by those processes aimed at data exploitation.

3. **Permanent repositories**: Data is stored and maintained in data repositories. Formats
and locations must be very wellknown and previously carefully defined.
4. **Data exploitation**: Data is used by a variety of Hadoop applications.
	* Data mining apps: which involves the discovery of patterns in large data sets
taking advantage of methods from artificial intelligence, machine learning and
statistics. The overall goal of the data mining techniques is to discover and
extract information and transform it to better understand or have a deeper, even
subtle insight on how you organization is performing its activities.
	* Business specific applications: applications involved in your organization day today activities or business.
	* Reports: related to data mining, there would exist processes running on a regular or timely fashion. The outcome of these processes is a set of static reports containing a valuable insight over a set of subjects.
	* Simple data queries: Queries performed on a very particular subject.
	* Batch processes: jobs running without manual intervention nor human interaction. Batch processes are usually configured to run under a strict schedule consuming
very definite workloads. Depending on the purpose of the process, this may last
from minutes to hours or even from days to months. Under this definition the
majority of the previously mentioned applications running in the cluster could be
considered as a particular type of a batch process.
5. **Data retiring process**: Data can be retired from the data repositories. Nevertheless,
data retired from the cluster should be ingested again, provided these retired datasets are necessary again. The ideal situation should be that data remains in the cluster forever which, we may say, is almost impossible or impractical.

### References

* [Link](http://www.url.to) Description
* [oficialsite.org](http://www.oficialwebsite.org) API & Docs
* [Overapi Cheatsheet](http://overapi.com/example/) Cheatsheet

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies

