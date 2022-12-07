
{ pkgs
, lib
, ...
}:
let
  inherit (lib) readFile;
in
{
  packages = with pkgs.vimPlugins; [
    nvim-scrollbar
  ];
  config = readFile ./init.lua;
}
