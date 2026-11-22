{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dotfiles.pi;
  mkLink = config.lib.file.mkOutOfStoreSymlink;

  # Runtime dependencies of third-party packages are vendored by the derivation
  # itself; Pi only receives the package root (the directory with package.json).
  piPackagePath =
    package:
    package.passthru.piPackage
      or (throw "dotfiles.pi.packages: ${package.name} does not expose passthru.piPackage");

  managedPackages = pkgs.writeText "pi-packages.json" (
    builtins.toJSON (map piPackagePath cfg.packages)
  );

  # First-party extensions stay editable in the repository and are hot-reloadable
  # with /reload, so link them instead of copying them into the store.
  # Enumerate through the store copy of this repository (pure evaluation), but
  # point the links at the working tree so edits apply with /reload.
  extensionsDir = "${config.dotfiles.path}/config/pi/extensions";
  repoExtensions =
    lib.filterAttrs
      (
        name: type:
        !(lib.hasPrefix "." name)
        && (type == "directory" || lib.hasSuffix ".ts" name || lib.hasSuffix ".js" name)
      )
      (
        if builtins.pathExists ../config/pi/extensions then
          builtins.readDir ../config/pi/extensions
        else
          { }
      );
in
{
  options.dotfiles.pi = {
    enable = lib.mkEnableOption "Pi coding agent extensions and packages";

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ (pkgs.callPackage ../pkgs/pi-subagents { }) ];
      description = ''
        Pi packages (extensions, skills, prompts, and themes) to load as local
        paths. `settings.json` is updated on activation, so packages installed
        with `pi install` are not preserved; declare them here instead.
      '';
    };

    extensionPaths = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      description = ''
        Extra extension files or directories to link into
        `~/.pi/agent/extensions`. Use store paths, for example
        `inputs.my-extensions`, for extensions that are not part of this
        repository.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.file =
      lib.mapAttrs' (
        name: _:
        lib.nameValuePair ".pi/agent/extensions/${name}" {
          source = mkLink "${extensionsDir}/${name}";
        }
      ) repoExtensions
      // lib.listToAttrs (
        map (
          path:
          lib.nameValuePair ".pi/agent/extensions/${baseNameOf (toString path)}" {
            source = path;
          }
        ) cfg.extensionPaths
      );

    home.activation.piPackages = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      settings="${config.home.homeDirectory}/.pi/agent/settings.json"
      ${pkgs.coreutils}/bin/mkdir -p "${config.home.homeDirectory}/.pi/agent"

      if [ -f "$settings" ] && ! ${pkgs.jq}/bin/jq -e . "$settings" >/dev/null 2>&1; then
        echo "pi: $settings is not valid JSON; leaving its packages untouched" >&2
      else
        tmp="$(mktemp "$settings.XXXXXX")"
        if [ -f "$settings" ]; then
          ${pkgs.jq}/bin/jq --slurpfile packages ${managedPackages} \
            '.packages = $packages[0]' "$settings" > "$tmp"
        else
          ${pkgs.jq}/bin/jq -n --slurpfile packages ${managedPackages} \
            '{ packages: $packages[0] }' > "$tmp"
        fi
        ${pkgs.coreutils}/bin/chmod 0644 "$tmp"
        if ${pkgs.diffutils}/bin/cmp -s "$tmp" "$settings"; then
          ${pkgs.coreutils}/bin/rm -f "$tmp"
        else
          ${pkgs.coreutils}/bin/mv "$tmp" "$settings"
        fi
      fi
    '';
  };
}
