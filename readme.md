#WebLogic 12.1.3 infra (JRF) with OSB ,ESS Cluster

##Details
- CentOS 6.7 vagrant box
- Puppet 3.7.4
- Vagrant >= 1.41
- Oracle Virtualbox >= 4.3.6

Download & Add the all the Oracle binaries to /software

edit Vagrantfile and update the software share to your own local folder
- osbdb.vm.synced_folder "/Users/edwin/software", "/software"
- osb2admin2.vm.synced_folder "/Users/edwin/software", "/software"

Vagrant boxes
- vagrant up osbdb
- vagrant up osb2admin2

## Database
- osbdb 10.10.10.5, 11.2.0.4 with Welcome01 as password

###software
- Oracle Database 11.2.0.4 Linux
- 1395582860 Aug 31 16:21 p13390677_112040_Linux-x86-64_1of7.zip
- 1151304589 Aug 31 16:22 p13390677_112040_Linux-x86-64_2of7.zip

## Middleware

### Cluster with 1 node
- osb2admin2 10.10.10.21, WebLogic 12.1.3 with Infra & OSB requires RCU

http://10.10.10.21:7001/em with weblogic1 as password

###software
- JDK 1.7u55 jdk-7u55-linux-x64.tar.gz
- JDK 7 JCE policy UnlimitedJCEPolicyJDK7.zip
- fmw_12.1.3.0.0_infrastructure.jar
- fmw_12.1.3.0.0_osb_Disk1_1of1.zip
