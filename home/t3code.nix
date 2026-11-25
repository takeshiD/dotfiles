{
  config,
  pkgs,
  lib,
  ...
}:
let
  # Official v0.1.8 public Connect configuration (not credentials).
  # nixpkgs builds omit these defaults; both the CLI and server need them.
  t3ConnectEnvironment = {
    T3CODE_RELAY_URL = "https://relay.t3.codes";
    T3CODE_CLERK_PUBLISHABLE_KEY = "pk_live_Y2xlcmsudDMuY29kZXMk";
    T3CODE_CLERK_CLI_OAUTH_CLIENT_ID = "hzxSgY2cH10sDU2r";
    T3CODE_TELEMETRY_ENABLED = "false";
    T3CODE_OTEL_SDK_DISABLED = "true";
  };
  tunnelConfig = (pkgs.formats.yaml { }).generate "t3code-tunnel.yml" {
    tunnel = "t3code-tunnel";
    credentials-file = "${config.home.homeDirectory}/.cloudflared/t3code-tunnel.json";
    ingress = [
      {
        hostname = "t3code.tkcd.dev";
        service = "http://127.0.0.1:3773";
      }
      { service = "http_status:404"; }
    ];
  };
in
{
  home.sessionVariables = t3ConnectEnvironment;

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

  systemd.user.services.cloudflared-t3code-tunnel = {
    Unit = {
      Description = "Cloudflare Tunnel for T3 Code";
      # Start the server first; keep the tunnel running across server restarts.
      Wants = [ "t3code.service" ];
      After = [ "t3code.service" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --config ${tunnelConfig} --no-autoupdate run";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 30;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
