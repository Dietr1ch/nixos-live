{
  description = "Custom NixOS installation media";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    systemn = {
      url = "github:Dietr1ch/systemn";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    id.url = "github:Dietr1ch/id";
  };

  outputs =
    {
      nixpkgs,
      nixos-hardware,
      systemn,
      id,
      ...
    }:

    {
      nixosConfigurations = {
        "live_iso" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.common-pc-ssd # ~/Projects/nixos-hardware/common/pc/ssd/default.nix

            ./personal # ./personal/default.nix

            id.users # ~/Projects/id/users/default.nix

            # SystemN  ~/Projects/systemn/flake.nix
            # =======

            # Hardware
            systemn.nixosModules.hardware-bluetooth # ~/Projects/systemn/hardware/bluetooth.nix
            systemn.nixosModules.hardware-graphics # ~/Projects/systemn/hardware/graphics/default.nix
            systemn.nixosModules.hardware-keyboard-ergodox_ez # ~/Projects/systemn/hardware/keyboard/ergodox_ez.nix
            systemn.nixosModules.hardware-memtest # ~/Projects/systemn/hardware/memtest.nix
            systemn.nixosModules.hardware-phone # ~/Projects/systemn/hardware/phone.nix
            systemn.nixosModules.hardware-printing # ~/Projects/systemn/hardware/printing.nix
            systemn.nixosModules.hardware-truerng # ~/Projects/systemn/hardware/truerng.nix

            # System
            systemn.nixosModules.system # ~/Projects/systemn/system/default.nix
            systemn.nixosModules.system-base-hardware_information # ~/Projects/systemn/system/base/hardware_information.nix
            systemn.nixosModules.system-base-watchdog # ~/Projects/systemn/system/base/watchdog.nix
            systemn.nixosModules.system-boot-efi # ~/Projects/systemn/system/boot/efi.nix
            systemn.nixosModules.system-input-mouse # ~/Projects/systemn/system/input/mouse.nix
            systemn.nixosModules.system-input-keyboard-dvorak # ~/Projects/systemn/system/input/keyboard/dvorak.nix
            systemn.nixosModules.system-networking # ~/Projects/systemn/system/networking/default.nix
            systemn.nixosModules.system-networking-connectivity # ~/Projects/systemn/system/networking/connectivity/default.nix
            systemn.nixosModules.system-security-yubikey # ~/Projects/systemn/system/security/yubikey.nix;

            # Desktop
            systemn.nixosModules.desktop # ~/Projects/systemn/desktop/default.nix

            (
              {
                lib,
                modulesPath,
                pkgs,
                ...
              }:

              {
                imports = [
                  (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
                ];

                nixpkgs = {
                  config = {
                    allowUnfreePredicate =
                      pkg:
                      builtins.elem (lib.getName pkg) [
                        "symbola"
                      ];
                  };
                };

                # Generated with mkpasswd --method=sha-512
                users.users.root.initialHashedPassword = lib.mkForce "$6$dyINLcIm1E3tQ5xU$nSREiDQrPVb9hK/Rncw24vxJr/gZnSMeDRe2vOGTH3yfgeHMJwr2Sq3rrA1J.O9N0dEvpFCI0F0Q5qhc1HMpF0";
                # Enable SSH in the boot process.
                systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];

                environment = {
                  systemPackages = with pkgs; [
                    fish
                    htop
                    zenith

                    ncdu
                    rsync
                    util-linux
                  ];
                };
              }
            )
          ];
        };
      };
    };
}
