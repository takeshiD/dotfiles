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

### Agent Skills

[agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix) is configured
for both hosts (and `local`) in `home/agent-skills.nix`. The 32 standalone skills
are selected explicitly from Matt Pocock, Vercel, ibelick, gfargo,
UI UX Pro Max, and the existing Herdr input. `resolving-merge-conflicts` uses
a separate historical Matt Pocock input because it was removed upstream.

Home Manager links skills into `~/.agents/skills` (read directly by Codex) and
`~/.claude/skills`. It does not install duplicate copies into `~/.codex/skills`.
The Claude destination is fixed and does not follow `CLAUDE_CONFIG_DIR`.
App-managed skills remain separate: Codex system/plugin skills, Claude synced
skills, and Collie's generated `collie-walky-talky` are not taken over.

For the initial migration of an existing installation, run on each machine:

```bash
bash scripts/migrate-agent-skills.sh tkcd@snowcat
# On doppio:
bash scripts/migrate-agent-skills.sh tkcd@doppio
```

The script builds the configuration first, backs up selected skills (both
resolved content and original links) under
`~/.local/state/dotfiles/skills-backups/`, then activates Home Manager.
After successful verification it removes the migrated entries from the old
Skills CLI lock file. Other installed skills are left alone. Backups also
preserve local edits and older versions; the active versions come from the
pinned Nix inputs. Subsequent updates use normal `home-manager switch`.

To add skills, first add a source input to `flake.nix`, for example:

```nix
anthropic-skills = {
  url = "github:anthropics/skills";
  flake = false;
};
```

Then add the source and selection settings in `home/agent-skills.nix`:

```nix
sources.anthropic = {
  input = "anthropic-skills";
  subdir = "skills";
};
skills.explicit.frontend-design = {
  from = "anthropic";
  path = "frontend-design";
};
```

Run `nix flake lock`, then apply the appropriate Home Manager configuration
on each machine using the commands above. To update the integration itself,
run `nix flake update agent-skills`. To update the Matt Pocock skills,
run `nix flake update mattpocock-skills`.

### Pi Extensions

[Pi](https://pi.dev) extensions are managed by `home/pi.nix`.

- First-party extensions live in `config/pi/extensions/` and are linked into
  `~/.pi/agent/extensions/`. They are symlinked to the working tree, so edits
  apply with `/reload` without a `home-manager switch`.
- Third-party packages (extensions plus their skills and prompts) are declared
  in `dotfiles.pi.packages` and built in `pkgs/`. `pkgs/pi-subagents` builds
  the published npm tarball with `buildNpmPackage` and exposes the package
  root as `passthru.piPackage`.

On activation, `dotfiles.pi.packages` is written to the `packages` array in
`~/.pi/agent/settings.json`. That array is owned by Nix: packages added with
`pi install` are replaced on the next switch, so add them to
`dotfiles.pi.packages` instead. Recorded credentials, sessions, models, and
other settings are left untouched.

To update a package, bump `version` in its `pkgs/<name>/default.nix` and refresh
both hashes. For `pkgs/pi-subagents`:

```bash
cd ~/dotfiles/pkgs/pi-subagents
# 1. rebuild the lockfile from the new tarball (npm install in a scratch dir)
# 2. nix store prefetch-file --hash-type sha256 "<tarball url>"
# 3. nix run nixpkgs#prefetch-npm-deps -- package-lock.json
nix build ~/dotfiles#pi-subagents
```

To add another package, create `pkgs/<name>/default.nix` that builds it with
`buildNpmPackage` and sets
`passthru.piPackage = "${finalAttrs.finalPackage}/lib/node_modules/<name>"`,
add it to the `default` list of `dotfiles.pi.packages`, and apply the
configuration.

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
- Some tools behave differently under `.#local` via
  `dotfiles.enableLocalOverrides`:
  - tmux: `config/tmux/local.conf` is symlinked to `~/.config/tmux/local.conf`,
    which `.tmux.conf` sources to switch the prefix back to `Ctrl+b` and set
    the tmux2k theme to `duo`.
  - tmux-deck: `~/.config/tmux-deck/config.toml` points at
    `config/tmux-deck/config.local.toml` (gruvbox theme) instead of
    `config/tmux-deck/config.toml`.
  - starship: `~/.config/starship/starship.toml` points at
    `config/starship/gruvbox.toml` instead of `config/starship/starship.toml`.

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

### Paseo on snowcat

Paseo and its dedicated Cloudflare Tunnel run as systemd user services, alongside
T3 Code. Open https://paseo.tkcd.dev (T3 remains at https://t3code.tkcd.dev).
The daemon binds to `127.0.0.1:6767`, serves the bundled web UI, and requires
a password. The Paseo relay is disabled.

`home/paseo.nix` uses the CLI package from the pinned `llm-agents` input
(0.17.4, the npm `latest` release when installed). Updates are deliberate:

```bash
nix flake update llm-agents
home-manager switch --flake .#tkcd@snowcat
systemctl --user restart paseo
```

This updates the other packages provided by that input too.

The login password is the value after `PASEO_PASSWORD=` in
`~/.config/paseo/daemon.env`. View it locally:

```bash
cat ~/.config/paseo/daemon.env
```

Keep this file private (mode 600), outside Git and the Nix store. To change the
password, edit this file and run `systemctl --user restart paseo`.
The service refuses to start if the password is missing or empty.

```bash
systemctl --user status paseo cloudflared-paseo
journalctl --user -u paseo -f
```

State and worktrees live under `~/.paseo`. Agent CLIs use the existing user's
credentials. For authenticated CLI commands in a shell:

```bash
set -a
. ~/.config/paseo/daemon.env
set +a
paseo ls
unset PASEO_PASSWORD
```

The dedicated `paseo-tunnel` uses
`~/.cloudflared/paseo-tunnel.json` and the DNS route `paseo.tkcd.dev`.
These credentials are not managed by Nix. On a fresh machine, restore the
private password and tunnel credentials before activating Home Manager.
Enable user lingering (`sudo loginctl enable-linger tkcd`) to start at boot
and continue after logout; it is already enabled on snowcat.

References: [Paseo web UI](https://paseo.sh/docs/web-ui),
[Cloudflare Tunnel configuration](https://developers.cloudflare.com/cloudflare-one/networks/connectors/cloudflare-tunnel/do-more-with-tunnels/local-management/configuration-file/).
