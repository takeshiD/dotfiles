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
in
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../home/cli.nix
    ../home/gui.nix
  ];
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
  # inherit dotfilesPath;
  home.username = "tkcd";
  home.homeDirectory = "/home/tkcd";
  home.stateVersion = "25.11";
  home.packages = llmAgentsPkgs ++ tmuxDeckPkgs;
  home.file = with config.lib.file; {
    ".bashrc".source = mkOutOfStoreSymlink "${dotfilesPath}/config/bash/.bashrc";
    ".inputrc".source = mkOutOfStoreSymlink "${dotfilesPath}/config/bash/.inputrc";
    ".tmux.conf".source = mkOutOfStoreSymlink "${dotfilesPath}/config/tmux/.tmux.conf";
    ".stack/config.yaml".source = mkOutOfStoreSymlink "${dotfilesPath}/config/stack/config.yaml";
    ".config/nvim".source = mkOutOfStoreSymlink "${dotfilesPath}/config/nvim";
    ".config/lazygit".source = mkOutOfStoreSymlink "${dotfilesPath}/config/lazygit";
    ".config/bottom".source = mkOutOfStoreSymlink "${dotfilesPath}/config/bottom";
    ".config/starship".source = mkOutOfStoreSymlink "${dotfilesPath}/config/starship";
    ".config/lsd".source = mkOutOfStoreSymlink "${dotfilesPath}/config/lsd";
    ".config/clangd".source = mkOutOfStoreSymlink "${dotfilesPath}/config/clangd";
    ".config/fish".source = mkOutOfStoreSymlink "${dotfilesPath}/config/fish";
    ".config/ghostty".source = mkOutOfStoreSymlink "${dotfilesPath}/config/ghostty";
    ".config/wezterm".source = mkOutOfStoreSymlink "${dotfilesPath}/config/wezterm";
    ".config/containers".source = mkOutOfStoreSymlink "${dotfilesPath}/config/containers";
    # ".claude/CLAUDE.md".source = mkOutOfStoreSymlink "${dotfilesPath}/config/claude/CLAUDE.md";
    # ".claude/settings.json".source = mkOutOfStoreSymlink "${dotfilesPath}/config/claude/settings.json";
    # ".codex/AGENTS.md".source = mkOutOfStoreSymlink "${dotfilesPath}/config/codex/AGENTS.md";
  };
  home.sessionVariables = with pkgs; {
    EDITOR = "nvim";
    PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [
      openssl.dev
    ];
  };
  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
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
