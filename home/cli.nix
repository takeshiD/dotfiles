{ pkgs, ... }:
let
  core = with pkgs; [
    neovim
    tmux
    bash
    fish
    starship
    bash-completion
    nix-bash-completions
  ];
  git = with pkgs; [
    git
    lazygit
    gh
    glab
    delta
  ];
  container = with pkgs; [
    docker
    podman
    act
    awscli2
    aws-cdk-cli
  ];
  misc = with pkgs; [
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
  ];
  wsl = with pkgs; [
    wslu
    wl-clipboard
  ];
  development = with pkgs; [
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
  lsp = with pkgs; [
    biome
    astro-language-server
    nixfmt-rfc-style
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
    nil
    taplo
    yaml-language-server
    haskell-language-server
    nixd
  ];
in
{
  home.packages = core ++ git ++ misc ++ wsl ++ development ++ lsp;
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
