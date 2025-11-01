{ ... }:

{
  nix = {
    # https://search.nixos.org/options?channel=unstable&query=nix.settings
    settings = {
      extra-substituters = [
        "https://nix-community.cachix.org" # Cachix - nix-community
        "https://devenv.cachix.org" # Cachix - devenv (https://devenv.sh/guides/using-with-flakes/#getting-started)
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # Cachix - nix-community
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" # Cachix - devenv (https://devenv.sh/guides/using-with-flakes/#getting-started)
      ];
    };
  }; # ..nix
}
