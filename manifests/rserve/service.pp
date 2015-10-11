# = Puppet module for dataverse.
# == Class: Iqss::Rserve::Service
#
# === Copyright
#
# Puppet module for dataverse.
# GPLv3 - Copyright (C) 2015 International Institute of Social History <socialhistory.org>.
#
# === Description
#
# Private class. Do not use directly.
#
# Set the user and configuration for the rserve daemon
#
class iqss::rserve::service {

  user {
    $iqss::rserve::rserve_user:
      ensure => present,
      uid    => $iqss::rserve::uid,
      groups => $iqss::rserve::rserve_user,
  }
  group {
    $iqss::rserve::rserve_user:
      ensure => present,
      gid    => $iqss::rserve::gid,
  }

  file {
    '/etc/Rserv.conf':
      ensure  => present,
      owner   => $iqss::rserve::rserve_user,
      group   => $iqss::rserve::rserve_user,
      content => template( 'iqss/rserve/Rserve.conf.erb' ),
      notify  => Service['rserve'] ;
    '/etc/Rserv.pwd':
      ensure  => present,
      owner   => $iqss::rserve::rserve_user,
      group   => $iqss::rserve::rserve_user,
      content => "${iqss::rserve::rserve_user} ${iqss::rserve::password}",
      notify  => Service['rserve'] ;
    '/var/log/rserve/':
      ensure => directory,
      owner  => $iqss::rserve::rserve_user,
      group  => $iqss::rserve::rserve_user;
    '/etc/init.d/rserve':
      ensure  => present,
      mode    => 755,
      content => template( 'iqss/rserve/rserve-startup.sh.erb' );
  }

  service {
    'rserve':
      ensure     => running,
      enable     => true,
      path       => '/etc/init.d/',
      hasrestart => true ;
  }

}