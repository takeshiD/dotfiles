{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.networkmanager.unmanaged = [ "interface-name:wg0" ];

  # Provision both files before activation, owned by root:systemd-network (0640).
  # server.key: server private key; laptop.pub: laptop public key only.
  # Never put private keys in this repository or in Nix string literals.
  systemd.tmpfiles.rules = [ "d /etc/wireguard 0750 root systemd-network -" ];

  systemd.network = {
    enable = true;
    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "10.77.0.1/24" ];
      networkConfig = {
        DHCP = "no";
        LinkLocalAddressing = "no";
        IPv6AcceptRA = false;
        ConfigureWithoutCarrier = true;
      };
      linkConfig.RequiredForOnline = "no";
    };
    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
      };
      wireguardConfig = {
        PrivateKeyFile = "/etc/wireguard/server.key";
        ListenPort = 51820;
      };
      wireguardPeers = [
        {
          PublicKeyFile = "/etc/wireguard/laptop.pub";
          AllowedIPs = [ "10.77.0.2/32" ];
        }
      ];
    };
  };
}
