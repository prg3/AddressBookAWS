class tomcat {
	package { "tomcat7": ensure => latest }
	file { "/etc/default/tomcat7":
		ensure => present,
		mode => 644,
		owner => root,
		group => root,
		source => "puppet:///files/tomcat7-defaults",
		require => Package["tomcat7"]
	}
	file { "/etc/tomcat7/web.xml":
		ensure => present,
		mode => 644,
		owner => root,
		group => root,
		source => "puppet:///files/web.xml",
		require => Package["tomcat7"]
	}
	file { "/etc/tomcat7/server.xml":
		ensure => present,
		mode => 644,
		owner => root,
		group => root,
		source => "puppet:///files/server.xml",
		require => Package["tomcat7"]
	}
	service { "tomcat7":
		enable => true,
		ensure => running,
		subscribe => [ File["/etc/default/tomcat7", "/etc/tomcat7/web.xml", "/etc/tomcat7/server.xml"]]
	}

}
