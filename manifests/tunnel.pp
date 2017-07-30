# The wireguard::tunnel resource creates a wireguard interface with given
# private key, listen port and peer list. This is done by adding a
# configuration file inside /etc/wireguard, and enabling and starting the
# wireguard@ service, installed by wireguard::packages.
#
# @param private_key the private key used here
# @param listen_port on which port wireguard should listen for incoming
# connections.  Chosen randomly if not specified.
# @param: a list of peers with a dict containing public_key (mandatory),
# allowed_ips and endpoint (optional). See wireguard::simple_tunnel for a
# detailed description.

define wireguard::tunnel (
  String  $private_key,
  Integer $listen_port,
  Array[Hash] $peers,
) {

  include wireguard::packages

  $detail_peers = $peers.map |$peer| {
    if($peer['public_key'] == undef) {
      fail('public key is mandatory for each peer')
    }
    return {
      public_key => $peer['public_key'],
      allowed_ips => $peer['allowed_ips'] or '0.0.0.0/0, ::/0',
      endpoint => $peer['endpoint'],
    }
  }

  file { "/etc/wireguard/${title}.conf":
    ensure  => file,
    content => epp('wireguard/config.epp', {
      private_key => $private_key,
      listen_port => $listen_port,
      peers       => $detail_peers,
    }),
    notify  => Exec["wireguard@${title}_reload"],
  }

  exec {"wireguard@${title}_reload":
    command     => "/bin/systemctl reload wireguard@${title}.service",
    refreshonly => true,
    require     => Service["wireguard@${title}.service"],
  }

  service { "wireguard@${title}.service":
    ensure  => running,
    enable  => true,
    require => File["/etc/wireguard/${title}.conf"],
  }
}
