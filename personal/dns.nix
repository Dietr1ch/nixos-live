{ ... }:

{
  services = {
    adguardhome = {
      settings = {
        dns = {
          bootstrap_dns = [
            # Google
            "8.8.8.8"
            "8.8.4.4"
            # Cloudflare
            "1.1.1.1"
            "1.0.0.1"
          ];
        };
      }; # ..services.adguardhome.settings
    }; # ..services.adguardhome

    # ./networking/connectivity/dns.nix
    dnscrypt-proxy = {
      # Generates /etc/systemd/system/dnscrypt-proxy.service
      settings = {
        sources = {
          public-resolvers = {
            cache_file = "/var/lib/dnscrypt-proxy/cache";
            urls = [
              "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
              "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            ];
            minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          };
        };
      }; # ..services.dnscrypt-proxy.settings
    }; # ..services.dnscrypt-proxy
  }; # ..services
}
