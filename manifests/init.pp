class wireguard (
  Array[Hash] $tunnels = [],
  Array[Hash] $simple_tunnels = [],
) {
  include wireguard::packages

  $tunnels.each |$tunnel| {
    $tunnel.each |$name, $params| {
      wireguard::tunnel { $name:
        * => $params,
      }
    }
  }
  $simple_tunnels.each |$simple_tunnel| {
    $simple_tunnel.each |$name, $params| {
      wireguard::simple_tunnel { $name:
        * => $params,
      }
    }
  }
}
