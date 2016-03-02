# AddressBookAWS
Address book infrastructure for AWS

#Infrastructure design

## AWS
![](ab.png?raw=true)

### Instances
Instances are t2.micro, which is plenty for this setup

### RDS
RDS is used as the backing database to keep the nodes stateless, created using MySQL 5.5 on the internal network only
This was done by hand, no scripts.. may rewrite that someday

### Security
Minimal security rules are setup for the world to access the nodes via the ELB
No inbound traffic is allowed into the worker nodes

### Autoscaling
"The autoscaling is a lie".. at least currently, nodes are manually ceated by using the misc/makenode.sh script, which automatically adds them to the ELB

### ELB
ELB is setup to healthcheck the css file in the resources folder, so this indicates with enough certianty that the solution is up and running properly. 
SSL offload is configured using LetsEncrypt on the ELB. East/West traffic is left unencrypted for now.

## CI
Utilizing Jenkins to autobuild the WAR file from github
Cron rsync command pulls the war file from the build path to the puppet root where it is distributed to the nodes

## Puppet
Puppet is used to push configuration and the war file to the worker nodes
Manifests should be relatively self explanatory

#AddressBook Application
The AddressBook application is pulled from: http://www.cumulogic.com/downloads/sample-applications/

