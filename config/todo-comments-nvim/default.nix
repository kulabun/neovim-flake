{ pkgs
, lib
, ...
}:
let
  inherit (lib) readFile;
in
{
  packages = with pkgs.vimPlugins; [
    todo-comments-nvim
  ];
  config = readFile ./init.lua;
}
