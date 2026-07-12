{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  llmAgentsPkgs = with inputs.llm-agents.packages.${pkgs.system}; [
    claude-code
    codex
    openclaw
  ];
  tmuxDeckPkgs = with inputs.tmux-deck.packages.${pkgs.system}; [
    tmux-deck
  ];
  gfmPreviewPkgs = with inputs.gfm-preview.packages.${pkgs.system}; [
    gh-gfm-preview
  ];
  # baconlsPkgs = with inputs.bacon-ls.packages.${pkgs.system}; [
  #   bacon-ls
  # ];
  obfishPkgs = with inputs.ob-fish.packages.${pkgs.system}; [
    ob-fish-completion
  ];
in
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../home/cli.nix
    ../home/common-files.nix
    ../home/gui.nix
  ];
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    nix-index = {
      enable = true;
      enableBashIntegration = true;
    };
    nix-index-database.comma = {
      enable = true;
    };
  };
  # inherit dotfilesPath;
  home.username = "tkcd";
  home.homeDirectory = "/home/tkcd";
  home.stateVersion = "26.05";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
      waylandFrontend = true;
      settings = {
        globalOptions = {
          Hotkey = {
            EnumerateWithTriggerKeys = true;
            EnumerateSkipFirst = false;
          };
          "Hotkey/TriggerKeys" = {
            "0" = "Control+space";
          };
          Behaviour = {
            ActiveByDefault = false;
          };
        };
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "mozc";
            Layout = "";
          };
          GroupOrder = {
            "0" = "Default";
          };
        };
      };
    };
  };
  cli = {
    enableCore = true;
    enableGit = true;
    enableContainer = true;
    enableMisc = true;
    enableWsl = false;
    enableGcc = false;
    enableClang = true;
    enableRust = true;
    enablePython = true;
    enableGo = true;
    enableNodejs = true;
    enableHaskell = false;
    enableLua = true;
    enableNix = true;
    enableLsp = true;
  };
  dotfiles = {
    shell = "bash";
    enableCargoConfig = true;
  };
  home.packages = llmAgentsPkgs ++ tmuxDeckPkgs ++ gfmPreviewPkgs ++ obfishPkgs;
  home.sessionVariables = {
    EDITOR = "nvim";
    DEFAULT_SHELL = "bash";
    PNPM_HOME = "$HOME/.local/share/pnpm";
  };
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/share/pnpm"
  ];
  # home.sessionVariables = [
  #   PKG_CONFIG
  # ];
  home.activation = {
    gitConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.git}/bin/git config --global include.path "${dotfilesPath}/config/git/gitconfig_shared"
    '';
    tpmGitClone = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "${config.home.homeDirectory}/.tmux/plugins/tpm" ]; then
        ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "${config.home.homeDirectory}/.tmux/plugins/tpm"
      fi
    '';
  };
}
