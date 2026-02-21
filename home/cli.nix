{ config, lib, pkgs, ... }:
let
  corePkgs = with pkgs; [
    neovim
    tmux
    bash
    fish
    brush
    starship
    bash-completion
    nix-bash-completions
  ];
  gitPkgs = with pkgs; [
    git
    lazygit
    gh
    ghq
    glab
    delta
  ];
  containerPkgs = with pkgs; [
    # docker
    lazydocker
    # podman
    # podman-tui
    act
    awscli2
    aws-cdk-cli
  ];
  miscPkgs = with pkgs; [
    ripgrep
    bat
    fd
    dust
    duf
    direnv
    zoxide
    tokei
    hexyl
    procs
    smem
    hyperfine
    vhs
    tree-sitter
    zip
    unzip
    less
    openssh
    openssl
    pkg-config
    pandoc
    jq
    sysstat
    doxx
    xleak
    zk
    glow
    figlet
    imagemagick
    fzf
    bottom
    lsd
    cachix
    rclone
  ];
  wslPkgs = with pkgs; [
    wslu
    wl-clipboard
  ];
  gccPkgs = with pkgs; [
    gcc
    gnumake
    pkg-config
    cmake
    mold
    cmake-language-server
  ];
  clangPkgs = with pkgs; [
    clang
    clang-tools
    pkg-config
    gnumake
    cmake
    mold
    cmake-language-server
  ];
  rustPkgs = with pkgs; [
    rustup
  ];
  pythonPkgs = with pkgs; [
    uv
    python313Packages.python-lsp-server
    pyright
    ruff
    ty
  ];
  goPkgs = with pkgs; [
    go
  ];
  nodePkgs = with pkgs; [
    typescript-language-server
    biome
    pnpm
    nodejs
  ];
  haskellPkgs = with pkgs; [
    haskellPackages.ghcup
    haskellPackages.haskell-language-server
  ];
  luaPkgs = with pkgs; [
    lua-language-server
    stylua
  ];
  nixPkgs = with pkgs; [
    # nil
    nixd
    nixfmt
  ];
  lspPkgs = with pkgs; [
    astro-language-server
    bash-language-server
    tailwindcss-language-server
    vscode-langservers-extracted
    markdown-oxide
    taplo
    yaml-language-server
  ];
in
{
  imports = [
    ../modules/cli-options.nix
  ];

  home.packages =
    lib.optionals config.cli.enableCore corePkgs
    ++ lib.optionals config.cli.enableGit gitPkgs
    ++ lib.optionals config.cli.enableContainer containerPkgs
    ++ lib.optionals config.cli.enableMisc miscPkgs
    ++ lib.optionals config.cli.enableWsl wslPkgs
    ++ lib.optionals config.cli.enableGcc gccPkgs
    ++ lib.optionals config.cli.enableClang clangPkgs
    ++ lib.optionals config.cli.enableRust rustPkgs
    ++ lib.optionals config.cli.enablePython pythonPkgs
    ++ lib.optionals config.cli.enableGo goPkgs
    ++ lib.optionals config.cli.enableNodejs nodePkgs
    ++ lib.optionals config.cli.enableLsp lspPkgs;
}
