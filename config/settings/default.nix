{ pkgs
, lib
, ...
}:
let
  inherit (lib) readFile;
in
{
  packages = with pkgs.vimPlugins; [
  ];
  config = readFile ./init.lua;
}
