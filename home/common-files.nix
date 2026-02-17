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

    shell = lib.mkOption {
      type = lib.types.enum [
        "bash"
        "fish"
        "both"
      ];
      default = "both";
      description = "Which shell configuration files to symlink.";
    };

    enableCargoConfig = lib.mkEnableOption "symlink .cargo/config.toml";
  };

  config.home.file =
    {
      ".tmux.conf".source = mkLink "${cfg.path}/config/tmux/.tmux.conf";
      ".stack/config.yaml".source = mkLink "${cfg.path}/config/stack/config.yaml";
      ".config/nvim".source = mkLink "${cfg.path}/config/nvim";
      ".config/lazygit".source = mkLink "${cfg.path}/config/lazygit";
      ".config/bottom".source = mkLink "${cfg.path}/config/bottom";
      ".config/starship".source = mkLink "${cfg.path}/config/starship";
      ".config/lsd".source = mkLink "${cfg.path}/config/lsd";
      ".config/clangd".source = mkLink "${cfg.path}/config/clangd";
      ".config/ghostty".source = mkLink "${cfg.path}/config/ghostty";
      ".config/wezterm".source = mkLink "${cfg.path}/config/wezterm";
      ".config/containers".source = mkLink "${cfg.path}/config/containers";
    }
    // lib.optionalAttrs (cfg.shell == "bash" || cfg.shell == "both") {
      ".bashrc".source = mkLink "${cfg.path}/config/bash/.bashrc";
      ".inputrc".source = mkLink "${cfg.path}/config/bash/.inputrc";
    }
    // lib.optionalAttrs (cfg.shell == "fish" || cfg.shell == "both") {
      ".config/fish".source = mkLink "${cfg.path}/config/fish";
    }
    // lib.optionalAttrs cfg.enableCargoConfig {
      ".cargo/config.toml".source = mkLink "${cfg.path}/config/cargo/config.toml";
    };
}
