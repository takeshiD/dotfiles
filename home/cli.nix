{
  config,
  lib,
  pkgs,
  ...
}:
let
  corePkgs = with pkgs; [
    # bash
    bash-completion
    brush
    fish
    neovim
    # nix-bash-completions
    starship
    tmux
  ];
  gitPkgs = with pkgs; [
    delta
    gh
    ghq
    git
    glab
    lazygit
  ];
  containerPkgs = with pkgs; [
    act
    aws-cdk-cli
    awscli2
    lazydocker
    # podman
    # podman-tui
  ];
  miscPkgs = with pkgs; [
    bat
    bat-extras.batman
    bottom
    cachix
    dig
    direnv
    doggo
    doxx
    duf
    dust
    fd
    figlet
    fzf
    glow
    hexyl
    hyperfine
    imagemagick
    jq
    less
    lsd
    eza
    openssh
    # openssl
    pandoc
    pgcli
    pkg-config
    procs
    rclone
    ripgrep
    smem
    sysstat
    tokei
    tree-sitter
    unzip
    vhs
    xleak
    zip
    zk
    zoxide
    binwalk
    file
    coreutils
    vega-lite
    vega-cli
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
    cargo-nextest
    bacon
    cargo-deny
    cargo-edit
    cargo-expand
    sccache
    cargo-bloat
    cargo-binstall
  ];
  pythonPkgs = with pkgs; [
    uv
    python313Packages.python-lsp-server
    ruff
    mypy
    pyright
    ty
    zuban
    pyrefly
  ];
  goPkgs = with pkgs; [
    go
    gopls
    golangci-lint
    golangci-lint-langserver
    go-tools
  ];
  nodePkgs = with pkgs; [
    typescript-language-server
    eslint
    biome
    pnpm
    nodejs
    bun
    deno
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
    tombi
    yaml-language-server
    cmake-language-server
    neocmakelsp
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
    ++ lib.optionals config.cli.enableHaskell haskellPkgs
    ++ lib.optionals config.cli.enableLua luaPkgs
    ++ lib.optionals config.cli.enableNix nixPkgs
    ++ lib.optionals config.cli.enableLsp lspPkgs;
}
