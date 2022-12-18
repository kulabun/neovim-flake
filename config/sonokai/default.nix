{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) readFile;
in {
  packages = with pkgs.vimPlugins; [
    sonokai
  ];
  config = readFile ./init.lua;
}
