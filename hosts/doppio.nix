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
  ];
  tmuxDeckPkgs = with inputs.tmux-deck.packages.${pkgs.system}; [
    tmux-deck
  ];
  mdpeekPkgs = with inputs.markdown-peek.packages.${pkgs.system}; [
    markdown-peek
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
  markdowReaderPkgs = with inputs.markdown-tui-explorer.packages.${pkgs.system}; [
    markdown-reader
  ];
in
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../home/cli.nix
    ../home/common-files.nix
    # ../home/gui.nix
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
  cli = {
    enableCore = true;
    enableGit = true;
    enableContainer = true;
    enableMisc = true;
    enableWsl = false;
    enableGcc = false;
    enableClang = false;
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
    shell = "both";
    enableCargoConfig = true;
  };
  home.username = "tkcd";
  home.homeDirectory = "/home/tkcd";
  home.stateVersion = "25.11";
  home.packages = llmAgentsPkgs ++ tmuxDeckPkgs ++ gfmPreviewPkgs ++ obfishPkgs ++ markdowReaderPkgs ++ mdpeekPkgs;
  home.sessionVariables = {
    EDITOR = "nvim";
    DEFAULT_SHELL = "bash";
    # DEFAULT_SHELL = "fish";
    PNPM_HOME = "$HOME/.local/share/pnpm";
    GH_CONFIG_DIR = "$HOME/.config/gh/";
  };
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/share/pnpm"
  ];
  home.keyboard = {
    layout = "us";
    variant = "";
    options = [ "ctrl:nocaps" ];
  };
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "ctrl:nocaps" ];
    };
  };
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
  news.display = "silent";
}
