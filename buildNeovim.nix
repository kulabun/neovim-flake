{ pkgs
, neovimPackage ? pkgs.neovim
, neovimPlugins ? [ ]
, extraPackages ? [ ]
, environment ? { }
, runBefore ? [ ]
, customRC ? ""
, ...
}:
let
  inherit (pkgs) wrapNeovimUnstable;
  inherit (pkgs.neovimUtils) makeNeovimConfig;
  inherit (pkgs.lib) concatStringsSep mapAttrsToList;

  dependencies = with pkgs; [
    xdg-utils
    curl
    wget
    coreutils
    gnugrep
    gnused
    gawk
    git

    nix-ld
    gcc
    gnumake
    pkg-config

    luajit
    python3
    nodejs
  ];

  environmentVariables = mapAttrsToList (name: value: { inherit name value; }) environment;

  config = makeNeovimConfig {
    plugins = neovimPlugins;
    customRC = ''
      lua << EOF
        ${customRC}
      EOF
    '';
  };

  neovim =
    pkgs.symlinkJoin
      rec {
        name = "nvim";
        buildInputs = [ pkgs.makeWrapper ];
        paths = [ neovimPackage ] ++ dependencies ++ extraPackages;
        postBuild = ''
          for f in $out/lib/node_modules/.bin/*; do
           path="$(readlink --canonicalize-missing "$f")"
           ln -s "$path" "$out/bin/$(basename $f)"
          done
          wrapProgram $out/bin/${name} \
            --prefix PATH ":" $out/bin \
            ${concatStringsSep " " (map (x: "--set ${x.name} ${x.value}") environmentVariables)} \
            ${concatStringsSep " " (map (x: "--run ${x}") runBefore)}
        '';
      };
in
wrapNeovimUnstable neovim (config // { wrapRc = true; })
