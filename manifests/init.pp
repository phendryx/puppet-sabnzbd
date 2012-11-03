class sabnzbd inherits sabnzbd::params {
	include sabnzbd::config
    include git
    include python::virtualenv
	
	user { 'sabnzbd':
        allowdupe => false,
        ensure => 'present',
        shell => '/bin/bash',
        home => "$base_dir/sabnzbd",
        password => '*',
    }

    file { "$base_dir/sabnzbd":
        ensure => directory,
        owner => 'sabnzbd',
        group => 'sabnzbd',
        mode => '0644',
        recurse => 'true'
    }
    exec { 'venv-create':
        command => "virtualenv $venv_dir",
        cwd => "$base_dir/sabnzbd",
        creates => "$base_dir/sabnzbd/$venv_dir/bin/activate",
        path => '/usr/bin/',
        require => Class['python::virtualenv'];
    }
    exec { 'download-sabnzbd':
        command => "/usr/bin/git clone $url src",
        cwd     => "$base_dir/sabnzbd",
        creates => "$base_dir/sabnzbd/src",
        require => Class['git'],
    }
}
