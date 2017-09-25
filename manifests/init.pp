class wireguard (
  Hash[String, Hash] $tunnels = {},
  Hash[String, Hash] $simple_tunnels = {},
) {
  include wireguard::packages

  $tunnels.each |$name, $params| {
    wireguard::tunnel { $name:
      * => $params,
    }
  }
  $simple_tunnels.each |$name, $params| {
    wireguard::simple_tunnel { $name:
      * => $params,
    }
  }
}
