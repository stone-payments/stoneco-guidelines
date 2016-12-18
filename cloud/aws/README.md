# AWS Best Practices

![AWS ](static/aws.png  "AWS Best Practices")

## Index

* [Introduction](#introduction)
* [Cloud Best Practices](#cloud-best-practices)  
* [Cloud Migration](#cloud-migration)
* [Account Management](#account-management)
* [User Management](#user-management)
* [Security](#security)
* [Storage](#storage)
* [Services](#services)
	* [EC2](#ec2)
	* [DynamoDB](#dynamodb)
	* [S3](#s3)
	* [IAM](#iam)
	* [Lambda](#lambda)
	* [SQS](#sqs)
	* [RDS](#rds)

---
## Introduction

While **Cloud** services offer flexibility, scalability and better economy of scale, there are also important concerns about security. 

Cloud services such as Software as a service (SaaS), Platform as a
service (PaaS) or Infrastructure as a service (IaaS) will each have their own security concerns that need to be addressed. 

As more data moves from centrally located on-premise servers to the Cloud, the potential for personal and private data to be compromised has increased.

Confidentiality, availability and integrity of data are at risk if appropriate measures and **Best Practices** are not put in place prior to selecting a Cloud vendor or implementing migrating to Cloud services.

The purpose of this information is then introduce the challenge of managing an IT environment over a cloud setting by identifying the benefits of using a set of recommended **Best Practices**.

This is why this document provides capital information about the best way to implement an infrastructure over the **Cloud** for the specific cases of the following:

- Cloud Migration
- Account Management
- User Management
- Security
- Storage
- Services

Please also note that Information in the part of **Services** it is also split on the special cases of:

- EC2
- Scaling (ELBs y ASGs)
- S3
- IAM
- Lambda
- SQS
- DynamoDB
- RDS

---
## Cloud Best Practices 

There are 5 main best practices that you must know in order to use AWS with success.

### Design for failure and nothing will fail

Assume that your hardware will fail. Assume that outages will occur. Assume that some disaster will strike
your application. Assume that you will be slammed with more than the expected number of requests per second some
day. Assume that with time your application software will fail too. By being a pessimist, you end up thinking about
recovery strategies during design time, which helps in designing an overall system better. 

AWS specific tactics for implementing this best practice:

1. Use ElasticIps for failover gracefully combine with Elastic Load Balancers and Route 53 service to minimize service outages.
2. Utilize multiple Availability Zones. By
deploying your architecture to multiple availability zones, you can ensure highly availability. Active multi AZs in Amazon RDS to avoid database outages. Many AWS services are multi AZ by default like S3,DynamoDB
3. Use Elastic Load Balancers to distribute traffic accross multiple AZs. 
4. Maintain an Amazon Machine Image so that you can restore and clone environments very easily in
a different Availability Zone.
5. Utilize Amazon CloudWatch (or various real-time open source monitoring tools) to get more
visibility and take appropriate actions in case of hardware failure or performance degradation.
6. Setup an Auto scaling group to maintain a fixed fleet size so that it replaces unhealthy Amazon EC2
instances by new ones.
7. Utilize Amazon EBS and set up cron jobs so that incremental snapshots are automatically uploaded
to Amazon S3 and data is persisted independent of your instances. Define a snapshot rotation policy for store older snapshot in Amazon Glacier
8. Utilize Amazon RDS and set the retention period for backups, so that it can perform automated
backups.

---

### Decouple your components

Decoupling your components, building asynchronous systems and scaling horizontally become very important in the
context of the cloud. Design your architecture in order to support multiple consumers and multiple producers for your app data.

AWS specific tactics for implementing this best practice:

1. Use Amazon SQS to isolate components 
2. Use Amazon SQS as buffer between components
3. Design every component such that it expose a service interface and is responsible for its own
scalability in all appropriate dimensions and interacts with other components asynchronously
4. Bundle the logical construct of a component into an Amazon Machine Image so that it can be
deployed more often
5. Make your applications as stateless as possible. Store session state outside of component use redis or memcached

---

### Implement elasticity

Elasticity is the ability of an app to adapt for their use. Can be implemented manually or automatically. 

To implement “Elasticity”, one has to first automate the deployment process and streamline the configuration and build
process. This will ensure that the system can scale without any human intervention.


AWS specific tactics for implementing this best practice:

1. Define Auto-scaling groups for different clusters using the Amazon Auto-scaling feature in Amazon
EC2.
2. Monitor your system metrics (CPU, Memory, Disk I/O, Network I/O) using Amazon CloudWatch and
take appropriate actions (launching new AMIs dynamically using the Auto-scaling service) or send
notifications.
3. Store and retrieve machine configuration information dynamically using DynamoDB
4. Design a build process such that it dumps the latest builds to a bucket in Amazon S3; download the
latest version of an application from during system startup or use AWS Code Deploy.
5. Bundle Just Enough Operating System (JeOS) and your software dependencies into an Amazon
Machine Image so that it is easier to manage and maintain. Pass configuration files or parameters at
launch time and retrieve user data and instance metadata after launch.

 


---

### Think parallel

You need to design your processes and workflow thinking in the concept of cloud parallelization. In order to achieve maximum performance and throughput, you should leverage request parallelization. Multi-threading
your requests by using multiple concurrent threads will store or fetch the data faster than requesting it sequentially.

AWS specific tactics for implementing this best practice:

1. Multi-thread your Amazon S3 requests 
2. Multi-thread your Amazon DynamoDB requests
3. Stream your information to multiple consumers with Amazon Kinesis and Amazon DynamoDB Streams.
4. Create a JobFlow using the Amazon Elastic MapReduce Service for each of your daily batch processes
(indexing, log analysis etc.) which will compute the job in parallel and save time.
5. Use the Elastic Load Balancing service and spread your load across multiple web app servers
dynamically
6. Use the Elastic Cache service to share user sessions information with all EC2 instances.
7. Use AWS Lambda to paralellize the execution of multiple functions for the same event.

---

### Keep dynamic data closer to the compute and static data closer to the end-user

In general it’s a good practice to keep your data as close as possible to your compute or processing elements to reduce
latency. In the cloud, this best practice is even more relevant and important because you often have to deal with
Internet latencies. Moreover, in the cloud, you are paying for bandwidth in and out of the cloud by the gigabyte of data
transfer and the cost can add up very quickly. 

AWS specific tactics for implementing this best practice:

1. Utilize the same Availability Zone to launch a cluster of machines
2. Use Amazon S3 to store all of the static files used by your application
3. Create a distribution of your Amazon S3 bucket and let Amazon CloudFront caches content in that
bucket 


---


## Cloud Migration

### Objective

A poor migration strategy can be responsible for costly time delays, data loss and other problems  on your way to success modernizing your infrastructure into the cloud.

To help avoid all this problems we offer this guide in order to be help and reference for future migrations from on-premise sites to the cloud.

The idea is not provide deep and boring documentation but highlight the roadmap to success in the migration.


### Description

The primary technological goal of any cloud migration project is to transfer an existing compute resource/application from one on-premise environment to another in the cloud, as quickly, efficiently, and cost effectively as possible. 

This is especially critical when considering a migration to a public cloud; considerations must include security controls, latency and subsequent performance, operations practices for backup/recovery and others.

For many companies, the initial pull to cloud based services is primary the lower cost – especially since the repeated infrastructure upgrades are no longer required. 

However many companies find themselves staying on cloud operations for other strategic reasons like improving productivity, move more swiftly and focus on business transformation related activates not just technical activities. We have had not one client move from the cloud back to on premise solutions.


### Best Practices

To help in the above premises, this is a selection of the best practices available from the Blueprint to the Cultural Change.


#### Blueprint
Before migration is always recommended to map out the requirements to the right blueprint of the current premise and operations because it can happen that the client doesn’t fully understand what they have on premise today and the features they need to be migrated.

Make sure of what functions/ features of your applications are most used in your on premise solutions and make sure that you rank them from the most used to the least used before starting.


#### Time Planning
Another important part of migrating process is to calculate how long the migration will take, and which are the key parts to transition first because you never want the business to suffer any longer, or any losses, in a drawn out transition. 

Start with the features that are not the most popular, then after you have mastered those, work your way up to the most frequently used. Also, make sure that you build an emergency exit into your project plan. 

If things don’t work out as expected in the cloud, you should have a way to dial back to your on premise solution, just in case, without affecting your business.


#### Availability & Resiliency
To be effective on a cloud infrastructure, the application architecture needs to be addressed for multiple points of failures. 

Though a lift and shift approach it should be strongly be evaluated re-factoring or re-architecting options before deciding on an approach to be carried out, and even more will be required a strategy to follow several testing cases to provide quality to the final result. 


#### DNS/URL/IP Management
Legacy applications within an enterprise are often accessed by business users via internal intranet URL. This URL common name and DNS management in a typical enterprise would have evolved over the last couple of decades into a complex setup, the management of which is often eased by having a centralized server cluster. 

Running out of IP addresses is also not uncommon. When you migrate an application to the cloud (private or public), the DNS entry rewiring often ends up as a nontrivial exercise. Multicloud or hybrid-cloud scenarios make this even more complex, careful planning and network design is of utmost importance.


#### Security & Access Management
A server farm infrastructure typically provides for a centralized security access mechanism like webseal or forefront plug-ins tied into the corporate active directory or LDAP. 

Many of the applications leverage this without any application specific security checks or balances in place. In this case the cloud can be a very secure place, but it will only be as secure as the application is, so it is very important to check security here in all cases.


#### Governance and Security
Managers often push back on cloud migration due to unfounded beliefs that the cloud is unsecured. IT should ascertain exactly what their security and governance needs are for a specific application and find a cloud provider according to the exact need for that app.

The cloud is always secure in origin because always exist a responsibility sharing agreement between the customer (the way security is implemented) and the service provider (secure infrastructure).

Major security problems are always related to the way the security tools, methods, politics and strategies are deployed in both networks and applications.


#### Monitoring & Alerts
The workflow of many operations & production support teams start with the monitoring alerts typically in place for these enterprise server clusters. 

Alert centralized tools do the server monitoring with a customized solution to inform the right teams and stakeholders. Again, the application is often unaware of the surrounding support structures that exist to keep it up and running, so before migrating to the cloud it is capital to deploy mechanisms to monitor the services and not only the servers.


#### Server Sprawl
Sometimes data centers have poor hardware resource utilization, poor system and software level security and wasted energy. Migration and deployment models available are designed to avoid this server sprawl. 

Though the public cloud players have some very good tooling in place, private clouds or hybrid clouds may be a different story. Often, organizational inertia and existing team structures will try to enforce legacy deployment models to the cloud, but is highly recommended to analyze and create new ones if required.


#### Licensing
Server sprawl could also be caused by licensing issues because multiple applications could share the same license, whereas it would be a substantially different cost model when going to individual servers – however small the server is. 

If this forces a legacy deployment model onto the applications, it may be worthwhile to consider re-platforming to open source tools.


#### Certificate Management
Many enterprise applications are self-signed, usually using an in-house certificate authority solution. This is also integrated with internal DNS and URLs. 

Cloud migration is an opportunity for the applications to ‘grow-up’ and be first world citizens.


#### Production Support
It is not uncommon for legacy applications to require direct database access or admin access for production support or business operations requirements. 

It is recommended that when migrating such applications to the cloud, both application access and network access are important parameters to consider and evaluate properly in order to implement the right solution. 


#### Disaster Recovery (DR)
Apart from being highly available (HA), many enterprise applications have centralized DR plans and processes in place. 

Cloud migration provides an opportunity to tier the applications based on service levels and DR profiles, and develop application specific deployment models.


#### Partners
An important part of transitioning successfully is choosing the right vendor according to their reliability, security metrics and certifications. If the provider is too small they may not last, if they are too big, you may not be their priority. It is capital to ensure that vendor has full range of capabilities that your business requires.

Do you have vendors, partners, clients that are accessing your on premise solution today? Review in deep how they can access that resources in a cloud solution and get the cloud services provider to do a full analysis of the current premise based infrastructure, especially with the customized functionalities adapted to the existing premise system that need to be migrated to the new cloud solution.


#### End User Adoption
Once the business has migrated fully to cloud based operations, it’s crucial to shift the focus to end user adoption. Cloud based technology offer greater features and flexibility than premise based. 

Many companies fail to leverage these benefits and continue their new cloud operations in the same manner as their earlier premise solution.


#### Cultural Change
Recognize and prepare for the change: cultural changes and general operational changes to how things work. Be open-minded as change can be hard, but worth it on the other side. 

The positive side to all of this change is that final customer should always be accompanied throughout the whole process. Remember that the cloud is always a relationship, not merely a product.


### Common Mistakes

In order to complete this document we are going to provide some more information related to common mistakes when deploying migrations to the cloud.

Perhaps the best approach is to complete the migration process by deploying the previous best practices from the beginning to the end and try to avoid all the following common mistakes. 

Good luck with all of your migrations!. 


#### Expenses

The first major mistake that enterprise makes when moving their IT operations on-premise to the cloud is not understanding the total cost of the process.

There are several complex metrics that must be used when determining if a migration of an application or project to the cloud is actually saving the company money. 

This is why it is highly recommended to invert time in measure the actual cost versus future cost on the cloud. 


#### Security & Governance

Another common mistake is plunging into the cloud without considering the security and governance standards that must be met. 

Always is up to the IT department to balance and follow up the proposal of accessibility and security in the IT infrastructure when migrated to the cloud.


#### Priorice

Prioritizing what applications (and in what order) are needed to be moved to the cloud is an important goal. 

Not everything needs to be moved into the cloud. Managers should look for applications that can be moved to the cloud in a cost-effective way, without sacrificing usability and security. 

By taking it on a case by case basis, special care can be taken for every specific applications in order to choose the best option.


#### Reusing

Legacy applications can have an architecture that is the exact opposite of cloud-native applications. 

By simply doing a lift and shift to the cloud, these applications could become less available or more unstable, so is also highly recommended to evaluate and deploy a new version of the application for the cloud. 

Luckily, in many cases the application refactoring that is required to fully leverage the cloud is only incremental compared to the lift and shift model. Often, a new deployment architecture will be sufficient to address the challenges. But simply lifting & shifting: i.e. replicating the legacy architecture in the cloud is a recipe for disaster.

---

## Account Management

There is no written rule about the account management when a new project is created. Although the first approach for small projects could be to create only one account for all the environments, it has to be known that some limits (number of EIP or EC2 instances and services (i.e. DynamoDB, IAM, Security Groups) are shared through the entire account. This could lead to problems in production when a limit is reached by someone in development.

Said that, it is a BEEVA best practice to separate projects by environment, creating one account for environment (development, maybe QA, staging and production). If for several causes different accounts can't be created, the environments has to be marked by different VPCs in order to isolate them.

There is one central account for user management and corporative issues, which has the consolidated billing for all the accounts. It is in this account where the monitoring and Continuous Integration platforms are tipically allocated. In order to use it, the VPCs in the remain ones can be connected fisically by VPC Peering with the master account.

The name standarizarion used in BEEVA is the following:

```
<project>.<environment>.aws@beeva.com with name <Proyect> <Environment> | BEEVA
```

This means that when a new account is created, a new alias for the corporative mail has to be created, forwarding all the mail to *sistemas@beeva.com*.

---

## User Management

Users in the account can be created with the Identity and Access Management (IAM) service. Following the previous section, where the creation of different accounts per environment, all subordinated to a master account for the billing and corporative tools, the same can be said about user management.

Not only the billing is consolidated into the master account. IAM users are managed with this account too, providing the assumption of the desired role with one single login. 

![Delegated user management](static/delegated.png "Delegated user management")

There is a github project for performing this, named [Anwbis](https://github.com/beeva/anwbis), based on the examples shown in the AWS blog: [How to enable cross account access to the AWS Management Console](https://blogs.aws.amazon.com/security/post/Tx70F69I9G8TYG/How-to-enable-cross-account-access-to-the-AWS-Management-Console).

### User creation

The minimum set of permissions rule apply when a new user is created. The BEEVA convention for the naming is the same as the corporative email without the @beeva.com, so i.e. for a new user named *john.doe@beeva.com*, the user *john.doe* is created in the master account. For external users, the rule is to writte *john.doe.contractor*.

The user is created with the MFA flag marked as true, so he can login into the different accounts using his multifactor authentication device (tipically [Google Authenticator](https://support.google.com/accounts/answer/1066447?hl=es), but tipically there is no permission to login into the master account in the AWS Management Console. 

The policy Corp-IAM-Permissions has been created to provide the minimum permission rule for assuming the role in the child accounts. At the time of this writting it is the following (The master account ID has been deleted by obvious reasons):

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1417088730000",
            "Effect": "Allow",
            "Action": [
                "iam:GetGroup",
                "iam:GetGroupPolicy"
            ],
            "Resource": [
                "arn:aws:iam::***********:group/corp-*"
            ]
        },
        {
            "Sid": "Stmt1417088730001",
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword",
                "iam:ListMFADevices",
                "iam:GetUser",
                "iam:GetUserPolicy",
                "iam:ListGroupsForUser",
                "iam:ListUserPolicies"
            ],
            "Resource": [
                "arn:aws:iam::************:user/${aws:username}"
            ]
        }
    ]
}

```

Note the use of the IAM variable *aws:username*, in order to provide a reusable policy for the entire organization.

### Delegated roles

#### Steps in the child account

As all the users in the project has to have the right permissions to use the accounts, several IAM roles can be created in the child account. The name convention is to use a role named:

```
 <environment>-<project>-delegated-<role_name>
```

For compatibility with anwbis, the role_name is advised to be *admin*, *developer*, *user* or *devops*.

In the role, the minimum permissions for the kind of user has to be provided. See [IAM](#iam) section for more information about how to create the role.

#### Steps in the master account

In order to provide the delegated use, a group named 

```
corp-<project>-master-<role_name> 
```

has to be created in the master account, where role name is tipically *admin*, *developer*, *devops* or *user*. It has only a policy named *Delegated_Roles* with the following structure:

```
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["sts:AssumeRole"],
    "Resource": [
        "arn:aws:iam::************:role/dev-<project>-delegated-<role>",
        "arn:aws:iam::************:role/pre-<project>-delegated-<role>",
        "arn:aws:iam::************:role/pro-<project>-delegated-<role>",
        "arn:aws:iam::************:role/val-<project>-delegated-<role>"
      ], 
    "Condition" : { "Null" : { "aws:MultiFactorAuthAge" : "false" } }
  }]
}
``` 

Where *role* is *admin*, *developer*, *devops* or *user*. In this example there are four environments for the project, but this policy could be extended with all the needed roles.

The users belonging to a project are attached to the group with the set of permissions needed, and they can login and attack the AWS API for the desired account.

#### IAM Credentials and Anwbis

Each user has a set of credentials (Access Key and Secret Key) which are not useful unless a MFA token is provided. In order to use the AWS cli (or other SDK), it is recomended that the file *~/.aws/credentials* is present and with the following content:

```
[default]
aws_access_key_id=<AccessKey>
aws_secret_access_key=<SecretKey>
```

When the user want to get a set of valid credentials with anwbis (version 1.2.1, at the time of the writting), he can do it by typing the following: 

```
anwbis  --profile <profile> -p <project> -e <environment> -r <role_name> --region <region_to_use>
```

The profile section is only needed if the credentials are not located on the default profile. If no region is provided, *eu-west-1* is taken into account.

This creates a new section into the *.aws/credentials* file, with a valid session token.

```
[default]
aws_access_key_id=<AccessKey>
aws_secret_access_key=<SecretKey>

[<project>-<environment>-<role_name>]
aws_access_key_id = <DelegatedAccessKey>
aws_secret_access_key = <DelegatedSecretKey>
aws_session_token = <DelegatedSessionToken>
region = <DefaultRegion>
```

The login into the AWS Management console can be done by providing the flag *-b*, with the browser *chrome* or *firefox* as an argument.

For several scenarios, such as continuous integration, the login can be made without MFA with the flag *--nomfa*. Additional arguments such as *--refresh* (for renewing the token each time) or *--duration* (for changing the duration of the token, from 900 to 3600 seconds) are also provided.

---

## Security
---
## Storage

### Introduction


AWS is a cloud computing platform which offers several options depending on the goal we want to achieve: durability, availability, latency, etc.

AWS provide us different storage options within its range of services. The main features of most important are:

#### S3

Simple Storage Service. S3 is a highly-scalable, reliable and low-latency distributed file system. We can use S3 in combination with our EC2 instances in order to get a scalable storage decoupled from our EC2 infrastructure.

##### Durability and Availability
Amazon S3 is designed for 99,999999999% **durability** per object and 99,99% **availability** over a 1 year period.

S3 provides mechanisms to prevent accidental deletion, allowing object versioning, and deletion with Multi-Factor Authentication. 

Also, you can use Reduced Reduntant Storage option (RRS) which provides a lower level of durability at a lower storage cost. Even being less durable than standard S3 objects, is still designed to provide 400 times more durability than a standard disk drive.

##### Scalability and Elasticity
S3 has been designed to offer a high level of elasticity and scalability automatically. S3 distributes automatically objects in your buckets among all the servers that conforms the infrastructure of S3.

##### Limits
S3 has no limit in the number of objects that you can store in a single bucket, but it has a 5TB limit per object.

##### Advanced Features
S3 has some interesiting extra features:
* The video streaming capacity
* The capacity to store and serve static webpages, acting like a static webhosting
* Object distribution via BitTorrent protocol, in order to get less API calls and the consecuent pricing benefits

#### Glacier

Amazon Glacier is an extreme low-cost AWS storage designed, which has been designed for archives and historical data. It provides a flexible and high durable storage, and it integrates seamlessly with S3 to define the object lifecycle at bucket level.

Glacier is commonly used to manage infrequent accessed data. The jobs to get data from Glacier back to S3 used to take 2-5 hour to complete.

#### EBS

Amazon EBS (Elastic Block Storage) are persistent block-level storage for EC2 instances. EBSs are attached to an EC2 instance, and used as a physical hard drive. EBS disks persists independently of a running life of its attached EC2 instance.

EBS disks are used specially for data which changes frecuently, for disks in a database for example, and for data which needs a long time persistance.

Also, you can perform automatic point in time backups of EBSs. These automatic backups are called Snapshots, and are stored in S3.

##### Types

There are different types of EBS volumes:

* **Standard Volumes**. These are the cheapest one, but doesn't have a great performance.
* **Provisioned IOPS Volumes**. PIOPS Volumes are designed to deliver high performance measured on IOPS (Inputs/Outputs Per Second). Currently, you can achieve 20.000 IOPS on a single disk. You can even stripe multiple volumes together to get hundreds of thousands of IOPS on a single instance.

EBSs are replicated across multiple servers, but it is attached to a single Availability Zone.

To maximize durability of your EBS disk, a good practice is to perform regular snapshots. For data consistency, it would be better to disable momentarily writes on disk, and then take the snapshot. Normal usage of disk can be performed while the snapshot is being taken.

You can create a new Volume from a Snapshot and start using inmediately. Even if it you have configured a large amount of space. There is no need to wait until the whole information wille be copied from S3, it will request the pending informacion when it is demanded.

---
## Services

### EC2
Amazon EC2 is one of the primary AWS service which provide the Infrastructure as a Service(IaaS) and it is related directly to several topics such as networking, security, ... so apply best practices in EC2 is very important.

##### EC2 Instance Management
* Follow the Standard Naming convention to the EC2 Instances like : project, environment, content / purpose of the instance, ... Example : _dev_memento_apis_ or _dev_memento_spark_
* Usually is necessary an Elastic IP, this way stop and start of the Instance will not impact the connections.
* Stop not needed Instances (for non productive environments),  the best approach here is doing it automatically so after work timetable and weekends the instances go down.
* Communicate always using the Private IP’s when possible to avoid the data transfer charges.
* When previous rule is not possible, use Public DNS, since when the comunication is from Internet or other regions, it will resolve as Public IP, however, if it is from same region it will resolve as Private IP automatically.
* Don’t keep any important data in ephemeral storage. You will lose the data, when you stop and start the instance.
* Use termination protection when necessary to prevent the accidental termination of EC2 instances.
* Select carefully instance types depending on the applications requirements (computation, memory, ...) running in it, AWS is always presenting new instance types and sometimes new ones are better and cheapper than old ones you need to be always up to date in that matter, in this [link](https://aws.amazon.com/ec2/pricing/) you can see instance types and prices so you can compare, be careful and select the target Region since the price is not the same.
* Setup the CloudWatch Monitoring alarms for CPU and Instance Status and configure the alerts for your support mail ID, to notify for any CPU issues or instance reachability issues.
* Periodically, run AWS trusted Advisor and see the underutilized instances, so that you can degrade them to the lower instance types

##### EBS Management
* Follow a convention for naming EBS volumes, the names should be self-explanatory, so with the name you can find out what is in there : volume purpose, environment, ... for example: _kafka_zookeeper_topics_data_volume_
* Take EBS snapshots regularly. The frequency will be based on the used of the volume, the more use, the more frequent, also it is useful before deploy a new release or a big change.
* Copy EBS snapshots to your DR or backup region to maximum availability.
* Keep at least last 15 snapshots of EBS volumes so you are able to rollback your data to certain older date.
* Perform regulary cleaning for the unused Volumes to avoid the confusion and cost saving.
* Be aware of the impact of the snapshots so always take your volumes snapshots at non-business hours.

##### AMI Management
* Create a Golden AMI, once you setup & configure your EC2 machine completely.
* Create Production AMI’s backup frecuently (depending on the frequency of changes you made to the Instance).
* Follow a standard naming convention when you name the AMIs. Best practice is append current date for the AMI name and Description. For example : _APIs_prod_AMI_201501212_
* Perform frecuently cleaning for not used AMIs.
* Copy the AMIs to the DR or backup region (if the project has) whenever you take the new AMI.

##### Security
* As in the previous sections, follow the Standard Naming convention for Key Pairs and Security Groups, this is always useful so  you can understand the purpose in at first glance.
* **Never** ever share any of your Key Pairs unless it is really needed.
* Create separate Keys and Groups for each group of Instances. Never use a single Key Pairs or Security Group for your entire region. 
* Perform frecuently cleaning and remove unused Security Groups / Key Pairs, specially remove the keys of users who are not part of the project or organization. Also unused ports (perphaps opened temporary) should be part of the cleaning.
* Use IAM permissions and never ever share the master key.
* Recycle the keys periodically, let's say half-yearly or yearly and create the new keys including master key.
* You shouldn't use a default SG for any instance.
* Never open any port to the entire public (Source 0.0.0.0/0) unless really needed, for example for ports like 80, 443 etc. Have in mind that for internal communications you can open ports using security groups rather than directly IP’s. Be aware that Public and Private IP’s keep changes.
* Create the SG before launching EC2 instance and assign it while launching it because you can’t change it once you have launched it.

### DynamoDB

DynamoDB best feature is the high performance, this guideline is a summary of best practices to maximize performance and to minimize throughput costs.

* Select the right primary key, this can be simple (partition key) or composite (partition key and sort key), have in mind that DynamoDB divides a table's items into multiple partitions, and distributes the data primarily based upon the partition key value. The provisioned throughput associated with a table is also divided evenly among the partitions, with no sharing of provisioned throughput across partitions so keep your workload spread evenly across the partition key values, distributing requests across partition key values distributes the requests across partitions.
* Cache Popular Items
* Provision the right amount of read and write capacity: to understand this let's use and example: consider a situation where you need to bulk-load 20 million items into a DynamoDB table. Assume that each item is 1 KB in size, resulting in 20 GB of data. This bulk-loading task will require a total of 20 million write capacity units. To perform this data load within 30 minutes, you would need to set the provisioned write throughput of the table to 11,000 write capacity units, in this scenario, DynamoDB will create 11 partitions, each with 1000 provisioned write capacity units. To understand the Provisioned Throughput in depth go to [this link](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/ProvisionedThroughputIntro.html).
* Test Your Application At Scale
* Items: DynamoDB items are limited in size ([see Limits in DynamoDB](http://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Limits.html)), however, there is no limit in terms of the number of items in a table so rather than storing large amount of data in attribute values in an item, consider one or more of these application design alternatives.
* Query and Scan: avoid Sudden Bursts of Read Activity since this can consume the provisioned read capacity, instead of using a large Scan operation, you can use Reduce Page Size and/or Isolate Scan Operations to minimize the impact of a scan on a table's provisioned throughput.
* Take Advantage of Parallel Scans
* Local secondary index lets you define an alternative sort key for your data, so they can be very useful but don't create them on attributes that you won't often query since they can contribute to increased storage and I/O costs.
* Regarding indexes, be aware of the cost of I/O operation to maintaining them, specially for tables with heavy write activity, If you need to index the data in such a table, evaluate copying the data to another table with any necessary indexes, and query it there.
* Optimize Frequent Queries To Avoid Fetches: to get the fastest queries with the lowest possible latency, project all of the attributes that you expect those queries to return
* Take Advantage of Sparse Indexes: for any item in a table, DynamoDB will only write a corresponding index entry if the index sort key value is present in the item. If the sort key does not appear in every table item, the index is said to be sparse.
* Global secondary indexes can be a powerful feature since they since them let you define alternative partition key and sort key attributes for your data so you can query a global secondary index in the same way that you query a table, always having in mind that it's very important to distribute the read and write activity evenly across the entire table based on the indexes so you should choose partition keys and sort keys that have a high number of values relative to the number of items in the index. Rremember that global secondary indexes do not enforce uniqueness.



### Scaling (ELBs y ASGs)
---
### S3

S3 is the petabyte-scale, fault-tolerant and highly-available distributed file system from AWS.

There are some considerations to make better use of S3.

* **Make use of different object types defined by its access frecuency and criticality**. You can choose between:
	* *Standard*.
	* *Infrequent Accessed Data (IA)*: 99% availability instead of eleven 99,999999999. 
	* *Reduced Redundant Storage (RRS)*: Less durability.

* **Use Server Side encryption** for the projects which needs to store encrypted data at rest. SSE make use of AES 256 algorithm to encrypt and decrypt the information.

* **Static Web Hosting options** allows you to serve an static webpage (eg, an informational web) at no cost other than the files size.

* **Activate S3 Server Logging** in order to get feedback about how your users interact with your data.

* **Enable versioning at bucket level** to be able to recover data lost by mistake or data which was deleted time ago. Rememeber you only can manage 1 version of an object at once, so when you recover the object, you loose the most recent one.

* **Specify lifecycle management configuration**. Tis feature allow you to control where are your objects (S3 or Glacier) and configure one of the special object types for your objects.

* **Cross-Region Replication**. This option copy objects from buckets asinchronously to other region.

---
### IAM

IAM enables you to control who can do what in your AWS Account. There are 10 best practices that you can realize related to IAM

####Create individual IAM users

Don't use your AWS root account credentials to access AWS, and don't give your credentials to anyone else. Instead, create individual users for anyone who needs access to your AWS account. Create an IAM user for yourself as well, give that user administrative privileges, and use that IAM user for all your work.

By creating individual IAM users for people accessing your account, you can give each IAM user a unique set of security credentials. You can also grant different permissions to each IAM user. If necessary, you can change or revoke an IAM user's permissions any time. (If you give out your AWS root credentials, it can be difficult to revoke them, and it is impossible to restrict their permissions.)

#### Use groups to assign permissions to IAM users

Instead of defining permissions for individual IAM users, it's usually more convenient to create groups that relate to job functions (administrators, developers, accounting, etc.), define the relevant permissions for each group, and then assign IAM users to those groups. All the users in an IAM group inherit the permissions assigned to the group. That way, you can make changes for everyone in a group in just one place. As people move around in your company, you can simply change what IAM group their IAM user belongs to.

#### Grant least privilege

When you create IAM policies, follow the standard security advice of granting least privilege—that is, granting only the permissions required to perform a task. Determine what users need to do and then craft policies for them that let the users perform only those tasks.

It's more secure to start with a minimum set of permissions and grant additional permissions as necessary, rather than starting with permissions that are too lenient and then trying to tighten them later.

Defining the right set of permissions requires some research to determine what is required for the specific task, what actions a particular service supports, and what permissions are required in order to perform those actions.

#### Configure a strong password policy for your users

If you allow users to change their own passwords, require that they create strong passwords and that they rotate their passwords periodically. On the Account Settings page of the IAM console, you can create a password policy for your account. You can use the password policy to define password requirements, such as minimum length, whether it requires non-alphabetic characters, how frequently it must be rotated, and so on.

#### Enable MFA for privileged users

For extra security, enable multifactor authentication (MFA) for privileged IAM users (users who are allowed access to sensitive resources or APIs). With MFA, users have a device that generates a unique authentication code (a one-time password, or OTP) and users must provide both their normal credentials (like their user name and password) and the OTP. The MFA device can either be a special piece of hardware, or it can be a virtual device (for example, it can run in an app on a smartphone).

#### Use roles for applications that run on Amazon EC2 instances

Applications that run on an Amazon EC2 instance need credentials in order to access other AWS services. To provide credentials to the application in a secure way, use IAM roles. A role is an entity that has its own set of permissions, but that isn't a user or group. Roles also don't have their own permanent set of credentials the way IAM users do. In the case of Amazon EC2, IAM dynamically provides temporary credentials to the EC2 instance, and these credentials are automatically rotated for you.

When you launch an EC2 instance, you can specify a role for the instance as a launch parameter. Applications that run on the EC2 instance can use the role's credentials when they access AWS resources. The role's permissions determine what the application is allowed to do.

#### Delegate by using roles instead of by sharing credentials

You might need to allow users from another AWS account to access resources in your AWS account. If so, don't share security credentials, such as access keys, between accounts. Instead, use IAM roles. You can define a role that specifies what permissions the IAM users in the other account are allowed, and from which AWS accounts the IAM users are allowed to assume the role.

#### Rotate credentials regularly

Change your own passwords and access keys regularly, and make sure that all IAM users in your account do as well. That way, if a password or access key is compromised without your knowledge, you limit how long the credentials can be used to access your resources. You can apply a password policy to your account to require all your IAM users to rotate their passwords, and you can choose how often they must do so.

#### Use policy conditions for extra security

To the extent that it's practical, define the conditions under which your IAM policies allow access to a resource. For example, you can write conditions to specify a range of allowable IP addresses that a request must come from, or you can specify that a request is allowed only within a specified date range or time range. You can also set conditions that require the use of SSL or MFA (multifactor authentication). For example, you can require that a user has authenticated with an MFA device in order to be allowed to terminate an Amazon EC2 instance.

#### Lock away your AWS account (root) access keys

You use an access key (an access key ID and secret access key) to make programmatic requests to AWS. However, do not use your AWS account (root) access key. The access key for your AWS account gives full access to all your resources for all AWS services, including your billing information. You cannot restrict the permissions associated with your AWS account access key.

Therefore, protect your AWS account access key like you would your credit card numbers or any other sensitive secret. Here are some ways to do that:

- If you don't already have an access key for your AWS account, don't create one unless you absolutely need to. Instead, use your account email address and password to sign in to the AWS Management Console and create an IAM user for yourself that has administrative privileges.
- If you do have an access key for your AWS account, delete it. If you must keep it, rotate (change) the access key regularly. To delete or rotate your AWS account access keys, go to the Security Credentials page in the AWS Management Console and sign in with your account's email address and password. You can manage your access keys in the Access Keys section.
- Never share your AWS account password or access keys with anyone. The remaining sections of this document discuss various ways to avoid having to share your account credentials with other users and to avoid having to embed them in an application.
- Use a strong password to help protect account-level access to the AWS Management Console. For information about managing your AWS account password, see Changing the AWS Account ("root") Password.
- Enable AWS multifactor authentication (MFA) on your AWS account. For more information, see Using Multi-Factor Authentication (MFA) in AWS.

---
### Lambda

AWS Lambda is a compute service where you can upload your code to AWS Lambda and the service can run the code on your behalf using AWS infrastructure. After you upload your code and create what we call a Lambda function, AWS Lambda takes care of provisioning and managing the servers that you use to run the code. 

The following are recommended best practices for using AWS Lambda:

* Write your Lambda function code in a stateless style, and ensure there is no affinity between your code and the underlying compute infrastructure.
* Lower costs and improve performance by minimizing the use of startup code not directly related to processing the current event.
* Use the built-in CloudWatch monitoring of your Lambda functions to view and optimize request latencies.
* Delete old Lambda functions that you are no longer using.
* Use Lambda function versioning and aliases  to better manage your in-production Lambda function code
* Test your functions before enable your event sources

---
### SQS

Amazon SQS is a distributed queue system that enables web service applications to quickly and reliably queue messages that one component in the application generates to be consumed by another component. A queue is a temporary repository for messages that are awaiting processing.

There is some best practices that you should use to work with SQS

#### Use Long Polling

Long polling allows the Amazon SQS service to wait until a message is available in the queue before sending a response. So unless the connection times out, the response to the ReceiveMessage request will contain at least one of the available messages (if any) and up to the maximum number requested in the ReceiveMessage call.

Long polling reduces the number of empty responses and false empty responses wich also helps to reduce your cost of using Amazon SQS.

You can activate long polling by set a value between 1 - 20 seconds for Receive Message Wait Time when you create a queue.

#### Visibility Timeout greater than 0 but not too high

Visibility Timeout avoid that two consumers receive the same message from a queue. If you set a visibility timeout too low ( like 0 s ) multiple consumer will process the same from that queue. In the other hand if you use a high visibility timeout value ( like 12h ) and the consumer of message die before complete message process you must wait too long in order to other consumer be able to consume that message.

![](static/Visibility_Timeout.png) 

#### Use Batching

Amazon SQS queues can deliver very high throughput (many thousands of messages per second). The key to achieving this throughput is to horizontally scale message producers and consumers. In addition, you can use the batching actions in the Amazon SQS API to send, receive, or delete up to 10 messages at a time. In conjunction with horizontal scaling, batching achieves a given throughput with fewer threads, connections, and requests than would be required by individual message requests. Because Amazon SQS charges by the request instead of by the message, batching can also substantially reduce costs.

#### Define Retention Period

SQS automatically deletes messages that have been in a queue for more than maximum message retention period. In some use cases, messages are no longer useful few minutes after they are send to queue. Set a short retention period ( like 5 minutes ) is a good practice to reduce polling of not useful messages.

---
### RDS

Amazon Relational Database Service (Amazon RDS) offers a distributed relational database running in the cloud that you can easily set up , operate and scale also provides cost-efficient , resizable capacity and manage common database administration tasks.  
Engines compatible with aws are MySQL, MariaDB, PostgreSQL, Oracle, Microsoft SQL Server, and MySQL-compatible Amazon Aurora DB .

These are the best practices you should follow when using this service:

* **Monitor :** It is very important to be aware of the use that your database receives to maintain system performance and availability . 
You can use the console to view metrics in real time for your DB instance or consume Enhanced Monitoring JSON output from CloudWatch Logs , this will help you to be notified when usage patterns change or when you approach the capacity of your deployment . More about [Enhanced Monitoring](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Monitoring.OS.html).  
Study performance problems in your metrics, you can improve the performance of the most used and most resource consumption queries using Tuning Queries consultations, read about best practices to use in each database engine [here](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_BestPractices.html#CHAP_BestPractices.TuningQueries) .

* **Scale up :** You must be prepared to scale up your DB instance when you receive unexpected increases from your applications.

* **Better safe than sorry :** 
 * **Automatic backups :** Having backups is a must, enable and select the appropriate time of day to occur. [See more](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.BackingUpAndRestoringAmazonRDSInstances.html).
 * **Test failover**  for your database instance to understand how long the process takes for your use case and to make sure that the application that accesses your database instance can automatically connect to the new DB instance later Of the failover.
 * **Recovery after failover** or database failure is very costly and slow , maintain control over the workload your database requires and if you need to increase it do any or all of the following:
	* Migrate to a DB instance class with High I/O capacity.
	* Changing standard storage (magnetic)  by another may be a good choice depending on your upgrade needs, there are more options like General Purpose (SSD) and IOPS Provided (input / output operations per second). Each one is different in its performance characteristics and price, you will also have to take into account if your DB instance is optimized for them. More about [Storage Types](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_Storage.html) .
	* If you are already using Provisioned IOPS storage, provision additional throughput capacity.

* **Set a time-to-live (TTL)** when your application caches the DNS data of your database instances. This will prevent your application from attempting to connect to an IP address that is no longer in service after an error.

* **Amazon RDS Security** : Use individual AWS IAM accounts for each user including yourself, giving each one the minimum required permissions for their responsibilities, you can group users using IAM groups.  
There should be no users with root credentials and you must rotate your IAM credentials regularly, this is the best way to control access to RDS API actions such as create , modify or delete such important resources as DB instances,security groups, option groups, or parameter groups, and others such as backing up and restoring DB instances or configuring Provisioned IOPS storage.  
For information on IAM best practices see [IAM Best Practices](#iam) .


---

### References

* [Architecting for the Cloud: Best Practices](http://media.amazonwebservices.com/AWS_Cloud_Best_Practices.pdf) 
* [IAM Best Practices](http://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
* [AWS SQS Developer Guide](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/Welcome.html)
* [Lambda Developer Guide](http://docs.aws.amazon.com/lambda/latest/dg/welcome.html)
* [RDS Best Practices](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_BestPractices.html)

___

[BEEVA](http://www.beeva.com) | 2016
