{ ... }:

# https://wiki.nixos.org/wiki/Locales

{
  # https://search.nixos.org/options?channel=unstable&query=i18n
  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/i18n.nix
  i18n = {
    # Default to en_GB.UTF-8/UTF-8
    defaultLocale = "en_GB.UTF-8";
    defaultCharset = "UTF-8";
  };
}
