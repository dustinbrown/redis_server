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
#   External Node Classifier as a comma separated list of hostnames." (Note,
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
# Copyright 2014 Your name here, unless otherwise noted.
#
class redis_server {

  include redis_server::install

  $required_dirs = ['/var/log/redis', '/var/redis', '/etc/redis']

  file {$required_dirs:
    ensure => directory
  }

  file {'/usr/local/bin':
    ensure => directory
  }

  file {'/usr/local/bin/redis-server':
    ensure => link,
    target => '/opt/redis-server/src/redis-server',
  }

  file {'/usr/local/bin/redis-cli':
    ensure => link,
    target => '/opt/redis-server/src/redis-cli',
  }

  #Define instances..
  redis_server::instance {'video':
    port    => 62223,
    require => File[$required_dirs],
  }

  redis_server::instance {'blackjack':
    port    => 62222,
    require => File[$required_dirs],
  }
}
