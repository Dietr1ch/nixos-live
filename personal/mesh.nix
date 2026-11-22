{ ... }:

{
  nix = {
    # https://search.nixos.org/options?channel=unstable&query=nix.settings
    settings = {
      extra-substituters = [
        "http://nix.flock.local"
        "http://nix.nuerburgring.local"
      ];
    };
  }; # ..nix
}
