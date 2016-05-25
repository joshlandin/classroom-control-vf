define users::managed_user (
  $group = $title,
) {

  user { $title:
    ensure => present,
    home => "/home/${title}",
    managehome => true,
    group => "${group}",
  }

  file { "/home/${title}": {
    ensure => directory,
    mode => '0660',
    owner => $title,
    group => $group,
  }
  
  file { "/home/${title}/.ssh": {
    ensure => directory,
    mode => '0700',
    owner => $title,
    group => $group,
  }
  
}
