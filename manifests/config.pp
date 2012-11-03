class sabnzbd::config {
    
    $api_key = hiera("sabnzbd_api_key")
    $email_to = hiera("email_to")
    $email_account = hiera("email_from")
    $email_server = hiera("email_server")
    $email_from = hiera("email_from")
    $email_passwd = hiera("email_passwd")
    $nzb_key = hiera("sabnzbd_nzb_key")
    $nzb_server_username = hiera("nzb_server_username")
    $nzb_server = hiera("nzb_server")
    $nzb_server_passwd = hiera("nzb_server_passwd")
    $nzb_server_port = hiera("nzb_server_port")
    $nzb_server_retention = hiera("nzb_server_retention")
    $nzb_server_maxconnections = hiera("nzb_server_maxconnections")
    $nzb_server_ssl = hiera("nzb_server_ssl")
    if ($nzbmatrix_username) {
        $nzbmatrix_username = hiera("nzbmatrix_username")
        $nzbmatrix_apikey = hiera("nzbmatrix_apikey")
    }
    
    $base_dir = hiera("app_dir")
    if ($nzb_scan_dir) {
        $nzb_scan_dir = hiera("nbz_scan_dir")
    }
    $complete_dir = hiera("complete_download_dir")
    $downloads_dir = hiera("incomplete_download_dir")
    
    $src_dir = "src"    
    $data_dir = "data"    
    $scripts_dir = "$base_dir/sabnzbd/$data_dir/scripts"

    file { "$base_dir/sabnzbd/$data_dir/sabnzbd.ini":
        content => template('sabnzbd/sabnzbd.ini.erb'),
        owner => 'sabnzbd',
        group => 'sabnzbd',
        mode => '0644',
        require => Exec['download-sabnzbd']
    }
    
    file { "$base_dir/sabnzbd/scripts":
        ensure => directory,
        owner => 'sabnzbd',
        group => 'automators',
        mode => '0644',
    }

    file { "$base_dir/sabnzbd/scripts/autoProcessTV.py":
        ensure => link,
        target => "$base_dir/sickbeard/autoProcessTV/autoProcessTV.py",
        require => File["$base_dir/sabnzbd/scripts","$base_dir/sickbeard"]
    }
    
    file { "$base_dir/scripts/autoProcessTV.cfg":
        ensure => link,
        target => "/opt/sickbeard/autoProcessTV/autoProcessTV.cfg",
        require => File["$base_dir/sabnzbd/scripts"]
    }
    
    file { "$base_dir/scripts/sabToSickBeard.py":
        ensure => link,
        target => "/opt/sickbeard/autoProcessTV/sabToSickBeard.py",
        require => File["$base_dir/sabnzbd/scripts"]
    }
    
}
