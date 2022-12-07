{ pkgs
, lib
, ...
}:
let
  inherit (lib) readFile;
in
{
  packages = with pkgs.vimPlugins; [
    project-nvim
  ];
  config = readFile ./init.lua;
}
