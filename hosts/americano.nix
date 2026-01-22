{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  llmAgentsPkgs = with inputs.llm-agents.packages.${pkgs.system}; [
    claude-code
    codex
  ];
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  home.username = "tkcd";
  home.homeDirectory = "/home/tkcd";
  home.stateVersion = "25.11";
  home.packages =
    with pkgs;
    [
      # Editor and Terminal tools
      neovim
      tmux
      bash
      fish
      bash-completion
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
      zoxide
      gh
      glab
      tokei
      hexyl
      procs
      smem
      hyperfine
      vhs
      # Development Tools
      # gcc
      # gnumake
      # mold
      # cmake
      # clang
      # clang-tools
      # rustup
      uv
      # pnpm
      # nodejs
      # go
      nixfmt
      lua-language-server
      stylua
      python313Packages.python-lsp-server
      pyright
      ruff
      ty
      bash-language-server
      # cmake-language-server
      # tailwindcss-language-server
      vscode-langservers-extracted
      markdown-oxide
      taplo
      # typescript-language-server
      nil
      taplo
      # cmake-language-server
      yaml-language-server
      # haskell-language-server
      nixd
      # LLM
      # claude-code   # install via pnpm
      # codex         # install via pnpm
      # Misc
      tree-sitter
      zip
      unzip
      less
      openssh
      # openssl
      # pkg-config
      # hackgen-nf-font
      # pandoc
      jq
      sysstat
      nix-bash-completions
      # doxx
      # xleak
      zk
      wl-clipboard
      # imagemagick
      # glow
      wslu
      figlet
      act
      # podman        # via pacman
      awscli2
      aws-cdk-cli
      # biome
      # astro-language-server
      # ghostty
      # google-chrome
      # cachix
    ]
    ++ llmAgentsPkgs;
  home.file = with config.lib.file; {
    ".bashrc".source = mkOutOfStoreSymlink "${dotfilesPath}/config/bash/.bashrc";
    ".inputrc".source = mkOutOfStoreSymlink "${dotfilesPath}/config/bash/.inputrc";
    ".tmux.conf".source = mkOutOfStoreSymlink "${dotfilesPath}/config/tmux/.tmux.conf";
    ".stack/config.yaml".source = mkOutOfStoreSymlink "${dotfilesPath}/config/stack/config.yaml";
    ".claude/CLAUDE.md".source = mkOutOfStoreSymlink "${dotfilesPath}/config/claude/CLAUDE.md";
    ".claude/settings.json".source = mkOutOfStoreSymlink "${dotfilesPath}/config/claude/settings.json";
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
    ".codex/AGENTS.md".source = mkOutOfStoreSymlink "${dotfilesPath}/config/codex/AGENTS.md";
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
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
