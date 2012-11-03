class sabnzbd {
	
	$url = "https://github.com/sabnzbd/sabnzbd.git"
	
	include sabnzbd::config
    include git
	
	user { 'sabnzbd':
        allowdupe => false,
        ensure => 'present',
        uid => '600',
        shell => '/bin/bash',
        gid => '700',
        home => "$base_dir/sabnzbd",
        password => '*',
    }

    file { "$base_dir/sabnzbd":
        ensure => directory,
        owner => 'sabnzbd',
        group => 'automators',
        mode => '0644',
        recurse => 'true'
    }

    exec { 'download-sabnzbd':
        command => "/usr/bin/git clone $url sabnzbd",
        cwd     => "$base_dir",
        creates => "$base_dir/sabnzbd",
        require => Class['git'],
    }
	
	file { "/etc/init.d/sabnzbd":
        content => template('sabnzbd/init-rhel.erb'),
        owner => 'root',
        group => 'root',
        mode => '0755',
    }	
}
