# puppet-systemd
[![Build Status](https://travis-ci.org/flokli/puppet-systemd.svg?branch=master)](https://travis-ci.org/flokli/puppet-systemd)

This module manages systemd and its services.

## Supported distributions
 - Debian (Jessie and later)
 - Ubuntu (Yakkety and later)
 - Archlinux

## Modules
It currently consists of the following modules:

### systemd
This ensures latest systemd from backports is installed (Debian)
This module is included by all further modules

### systemd::network
 - Ensures `systemd-networkd` is installed, running and enabled
 - Empties `/etc/network/interfaces`, ensures networking isn't started anymore
 - Manages the `/etc/systemd/network` directory, while purging unmanaged files.
   (Files matching 1*.(link,netdev,network) are preserved)
 - Installs a `99-default.network` file to do dhcp on all `eth*` and `en*` interfaces
   if nothing was configured by then
 - Takes care `systemd-networkd` is only restarted when all networkd files have been written
