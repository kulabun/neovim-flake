{
  description = "My Neovim configuration";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    buildNeovim = args: import ./buildNeovim.nix args;

    neovim = pkgs:
      buildNeovim {
        inherit pkgs;
        neovimPackage = pkgs.neovim-unwrapped;
        neovimPlugins =
          map (plug: (plug pkgs)) [
          ]
          ++ (with pkgs.vimPlugins; [
            telescope-fzf-native-nvim
            telescope-nvim

            nvim-treesitter-textobjects
            # nvim-treesitter.withAllGrammars - comment grammar conflicts with todo-comments, plus there are too many grammars there
            (nvim-treesitter.withPlugins (
              plugins:
                with plugins; [
                  tree-sitter-bash
                  tree-sitter-c
                  tree-sitter-diff
                  tree-sitter-dockerfile
                  tree-sitter-gitattributes
                  tree-sitter-gitcommit
                  tree-sitter-git_config
                  tree-sitter-gitignore
                  tree-sitter-git_rebase
                  tree-sitter-go
                  tree-sitter-gomod
                  tree-sitter-gosum
                  tree-sitter-graphql
                  tree-sitter-hcl # terraform
                  tree-sitter-html
                  tree-sitter-http
                  tree-sitter-java
                  tree-sitter-javascript
                  tree-sitter-jq
                  tree-sitter-json
                  tree-sitter-json5
                  tree-sitter-kdl
                  tree-sitter-kotlin
                  tree-sitter-lua
                  tree-sitter-luadoc
                  tree-sitter-luap
                  tree-sitter-make
                  tree-sitter-markdown
                  tree-sitter-markdown-inline
                  tree-sitter-nix
                  tree-sitter-po # internationalization
                  tree-sitter-pug
                  tree-sitter-python
                  tree-sitter-query # for the tree-sitter itself
                  tree-sitter-regex
                  tree-sitter-regex
                  tree-sitter-rust
                  tree-sitter-toml
                  tree-sitter-tsx
                  tree-sitter-typescript
                  tree-sitter-vim
                  tree-sitter-vimdoc
                  tree-sitter-yaml
                ]
            ))

            catppuccin-nvim

            dressing-nvim
            neo-tree-nvim
            which-key-nvim
            nvim-navic
            nvim-web-devicons
            indent-blankline-nvim
            gitsigns-nvim
            bufferline-nvim
            lualine-nvim
            todo-comments-nvim

            mini-nvim

            nvim-cmp
            cmp-nvim-lsp
            cmp_luasnip
            cmp-path
            cmp-nvim-lsp-signature-help

            cmp-buffer
            cmp-treesitter

            luasnip
            # friendly-snippets

            copilot-lua

            null-ls-nvim
            nvim-lspconfig
            nvim-jdtls

            plenary-nvim
          ]);
        extraPackages = with pkgs; [
          # Python
          pyright # language server
          black # formatter
          isort # formatter
          ruff # diagnostics

          # Shell
          nodePackages.bash-language-server # language server
          shfmt # formatter
          shellharden # formatter
          shellcheck # diagnostics

          # Nix
          nil # language server
          nixpkgs-fmt # formatter
          statix # diagnostics

          # Lua
          lua-language-server # language server
          stylua # formatter
          selene # diagnostics

          # JSON
          nodePackages.jsonlint
          python3Packages.yamllint

          # Java
          jdt-language-server

          # HTML/CSS/JS
          nodePackages.vscode-langservers-extracted
          nodePackages."@tailwindcss/language-server"
          # nodePackages.typescript-language-server
          # nodePackages.typescript
          nodePackages.prettier
          deno

          # nodejs # for copilot
          fzf
          bat
          ripgrep
          fd
          git
          # lazygit
        ];
        customRC = ''
          vim.opt.rtp:prepend("${./config}")
          vim.opt.packpath = vim.opt.rtp:get()
          require("user")
        '';
      };
  in
    {
      overlays.default = final: prev: {
        kl-nvim = neovim prev;
      };
    }
    // flake-utils.lib.eachSystem
    [
      "x86_64-linux"
    ]
    (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [self.overlays.default];
        config.allowUnfree = true;
      };

      inherit (pkgs.neovimUtils) makeNeovimConfig;
    in rec {
      apps = {
        default = {
          type = "app";
          program = "${pkgs.kl-nvim}/bin/nvim";
        };
      };

      packages = {
        default = pkgs.kl-nvim;
      };

      checks = let
        checkNoErrors = checkName: cmd:
          pkgs.runCommand checkName
          {buildInputs = [pkgs.git];}
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
      in {
        neovim-check-config = checkNoErrors "neovim-check-config" ''${pkgs.nvim}/bin/nvim --headless -c "q"'';
      };

      devShells.default = pkgs.mkShell {
        buildInputs = [];
      };
    });
}
