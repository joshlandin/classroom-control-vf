class nginx {
  $docroot = '/var/www'
  blockdir = '/etc/nginx/conf.d'
  
  package { 'nginx':
    ensure => present,
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0664',
  }
  
  file { '/etc/nginx/nginx.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/nginx.conf',
  }
  
  file { '/etc/nginx/conf.d/default.conf':
    ensure  => file,
    source  => 'puppet:///modules/nginx/default.conf',
  }
  
  file { '/var/www':
    ensure => directory,
    mode    => '0755',
  }
  
  file { '/var/www/index.html':
    ensure => file,
    source => 'puppet:///modules/nginx/index.html',
  }
  
  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => [File['/etc/nginx/nginx.conf'],File['/etc/nginx/conf.d/default.conf']],
  }
  
}
