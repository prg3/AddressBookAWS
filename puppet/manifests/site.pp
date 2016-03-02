import "classes/*"

node default {
	include default_node
	include tomcat
	include oracle_java
	class { 'nginx': }
        nginx::resource::upstream{ 'tomcat': members => [ 'localhost:9000' ] }
	nginx::resource::vhost{ 'intuit.majestik.org':
		proxy => 'http://tomcat/AddressBook/'
	}
	include app
}
