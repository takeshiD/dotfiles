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
  tmuxdeckPkgs = with inputs.tmux-deck.packages.${pkgs.system}; [
    tmux-deck
  ];
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  imports = [
    ../home/cli.nix
    ../home/common-files.nix
  ];
  home.username = "tkcd";
  home.homeDirectory = "/home/tkcd";
  home.stateVersion = "25.11";
  cli = {
    enableCore = true;
    enableGit = true;
    enableContainer = true;
    enableMisc = true;
    enableWsl = true;
    enableGcc = false;
    enableClang = false;
    enableRust = false;
    enablePython = true;
    enableGo = false;
    enableNodejs = true;
    enableLsp = true;
  };
  dotfiles = {
    shell = "both";
    enableCargoConfig = false;
  };
  home.packages = llmAgentsPkgs ++ tmuxdeckPkgs;
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
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
  # programs = {
  #   home-manager.enable = true;
  #   direnv = {
  #     enable = true;
  #     enableBashIntegration = true;
  #     nix-direnv.enable = true;
  #   };
  # };
}
