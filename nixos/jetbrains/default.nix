{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    (jetbrains-toolbox.withExtraPkgs config.fonts.fontconfig.confPackages)
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    jetbrains-toolbox = pkgs.callPackage ./toolbox {};
  };
}