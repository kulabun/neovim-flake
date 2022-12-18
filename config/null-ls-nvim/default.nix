{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) readFile;
in {
  packages = with pkgs.vimPlugins; [
    null-ls-nvim
  ];
  config = readFile ./init.lua;
}
