class sabnzbd inherits sabnzbd::params {
	include sabnzbd::config
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
    }
    exec { 'venv-create':
        command => "virtualenv $venv_dir",
        cwd => "$base_dir/sabnzbd",
        creates => "$base_dir/sabnzbd/$venv_dir/bin/activate",
        path => '/usr/bin/',
        require => [Class['python::virtualenv'], Package['python-yenc']];
    }
    exec { 'download-sabnzbd':
        command => "/usr/bin/git clone $url src",
        cwd     => "$base_dir/sabnzbd",
        creates => "$base_dir/sabnzbd/src",
        require => Class['git'],
    }
    exec { 'install-pyopenssl':
        command => "$base_dir/sabnzbd/venv/bin/pip install pyOpenSSL",
        cwd => "$base_dir/sabnzbd/venv",
        creates => "$base_dir/sabnzbd/venv/lib/python2.7/site-packages/OpenSSL",
        path => "$base_dir/sabnzbd/venv/bin",
        require => Exec['venv-create'];
    }
    exec { 'install-cheetah':
        command => "$base_dir/sabnzbd/venv/bin/pip install cheetah",
        cwd => "$base_dir/sabnzbd/venv",
        creates => "$base_dir/sabnzbd/venv/bin/cheetah",
        path => "$base_dir/sabnzbd/venv/bin",
        require => Exec['venv-create'];
    }
    supervisor::service {
        'sabnzbd':
            ensure => present,
            enable => true,
            stdout_logfile => "$base_dir/sabnzbd/log/supervisor.log",
            stderr_logfile => "$base_dir/sabnzbd/log/supervisor.log",
            command => "$base_dir/sabnzbd/venv/bin/python $base_dir/sabnzbd/src/SABnzbd.py -f $base_dir/sabnzbd/config/sabnzbd.ini",
            user => 'sabnzbd',
            group => 'sabnzbd',
            directory => "$base_dir/sabnzbd/src/",
            require => Exec['download-sabnzbd'],
    }
    nginx::resource::upstream { 'sabnzbd':
        ensure  => present,
        members => "$sabnzbd_host:$sabnzbd_port",
    }
    nginx::resource::vhost { 'gettomy.dyndns-home.com':
       ensure   => present,
       proxy  => 'http://sabnzbd',
     }
}
