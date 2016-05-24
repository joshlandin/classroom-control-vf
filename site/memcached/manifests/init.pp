class memcached {

  package { 'memcached':
    ensure => present,
  }
  
  file { '/etc/sysconfig/memcached':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['memcached'],
    source  => 'puppet:///modules/memcached/memcached_config'
  }
  
  service {
    ensure  => running,
    enable  => true,
    require => File['/etc/sysconfig/memcached'],
  }
  
}
