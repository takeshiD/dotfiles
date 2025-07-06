{ config, pkgs, ... }:
{
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
    nixfmt-rfc-style
    # LLM
    claude-code
    # Misc
    tree-sitter
    zip
    unzip
  ];
  home.file = {
    ".bashrc".source = config.lib.file.mkOutOfStoreSymlink config/bash/.bashrc;
    ".inputrc".source = config.lib.file.mkOutOfStoreSymlink config/bash/.inputrc;
    ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink config/git/.gitconfig;
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink config/tmux/.tmux.conf;
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink config/nvim;
    ".config/lazygit".source = config.lib.file.mkOutOfStoreSymlink config/lazygit;
    ".config/bottom".source = config.lib.file.mkOutOfStoreSymlink config/bottom;
    ".config/starship".source = config.lib.file.mkOutOfStoreSymlink config/starship;
    ".config/lsd".source = config.lib.file.mkOutOfStoreSymlink config/lsd;
    ".config/clangd".source = config.lib.file.mkOutOfStoreSymlink config/clangd;
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
