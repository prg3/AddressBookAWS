import "classes/*"

node default {
	include base
	include tomcat
	include oracle_java
	class { 'nginx': }
        nginx::resource::upstream{ 'tomcat': members => [ 'localhost:9000' ] }
	nginx::resource::vhost{ 'awstest.majestik.org':
		proxy => 'http://tomcat/AddressBook/'
	}
	include app
	include collectd
}
