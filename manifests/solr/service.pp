# = Puppet module for dataverse.
# == Class: Dataverse::Solr::Service
#
# === Copyright
#
# Puppet module for dataverse.
# GPLv3 - Copyright (C) 2015 International Institute of Social History <socialhistory.org>.
#
# === Description
#
# === Copyright
#
# Puppet module for dataverse.
# GPLv3 - Copyright (C) 2015 International Institute of Social History <socialhistory.org>.
#
# Private class. Do not use directly.
#
class dataverse::solr::service {

  if ( $facts['lsbdistrelease'] == '16.04' or $facts['lsbdistid'] == 'Ubuntu' ) {
    anchor { 'dataverse::solr::service::begin': }->
    ::systemd::unit_file  { 'solr.service':
        content =>  template ('dataverse/solr/solr.service') ,
    } ->
    service {  'solr' :
        ensure   => running,
        provider => 'systemd',
    }
  }
  else {
    anchor { 'dataverse::solr::service::begin': }->
    service { $dataverse::solr::jetty_user:
      ensure     => running,
      enable     => true,
      path       => '/etc/init.d/',
      hasrestart => true,
      subscribe  => File["${dataverse::solr::solr_home}/${dataverse::solr::core}/conf"]
    }

    anchor { 'solr::service::end':
      require => Service[$dataverse::solr::jetty_user],
    }
  }

}
