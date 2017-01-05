#### Hardware Selection

 - It is recommended to use commodity general-purpose server hardware. Special hardware is not needed to run Hadoop clusters and in some cases can present problems.

 - It is recommended to run Hadoop cluster on a homogeneous hardware (all worker nodes have to possess same hardware caracteristics (same number of cores, RAM, disk space, etc).

##### HDDs

 - The more disks the worker node has to store data - the better.

 - The faster disks the worker node has to store data - the better.

 - It is recommended to have separate disks for OS and for data storage.

 - It is recommended to use disks for data storage configured as JBOD (not recommended to use RAID). On the other hand, it is recommended to use RAID for disks with OS/Software.

 - It is recommended to limit the storage capacity of a worker node. 36 TB per node is a good estimate. Otherwise network saturation could be provoked in case of a failure of a worker node (due to data replication to other nodes).

##### CPU

 - It is recommended to enable HyperThreading.

 - A good estimate of a number of CPUs per worker node: vcores = HDDs x 2.

##### RAM

 - Amount of RAM per node depends on the Hadoop services one pretends to run. Here is a formula to estimate the necesary amount of RAM: RAM = (CPUs * RAM_PER_YARN_CONTAINER) + IMPALA_RAM + HBASE_RAM + SO_RAM.

##### NETWORKING

 - The more bandwidth - the better (together with the HDD speed, network bandwidth is the common bottleneck in Hadoop clusters).


#### OS CONFIGURATION

##### OS TYPE

 - It is recommended to run Hadoop on Linux. The most widely used distribution is RHEL/CentOS.

##### KERNEL PARAMETERS

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

##### HOSTNAME RESOLUTION

 - It is recommended to configure a DNS server for hostname resolution (not to use the /etc/hosts file).

 - It is required to have the iverse resolution configured for all cluster hosts. A quick test could be done via Python shell:
````bash
python -c 'import socket; print socket.getfqdn(), socket.gethostbyname(socket.getfqdn())'
````

 - The hostnames have to be in FQDN form. The command 'hostname -f' should return both hostname and domainname.

 - It is recommended to install and configure nscd service on all hosts to cache DNS.

##### DATE AND TIME

 - It is required to have the date and time in sync across all cluster nodes (via ntp or other source).

##### JAVA

 - It is recommended to use Oracle JDK.


#### DEPLOYMENT

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

#### HADOOP DISTRIBUTION

 - CDH from Cloudera is recommended as a general-purpose Hadoop distribution. 
The main advantages over its rivals are: 
 - - superior administration/data governance tools
 - - superior stability

 - In case of using CDH, it is recommended to use Cloudera Manager for cluster deployment/administration.

 - In case of using CDH, it is recommended to use parcels (not rpms) for cluster deployment.

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
