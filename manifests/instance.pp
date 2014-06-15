# == Class: redis_server
#
# Full description of class redis_server here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostinstance_names." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { redis_server:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your instance_name here, unless otherwise noted.
#
define redis_server::instance (
  $instance_name = $title,
  $port = 62222
) {

  file { "/etc/init.d/redis_${instance_name}":
    ensure  => 'present',
    content => template("redis_server/init.erb"),
    group   => '0',
    mode    => '755',
    owner   => '0',
  }

  file { "/etc/redis/${instance_name}.conf":
    ensure  => 'present',
    content => template("redis_server/conf.erb"),
    group   => '0',
    mode    => '644',
    owner   => '0',
  }

  file {"/var/redis/${instance_name}":
    ensure => directory,
    require => File['/var/redis'],
  }

  file {"/var/log/redis/${instance_name}.log":
    ensure => present,
    require => File['/var/log/redis'],
  }
}
