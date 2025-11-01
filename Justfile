
build_iso:
	nix build .#nixosConfigurations.live_iso.config.system.build.isoImage

boot_iso: build_iso
	nix-shell -p qemu --command "qemu-system-x86_64 -enable-kvm -m 256 -cdrom result/iso/nixos-*.iso"

list_drives:
	ls -l /dev/sd*

write TARGET: build_iso
	sudo dd if=$(find result/ -name '*.iso') of={{TARGET}} bs=4M status=progress conv=fdatasync
