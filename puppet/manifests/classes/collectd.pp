class collectd {
	package { "collectd": ensure => latest }
	file { "/etc/collectd/collectd.conf":
		ensure => present,
		mode => 644,
		owner => root,
		group => root,
		source => "puppet:///files/collectd.conf",
		require => Package["collectd"],
		notify => Service["collectd"]
	}
	service { "collectd":
		enable => true,
		ensure => running,
		require => Package["collectd"]
	}

}
