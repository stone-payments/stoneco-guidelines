# Server Security

## Content index

* [Introduction](#introduction)
* [Credential management](#credential-management)
* [Public Key Infrastructure solutions](#public-key-infrastructure-pki-solutions)
* [Network security](#network-security)
* [Server bastioning](#server-bastioning)
* [Back up and disaster recovery](#back-up-and-disaster-recovery)
* [Monitoring](#monitoring)
* [Vulnerabilities](#vulnerabilities)
* [Data encryption at rest](#data-encryption-at-rest)
* [Security audits](#security-audits)
* [Incident response](#incident-response)


## Introduction

Security is one of the pillars of the IT industry nowadays, and as such it needs to be introduced in many of the current company processes, developments and deployments.

This best practices guide provides an overview of the main topics regarding security practices for IT server environments. It will therefore provide guidance on the main topics that need to be taken into account when securing server solutions, by presenting the main tools that are recommended and by forwarding the reader to the appropriate standards or recommendations where relevant.

### NOTE:

If you are looking for one of the following topics, please follow the provided instructions in each case:

* For security best practices in AWS, please check: http://media.amazonwebservices.com/AWS_Security_Best_Practices.pdf
* For company wide security procedures and policies please check the ISO 27000 standard family: https://en.wikipedia.org/wiki/ISO/IEC_27000


## Credential management

### Credentials

**¿What's a credential?**

According to [wikipedia](https://es.wikipedia.org/wiki/Credential "wikipedia"), the following is:

"A credential is an attestation of qualification, competence, or authority issued to an individual by a third party with a relevant or de facto authority or assumed competence to do so. Examples of credentials include academic diplomas, academic degrees, certifications, security clearances, identification documents, badges, passwords, user names, keys, powers of attorney, and so on."

In this case, the following text will be devoted to the good practice in the password area.

As a starting point, we need to know how much time is required to "break" a password. That is, to test all possible combinations until its found. The following table shows this clearly:


| Password length | All characters            | Lower case only |
| --------------- |:--------------------------|:----------------|
| 3 characters    | 0.86 seconds              | 0.02 seconds    |
| 4 characters    | 1.36 minutes              | 0.46 seconds    |
| 5 characters    | 2.15 hours                | 11.9 seconds    |
| 6 characters    | 8.51 days                 | 5.15 minutes    |
| 7 characters    | 2.21 years                | 2.23 hours      |
| 8 characters    | 2.10 centuries            | 2.42 days       |
| 9 characters    | 20 millennia              | 2.07 months     |
| 10 characters   | 1,899 millennia           | 4.48 years      |
| 11 characters   | 180,365 millennia         | 1.16 centurie   |
| 12 characters   | 17,184,705 millennia      | 3.03 millennia  |
| 13 characters   | 1,627,797,068 millennia   | 78.7 millennia  |
| 14 characters   | 154,640,721,434 millennia | 2,046 millennia |


With this table in mind, it is possible to summarise that the password has to comply, at least, with the following requirements:

- **Minimum length of 8 characters**
- **Includes upper case letters**
- **Includes lower case letters**
- **Includes numbers**
- **Includes special characters (_-!@.....)**

By meeting those requirements alone, 2.10 centuries would be required to obtain the password. In contrast only, 2.24 days would suffice to obtain it if only lower case letters would be used.

When managing a server or a login service, this is a fact that needs to be controlled. In order to perform it, the pam.d and the sshd_config files are used.


### Password configuration in servers 

Pluggable Authentication Modules (PAM) is a common authentication scheme for Linux environments. The name of the daemon is pam.d and it has some configuration files associated. PAM is enabled by default in RHEL and it is available for use in other systems such as Ubuntu.

The service was previously configured in /etc/pam.conf. Currently this is performed in /etc/pam.d/

Now, a configuration sample for pam.d is reviewed in which the authentication is blocked for the user upon failure and in which the password requirements are enforced. Below, the meaning of the configuration is explained for the colour highlighted lines. (Please note that the configuration provided is an image, Scroll further down for selectable configuration).

![alt text](static/pamd_color.png?raw=true "pamd")

Lines will be explained by colours:

**Blue** - With these lines we indicate that if the user tries to access for 5 times with an access denied response, the sixth attempt will block the user for 30 minutes. This behaviour helps protecting against brute force attacks.

**Red** - With this part it is possible to force the user to introduce complex passwords. Specifically, the ones that have a minimum of 8 characters, at least 1 upper case letter, 1 lower case letter and 1 number. Additionally, the hash (sha512) of the last 5 password will be remembered. Lastly, the line with “password requisite pam_passwdqc.so min=disabled,disabled,16,12,8” indicates the requirements to comply based on the length on the password. For example, if the length of the password is lower than 12 characters, the system will require introducing a special character.

***vim /etc/pam.d/system-auth***

    ##%PAM-1.0
    # This file is auto-generated.
    # User changes will be destroyed the next time authconfig is run.
    authrequired  pam_env.so
    authsufficientpam_unix.so nullok try_first_pass
    authrequisite pam_succeed_if.so uid >= 500 quiet
    auth   required pam_faillock.so preauth audit silent deny=5 unlock_time=1800
    auth   [success=1 default=bad] pam_unix.so
    auth   [default=die] pam_faillock.so authfail audit deny=5 unlock_time=1800
    auth   sufficient pam_faillock.so authsucc audit deny=5 unlock_time=1800
    authrequired  pam_deny.so

    account required  pam_unix.so
    account sufficientpam_localuser.so
    account sufficientpam_succeed_if.so uid < 500 quiet
    account required  pam_permit.so

    passwordrequisite pam_cracklib.so try_first_pass retry=3 type=
    password required pam_cracklib.so try_first_pass retry=3 minlen=8,dcredit=-1,ucredit=-1,lcredit=-1
    password requisite pam_passwdqc.so min=disabled,disabled,16,12,8
    passwordsufficientpam_unix.so sha512 shadow nullok try_first_pass use_authtok
    password sufficient pam_unix.so remember=5
    passwordrequired  pam_deny.so

    session optional  pam_keyinit.so revoke
    session required  pam_limits.so
    session [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
    session required  pam_unix.so


More information on this configuration can be found in the following links:

[https://peterpap.net/index.php/Enforcing_Password_Complexity_on_CentOS/RedHat](https://peterpap.net/index.php/Enforcing_Password_Complexity_on_CentOS/RedHat)

[http://linux.die.net/man/8/pam_passwdqc](http://linux.die.net/man/8/pam_passwdqc)


## Public Key Infrastructure (PKI) solutions

Public Key Infrastructure is the set of entities and elements that when applied on internet solutions allows customer to:

1. Trust the other end in relation to the identity that it advertises.
2. Secure the communication between both parties so that no one having intercepted the communication is capable of understanding or modifying the message.

In this regard, Transport Layer Security (TLS) is the industry standard for communication encryption procedures for web related services. TLS is the evolution of SSL (Secure Socket Layer), and they are usually referred as TLS / SSL or even SSL. Most commonly but not only, TLS provides encryption for the HTTP protocol. This is the one used under HTTPS connections.

In this section, recommended practices are presented for all the aspects that have to do with the PKI area.

### On which services to protect

Depending on the characteristics of the service it might or might not be required to be protected. In general, the following points can be used as guidance for deciding which areas or services to protect, where the use is recommended:

* For online transactions.
* For any function that is not public and is login protected.
* For any personal data that is displayed.
* For file transfers.
* When the nature of the site requires the client to be protected.

On the contrary, when general information is made generally available it is not required and it can save a server side computational resources.

### Protocol version

The following are the guidelines for selecting the protocol version for a solution:

* SSL in any of its versions is fully deprecated.
* The recommended protocol is __TLS 1.2__.
* Please __make sure__ that the solution does not allow clients to negotiate any SSL version. TLS implementations were backwards compatible and this support has been dropped due to security issues.

### Certificate hashing algorithm

There are different hashing algorithms available to generate certificates:

* Certificate of the SHA 1 family.
* Certificate of the SHA 2 family.

Information points:

* SHA 1 algorithms are expected to be removed along 2016.
* Web browsers are currently displaying warnings for some certificates under this conditions.

The __recommended approach__ is to use:

* A SHA2 family certificate with at least 256 bit length key for new deployments.
* Existing SHA1 certificates should be gradually replaced until Q1 2016, beginning with the most critical services.

### Certificate deployment options

Server certificates can be deployed in different locations:

* Server: Deploy the certificate in the web server.
* Load balancer: The certificate is deployed in the load balancer and the traffic sent to the instances behind is sent in clear from this point.

In order to select a location please take into account:

* Installing the certificate in the load balancer is made in a single point, whereas in servers it needs to be replicated, which might introduce errors.
* The computational load generated by the encryption algorithms is very relevant. Additionally, virtualisation solutions do not perform cryptographic primitives very well since they are quite CPU intensive. For high load applications, the load balancer approach is recommended.
* In the case of the load balancer, a final communication is left cryptographically unprotected, although it might be physically secured. Care must be taken so that such traffic cannot be reached from other areas of the network.

### Autosigned certificates

It is possible to generate autosigned certificates, that is, when the CA is managed by the same company as the server. These type of certificates are not recommended in any case for production or open trial use. They should only be used for private trials where that is the only way of enabling TLS and the other option is not use ciphering.

### Certificate verification

When exposing HTTPS services it is possible to use tools to verify the status and configuration of deployed certificates.

As an example, Qualys provides a service that allows testing several certificate related parameters:

https://www.ssllabs.com/ssltest/

Once the revision is complete a grade is assigned A+ to F. The recommended value to be obtained is at least an A. In case of vulnerability detection useful information is provided in order to fix it.

## Network security

One key aspect of server security is the access to specific ports of machines. In order to prevent unauthorised access firewalls need to be used.

The use of firewalls of any kind is __absolutely necessary__ for internet reachable instances. In general, all traffic,

If a hardware firewall is not available, a good first step can be to make use of software firewalls. In Linux's case, it is possible to use the Kernel's netfilter module in order to block traffic. This module allows introducing rules to the networking stack of the Kernel and allows to perform operations on packets as the arrive, leave or they are forwarded through. Both the rules and the and the solution are usually referred to as IPtables, and they are available since Kernel 2.4 series. However a successor has been already introduced [nftables](https://en.wikipedia.org/wiki/Nftables).

For bastioning a host (please see next section), the following operations are the ones to be performed:

* As a default, block all incoming traffic.
* Provide access to service ports only.
* Limit the rate of calling to certain hosts.
* Create blacklists (origins whose packets are dropped) to be dynamic.
* Protect against known attacks such as SYN flooding and SYN spoofing.


## Server bastioning

Bastioning is the procedure of protecting a server to convert it into a bastion. In general, the clean installation of an operating system does not provide the required security guarantees for production operation. Hence, a set of changes __needs to be made__ for in order to protect the host.

The following is an overview of the tasks that need to be performed in order to obtain a bastion host:

* __Update all services and apply security patches:__ This will try to remove already known and therefore open security holes.
* __Protect the networking of the server with a firewall:__ This will drop all packets to ports not offering service or from unauthorised origins. It might be recommended to use some throttling solution in some cases, which blacklists the requester for some time in order to prevent brute force and Denial of Service (DoS) attacks.
* __Remove unnecessary users from the host:__ As an example, if there is a user for the printer and the server is not a printing server, that user needs to be removed. The less accounts available the better in order to avoid permission escalations.
* __Set aggressive permission schemes for users and services:__ Users should only be capable of the minimum when connecting to the system. That way, intentional or unintentional damages, and permission escalations are limited.
* __Configure the services to be offered by the server, with the most strict secure options:__ For example, if SSH is one of the services to be offered, disable tcp forwarding. A user should not be able to reach ports that are protected by the firewall.


### System update policy

A key question to make oneself is: **When should I update or patch my systems?**

Our recommendation is to create an update policy that ensures system updating periodically, once in a certain amount of time. For example, the policy can ensure that all systems are updated every three months.

The policy, should always be used as a base and it should include exceptions for more urgent matters. For example, if a serious vulnerability is identified, such as the HeartBleed or Poodle cases, the update should be applied as soon as possible. Therefore, the policy should cover the criticality level of the vulnerability in order to assess how soon the patch or update needs to be applied.

Another point to take into account are Kernel updates, which might bring security fixes along. For this case as well, the criticality level of the security fixes should be evaluated in order to decide whether the update should be applied immediately by creating an update window for that purpose or if the update should be held until the periodic update window.

### Software updates 

Usually, the update of web or application server products, such as Tomcat, Apache, etc can create problems with the services deployed. Due to this fact, their upgrade should be kept out of the scope of regular upgrade windows and it should be covered separately. Instead, it should be covered as a separate policy that takes case of testing and evaluating new versions in order to identify if the applications run correctly with such version. In case everything is correct for the new version the update process would be arranged and completed.

Another relevant point to take into account is trying to keep the same version of services along all systems and environments deployed. This approach allows predicting the behaviour of systems during updates.

### SSH configuration

Along with pam.d, the sshd_config file (in RHEL) needs to be filled in order to secure the access to servers.

A recommended basic configuration is the following one:

***vim /etc/ssh/sshd_config***

- ClientAliveInterval 900  -  Closes the user's session after 15 minutes of inactivity.

- Ciphers aes128-ctr,aes192-ctr,aes256-ctr - Allowed ciphers for ssh

- Banner /path/del/banner  - When someone accesses the servers a banner will be displayed, which normally indicates that unauthorised access is forbidden. A usual message would be:

*“ALERT! You are entering into a secured area! Your IP, Login Time, Username has been noted and has been sent to the server administrator!
This service is restricted to authorized users only. All activities on this system are logged.
Unauthorized access will be fully investigated and reported to the appropriate law enforcement agencies.”* 

Another recommendation is to change the ssh port so that a direct attack to port 22 can be avoided.

We would change

**port 22**

by

**port 8222**

Lastly, password rotation needs to be assessed. A password change is recommended every 90 days. The rotation will be enforced by modifying the ***/etc/login.defs*** file and setting the following line:

    PASS_MAX_DAYS   90

If users have been previously created, the following command needs to be executed:

    chage -d 0 user

This will force the user to change the password in its next login and it will enter the 90 day password rotation scheme.

A link is provided where other uses of the **chage** command are described:

[http://rm-rf.es/comando-chage-tiempo-de-vida-de-claves-y-usuarios-en-gnulinux/](http://rm-rf.es/comando-chage-tiempo-de-vida-de-claves-y-usuarios-en-gnulinux/)


## Back up and disaster recovery

Any solution can suffer failure any time and at any level. Those failures, can result in a potential data loss which might not be possible to recover. In order to prevent these kind of situations, different prevention schemes are used. Two are the main areas covered by the prevention plan or scheme:

* Data safety and back up.
* Disaster recovery.

The former covers how to replicate the relevant data that should not be lost in any case, and the latter focuses on both the process of planning against possible contingencies and restoring the solution once a contingency actually happens.

### Data safety and back up

Relevant data __needs to be backed up regularly__ in order to prevent data loss upon failure. Failures should be taken for granted in every situation and backups are the solution for avoiding many relevant issues.

#### Data safety

The first point to take into account is to ensure that data is correctly stored. Currently, the loss of business critical data can affect the performance of a company on the short and long terms, therefore the __main storage of data needs to be redundant__. That is, the same data needs to be replicated in several disks at the same time. This way, data can be preserved from some usual hardware failures. Being replicated, it is possible to restore the lost copy from the other ones.

#### Regular backups

Even with redundant storages, larger failures still happen, and therefore __regular backups are required for business critical data__. It is recommended that backups are kept in a separate location from the main one in order to avoid disasters to affect both sets (main and backup) at the same time.

In general, depending on the relevance of data, backups do not necessarily need to be enforced. For example, some kind of logs might not be critical and losing them might not affect business. Similarly, the periodicity of backups also depends of the data's relevance.

### Disaster recovery (DR)

As introduced earlier, disaster recovery covers two main areas:

* Contingency planning
* Solution recovery

This area not only focuses in data but has a much wider view and it usually includes machines, networking, outages, fire, natural disasters etc.

For DR within AWS there is the following whitepaper available: http://media.amazonwebservices.com/AWS_Disaster_Recovery.pdf

#### Contingency planning

There are a number of possible issues that can happen and for which the solution needs to plan against. The following are the main ones:

* Hardware failures.
* Software failures.
* Power outages.
* 3rd party supplier failure.
* Fire.
* Natural disasters.

For each relevant case, a plan needs to be made, so that the solution is resilient against it and it can be recovered in a fixed amount of time. Cost is another relevant factor in this case. 

Usually, the disaster recovery proposal of a solution tries to make a balance between:

* Point in time recovery: The amount of data that is lost or not available when the solution is recovered.
* Recovery time: The time it takes to bring the solution back to work.
* The percentage of downtime.
* Cost.
* Complexity.

#### Recovering

Both in the case of on-premise or in cloud solutions when a failure or a disaster (which could be a chain of failures) occurs, the recovery procedure needs to be followed. 

Once the incident is resolved, it is good practice to perform an analysis of:

* The facts that have lead to the situation.
* How the process has been conducted.
* If both the solution, or the procedures can be improved for the future.


## Monitoring

Every time the "monitoring" word is mentioned the first idea that comes up is tracking the status of a server, usually in relation to its CPU, Memory and Drive usage. However, in the security area there are other monitoring types. In this case the focus is set in Intrusion detection and in security related events.

In order to monitor intrusion related events, Intrusion Detection Systems (IDS) exist, which divide into two categories, NIDS and HIDS. While the main focus of this document is in latter, some tips are also provided for the former.

**NIDS**

NIDS are network based IDS systems. They are usually traffic "sniffers" that can watch over local, incoming or outgoing traffic. The functionality can be deployed as dedicated hardware applaiances or as a software solution in a server. There are commercial solutions available for both cases.

Open source alternatives are also available, such as Snort ([https://www.snort.org](https://www.snort.org)) or Suricata ([http://suricata-ids.org/](http://suricata-ids.org/)), which are perfect to start with IDS solutions and keep a controlled and secure environment.

As a complement to these IDSs, it is possible to add Snorby ([https://github.com/Snorby/snorby](https://github.com/Snorby/snorby)), a web page built in Ruby that shows traffic metrics of the traffic captured by the IDS systems.


**HIDS**

HIDS are IDS solutions for hosts, that is, the solution is installed in the server and based on logs, events and modifications report whether something harmful has happened in the system. They cover the file system the login and network layers.

Ossec ([http://ossec.github.io/](http://ossec.github.io/)) is a very powerful HIDS that is open source and distributed under the GNU license.

At Beeva's blog it was already covered how to perform the installation: [https://www.beeva.com/beeva-view/sistemas/instalando-ossec-como-detector-de-intrusos-en-el-host/](https://www.beeva.com/beeva-view/sistemas/instalando-ossec-como-detector-de-intrusos-en-el-host/).

For a good workflow with Ossec, the ideal solution is to have an Ossec agent installed in every server and to centralise all information in an Ossec server. This Ossec server can have a web page installed which facilitates information visualisation.

Once deployed, the first step taken by Ossec is to complete the **checksum verification** of some paths defined in its configuration. With this process Ossec can detect wether any file in those paths has been modified and if so a an email will be sent indicating what has happened. This can be in a real time fashion or in one of the periodic scans.

For the case of web servers, where Ossec agents are installed, it is possible to configure an **Active response**. This is performed by analysing the logs from **Mod_security and Apache/Nginx**, and if an attack is detected form a given IP based on a previously introduced ruleset, then such IP will be blocked.

However, the active response might be dangerous if not configured properly by activating the **X-Forwarded-For** option. In such case, it could be possible for the active response to block an internal IP (e.g. the one used by a load balancer), and to bring the service down form the user perspective.

In addition to the previously presented functionality, Ossec also informs on security events related to SSH logins, sudo, file permissions etc. That is, for every resource that is monitored under Ossec if an action occurs an email is sent informing on such event.

Finally, Ossec also allows to create custom rules so that notifications a generated when certain information appears in the logs. For example, a custom rule would be to create an email notification if a deployed Java application generated a "null pointer" exception in a log.

Due to all the information that Ossec manages and that it can provide, as well as due to all of its configuration options, it results a very relevant tool for any environment.


## Vulnerabilities

**How to keep up to date with vulnerabilities?**

New vulnerabilities are made public on a daily basis and it is quite difficult to be completely updated. For that reason, several recommendations are placed so that environments can be kept secure in the most simple manner.

Mailing lists:

There are three mailing lists that are very relevant to this matter since almost all software related vulnerabilities show up. The following is a quick description of each of them:

[https://public.govdelivery.com/accounts/USDHSUSCERT/subscriber/new](https://public.govdelivery.com/accounts/USDHSUSCERT/subscriber/new)

This list is developed in the US and it specially focuses on brands such as Microsoft or Red Hat and it covers vulnerabilities with a high level of criticality. Additionally, a weekly summary is sent.

[http://www.securityfocus.com/archive/1/description](http://www.securityfocus.com/archive/1/description)

Bugtraq is one of the most relevant ones and covers vulnerabilities and 0-days.

[http://nmap.org/mailman/listinfo/fulldisclosure](http://nmap.org/mailman/listinfo/fulldisclosure)

Full Disclosure is __The__ vulnerability mailing list. It was closed during 2014 but reopened afterwards by Foydor, Nmap's creator.

Both Bugtraq and Full Disclosure have quite a level of mail traffic and therefore their filtering and centralisation is recommended.

Blogs:

Another way to stay up to date is to consult specialised blogs. For example:

[http://unaaldia.hispasec.com/](http://unaaldia.hispasec.com/)

In this blog a new vulnerability is covered every day.

[http://blog.segu-info.com.ar/](http://blog.segu-info.com.ar/)

And this one gathers security information from different webs and it is usually tranlated to spanish.


## Data encryption at rest

In this section, a basic overview of the data encryption needs available is made.

Data stored in servers is as sensitive as protecting access to the root account of a server. In a similar way, data is protected when on transit and it should be protected when it is at rest or stored. In order to protect the data from from being accessed when a disk fails and it is removed from the server or if is stolen, data should be encrypted. This actually depends on the security measures in place in the datacenter. In cloud providers, data encryption at rest is already provided and it should be used when possible. 

Since the inclusion of data encryption schemes introduce another point of failure, disaster recovery policies need to consider it as well. It is possible for a key to be lost and then the data protected with that key to be unrecoverable.

Data encryption also applies to backups since it does not make sense to have data protected and to leave the backup of that very same data unprotected. Hence and as a general rule, the same level of encryption should be applied to data in production and to its active replicas and backups.


## Security audits

When a solution is to be deployed and the final configuration is already designed it is good practice to heavily attack a solution clone in order to identify potential vulnerabilities. Once in production, this task should be performed with caution so that the solution is not affected. This task is one of which is usually underestimated and which might leave attackers an open door if room is left for a simple attack to be performed.

Beyond attacking solutions, it is also necessary to perform audits periodically in order to detect deficiencies. The outcome of audits might impact on deployed solutions or even or company processes.

In general, security is a periodic job more than a one time task. Therefore, it is necessary define periodic company processes to evaluate and improve it.


## Incident response

Every company needs to have a protocol in order to response a security incident. In Beeva, this actuation protocol is provided to employees in their first day and it is annually reviewed. Any Beeva employee can download it from the company's intranet.

If there is no procedure defined and one is required, the first thing to get to know is [RBAC](https://en.wikipedia.org/wiki/Role-based_access_control "RBAC").

RBAC is a role hierarchy that is thought for describing the responsibility of a person, department or position when accessing a system and which should would be its behaviour in case of problems or incidents.

## References

The following is the list covers additional references used during the development of this guide:

* Linux Server Security - Michael d. Bauer - O'reilly media 2005
___

[BEEVA](https://www.beeva.com) | Technology and innovative solutions for companies

