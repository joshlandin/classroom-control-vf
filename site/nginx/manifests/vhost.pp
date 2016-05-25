define nginx::vhost (
  $port = 80,
  $servername = $title,
  $docroot = "${nginx::docroot}/vhosts/${title}",
) {

  file { $docroot:
    ensure => directory,
  }

  file { "$docroot/index.html":
    ensure  => file,
    content => template('nginx/index.html.erb'),
  }

  file { "nginx-vhost-${title}":
    ensure  => file,
    path    => "${nginx::blockdir}/${title}.conf",
    content => template('nginx/index.html.erb'),
    notify  => Service['nginx'],
  }

}
