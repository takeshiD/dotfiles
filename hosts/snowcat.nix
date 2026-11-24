{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  # Official v0.1.8 public Connect configuration (not credentials).
  # nixpkgs builds omit these defaults; both the CLI and server need them.
  t3ConnectEnvironment = {
    T3CODE_RELAY_URL = "https://relay.t3.codes";
    T3CODE_CLERK_PUBLISHABLE_KEY = "pk_live_Y2xlcmsudDMuY29kZXMk";
    T3CODE_CLERK_CLI_OAUTH_CLIENT_ID = "hzxSgY2cH10sDU2r";
  };
  llmAgentsPkgs = with inputs.llm-agents.packages.${pkgs.system}; [
    claude-code
    codex
    pi
    dsh
    opencode2
  ];
  tmuxDeckPkgs = with inputs.tmux-deck.packages.${pkgs.system}; [
    tmux-deck
  ];
  mdpeekPkgs = with inputs.markdown-peek.packages.${pkgs.system}; [
    markdown-peek
  ];
  pcxPkgs = with inputs.pcx.packages.${pkgs.system}; [
    pcx
  ];
  gfmPreviewPkgs = with inputs.gfm-preview.packages.${pkgs.system}; [
    gh-gfm-preview
  ];
  # baconlsPkgs = with inputs.bacon-ls.packages.${pkgs.system}; [
  #   bacon-ls
  # ];
  obfishPkgs = with inputs.ob-fish.packages.${pkgs.system}; [
    ob-fish-completion
  ];
in
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../home/agent-skills.nix
    ../home/cli.nix
    ../home/common-files.nix
    ../home/pi.nix
    ../home/gui.nix
  ];
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    nix-index = {
      enable = true;
      enableBashIntegration = true;
    };
    nix-index-database.comma = {
      enable = true;
    };
  };
  # inherit dotfilesPath;
  home.username = "tkcd";
  home.homeDirectory = "/home/tkcd";
  home.stateVersion = "26.05";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
      waylandFrontend = true;
      settings = {
        globalOptions = {
          Hotkey = {
            EnumerateWithTriggerKeys = true;
            EnumerateSkipFirst = false;
          };
          "Hotkey/TriggerKeys" = {
            "0" = "Control+space";
          };
          Behaviour = {
            ActiveByDefault = false;
          };
        };
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "mozc";
            Layout = "";
          };
          GroupOrder = {
            "0" = "Default";
          };
        };
      };
    };
  };
  cli = {
    enableCore = true;
    enableGit = true;
    enableContainer = true;
    enableMisc = true;
    enableWsl = false;
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
    # shell = "bash";
    # enableCargoConfig = true;
  };
  dotfiles.pi.enable = true;
  home.packages =
    llmAgentsPkgs
    ++ tmuxDeckPkgs
    ++ mdpeekPkgs
    ++ pcxPkgs
    ++ gfmPreviewPkgs
    ++ obfishPkgs;
  home.sessionVariables = t3ConnectEnvironment // {
    EDITOR = lib.getExe pkgs.neovim;
    SUDO_EDITOR = lib.getExe pkgs.neovim;
    DEFAULT_SHELL = "bash";
    PNPM_HOME = "$HOME/.local/share/pnpm";
    GH_CONFIG_DIR = "$HOME/.config/gh/";
  };
  home.sessionPath = [
    "$HOME/.cargo/bin"
    "$HOME/.local/share/pnpm"
  ];
  # home.sessionVariables = [
  #   PKG_CONFIG
  # ];
  # スマホからは T3 Connect 経由で接続する。
  systemd.user.services.t3code = {
    Unit.Description = "T3 Code server";
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.t3code}/bin/t3 serve --host 127.0.0.1 --port 3773";
      WorkingDirectory = config.home.homeDirectory;
      Environment = [
        ''"GIT_SSH_COMMAND=ssh -F /home/tkcd/.ssh/t3code_config"''
        "PATH=${config.home.homeDirectory}/.nix-profile/bin:${config.home.homeDirectory}/.local/bin:${config.home.homeDirectory}/.cargo/bin:/run/current-system/sw/bin"
        "SHELL=/run/current-system/sw/bin/zsh"
      ]
      ++ lib.mapAttrsToList (name: value: "${name}=${value}") t3ConnectEnvironment;
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 30;
    };
    Install.WantedBy = [ "default.target" ];
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
}
