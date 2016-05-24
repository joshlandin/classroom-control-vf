class memcached {

  package { 'memcached':
  }
  
  file { 'memcached_config':
    path    => '/etc/sysconfig/memcached',
    type    => 'file',
    mode    => '0644',
    require => Package['memcached'],
    source  => 'puppet:///memcached/memcached_config'
  }
  
  service {
    require => Package['/etc/sysconfig/memcached'],
  }
  
}
