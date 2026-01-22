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
    docker
    podman
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
  ];
  wslPkgs = with pkgs; [
    wslu
    wl-clipboard
  ];
  devPkgs = with pkgs; [
    gcc
    gnumake
    mold
    cmake
    clang-tools
    rustup
    uv
    pnpm
    nodejs
    go
  ];
  lspPkgs = with pkgs; [
    biome
    astro-language-server
    nixfmt
    lua-language-server
    stylua
    python313Packages.python-lsp-server
    pyright
    ruff
    ty
    bash-language-server
    cmake-language-server
    tailwindcss-language-server
    vscode-langservers-extracted
    markdown-oxide
    taplo
    typescript-language-server
    taplo
    yaml-language-server
    haskell-language-server
    nil
    nixd
  ];
in
{
  home.packages = corePkgs ++ gitPkgs ++ containerPkgs ++ miscPkgs ++ wslPkgs ++ devPkgs ++ lspPkgs;
  home.sessionVariables = with pkgs; {
    EDITOR = "nvim";
    PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [
      openssl.dev
    ];
  };
  home.sessionPath = [
    "$HOME/.cargo/bin"
  ];
}
