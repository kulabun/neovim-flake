{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) readFile;
in {
  packages = with pkgs.vimPlugins; [
    nvim-web-devicons
  ];
  config = readFile ./init.lua;
}
