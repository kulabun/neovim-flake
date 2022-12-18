{
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) concatStringsSep filter hasAttr getAttr concatLists mapAttrsToList any hasPrefix;
  inherit (pkgs.neovimUtils) makeNeovimConfig;
in {
  buildNeovim = attrs @ {
    neovimPackage,
    extraPackages ? [],
    environment ? {},
    runBefore ? null,
    customRC ? "",
    neovimPlugins ? [],
  }: let
    hasAnyPrefix = prefs: str: any (pref: hasPrefix pref str) prefs;
    isVimPlugin = pkg: hasAnyPrefix ["vimplugin-" "lua"] pkg.name;
    isNotVimPlugin = pkg: !isVimPlugin pkg;
    withDependencies = plugins: (concatLists (map (p: [p] ++ withDependencies (p.dependencies or [])) plugins));

    plugins = concatLists (map (p: p.packages) neovimPlugins);
    # pluginsAll = filter (isVimPlugin pkgs) (withDependencies plugins);
    pluginRequiredPackages = filter isNotVimPlugin (withDependencies plugins);
  in
    import ./buildNeovim.nix {
      inherit pkgs neovimPackage;
      environment = mapAttrsToList (name: value: {inherit name value;}) environment;
      runBefore = filter (x: x != null) [runBefore];
      neovimConfig = makeNeovimConfig {
        inherit plugins;
        customRC = ''
          lua << EOF
            ${concatStringsSep "\n" (map (p: p.config) neovimPlugins)}
            ${customRC}
          EOF
        '';
      };
      extraPackages = extraPackages ++ pluginRequiredPackages;
    };
}
