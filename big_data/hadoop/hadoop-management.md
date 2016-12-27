# Best practices for Hadoop
![Hadoop logo](static/hadoop_logo.png "Hadoop logo")

## Index

* [HDFS](#hdfs)
* [YARN](#yarn)
* [Hardware Selection](#hardware-selection)
* [OS Configuration](#os-configuration)
* [JAVA](#java)
* [Deployment](#deployment)
* [Hadoop Distribution](#hadoop-distribution)
* [Apache HBase](#apache-hbase)

### HDFS

 - It is a distributed file system designed to run on commodity hardware.

 - Bringing the computing to the data instead bringing the data to the computing decrease considerably the bandwidth use and increase the parallelism to computing. Although if any node get down the data continues in the other copies and the computing can starts in one of these nodes. 

 - The client can set the replica factor and the block size to increase heuristic for the data locality. Accurate block size is 128MB and replica factor, at least, three.

 - NameNode handles the location of file blocks in HDFS and it's loaded in ram memory so it's limited. For this reason it's suitable to manage big/very big files instead of several little files, appending content to files. Each file registered in the NameNode needs around 150 bytes for metadata.

 - Secondary NameNode is not  a failover NameNode, it have a copy in time from the NameNode to roll the changes in NameNode 'Edits' file to create a new FSImage file. It should be called 'Checkpoint NameNode'.

 - To fix NameNode uniqueness the HDFS can be converted in a HA (high avaliability) service 'NameService' where two (or more) node works as NameNode but only one in production and the other does the checkpoint task. Using Zookeeper can automatically change the state from Failover to Production NameNode. It has a disadvantage that all DataNodes need to communicate with the different nodes in the NameService increasing the bandwidth use.

Comic example how HDFS works:

![hdfs_comic_p1](static/hdfs_comic_p1.png)
![hdfs_comic_p2](static/hdfs_comic_p2.png)
![hdfs_comic_p3](static/hdfs_comic_p3.png)
![hdfs_comic_p4](static/hdfs_comic_p4.png)
![hdfs_comic_p5](static/hdfs_comic_p5.png)

### YARN

- 'Yet Another Resource Negotiator', not only for Map Reduce tasks. It's a dynamic resource manager using Containers for Map Reduce, Apache Spark, Apache Flink, Impala, ... .

- In Hadoop a Worker node is: DataNode + NodeManager for datalocality. Recomended 8cores and 8GB Ram memory per node.

- ResourceManager only manage the cluster resources. It decides where the Container in which NodeManager must be launched.

- The client asks to the ResourceManager for a Container to run a job. Starting with the ApplicationManager (~JobTracker in MR1) and this will ask itself to the ResourceManager about it requirements to run the different tasks for the job to launch them in other Containers assigned by the ResourceManager in different NodeManagers.

- Splits are not blocks, but can be. A job starts calculating the number of splits, by default is the number of hdfs block size. The client can increase splits number helping parallelism and decreasing them reduce the parallelism. It depends of replica factor, number of workers, task requirements.

### Hardware Selection

 - It is recommended to use commodity general-purpose server hardware. Special hardware is not needed to run Hadoop clusters and in some cases can present problems.

 - It is recommended to run Hadoop cluster on a homogeneous hardware (all worker nodes have to possess same hardware caracteristics (same number of cores, RAM, disk space, etc).

#### HDDs

 - The more disks the worker node has to store data - the better.

 - The faster disks the worker node has to store data - the better.

 - It is recommended to have separate disks for OS and for data storage.

 - It is recommended to use disks for data storage configured as JBOD (not recommended to use RAID). On the other hand, it is recommended to use RAID for disks with OS/Software.

 - It is recommended to limit the storage capacity of a worker node. 36 TB per node is a good estimate. Otherwise network saturation could be provoked in case of a failure of a worker node (due to data replication to other nodes).

#### CPU

 - It is recommended to enable HyperThreading.

 - A good estimate of a number of CPUs per worker node: vcores = HDDs x 2.

#### RAM

 - Amount of RAM per node depends on the Hadoop services one pretends to run. Here is a formula to estimate the necesary amount of RAM: RAM = (CPUs * RAM_PER_YARN_CONTAINER) + IMPALA_RAM + HBASE_RAM + SO_RAM.

#### NETWORKING

 - The more bandwidth - the better (together with the HDD speed, network bandwidth is the common bottleneck in Hadoop clusters).


### OS Configuration

#### OS TYPE

 - It is recommended to run Hadoop on Linux. The most widely used distribution is RHEL/CentOS.

#### KERNEL PARAMETERS

 - It is recommended to set vm.swappiness parameter in a range 1-10 (/etc/sysctl.conf file). The default value for most linux distributions is higher (60).

 - It is recommended to disable the transparent huge pages (THP) function.
RHEL:
````bash
echo "never" > /sys/kernel/mm/redhat_transparent_hugepage/defrag
````
Ubuntu/Debian, OEL, SLES:
````bash
echo "never" > /sys/kernel/mm/transparent_hugepage/defrag
````

 - It is recommended to disable SELINUX (even though some Hadoop distributions support running Hadoop with SELIUX enabled).

 - It is recommended to set a higher limits for open files and running processes for Hadoop users in /etc/security/limits.conf
````bash
hdfs  -       nofile  32768
hdfs  -       nproc   32768
...
````

#### HOSTNAME RESOLUTION

 - It is recommended to configure a DNS server for hostname resolution (not to use the /etc/hosts file).

 - It is required to have the iverse resolution configured for all cluster hosts. A quick test could be done via Python shell:
````bash
python -c 'import socket; print socket.getfqdn(), socket.gethostbyname(socket.getfqdn())'
````

 - The hostnames have to be in FQDN form. The command 'hostname -f' should return both hostname and domainname.

 - It is recommended to install and configure nscd service on all hosts to cache DNS.

#### DATE AND TIME

 - It is required to have the date and time in sync across all cluster nodes (via ntp or other source).

### JAVA

 - It is recommended to use Oracle JDK.


### Deployment

 - There are three type of nodes in Hadoop cluster: master, worker and gateway. It is recommended to maintain separate nodes for each role (e.g. not to mix master-nodes with gateway-nodes).

 - For Hadoop services that require a database it is recommended to setup an external database and configure services to use it (it is not recommended to use embedded databases such as Derby, etc...).

 - For small/medium-sized clusters it is recommended to deploy the services that require a database on the database nodes. On large clusters it is recommended to setup a database on a dedicated host.

 - It is recommended to setup a Zookeeper ensemble on at least three nodes.

 - It is recommended to deploy HDFS and YARN in high avaliability mode

 - Recommended distribucion for master nodes in medium-sized cluster:


Master1: HS2, HM, Oozie, Hue, RDBMS, (Manager)  
Master2 ZK, NN, JN, HBM  
Master3 ZK, RM, JH, SH, ISS, ICS  
Master4 ZK, NN, JN, RM, HBM  

ZK - Zookeeper  
NN - NameNode  
JN - JournalNode  
RM - YARN Resource Manager  
JH - MapReduce JobHistory Service  
SH - Spark JobHistory Service  
ISS - Impala StateStore  
ICS - Impala Catalog Service

### Hadoop Distribution

 - CDH from Cloudera is recommended as a general-purpose Hadoop distribution. 
The main advantages over its rivals are: 
 - - superior administration/data governance tools
 - - superior stability

 - In case of using CDH, it is recommended to use Cloudera Manager for cluster deployment/administration.

 - In case of using CDH, it is recommended to use parcels (not rpms) for cluster deployment.

### Apache HBase
![Logo Hbase](static/logo_hbase.png)
#### Main Features

> - Distributed and scalable. Data is distributedly stored over hadoop storage system.
> - Column-oriented. Data is saved grouped by columns, and column values are stored contiguosly on disk.
> - Key-based access to a specific set of data.
> - Provide strict consistent reads and writes. Low-latency reads. 
> - Sharding of tables.
> - Region Servers.
> - Easy to use java API. Integrated to MapReduce jobs and Spark jobs.
> - Thrift gateway.
> - Shell.

Use this database when you want to take advantage of a columnar data model. In the way that you don't know how many columns a record will have and you don't want to explicitly set the number of columns to use. You can set millions of columns dynamically.

Master server coordinates the cluster, performing admin operations, regions allocations and load balancing.
Region Servers do the real work. A subset of each table is handled by each region server. 
Clients talk to region servers to access the data.

----------
####Basic Pre-requisites


![HBase JDK Versions](static/jdk_hbase.png "HBase JDK Versions")


####Hardware Specifications

HBase can run on many different hardware configurations.
Possibility to run on server-grade machines.

Based on a master-slaves server architecture.

 > - HBase Master should run on the master node (the one where NameNode runs in).
 > - HBase master node is not going to storage data from tables (region server do), so it could not need the same ammount of disk than region servers, although is very common to use the same hardware specification for boths.
 > - Beef master nodes up with reduntant hardware components is a good practice. 
 
CPU

>  - Multicore processors for a production environment.
>  - Quad-core fit well althought hexa-core are more popular. You can use two quad-core
CPUs for a total of eight cores.
>   
 This could be a good configuration.
Master Dual quad-core CPUs, 2.0-2.5 GHz
Slave Dual quad-core CPUs, 2.0-2.5 GHz

MEMORY

HBase is a very memory hungry application.  Each node in HBase installation, called RegionServer, keeps a number of regions, or chunks of your data, in memory (if caching is enabled).  Ideally, the whole table would be kept in memory but this is not possible with a TB dataset.

 - Region Servers: at least 4GB each (depends significantly on your application load and access pattern)
 - Master Node: 4 Gb. Usually lightly loaded. Moderate requirements.
 - Zookepper: 1 Gb. Moderate requirements


DISKS

 - JBOD over RAID
 - One core per disk
 - In general, SATA drives are recommended over SAS

![HBase disks](static/disks_hbase.png "HBase disks")

----------

####Software Specifications

#####**Operative System**

Hadoop and HBase are inherently designed to work with Linux, or any other Unix-like system, or with Unix. It's only have been tested with Unix-like systems.

Here is a short list of
operating systems that are commonly found as a basis for HBase clusters:

 - CentOS
 - Fedora
 - Debian
 - Ubuntu
 - Solaris
 - Red Hat Enterprise Linux
 
 #####**File System**
The common sys-
tems in use are ext3, ext4, and XFS, but you may be able to use others as well

#####**Hadoop**

Currently, HBase is bound to work only with the specific version of Hadoop it was
built against. One of the reasons for this behavior concerns the remote procedure call
(RPC) API between HBase and Hadoop.

Hadoop 2.x is recommended.

![HBase-Hadoop Versions](static/versions_hbase.png "HBase-Hadoop Versions")

#####**SSH**
ssh must be installed and sshd must be running if you want to use the supplied
scripts to manage remote Hadoop and HBase daemons.

#####**Domain name service**

HBase uses the local hostname to self-report its IP address. Both forward and reverse
DNS resolving should work. You can verify if the setup is correct for forward DNS
lookups by running the following command:

$ ping -c 1 $(hostname)

You need to make sure that it reports the public IP address of the server and not the
loopback address 127.0.0.1 . A typical reason for this not to work concerns an incor-
rect /etc/hosts file, containing a mapping of the machine name to the loopback address.

#####**Synchronized time**
The clocks on cluster nodes should be in basic alignment. Some skew is tolerable, but
wild skew can generate odd behaviors. Even differences of only one minute can cause
unexplainable behavior. Run NTP on your cluster, or an equivalent application, to
synchronize the time on all servers.

#####**Swappiness**
You need to prevent your servers from running out of memory over time: setting the heap sizes small enough that they give the operating system enough room for its own processes.

#####**Windows**
HBase running on Windows has not been tested to a great extent. Running a production
install of HBase on top of Windows is not recommended.
If you are running HBase on Windows, you must install Cygwin to have a Unix-like
environment for the shell scripts.


----------

####Zookeeper

A distributed Apache HBase (TM) installation depends on a running ZooKeeper cluster. All participating nodes and clients need to be able to access the running ZooKeeper ensemble. Apache HBase by default manages a ZooKeeper "cluster" for you. It will start and stop the ZooKeeper ensemble as part of the HBase start/stop process. You can also manage the ZooKeeper ensemble independent of HBase and just point HBase at the cluster it should use. To toggle HBase management of ZooKeeper, use the HBASE_MANAGES_ZK variable in conf/hbase-env.sh. This variable, which defaults to true, tells HBase whether to start/stop the ZooKeeper ensemble servers as part of HBase start/stop.

In production it is recommended that you run a ZooKeeper ensemble of 3, 5 or 7 machines; the more members an ensemble has, the more tolerant the ensemble is of host failures. Also, run an odd number of machines.

Give each ZooKeeper server around 1GB of RAM, and if possible, its own dedicated disk.

 For very heavily loaded clusters, run ZooKeeper servers on separate machines from RegionServers (DataNodes and TaskTrackers).

For example, to have HBase manage a ZooKeeper quorum on nodes rs{1,2,3,4,5}.example.com, bound to port 2222 (the default is 2181) ensure HBASE_MANAGE_ZK is commented out or set to true in conf/hbase-env.sh and then edit conf/hbase-site.xml and set hbase.zookeeper.property.clientPort and hbase.zookeeper.quorum. You should also set hbase.zookeeper.property.dataDir to other than the default as the default has ZooKeeper persist data under /tmp which is often cleared on system restart. In the example below we have ZooKeeper persist to /user/local/zookeeper. 

![HBase Zookeeper Config](static/zookeeper_hbase.png "HBase Zookeeper Config")

The default timeout is three minutes (specified in milliseconds). This means that if a server crashes, it will be three minutes before the Master notices the crash and starts recovery. 

    zookeeper.session.timeout

The number of volumes that are allowed to fail before a DataNode stops offering service
is set by the property

    dfs.datanode.failed.volumes.tolerated
You might want to set this to about half the amount of your available disks.
    

####Important configurations

 - If you have a cluster with a lot of regions, it is possible that a Regionserver checks in briefly after the Master starts while all the remaining RegionServers lag behind. This first server to check in will be assigned all regions which is not optimal. To prevent the above scenario from happening, up the `hbase.master.wait.on.regionservers.mintostart` property from its default value of 1. 
 - If the primary Master loses its connection with ZooKeeper, it will fall into a loop where it keeps trying to reconnect. Disable this functionality if you are running more than one Master
 - `hbase.regionserver.handler.count`
	This setting defines the number of threads that are kept open to answer incoming requests to user tables. The rule of thumb is to keep this number low when the payload per request approaches the MB (big puts, scans using a large cache) and high when the payload is small (gets, small puts, ICVs, deletes). 
 - You should consider enabling ColumnFamily compression.
 - Column family, column qualifiers and table names should be as short as possible.
 - HBase uses wal to recover the memstore data that has not been flushed to disk in case of an RS failure. These WAL files should be configured to be slightly smaller than HDFS block (by default a HDFS block is 64Mb and a WAL file is ~60Mb).


----------
####Splitting

HBase generally handles splitting your regions, based upon the settings in your hbase-default.xml and hbase-site.xml configuration files. Important settings include hbase.regionserver.region.split.policy, hbase.hregion.max.filesize, hbase.regionserver.regionSplitLimit. A simplistic view of splitting is that when a region grows to hbase.hregion.max.filesize, it is split. For most use patterns, most of the time, you should use automatic splitting. 

Instead of allowing HBase to split your regions automatically, you can choose to manage the splitting yourself.

To **disable automatic splitting**, set `hbase.hregion.max.filesize` to a very large value, such as 100 GB It is not recommended to set it to its absolute maximum value of Long.MAX_VALUE.
**Automatic splitting is recomended**.

The **optimal number of pre-split regions** depends on your application and environment. A good rule of thumb is to start with 10 pre-split regions per server and watch as data grows over time.


----------


####Compactions

Apache HBase is a distributed data store based upon a log-structured merge tree, so optimal read performance would come from having only one file per store (Column Family). However, that ideal isn’t possible during periods of heavy incoming writes. Instead, HBase will try to combine HFiles to reduce the maximum number of disk seeks needed for a read. This process is called **compaction**.

Compactions choose some files from a single store in a region and combine them. This process involves reading KeyValues in the input files and writing out any KeyValues that are not deleted, are inside of the time to live (TTL), and don’t violate the number of **versions**. The newly created combined file then replaces the input files in the region.


----------


####Versions

A {row, column, version} tuple exactly specifies a cell in HBase. It's possible to have an unbounded number of cells where the row and column are the same but the cell address differs only in its version dimension.

While rows and column keys are expressed as bytes, the version is specified using a long integer. Typically this long contains time instances such as those returned by java.util.Date.getTime() or System.currentTimeMillis(), that is: “the difference, measured in milliseconds, between the current time and midnight, January 1, 1970 UTC”.

HBase does not overwrite row values, but rather stores different values per row by time (and qualifier). Excess versions are removed during major compactions. The number of **max versions** may need to be increased or decreased depending on application needs.


----------
#### Rowkey Design

 - Rows in HBase are **sorted lexicographically by row key**. This
   design optimizes for scans, allowing you to store related rows, or
   rows that will be read together, near each other. However, poorly
   designed row keys are a common source of hotspotting. Hotspotting
   occurs when a large amount of client traffic is directed at one node,
   or only a few nodes, of a cluster.
 - To **prevent hotspotting** on writes, design your row keys such that
   rows that truly do need to be in the same region are, but in the
   bigger picture, data is being written to multiple regions across the
   cluster, rather than one at a time.
 - **Salting** in this sense has nothing to do with cryptography, but refers to adding random data to the start of a row key. In this case,
   salting refers to adding a randomly-assigned prefix to the row key to
   cause it to sort differently than it otherwise would. The number of
   possible prefixes correspond to the number of regions you want to
   spread the data across.
 - Instead of a random assignment, you could use a **one-way hash** that
   would cause a given row to always be "salted" with the same prefix,
   in a way that would spread the load across the RegionServers, but
   allow for predictability during reads. Using a deterministic hash
   allows the client to reconstruct the complete rowkey and use a Get
   operation to retrieve that row as normal.
 - Keep **rowkey length** as short as possible.
 - **Rowkeys cannot be changed**. The only way they can be "changed" in a table is if the row is deleted and then re-inserted.


### References

* [www.formhadoop.es](http://www.formhadoop.es/img/HDFS-comic.pdf) Hadoop Hdfs comic

___

![beeva logo](../../static/horizontal-beeva-logo.png)

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
