# NixOS

![Gitleaks](https://github.com/mikesupertrampster/nixos/actions/workflows/gitleaks.yml/badge.svg)

```nix
{
  home-manager.users."user" = { ... }: {
    imports = [ /home/mike/.config/nixpkgs/home.nix ];
  };
}
```

 * https://github.com/mjstewart/nix-home-manager/blob/master/home.nix
 * https://github.com/malloc47/config/blob/master/config/home.nix
 * https://nixos.org/manual/nix/unstable/expressions/builtins.html
 * https://christine.website/blog/nixos-desktop-flow-2020-04-25
 * https://www.lafuente.me/posts/installing-home-manager/
