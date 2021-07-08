# NixOS

![Gitleaks](https://github.com/mikesupertrampster/nixos/actions/workflows/gitleaks.yml/badge.svg)

```nix
{
  home-manager.users."user" = { ... }: {
    imports = [ /home/mike/.config/nixpkgs/home.nix ];
  };
}
```

```
  ln -s ~michael.liu/.config/nixpkgs/nixos/one/*.nix .
  ln -s ~michael.liu/.config/nixpkgs/nixos/*.nix .
```
