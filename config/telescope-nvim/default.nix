{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) readFile;
in {
  packages = with pkgs.vimPlugins; [
    plenary-nvim
    telescope-nvim
    # telescope-ui-select-nvim
    telescope-fzf-native-nvim
    telescope-project-nvim
    telescope-file-browser-nvim

    telescope-manix
    pkgs.manix

    pkgs.fd
    pkgs.ripgrep
    pkgs.fzf
  ];
  config = readFile ./init.lua;
}
