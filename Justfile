build_iso:
	nix build .#nixosConfigurations.live_iso.config.system.build.isoImage

build_raspberry_pi3:
	nix build .#nixosConfigurations.raspberry_pi3.config.system.build.images.sd-card

boot_iso: build_iso
	nix-shell -p qemu --command "qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso"

list_drives:
	ls -l /dev/sd*

write_iso TARGET: build_iso
	sudo dd if=$(find result/ -name '*.iso') of={{TARGET}} bs=4M status=progress conv=fdatasync

write_raspberry_pi3_sd_image TARGET: build_raspberry_pi3
	sudo dd if=$(find result/ -name 'nixos-image-sd-card-*.img.zst') of={{TARGET}} bs=4M status=progress conv=fdatasync
