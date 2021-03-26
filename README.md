# NixOS

[[![Gitleaks](https://github.com/mikesupertrampster/nixos/actions/workflows/gitleaks.yml/badge.svg)](https://github.com/mikesupertrampster/nixos/actions/workflows/gitleaks.yml)](https://github.com/mikesupertrampster/nixos/actions/workflows/gitleaks.yml)

```nix
{
  home-manager.users."user" = { ... }: {
    imports = [ /home/mike/.config/nixpkgs/home.nix ];
  };
}
```