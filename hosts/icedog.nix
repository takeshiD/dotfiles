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
    ../home/common-files.nix
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
  cli = {
    enableCore = true;
    enableGit = true;
    enableContainer = true;
    enableMisc = true;
    enableWsl = true;
    enableGcc = false;
    enableClang = true;
    enableRust = true;
    enablePython = true;
    enableGo = true;
    enableNodejs = true;
    enableHaskell = false;
    enableLua = true;
    enableNix = true;
    enableLsp = true;
  };
  dotfiles = {
    shell = "both";
    enableCargoConfig = true;
  };
  home.packages = llmAgentsPkgs ++ tmuxDeckPkgs;
  home.sessionVariables = {
    EDITOR = "nvim";
    DEFAULT_SHELL = "fish";
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
    bashProfile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if [ ! -f "${config.home.homeDirectory}/.bash_profile" ]; then
              cat > "$HOME"/.bash_profile << 'EOF'
      [[ -f ~/.bashrc ]] && source ~/.bashrc
      EOF
            fi
    '';
  };
}
