class base {
	file { "/etc/puppet/puppet.conf":
		ensure => present,
		owner => root,
		group => root,
		mode => 644,
		source => "puppet:///files/puppet.conf",
		notify => Service["puppet"]
	}
	service { "puppet":
		enable => true,
		ensure => running
	}
}
