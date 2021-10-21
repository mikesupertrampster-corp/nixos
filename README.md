# NixOS

![Gitleaks](https://github.com/mikesupertrampster/nixos/actions/workflows/gitleaks.yml/badge.svg)

```nix
{
  home-manager.users."user" = { ... }: {
    imports = [ /home/mike/.config/nixpkgs/home.nix ];
  };
}
```

```bash
export NIX_PATH="nixos-config=$(pwd)"
nixos-rebuild switch
```

```bash
nixos-rebuild switch -I nixos-config=/home/mike/.config/nixpkgs/nixos
```
