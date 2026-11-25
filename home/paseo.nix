{
  config,
  inputs,
  pkgs,
  ...
}:
let
  paseo = inputs.llm-agents.packages.${pkgs.system}.paseo;
  tunnelConfig = pkgs.writeText "paseo-cloudflared.json" (
    builtins.toJSON {
      tunnel = "paseo-tunnel";
      credentials-file = "${config.home.homeDirectory}/.cloudflared/paseo-tunnel.json";
      ingress = [
        {
          hostname = "paseo.tkcd.dev";
          service = "http://127.0.0.1:6767";
        }
        { service = "http_status:404"; }
      ];
    }
  );
  startPaseo = pkgs.writeShellScript "start-paseo" ''
    if [ -z "''${PASEO_PASSWORD:-}" ]; then
      echo "Set PASEO_PASSWORD in ~/.config/paseo/daemon.env before starting Paseo." >&2
      exit 1
    fi
    exec ${paseo}/bin/paseo daemon run
  '';
in
{
  home.packages = [ paseo ];
  systemd.user.services.paseo = {
    Unit.Description = "Paseo headless daemon and web UI";
    Service = {
      Type = "simple";
      ExecStart = "${startPaseo}";
      WorkingDirectory = config.home.homeDirectory;
      EnvironmentFile = "%h/.config/paseo/daemon.env";
      Environment = [
        "PASEO_HOME=${config.home.homeDirectory}/.paseo"
        "PASEO_LISTEN=127.0.0.1:6767"
        "PASEO_HOSTNAMES=paseo.tkcd.dev"
        "PASEO_WEB_UI_ENABLED=true"
        "PASEO_RELAY_ENABLED=false"
        "PATH=${config.home.homeDirectory}/.nix-profile/bin:${config.home.homeDirectory}/.local/bin:${config.home.homeDirectory}/.cargo/bin:/run/current-system/sw/bin"
        "SHELL=/run/current-system/sw/bin/zsh"
      ];
      UMask = "0077";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 30;
    };
    Install.WantedBy = [ "default.target" ];
  };
  systemd.user.services.cloudflared-paseo = {
    Unit = {
      Description = "Cloudflare Tunnel for Paseo";
      After = [ "paseo.service" ];
      Wants = [ "paseo.service" ];
    };
    Service = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --config=${tunnelConfig} --no-autoupdate run";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
