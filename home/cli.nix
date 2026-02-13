{ pkgs, inputs, ... }:
let
  corePkgs = with pkgs; [
    neovim
    tmux
    bash
    fish
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
  lspPkgs = with pkgs; [
    astro-language-server
    lua-language-server
    stylua
    bash-language-server
    tailwindcss-language-server
    vscode-langservers-extracted
    markdown-oxide
    taplo
    yaml-language-server
    haskell-language-server
    nil
    nixd
    nixfmt
  ];
in
{
  home.packages =
    corePkgs
    ++ gitPkgs
    ++ containerPkgs
    ++ miscPkgs
    ++ wslPkgs
    # ++ gccPkgs
    # ++ clangPkgs
    # ++ rustPkgs
    ++ pythonPkgs
    ++ goPkgs
    ++ nodePkgs
    ++ lspPkgs;
  home.sessionVariables = with pkgs; {
    EDITOR = "nvim";
    # PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [
    #   openssl.dev
    # ];
  };
  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}
