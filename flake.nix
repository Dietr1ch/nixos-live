{
  description = "Custom NixOS installation media";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";

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

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org" # Cachix - nix-community
      "https://devenv.cachix.org" # Cachix - devenv (https://devenv.sh/guides/using-with-flakes/#getting-started)
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # Cachix - nix-community
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" # Cachix - devenv (https://devenv.sh/guides/using-with-flakes/#getting-started)
    ];
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

            # Id
            # ==
            id.locations-cl-valle_nevado # ~/Projects/id/locations/cl/valle_nevado.nix
            id.users # ~/Projects/id/users/default.nix

            # SystemN  ~/Projects/systemn/flake.nix
            # =======

            # Hardware
            systemn.nixosModules.hardware # ~/Projects/systemn/hardware/default.nix
            systemn.nixosModules.hardware-bluetooth # ~/Projects/systemn/hardware/bluetooth.nix
            systemn.nixosModules.hardware-graphics # ~/Projects/systemn/hardware/graphics/default.nix
            systemn.nixosModules.hardware-keyboard-ergodox_ez # ~/Projects/systemn/hardware/keyboard/ergodox_ez.nix
            systemn.nixosModules.hardware-memtest # ~/Projects/systemn/hardware/memtest.nix
            systemn.nixosModules.hardware-phone # ~/Projects/systemn/hardware/phone.nix
            systemn.nixosModules.hardware-printing # ~/Projects/systemn/hardware/printing.nix
            systemn.nixosModules.hardware-storage # ~/Projects/systemn/hardware/storage.nix
            systemn.nixosModules.hardware-truerng # ~/Projects/systemn/hardware/truerng.nix
            systemn.nixosModules.hardware-usb # ~/Projects/systemn/hardware/usb.nix

            # System
            systemn.nixosModules.system # ~/Projects/systemn/system/default.nix
            systemn.nixosModules.system-base-hardware_information # ~/Projects/systemn/system/base/hardware_information.nix
            systemn.nixosModules.system-base-watchdog # ~/Projects/systemn/system/base/watchdog.nix
            systemn.nixosModules.system-boot-efi # ~/Projects/systemn/system/boot/efi.nix
            systemn.nixosModules.system-input-keyboard-dvorak # ~/Projects/systemn/system/input/keyboard/dvorak.nix
            systemn.nixosModules.system-input-mouse # ~/Projects/systemn/system/input/mouse.nix
            systemn.nixosModules.system-input-touchpad # ~/Projects/systemn/system/input/touchpad.nix
            systemn.nixosModules.system-networking # ~/Projects/systemn/system/networking/default.nix
            systemn.nixosModules.system-networking-connectivity # ~/Projects/systemn/system/networking/connectivity/default.nix
            systemn.nixosModules.system-security # ~/Projects/systemn/system/security/default.nix;
            systemn.nixosModules.system-security-yubikey # ~/Projects/systemn/system/security/yubikey.nix;

            # Desktop
            systemn.nixosModules.desktop # ~/Projects/systemn/desktop/default.nix
            systemn.nixosModules.desktop-gaming # ~/Projects/systemn/desktop/gaming/default.nix
            systemn.nixosModules.desktop-shell-graphical-browser # ~/Projects/systemn/desktop/shell/graphical/browser/default.nix
            systemn.nixosModules.desktop-shell-graphical-browser-chromium # ~/Projects/systemn/desktop/shell/graphical/browser/chromium.nix
            systemn.nixosModules.desktop-shell-graphical-office # ~/Projects/systemn/desktop/shell/graphical/office.nix
            systemn.nixosModules.desktop-shell-terminal # ~/Projects/systemn/desktop/shell/terminal/default.nix
            systemn.nixosModules.desktop-shell-terminal-documents # ~/Projects/systemn/desktop/shell/terminal/documents.nix
            systemn.nixosModules.desktop-sound # ~/Projects/systemn/desktop/sound.nix

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
                        "steam"
                        "steam-unwrapped"
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
                    rustscan
                    vlc
                    meld
                    gparted

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
