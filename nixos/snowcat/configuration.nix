{
  config,
  pkgs,
  ioskeley-mono-jp,
  ...
}:
{
  nix.settings = {
    trusted-users = [
      "root"
      "tkcd"
    ];
    substituters = [
      "https://cache.numtide.com"
      "https://ros.cachix.org"
      "https://takeshid.cachix.org"
    ];
    trusted-substituters = [
      "https://ros.cachix.org"
      "https://takeshid.cachix.org"
    ];
    trusted-public-keys = [
      "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "takeshid.cachix.org-1:2GsGTUZ3djVzbGzXgeia+SRV1ZJYOXySHyNfBPsEjRA="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "snowcat"; # Define your hostname.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
      options = "ctrl:nocaps";
    };
    autoRepeatDelay = 192;
    autoRepeatInterval = 16;
  };
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome = {
    core-apps.enable = true;
    core-developer-tools.enable = true;
    games.enable = false;
  };
  services.libinput = {
    enable = true;
    touchpad = {
      scrollMethod = "edge";
      naturalScrolling = true;
      disableWhileTyping = true;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.thermald.enable = true;
  services.power-profiles-daemon.enable = true;
  services.tlp = {
    enable = false;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Energy Perfomance Preference
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # CPU Boost
      CPU_BOOST_ON_AC = 0;
      CPU_BOOST_ON_BAT = 0;

      # USB Device auto suspend
      USB_AUTOSUSPEND = 1;

      # Wifi power save
      WIFI_PWR_ON_BAT = "on";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 0; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 95; # 80 and above it stops charging

    };
  };
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    loadModels = [
      "gemma3:27b"
      "gemma4:e4b"
      "gemma4:12b"
      "gemma4:26b"
      "qwen3.5:9b"
      "qwen3.5:27b"
      "qwen3.6:27b"
      "qwen3.6:27b"
    ];
  };
  services.resolved.enable = true;
  services.tailscale.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  ###################################################
  # Power Management and Behaviour closing the lid. #
  # > see https://wiki.nixos.org/wiki/Laptop        #
  ###################################################
  services.logind.settings.Login = {
    # "ignore": no action
    # "poweroff": shutdown os and turn off
    # "halt": shutdown os and NOT turn off
    # "reboot": reboot os and NOT turn off
    # "kexec": ?
    # "suspend": NOT turn off RAM, turn off CPUoption
    # "hibernate": Save RAM data to swap partition, turn off
    # "hybrid-sleep": first suspend,
    # "suspend-then-hibernate": closing the lid and suspend, spent few minutes and hybernate
    # "lock": screen lock only
    # Battely supply
    # HandleLidSwitch = "suspend-then-hibernate";
    IdleAction = "ignore";
    HandleLidSwitch = "ignore";
    # Power is connected
    HandleLidSwitchExternalPower = "ignore";
    # Another screen is connected(cram shell)
    HandleLidSwitchDocked = "ignore";
  };
  powerManagement.powertop.enable = true;
  systemd.sleep.settings.Sleep = {
    AllowSuspend = false;
    AllowHibernation = false;
    AllowHybridSleep = false;
    AllowSuspendThenHibernate = false;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tkcd = {
    isNormalUser = true;
    description = "tkcd";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = [ ];
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    neovim
    git
    pgcli
    powertop
    wirelesstools
    iw
    iwd
    nixos-container
    usbutils
    pciutils
    (ollama.override {
      acceleration = "cuda";
    })
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };
  virtualisation.docker = {
    enable = true;
  };
  fonts = {
    packages =
      with pkgs;
      [
        hackgen-nf-font
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        fira-code
        fira-code-symbols
        dina-font
        proggyfonts
        udev-gothic-nf
        font-awesome
        cantarell-fonts
      ]
      ++ [ ioskeley-mono-jp.packages.${pkgs.system}.default ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "UDEV Gothic 35NF" ];
        sansSerif = [
          "Noto Sans CJK JP"
          "DejaVu Sans"
        ];
        serif = [
          "Noto Serif JP"
          "DejaVu Serif"
        ];
      };
      subpixel = {
        lcdfilter = "light";
      };
    };
  };
  programs.nix-ld.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?
  services.jupyterhub = {
    enable = false;
    host = "0.0.0.0";
    port = 9999;
    kernels = {
      python3 =
        let
          env = (
            pkgs.python3.withPackages (
              pythonPackages: with pythonPackages; [
                ipykernel
                pandas
                scikit-learn
                scikit-image
                ipympl
                plotly
                ipywidgets
                numpy
                matplotlib
                torch-bin
                torchvision-bin
                pyvista
                vtk

              ]
            )
          );
        in
        {
          displayName = "Python 3 for machine learning";
          argv = [
            "${env.interpreter}"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
          language = "python";
          logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
          logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
        };
    };
    extraConfig = ''
      c.Authenticator.allowed_users = {"tkcd"}
      c.Authenticator.admin_users = {"tkcd"}

      import os, pwd, json

      BASE = "/var/lib/jupyterhub/users"

      # ノートブックのルート({username}はJupyterHubが展開)
      c.Spawner.notebook_dir = BASE + "/{username}/notebooks"

      def pre_spawn_hook(spawner):
          name = spawner.user.name
          uid = pwd.getpwnam(name).pw_uid
          gid = pwd.getpwnam(name).pw_gid
          root = os.path.join(BASE, name)

          for sub in ("notebooks", "data", "config", "lab-settings", "workspaces"):
              d = os.path.join(root, sub)
              os.makedirs(d, exist_ok=True)
              os.chown(d, uid, gid)
          os.chown(root, uid, gid)

          # ~/.jupyter や ~/.local/share/jupyter を使わせない
          spawner.environment.update({
              "JUPYTER_DATA_DIR": f"{root}/data",
              "JUPYTER_CONFIG_DIR": f"{root}/config",
              "JUPYTERLAB_SETTINGS_DIR": f"{root}/lab-settings",
              "JUPYTERLAB_WORKSPACES_DIR": f"{root}/workspaces",
          })

      c.Spawner.pre_spawn_hook = pre_spawn_hook
        '';
  };
}
