{
  pkgs,
  neovimPackage,
  neovimConfig,
  extraPackages ? [],
  environment ? {},
  runBefore ? [],
  ...
}: let
  inherit (pkgs) wrapNeovimUnstable;
  inherit (pkgs.lib) concatStringsSep;

  dependencies = with pkgs; [
    xdg-utils
    curl
    wget
    coreutils
    gnugrep
    gnused
    gawk
    git

    gcc
    gnumake
    pkg-config

    nodejs # copilot needs nodejs
    luajit
  ];

  neovim =
    pkgs.symlinkJoin
    rec {
      name = "nvim";
      buildInputs = [pkgs.makeWrapper];
      paths = [neovimPackage] ++ dependencies ++ extraPackages;
      postBuild = ''
        for f in $out/lib/node_modules/.bin/*; do
         path="$(readlink --canonicalize-missing "$f")"
         ln -s "$path" "$out/bin/$(basename $f)"
        done
        wrapProgram $out/bin/${name} \
          --prefix PATH ":" $out/bin \
          ${concatStringsSep " " (map (x: "--set ${x.name} ${x.value}") environment)} \
          ${concatStringsSep " " (map (x: "--run ${x}") runBefore)}
      '';
    };
in
  wrapNeovimUnstable neovim (neovimConfig // {wrapRc = true;})
