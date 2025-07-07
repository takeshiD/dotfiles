{ config, pkgs, lib, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
in
{
  # inherit dotfilesPath;
  home.username = "tkcd";
  home.homeDirectory = "/home/tkcd";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    # Editor and Terminal tools
    neovim
    tmux
    starship
    lazygit
    bottom
    lsd
    fzf
    ripgrep
    bat
    delta
    fd
    dust
    duf
    direnv
    # Development Tools
    gcc
    gnumake
    cmake
    clang-tools
    rustup
    uv
    pnpm
    nodejs
    stack
    nixfmt-rfc-style
    # LLM
    claude-code
    # Misc
    tree-sitter
    zip
    unzip
    neofetch
    vhs
    less
  ];
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
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
