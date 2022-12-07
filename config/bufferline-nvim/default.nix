{ pkgs
, lib
, ...
}:
let
  inherit (lib) readFile;
in
{
  packages = with pkgs.vimPlugins; [
    bufferline-nvim
  ];
  config = readFile ./init.lua;
}
