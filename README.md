<h1 align="center">tkcd dotfiles</h1>

Personal dotfiles managed with [Nix Flakes](https://nixos.wiki/wiki/Flakes) and [home-manager](https://github.com/nix-community/home-manager).

## Machines

| Host              | Env    | OS          | GUI   | IME         | Description    |
| ------            | ----   | -----       | ----- | ----        | -----          |
| ❄  tkcd@snowcat   | Native | NixOS       | GNOME | fcitx5-mozc | main laptop    |
| ❄  tkcd@icedog    | WSL2   | NixOS       | -     | Windows IME | main desktop   |
| ☕︎ tkcd@doppio    | Native | Arch Linux  | GNOME | fcitx5-mozc | sub laptop     |
| ☕︎ tkcd@americano | WSL2   | Arch Linux  | -     | Windows IME | company laptop |
| ☕︎ tkcd@espresso  | WSL2   | Arch Linux  | -     | Windows IME | main desktop   |
| ☕︎ tkcd@cafelatte | WSL2   | Ubuntu24.02 | -     | Windows IME | main desktop   |

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
# Personal laptop
home-manager switch --flake .#tkcd@dev-laptop

# Company laptop
home-manager switch --flake .#tkcd@company-laptop
```

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
