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
  Enum['present','absent'] $ensure = 'present',
  Hash[String, Struct[
    {
      public_key           => String,
      endpoint             => Optional[String],
      allowed_ips          => Optional[String],
    }
  ]] $peers = {},
) {

  include wireguard::packages

  $peers.each |$key, $value| {
    if($value['public_key'] == undef) {
      fail('public key is mandatory for each peer')
    }
  }

  file { "/etc/wireguard/${title}.conf":
    ensure  => $ensure,
    content => epp('wireguard/config.epp', {
      private_key => $private_key,
      listen_port => $listen_port,
      peers       => $peers.map |$key, $value| {
        {
          'public_key'           => $value['public_key'],
          'endpoint'             => $value['endpoint'],
          'allowed_ips'          => ($value['allowed_ips'] != undef) ? { true => $value['allowed_ips'], default => '0.0.0.0/0, ::/0'},
        }
      },
    }),
    notify  => Service["wireguard@${title}.service"],
  }

  service { "wireguard@${title}.service":
    ensure  => if $ensure { 'running' } else { 'stopped' },
    enable  => if $ensure { true } else { false },
    require => File["/etc/wireguard/${title}.conf"],
  }
}
