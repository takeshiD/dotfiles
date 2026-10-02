{ config, lib, ... }:
let
  cfg = config.dotfiles;
  mkLink = config.lib.file.mkOutOfStoreSymlink;
in
{
  options.dotfiles = {
    path = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/dotfiles";
      description = "Path to the dotfiles repository used for config symlinks.";
    };

    enableLocalOverrides = lib.mkEnableOption "overrides for the local configuration (tmux prefix C-b, tmux2k duo theme, tmux-deck and starship gruvbox themes)";
  };

  config.home.file = {
    ".tmux.conf".source = mkLink "${cfg.path}/config/tmux/.tmux.conf";
    ".stack/config.yaml".source = mkLink "${cfg.path}/config/stack/config.yaml";
    ".config/nvim".source = mkLink "${cfg.path}/config/nvim";
    ".config/lazygit".source = mkLink "${cfg.path}/config/lazygit";
    ".config/bottom".source = mkLink "${cfg.path}/config/bottom";
    ".config/starship/starship.toml" = {
      source = mkLink "${cfg.path}/config/starship/${
        if cfg.enableLocalOverrides then "gruvbox.toml" else "google.toml"
      }";
      force = true;
    };
    ".config/lsd".source = mkLink "${cfg.path}/config/lsd";
    ".config/ghostty".source = mkLink "${cfg.path}/config/ghostty";
    ".config/wezterm".source = mkLink "${cfg.path}/config/wezterm";
    ".config/containers".source = mkLink "${cfg.path}/config/containers";
    ".config/tombi".source = mkLink "${cfg.path}/config/tombi";
    ".config/gh-dash".source = mkLink "${cfg.path}/config/gh-dash";
    ".config/mdpeek".source = mkLink "${cfg.path}/config/mdpeek";
    ".config/herdr/config.toml".source = mkLink "${cfg.path}/config/herdr/config.toml";
    ".bashrc".source = mkLink "${cfg.path}/config/bash/.bashrc";
    ".inputrc".source = mkLink "${cfg.path}/config/bash/.inputrc";
    ".zshrc".source = mkLink "${cfg.path}/config/zsh/.zshrc";
    ".config/fish".source = mkLink "${cfg.path}/config/fish";
    ".cargo/config.toml".source = mkLink "${cfg.path}/config/cargo/config.toml";
    ".config/tmux-deck/config.toml".source = mkLink "${cfg.path}/config/tmux-deck/${
      if cfg.enableLocalOverrides then "config.local.toml" else "config.toml"
    }";
  }
  // lib.mapAttrs' (
    name: _:
    lib.nameValuePair ".codex/rules/${name}" {
      source = mkLink "${cfg.path}/config/codex/rules/${name}";
      force = true;
    }
  ) (lib.filterAttrs (_: type: type == "regular") (builtins.readDir ../config/codex/rules))
  // lib.optionalAttrs cfg.enableLocalOverrides {
    ".config/tmux/local.conf".source = mkLink "${cfg.path}/config/tmux/local.conf";
  };
}
