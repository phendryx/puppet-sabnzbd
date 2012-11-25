class sabnzbd inherits sabnzbd::params {
	include sabnzbd::config
	include sabnzbd::proxy
    include git
    include python::virtualenv
    include supervisor
	
    package {
        'unrar':
            ensure => present;
   #     'unzip':
   #         ensure => present;
        'par2':
            ensure => present;
        'python-yenc':
            ensure => present;
    }
#	user { "$services_user":
#        allowdupe => false,
#        ensure => 'present',
#    }

    file { "$base_dir/sabnzbd":
        ensure => directory,
        owner => "$services_user",
        group => "$services_user",
        mode => '0644',
    }
    exec { 'venv-create-sabnzbd':
        command => "virtualenv $venv_dir",
        cwd => "$base_dir/sabnzbd",
        creates => "$base_dir/sabnzbd/$venv_dir/bin/activate",
        path => '/usr/bin/',
        user => "$services_user",
        require => [Class['python::virtualenv'], Package['python-yenc']];
    }
    exec { 'download-sabnzbd':
        command => "/usr/bin/git clone $url src",
        cwd     => "$base_dir/sabnzbd",
        creates => "$base_dir/sabnzbd/src",
        user => "$services_user",
        require => Class['git'],
    }
    exec { 'install-pyopenssl':
        command => "$base_dir/sabnzbd/venv/bin/pip install pyOpenSSL",
        cwd => "$base_dir/sabnzbd/venv",
        creates => "$base_dir/sabnzbd/venv/lib/python2.7/site-packages/OpenSSL",
        path => "$base_dir/sabnzbd/venv/bin:/usr/bin",
        user => "$services_user",
        require => Exec['venv-create-sabnzbd'];
    }
    exec { 'install-cheetah-sabnzbd':
        command => "$base_dir/sabnzbd/venv/bin/pip install cheetah",
        cwd => "$base_dir/sabnzbd/venv",
        creates => "$base_dir/sabnzbd/venv/bin/cheetah",
        path => "$base_dir/sabnzbd/venv/bin",
        user => "$services_user",
        require => Exec['venv-create-sabnzbd'];
    }
    supervisor::service {
        'sabnzbd':
            ensure => present,
            enable => true,
            stdout_logfile => "$base_dir/sabnzbd/log/supervisor.log",
            stderr_logfile => "$base_dir/sabnzbd/log/supervisor.log",
            command => "$base_dir/sabnzbd/venv/bin/python $base_dir/sabnzbd/src/SABnzbd.py -f $base_dir/sabnzbd/config/sabnzbd.ini",
            user => "$services_user",
            group => "$services_user",
            directory => "$base_dir/sabnzbd/src/",
            require => Exec['download-sabnzbd'],
    }
}
