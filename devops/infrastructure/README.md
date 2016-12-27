Infrastructure
==============

## What is IT Service Management (ITSM)?

According to ITIL, ITSM is defined as "The implementation and management of quality IT services that meet the needs of the business. The IT service management is performed by IT service providers through appropriate mix of people, processes and information technology. "

IT Service Management (ITSM) refers to the discipline that is based on the processes of IT services in the company, always thinking about the end customer.

IT Service Management proposes to change the paradigm of IT management, a collection of components focused on services, using different frameworks with "best practices".

Usually the IT service management involves the use of external services, internal services and shared services. It is extremely important to maintain a broad base of knowledge within the organization so that these practices are successful.
Among the most important objectives of IT management services include:

- Align business processes and IT infrastructure.

- Provide a high-level management for the company.

- Reduce the risks associated with IT services.


## Aligning business objectives

Companies currently making significant investments in IT resources to support business processes. Currently the most important value for companies are the use you give your information, this determines that all processes relating to the production and use of Information Technology services should be optimally managed and controlled to ensure the quality of it.

All data processing and information product operations and business processes, techniques and measures required to implement control management system that complies with the provision of services and reducing risk vulnerability to threats that endanger the system stability.

In companies there is an organization that generates and provides IT services and a group of internal and external customers demanding these services. Relations and communications between the provider of IT and IT customers should be channeled through a system that guarantees delivery processes

Investments made in IT infrastructure and information assets of organizations are becoming increasingly important, which justifies the implementation of systems to ensure process performance based IT services.

How is it possible to guarantee access to information within a company and justify the investment. Currently we have frames work for it, one of the mostly known is ITIL.

## Information Technology Infrastructure Library (ITIL)

ITIL is a framework that brings together concepts and best practices for managing IT services. ITIL is a comprehensive set of procedures for businesses, to achieve quality and efficiency of IT services. Integrating technology with the company. With this it is getting innovation, speed of reaction, answers to problems, and ability to work, in other words to optimize the work.

We can divide the principles of ITIL is the following:
- Processes.

- IT Services.

- Service management.

- Lifecycle Services.

- Learning and Certification.


## Processes

According to ITIL, "A process is a structured set of activities designed to achieve a specific goal. A process takes one or more defined inputs and turns them into defined outputs. "
ITIL is based on processes, which can be divided into the following questions:

- Where do we want to be? (Mission and Business Goals)

- Where are we today? (Rating)

- How do we get there? (Changes in the process)

- How do we know that? (Metric)

ITIL postulates that the support service, the administration and the operation is performed through five processes:

- Incident Management

- Handling problems

- Management settings

- Management changes

- Management of delivery


#### Incident Management Process

Its primary goal is to restore service as quickly as possible to prevent the client is affected, this is done in order that the effects of the operation are minimized.


#### Problem Management Process

The objective of this process is to prevent and minimize the incidents, and this leads to a reduction in the level of incidence. On the other hand it helps us to provide fast and effective solutions to ensure structured resources.

In this process what is sought is that you can have full control of the problem, this is achieved by giving tracking and monitoring the problem.


#### Configuration management process

Its aim is to provide real and current information than you have configured and installed on each client system.


#### Change Control Process

The aim of this process is to reduce both technical, economic and time when performing changes risks.


#### Process management deliveries

Its aim is to plan and successfully control the installation of software and hardware under three environments: development environment, controlled test environment and real environment.


## Backup and recovery

### Do a backup and recovery guide

One of the most important things what you should do when you are administrating a system could be have a backup and restore policy.
This policy should have a list of things to do for a system backup and what to do to recover.

Also, this policy would have how many time cost the backup process and how many time you need to recover the information. You should consider that the backup size
increase over time.

These are several things that you should consider:
1. What kind of hardware is making a backup (network topology and hardware, drives, tapes,...)
2. The backup time should be less than backup window
3. The restore time should be ok for your bussiness.
4. Retention time. How many time you should be your old backups safe.
5. You need recover to one snapshot point or a specific point in time (point in time recovery)
6. That perform backup:
	1. System
	2. Database
	3. Aplication
	4. ...

### How to do the backup

Depending on what you want perform backup you can select several ways, some of them only are useful to one type and other all valid to all. You can made backup from several sources, you should think which is better for your system or application.
Sometimes you need only do backup from your database and you won't have system backup because you can recover the system quickly.

These are some ways to do backup:
	- Backup on array storage: You perform a snapshot and the storage save the information between snapshot.
	- Backup between array storage: A storage make a snapshot and send data to another storage.
	- System backup: You can made a full system backup or exclude some folders
	- Backup from database: You can use specific database tools to do a backup
	- Backup from application: Some application can save data and files from one specific export tool.

Other think to keep in mind is backup window, If the backup time is more than backup window you must do reduce backup size, change backup time, optimize backup or increment hardware to backup. And if you restore time isn't ok also.
If you don't have a specific network to backup your system performance could be reduce when the backup is doing.

You should consider how is your system, the more complex is the more complex the backup.

### Backup size

One of the most important things you have to consider is the backup size. It could limit the information you can save or the retention time.
You have a limit storage where you make a backup and you must adapt your backup to it. You must keep the information for a bussiness retention time and you must keep it safe during it.

Reduce backup size if is posible, you try to reduce files to backup (remove iso, software zip, etc from backup), data read only that you safe previusly.
If you can get some file more quickly than recover from backup don't backup it. For example, you can reload a database from data files more quickly than recover from backup.

Also, you can perform incremental backup some days. It reduce the backup time but increase restore time. For example on weekend you can perform full and incremental backups on bussines days.

### Backup location

You can save backups to:
	- local or network disk. It's posible put in on tape later
	- Directly to tape.

Depend of backup location the time could be increase. Backup to disk normaly is more quickly than to tape.

Finally, you must safe the backup on different location when you do it, you send the tape to another place or send backup data to another place by network.

### Test recover process

A backup isn't useful if you don't test how to recover it. When you have a backup policy you have to test it. To test it you should recover several files from backup and do and full recover from your system on a test enviroment. This test could be useful to have recover time and to deploy a disaster recover guide.

Recover files and system from diferent times, if you have a retention of 30 days you should try to perform a recovery from files of 30 days ago.

Finally you should test recover process on the future. Maybe things were ok in the past, but they won't be ok on the future.

Capacity Planning
=================

Capacity planning is the process of determining the ability of a company to meet the growth in demand for its products.

There are thousands of models, planning to run a professional capacity since it can run each of shape, because in IT projects there is no single methodology or standard for this reason the term is not well known. Although for the implementation of a planning capacity it is important to have not only the hardware and software components, but also with human talent in the area.

 The duration and size depend on the target that you want to reach.

Thanks to capacity planning can distinguish between risk management and risk perception. In doing will allow us to know what are the real risks of the IT platform which we are responsible, as the risk impact on the business of our company.

The main moments which should execute a capacity planning are:

- During the development of the project.
- Once the platform is in production.
- Each time the company will make a decision on business.

The primary responsibility for capacity planning should be the area of ​​systems of the organization, since it is responsible for maintaining production systems and should know perfectly what the status and potential for growth.

The three basic steps necessary to execute a capacity planning are:

#### Defining service levels

Defines the minimum level above which the quality of service is acceptable. The definition of service levels must be realistic with the business needs of the company. Establish too demanding service levels can cause a miscalculation on the other service levels "relaxed" become an issue of platform performance against unexpected needs of small growths platform.
To set service levels must be clear what will work units, based on which service levels will be defined, generally tend to be those operations critical to the development of business, this allows me to identify problems in the IT platform associate problems to a part of the development of business and thus to manage the risk that this problem can come up.

#### Capacity analysis:

 Is to retrieve a set of data, depending on the quality of data collected and experience of the team that analyzed, this will be more or less accurate. Therefore there are two maxims when you analyze the capacity of the platform:
Having a procedure to collect data, which guarantees the same quality and have a team with enough experience to interpret the data collected correctly.

#### Action planning: 

is the last phase where being planned according to the results. Depending on the project phase in which we find ourselves, action planning can cause you to have to replant the architecture of the new platform, which is due to invest in the production platform, among others.
It should generate a customized documentation for the various areas involved in the project, failure to do so will not be able to transmit tightly and efficiently gaps, problems or changes in the platform.
In short, this is the time where you must perform a risk management, if we do not pass on the possible risks, have failed in our task of capacity planning and thus be endangering the business of our company.

___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies
