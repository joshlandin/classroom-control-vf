class nginx {

  package { 'nginx':
    ensure => present,
  }
  
  file { '/etc/nginx/nginx.conf':
    ensure => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['nginx'],
    source => 'puppet:///modules/nginx/nginx.conf',
  }
  
  service { 'nginx':
    enable  => true,
    require => File['/etc/nginx/nginx.conf'],
  }
  
}
