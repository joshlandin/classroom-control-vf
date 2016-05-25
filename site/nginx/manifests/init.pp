class nginx {

  $port        = 80
  $package     = 'root'
  $owner       = 'root'
  $group       = 'root',
  $docroot     = '/var/www'
  $logsdir     = '/var/log/nginx'
  $blockdir    = '/etc/nginx/conf.d'
  $confdir     = '/etc/nginx'
  $serviceuser = 'nginx'

  case $::osfamily {
    'redhat': {
    }
    'debian': {
      $serviceuser = 'www-data'
    }
    'windows': {
      $package     = 'nginx-service'
      $owner       = 'Administrator'
      $group       = 'Administrators'
      $basedir     = 'C:/ProgramData/nginx'
      $docroot     = "${basedir}/html"
      $logsdir     = "${basedir}/logs"
      $blockdir    = "${basedir}/conf.d"
      $confdir     = "${basedir}"
      $serviceuser = 'nobody'
    }
    default: {
      fail("Operating system ${::osfamily} is not supported.")
    }
  }

  package { 'nginx':
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
    source  => 'puppet:///modules/nginx/nginx.conf.erb',
  }
  
  file { 'nginx-default-conf':
    ensure  => file,
    path    => "${blockdir}/default.conf",
    source  => 'puppet:///modules/nginx/default.conf.erb',
  }
  
  file { $docroot:
    ensure => directory,
    mode   => '0755',
  }
  
  file { "${docroot}/index.html":
    ensure => file,
    source => 'puppet:///modules/nginx/index.html',
  }
  
  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => [ 
      File['nginx-conf'], 
      File['nginx-default-conf'], 
    ],
  }
  
}
