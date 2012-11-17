class sabnzbd::params (
    $api_key = hiera("sabnzbd_api_key"),
    $email_to = hiera("email_to"),
    $email_account = hiera("email_from"),
    $email_server = hiera("email_server"),
    $email_from = hiera("email_from"),
    $email_passwd = hiera("email_passwd"),
    $nzb_key = hiera("sabnzbd_nzb_key"),
    $ssl = hiera("sabnzbd_ssl", "0"),
    $nzb_server_username = hiera("nzb_server_username"),
    $nzb_server = hiera("nzb_server"),
    $nzb_server_passwd = hiera("nzb_server_passwd"),
    $nzb_server_port = hiera("nzb_server_port"),
    $nzb_server_retention = hiera("nzb_server_retention"),
    $nzb_server_maxconnections = hiera("nzb_server_maxconnections", "20"),
    $nzb_server_ssl = hiera("nzb_server_ssl", "1"),
    $nzbmatrix_username = hiera("nzbmatrix_username", ""),
    $nzbmatrix_apikey = hiera("nzbmatrix_apikey", ""),
    $nzb_scan_dir = hiera("nbz_scan_dir", ""),
    $base_dir = hiera("app_dir", "/opt"),
    $sabnzbd_host = hiera("sabnzbd_host", "localhost"),
    $sabnzbd_port = hiera("sabnzbd_port", "8080"),
    $sabnzbd_webroot = hiera("sabnzbd_webroot", "/sabnzbd"),
    $complete_dir = hiera("complete_download_dir"),
    $downloads_dir = hiera("incomplete_download_dir"),
    $complete_movie_download_dir = hiera("complete_movie_download_dir", "moveies"),
    $complete_tv_download_dir = hiera("complete_tv_download_dir", "tv"),
    $complete_music_download_dir = hiera("complete_music_download_dir", "music"),
    $external_dns = hiera("external_dns", "localhost"),
    $proxy_nginx = hiera("proxy_nginx", "true"),
    $proxy_apache = hiera("proxy_apache", "false"),
    $venv_dir = "venv",
    $url = hiera("sabnzbd_git_url", "https://github.com/sabnzbd/sabnzbd.git"),
)
{
    $scripts_dir = "$base_dir/sabnzbd/scripts"
    $log_dir = "$base_dir/sabnzbd/log"
    $admin_dir = "$base_dir/sabnzbd/admin"
    $cache_dir = "$base_dir/sabnzbd/cache"
}
