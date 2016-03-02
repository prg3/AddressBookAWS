class app {
	file { "/var/lib/tomcat7/webapps/AddressBook.war":
		ensure => present,
		mode => 644,
		owner => tomcat7,
		group => tomcat7,
		source => "puppet:///files/granny.war",
		require => [ Package ["tomcat7"]],
		notify => Service['tomcat7']
	}
#	file { "/var/lib/tomcat7/webapps/AddressBook/META-INF/context.xml":
#		ensure => present,
#		mode => 644,
#		owner => tomcat7,
#		group => tomcat7,
#		source => "puppet:///files/context.xml",
#	}
#	file { "/var/lib/tomcat7/webapps/AddressBook":
#		ensure => directory,
#		mode => 755,
#		owner => tomcat7,
#		group => tomcat7,
#		require => [ Package ["tomcat7"]],
#		notify => Service['tomcat7']
#	}
#	file { "/var/lib/tomcat7/webapps/AddressBook/META-INF":
#		ensure => directory,
#		mode => 755,
#		owner => tomcat7,
#		group => tomcat7,
#		require => [ Package ["tomcat7"]],
#		notify => Service['tomcat7']
#	}
	file { "/usr/share/tomcat7/lib/catalina.jar":
		ensure => present,
		mode => 644,
		owner => tomcat7,
		group => tomcat7,
		source => "puppet:///files/catalina.jar",
		require => [ Package ["tomcat7"]],
		notify => Service['tomcat7']
	}
	file { "/usr/share/tomcat7/lib/tomcat-dbcp.jar":
		ensure => present,
		mode => 644,
		owner => tomcat7,
		group => tomcat7,
		source => "puppet:///files/tomcat-dbcp.jar",
		require => [ Package ["tomcat7"]],
		notify => Service['tomcat7']
	}
}

