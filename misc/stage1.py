#!/usr/bin/python
import boto3
import aws_utils
import sys
import os
import base64
import pprint

pp = pprint.PrettyPrinter(indent=4)

#Some configuration, leave blank for automatic
domain="demo.majestik.org"
ami_base="ami-fce3c696" # Ubuntu 14.04 LTS - SSD
ami_node="ami-80696aee" #Ubuntu 14.04 Instance Store
pubkey=None
pubkey_name="Default"

#Read .ssh/id_rsa.pub if pubkey is blank
if not pubkey:
	print("Reading id_rsa.pub from home")
	from os.path import expanduser
	home = expanduser("~")
	fh=open(home + "/.ssh/id_rsa.pub")
	pubkey=fh.read()
	fh.close()

fh=open("makepuppetmaster.sh")
userdata=fh.read()
fh.close()

# Create the connections
ec2 = boto3.resource('ec2')
ec2_client = boto3.client('ec2')
route53=boto3.client('route53')

#Find the default VPC name
for i in ec2.vpcs.all():
	if i.is_default:
		vpc=i

print ("Creating security groups")
# Create Security Groups
 # Puppet Server (tcp/8140 internal)
aws_utils.secgroup(ec2, 'puppetservers', [8140], 'tcp', vpc, vpc.cidr_block)
 # Web Internal (http/internal, ssh/internal)
aws_utils.secgroup(ec2, 'internal-http', [80,22], 'tcp', vpc, vpc.cidr_block)
 # Web External (http/world)
aws_utils.secgroup(ec2, 'external-http', [443,80], 'tcp', vpc, '0.0.0.0/0')
 # SSH External (ssh/world)
aws_utils.secgroup(ec2, 'external-ssh', [22], 'tcp', vpc, '0.0.0.0/0')

#Register domain in Route53
print ("\nCreating zone - %s"%(domain))
dns=None
for zone in route53.list_hosted_zones()['HostedZones']:
	if zone['Name'] == domain + ".":
		dns=route53.get_hosted_zone(Id=zone['Id'])
if dns == None:
	dns=route53.create_hosted_zone(Name=domain,CallerReference="javaInfra2")

print ("Please add the following nameservers to your root domain configuration")
for server in dns['DelegationSet']['NameServers']:
	print "\t\t%s"%(server)

#Create and import Key 
print("\nEnsuring public key is setup")
iskey=None
for key in ec2_client.describe_key_pairs()['KeyPairs']:
	if key['KeyName'] == pubkey_name:
		iskey=True
if not iskey:
	ec2_client.import_key_pair(
		KeyName=pubkey_name,
		PublicKeyMaterial=pubkey
	)

#Create the base puppet/controller node
#Use the startup script file
 # Configures Grafana, graphite, jenkins, puppetmaster
found=None
for instanceres in ec2_client.describe_instances()['Reservations']:
	for instance in instanceres['Instances']:
		if instance['State']['Name'] == "terminated":
			continue
		if 'Tags' in instance.keys():
			for tag in instance['Tags']:
				if tag['Key'] == "Name":
					if tag['Value'] == 'puppetmaster':
						found=True
						main_instance=ec2.Instance(instance['InstanceId'])
						print "Instance already exists, you may need to terminate and recreate"

if not found:
	print ("Creating and tagging the base instance")
	instance = ec2.create_instances(
		ImageId=ami_base,
		MinCount=1,
		MaxCount=1,
		KeyName=pubkey_name,
		SecurityGroups=['external-ssh', 'external-http'],
		UserData=userdata,
		InstanceType='t2.micro',
		)
	ec2.create_tags(
		Resources=[str(instance[0].id)],
		Tags=[{'Key': 'Name', 'Value': 'puppetmaster'}]
		)
	print ("Instance created")
	main_instance=ec2.Instance(str(instance[0].id))

main_ip=main_instance.public_ip_address
print ("Connect by running 'ssh ubuntu@%s'")%(main_ip)


#Create Launch group
#Create ELB
	# Health check
#Register ELB in Route53
#Setup response group
