{ lib, ... }:

{
  imports = [
    ./dns.nix
    ./identity.nix
    ./locale.nix
    ./nix.nix

    ./users.nix
  ];

  # Disable OpenSnitch
  services.opensnitch.enable = lib.mkForce false;
  # Disable SMART to allow booting in a VM
  services.smartd.enable = lib.mkForce false;
  security = {
    sudo = {
      enable = lib.mkForce false;
    };
  };
}
