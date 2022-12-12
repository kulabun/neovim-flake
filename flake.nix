{
  description = "My Neovim configuration";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    neovim-flake = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay.url = "github:oxalica/rust-overlay";

    # Vim plugins
    plugin-copilot-lua = {
      url = "github:zbirenbaum/copilot.lua";
      flake = false;
    };
    plugin-copilot-cmp = {
      url = "github:zbirenbaum/copilot-cmp";
      flake = false;
    };
    manix.url = "github:kulabun/manix";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , ...
    } @ inputs:
    let
      buildNeovim = pkgs: (import ./lib { inherit inputs pkgs; }).buildNeovim;
      config = pkgs: (import ./config { inherit inputs pkgs; lib = pkgs.lib; });

      plugins = pkgs:
        with (config pkgs).plugins; [
          settings
          sonokai
          nvim-web-devicons
          todo-comments-nvim
          neo-tree-nvim
          lualine-nvim
          indent-blankline-nvim
          bufferline-nvim
          project-nvim
          telescope-nvim
          nvim-treesitter
          nvim-lspconfig
          comment-nvim
          nvim-scrollbar
          nvim-cmp
          which-key-nvim
          trouble-nvim
        ];
    in
    {
      overlays.default = final: prev:
        rec {
          neovim-kl = buildNeovim prev {
            neovimPackage = inputs.neovim-flake.packages.${prev.system}.neovim;
            extraPackages = [ prev.wl-clipboard ];
            neovimPlugins = plugins prev;
          };
        };
    }
    // flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-linux"
      ]
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import inputs.rust-overlay)
            (final: prev: { inherit (inputs.manix.packages.${system}) manix; })
            self.overlays.default
          ];
          # config = {allowUnfree = true;};
        };
        inherit (pkgs.neovimUtils) makeNeovimConfig;
      in
      rec {
        apps = rec {
          neovim = {
            type = "app";
            program = "${pkgs.neovim-kl}/bin/nvim";
          };
          default = neovim;
        };

        packages = rec {
          inherit (pkgs) neovim-kl;
          default = neovim-kl;
        };

        checks =
          let
            checkNoErrors = checkName: cmd:
              pkgs.runCommand checkName
                { buildInputs = [ pkgs.git ]; }
                ''
                  mkdir -p "$out"
                  export HOME=$TMPDIR
                  # should we set XDG_* vars here?

                  ${cmd} 2> "$out/${checkName}.log"

                  cat "$out/${checkName}.log"

                  if [ -n "$(cat "$out/${checkName}.log")" ]; then
                      while IFS= read -r line; do
                          echo "$line"
                      done < "$out/${checkName}.log"
                      exit 1
                  fi
                '';
          in
          {
            neovim-check-config = checkNoErrors "neovim-check-config" ''${pkgs.neovim-kl}/bin/nvim --headless -c "q"'';
            # TODO: checkhealth?
          };

        devShells.default = pkgs.mkShell {
          buildInputs = [ ];
        };
      });
}
