class nginx {

  $port        = 80
  $package     = 'nginx'
  $owner       = 'root'
  $group       = 'root'
  $docroot     = '/var/www'
  $confdir     = '/etc/nginx'
  $blockdir    = '/etc/nginx/conf.d'
  $logsdir     = '/var/log/nginx'
  $service     = 'nginx'
  $serviceuser = 'nginx'

  case $::osfamily {
    'redhat': {
    }
    'debian': {
      $serviceuser = 'www-data'
    }
    'windows': {
      $basedir     = 'C:/ProgramData/nginx'
      $package     = 'nginx-service'
      $owner       = 'Administrator'
      $group       = 'Administrators'
      $docroot     = "${basedir}/html"
      $confdir     = "${basedir}"
      $blockdir    = "${basedir}/conf.d"
      $logsdir     = "${basedir}/logs"
      $serviceuser = 'nobody'
    }
    default: {
      fail("Operating system ${::osfamily} is not supported.")
    }
  }

  package { $package:
    ensure => present,
  }

  File {
    owner => $owner,
    group => $group,
    mode  => '0664',
  }
  
  file { 'nginx-conf':
    ensure  => file,
    path    => "${confdir}/nginx.conf",
    content => template('nginx/nginx.conf.erb'),
  }
  
  file { 'nginx-default-conf':
    ensure  => file,
    path    => "${blockdir}/default.conf",
    content => template('nginx/default.conf.erb'),
  }
  
  file { $docroot:
    ensure => directory,
    mode   => '0755',
  }
  
  file { "${docroot}/index.html":
    ensure => file,
    source => 'puppet:///modules/nginx/index.html',
  }
  
  service { $service:
    ensure  => running,
    enable  => true,
    subscribe  => [
      File['nginx-conf'], 
      File['nginx-default-conf'], 
    ],
    require => [
      Package[$package],
      File['nginx-conf'], 
      File['nginx-default-conf'], 
    ],
  }
  
}
