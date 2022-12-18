{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) readFile;
in {
  packages = with pkgs.vimPlugins; [
    comment-nvim
  ];
  config = readFile ./init.lua;
}
