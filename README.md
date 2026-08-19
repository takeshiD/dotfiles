<h1 align="center">tkcd dotfiles</h1>

Personal dotfiles managed with [Nix Flakes](https://nixos.wiki/wiki/Flakes) and [home-manager](https://github.com/nix-community/home-manager).

## Machines

| Host           | Env    | OS          | GUI   | IME         | Description  |
| ------         | ----   | -----       | ----- | ----        | -----        |
| ❄ tkcd@snowcat | Native | NixOS       | GNOME | fcitx5-mozc | main desktop |
| ☕︎ tkcd@doppio | Native | Ubuntu24.04 | GNOME | fcitx5-mozc | main laptop  |

## Directory Structure

```
dotfiles/
├── flake.nix                   # Entry point (NixOS + Home Manager)
├── hosts/
│   ├── dev-laptop.nix          # Personal laptop (NixOS + GNOME + GUI apps)
│   └── company-laptop.nix      # Company laptop (WSL2, CLI focused)
├── home/
│   └── cli.nix                 # Shared CLI packages (optional)
├── nixos/
│   ├── configuration.nix       # NixOS system config (GNOME, fcitx5, etc.)
│   └── hardware-configuration.nix
├── config/                     # Application configs (symlinked)
│   ├── bash/
│   ├── fish/
│   ├── nvim/
│   ├── tmux/
│   ├── lazygit/
│   ├── starship/
│   ├── ghostty/
│   ├── wezterm/
│   ├── claude/
│   └── ...
└── install.sh                  # Initial setup script
```

## Requirements

- `git`
- `curl` (for Nix installation)

## Installation

### Fresh Install (Non-NixOS)

Run `install.sh` twice - first to install Nix, then to apply configuration:

```bash
cd ~
git clone https://github.com/takeshiD/dotfiles.git
cd dotfiles
./install.sh
# Restart shell after Nix installation
./install.sh
```

### NixOS

```bash
cd ~/dotfiles
sudo nixos-rebuild switch --flake .#dev-laptop
```

## Usage

### Apply home-manager Configuration

```bash
# main desktop
home-manager switch --flake .#tkcd@snowcat

# main laptop
home-manager switch --flake .#tkcd@doppio

# any other machine (user and home directory taken from the environment)
home-manager switch --flake .#local --impure
```

### The `local` Configuration

`.#local` is for machines whose account name or hostname must not be recorded
in this public repository - for example a work machine where the login name
contains a real name or an employer domain.

Such values cannot be hidden by encryption, because Nix needs them at
evaluation time. So they are not written down at all: `.#local` reads them from
the environment instead.

```nix
home.username = requireEnv "USER";
home.homeDirectory = requireEnv "HOME";
```

Notes:

- `--impure` is required. Flakes block environment variables during pure
  evaluation, and without it the run stops with an explicit error message.
- `.#local` builds on `hosts/doppio.nix`. Its `home.username` and
  `home.homeDirectory` are declared with `lib.mkDefault`, so `.#local`
  overrides them.
- `dotfiles.path` follows `$HOME/dotfiles`. Clone this repository to
  `~/dotfiles` on those machines as usual, since the `config/` files are
  symlinked from there.
- Machine specific settings, if any are ever needed, belong outside this
  repository. Keep `.#local` free of them.

### Apply NixOS Configuration

```bash
sudo nixos-rebuild switch --flake .#dev-laptop
```

### Update Flake Inputs

```bash
nix flake update
```

## Adding Packages

1. Edit the appropriate host file in `hosts/`:
   - `hosts/dev-laptop.nix` for personal laptop
   - `hosts/company-laptop.nix` for company laptop

2. Add packages to `home.packages`:
   ```nix
   home.packages = with pkgs; [
     # Add your package here
     newpackage
   ];
   ```

3. Apply changes:
   ```bash
   home-manager switch --flake .#tkcd@dev-laptop
   ```

## Adding Application Configs

1. Add config files to `config/<app-name>/`

2. Add symlink in host file:
   ```nix
   home.file = with config.lib.file; {
     ".config/<app-name>".source = mkOutOfStoreSymlink "${dotfilesPath}/config/<app-name>";
   };
   ```

## Key Features

- **Nix Flakes**: Reproducible builds with locked dependencies
- **home-manager**: Declarative user environment management
- **Symlinked configs**: Edit configs directly without rebuild
- **Multi-host support**: Different configurations per machine
