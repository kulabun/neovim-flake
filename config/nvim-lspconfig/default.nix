{ pkgs
, lib
, ...
}:
let
  inherit (lib) readFile;
  my-rust = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-src" ];
    targets = [ "x86_64-unknown-linux-gnu" ];
  };
  my-rust-analyzer = pkgs.symlinkJoin {
    name = "rust-analyzer";
    paths = [ pkgs.rust-analyzer ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/rust-analyzer \
        --set-default "RUST_SRC_PATH" "${my-rust}"
    '';
  };
in
{
  packages = with pkgs.vimPlugins; [
    nvim-lspconfig

    # python
    pkgs.nodePackages.pyright
    # haskell
    pkgs.haskell-language-server
    # rust
    my-rust
    my-rust-analyzer
    # nix
    pkgs.rnix-lsp
    # typscript, javascript
    pkgs.nodePackages.typescript-language-server
    pkgs.nodePackages.typescript
    # lua
    pkgs.sumneko-lua-language-server
    # html, css, json, yaml
    pkgs.nodePackages.vscode-langservers-extracted
    # bash
    pkgs.nodePackages.bash-language-server
    # go
    pkgs.gopls
  ];
  config = readFile ./init.lua;
}
