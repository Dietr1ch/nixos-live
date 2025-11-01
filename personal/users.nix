{ ... }:

{
  users = {
    users = {

      "dietr1ch" = {
        home = "/home/dietr1ch";

        # Allow mosh sessions linger arround
        # linger = true;

        extraGroups = [
          "vboxusers"
          "libvirtd"

          "wireshark"

          "audio"
          "dialout" # zigbee
        ];
      }; # ..users.users."dietr1ch"

    }; # ..users.users
  }; # ..users
}
