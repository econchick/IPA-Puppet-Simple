class ipa(
  $server_ip      	= $ipa::params::server_ipaddr,
  $client_ip        = $ipa::params::client_ipaddr,
  $config_server	  = $ipa::params::config_server,
  $config_client  	= $ipa::params::config_client,
  $dns_forwarder  	= $ipa::params::dns_forwarder,
  $realm            = $ipa::params::realm,
  $domain           = $ipa::params::domain,
  $server_fqdn      = $ipa::params::server_fqdn,
  $server_name      = $ipa::params::hostname,
  $client_fqdn      = $ipa::params::client_fqdn,
  $password		      = $ipa::params::password,
) inherits ipa::params {
  if $ipa::config_server {
    package { 'bind':
      ensure => installed,
    }
    package { "bind-dyndb-ldap":
      ensure => installed,
    }
    package { "freeipa-server":
      ensure => installed,
    }

    file {'/etc/hosts':
      path => '/etc/hosts',
      content => template('/vagrant/server/hosts.erb'),
      owner => 'root',
      group => 'root',
      mode => '0644',
    }

    file {'/etc/resolv.conf':
      path => '/etc/resolv.conf',
      content => template('/vagrant/server/resolv.conf.erb'),
      owner => 'root',
      group => 'root',
      mode => '0644',
      require => File['/etc/hosts'],
    }

    exec {'ipa-server-install':
      command => "/sbin/ipa-server-install --realm=${realm} --hostname=${server_fqdn} --domain=${domain} -p ${password} -a ${password} --setup-dns --forwarder=${dns_forwarder} -U",
      timeout => '0',
      unless  => "/sbin/ipactl status >/dev/null 2>&1",
      creates => "/etc/ipa/default.conf",
      logoutput => "on_failure",
      require => [
        Package['bind'],
        Package['bind-dyndb-ldap'],
        Package['freeipa-server'],
        File['/etc/hosts'],
        File['/etc/resolv.conf']
        ]
    }

    exec {'kinit admin':
      command => "/bin/echo ${password} | /bin/kinit admin",
      require => Exec['ipa-server-install']
    }

    exec {'firewall':
      command => "/bin/sh /vagrant/server/firewall.sh",
      require => Exec['kinit admin']
    }
  }

  if $ipa::config_client {
    package { 'freeipa-client':
      ensure => installed,
    }
    package { 'freeipa-admintools':
      ensure => installed,
      require => Package['freeipa-client']
    }

    file {'/etc/hosts':
      path => '/etc/hosts',
      content => template('/vagrant/client/hosts.erb'),
      owner => 'root',
      group => 'root',
      mode => '0644',
    }

    file {'/etc/resolv.conf':
      path => '/etc/resolv.conf',
      content => template('/vagrant/client/resolv.conf.erb'),
      owner => 'root',
      group => 'root',
      mode => '0644',
      require => File['/etc/hosts'],
    }
    exec {'firewall':
      command => "/bin/sh /vagrant/client/firewall.sh",
    }

    exec {'ipa-client-install':
      command => "/sbin/ipa-client-install --server=${server_fqdn} --hostname=${client_fqdn} --domain=${domain} --realm=${realm} --enable-dns-updates --ssh-trust-dns -p admin -w ${password} -U",
      timeout   => '0',
      logoutput => "on_failure",
      require => [
        File['/etc/hosts'],
        File['/etc/resolv.conf'],
        Package['freeipa-client'],
        Package['freeipa-admintools'],
        Exec['firewall'],
        ]
    }

    exec {'kinit admin':
      command => "/usr/bin/echo ${password} | /usr/bin/kinit admin",
      require => Exec['ipa-client-install']
    }
  }
}
