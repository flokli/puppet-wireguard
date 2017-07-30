class wireguard::packages {
  if($::osfamily == 'debian') {
    include apt

    apt::pin {'wireguard':
      packages => ['wireguard-dkms', 'wireguard-tools'],
      release  => 'experimental',
      priority => 501,
      require  => Apt::Source['debian_unstable'],
    }
    [Apt::Pin['wireguard'], Class['apt::update']] -> Package<| title == 'wireguard-dkms' |>
    [Apt::Pin['wireguard'], Class['apt::update']] -> Package<| title == 'wireguard-tools' |>
  }

  package { ['wireguard-dkms', 'wireguard-tools']:
    ensure => latest,
  }

  file { '/etc/wireguard':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    purge   => true,
    recurse => true,
    require => Package['wireguard-tools'],
  }

  file { '/etc/systemd/system/wireguard@.service':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/wireguard/wireguard@.service',
  }
}
