# NixOS

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/e4ae5984d2484768b3e11c7eaf2a2681)](https://app.codacy.com/gh/mikesupertrampster-corp/nixos?utm_source=github.com&utm_medium=referral&utm_content=mikesupertrampster-corp/nixos&utm_campaign=Badge_Grade_Settings)

![Gitleaks](https://github.com/mikesupertrampster/nixos/actions/workflows/gitleaks.yml/badge.svg)

### Yubikey

###### Nixos Commands

Compiles and builds nixos based on the configuration file(s):
```bash
nixos-rebuild switch
```

Removes old references of build(s):
```bash
nix-collect-garbage -d
nixos-rebuild switch
```

Switch to bleeding edge:
```
nix-channel --add https://nixos.org/channels/nixos-unstable
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
nixos-rebuild switch --upgrade
```

###### Install package

```
NIXPKGS_ALLOW_UNFREE=1 nix-env -i terraform-0.11.5-with-plugins
```

###### Installation of NixOs

1. Download [nix-os](https://nixos.org/nixos/download.html) - choose `Graphical live CD` to help with installation using wifi.
2. Use [Rufus](https://rufus.akeo.ie/) and get the iso:
  1. Select GPT partitioning scheme for BIOS or UEFI
  2. Use FAT32 file system
  3. volume label must be *NIXOS_ISO*
3. Disable secure boot
4. On bootup, prepare the parition for installation:
  1. Perform `cfdisk /dev/<device>` or `mkfs.ext4 -L nixos /dev/<device>`
  2. Locate free space and create new partition.
  4.  `cryptsetup luksFormat /dev/<device>` to encrypt partition.
  5.  `cryptsetup open --type luks /dev/<device> enc-root` to open it.
  6.  `mkfs.ext4 -L nixos /dev/mapper/enc-root`.
  7.  `mount /dev/disk/by-label/nixos /mnt`
  8.  `mkdir /mnt/boot`
  9.  `mount /dev/disk/by-label/EFI /mnt/boot`
5.  Generate new config by running `nixos-generate-config --root /mnt`.
6.  Setup wifi by
  1. Use `ip a` to find wireless card.
  2. `nmcli dev wifi list` to show wifi list
  3. `nmcli device wifi connect <AP name> password <password>` to connect
7.  Install by `nixos-install`
