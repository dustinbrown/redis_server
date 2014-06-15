# == Class: redis_server::install
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
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { redis_server::install:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Dustin Brown <dustinjamesbrown@gmail.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class redis_server::install inherits redis_server::params {

  package {['gcc', 'make', 'wget']:
    ensure => present,
  }

  file {'/opt/redis-server':
    ensure => link,
    require => Exec["wget http://download.redis.io/releases/${redis_server::params::version}.tar.gz"],
    target => "/opt/$redis_server::params::version",
  }

  exec {"wget http://download.redis.io/releases/${redis_server::params::version}.tar.gz":
    creates => "/opt/$redis_server::params::version",
    cwd     => '/opt/',
    path    => ['/usr/bin', '/usr/sbin'],
    require => Package['wget'],
  }

  exec {"tar xzf ${redis_server::params::version}.tar.gz":
    cwd         => '/opt/',
    path        => ['/usr/bin', '/usr/sbin', '/bin'],
    refreshonly => true,
    subscribe   => Exec["wget http://download.redis.io/releases/${redis_server::params::version}.tar.gz"],
  }

  exec {'make':
    cwd         => '/opt/redis-server',
    environment => ['PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin'],
    path        => ['/usr/bin', '/usr/sbin', '/bin'],
    refreshonly => true,
    require     => Package['make'],
    subscribe   => Exec["tar xzf ${redis_server::params::version}.tar.gz"],
  }
}
