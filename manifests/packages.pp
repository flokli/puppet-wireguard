class wireguard::packages {
  if($::osfamily == 'debian') {
    include apt

    $osname = $facts['os']['name']

    case $osname {
      'ubuntu' : {
        apt::source { 'wireguard' :
          location => "http://ppa.launchpad.net/wireguard/wireguard/${osname}",
          release  => $facts['lsbdistcodename'],
          repos    => 'main',
          key      => {
            'id'     => 'E1B39B6EF6DDB96564797591AE33835F504A1A25',
            'server' => 'pgp.mit.edu',
          },
          include  => {
            'src' => false,
          },
        }
        [Apt::Source['wireguard'], Class['apt::update']] -> Package<| title == 'wireguard-tools' |>
        [Apt::Source['wireguard'], Class['apt::update']] -> Package<| title == 'wireguard-dkms' |>
      }
      default : {
        apt::pin {'wireguard':
          packages => ['wireguard-dkms', 'wireguard-tools'],
          release  => 'experimental',
          priority => 501,
          require  => Apt::Source['debian_unstable'],
        }

        [Apt::Pin['wireguard'], Class['apt::update']] -> Package<| title == 'wireguard-dkms' |>
        [Apt::Pin['wireguard'], Class['apt::update']] -> Package<| title == 'wireguard-tools' |>
      }
    }
  }

  package { ['wireguard-dkms', 'wireguard-tools']:
    ensure => latest,
  }

  file { '/etc/wireguard':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
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
