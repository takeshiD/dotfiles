# Target OS
- ArchLinux

# Requirement
- `git`

# Installation

You have to run `install.sh` twice for applying configuration and installaion.

```
$ cd ~
$ git clone https://github.com/takeshiD/dotfiles.git
$ cd dotfiles
$ ./install
[INFO] 🚀 Setting up development environment with flakes...
[INFO] 📦 Installing Nix...
...
[SUCCESS] ❄  Nix install is success! Please restart shell, due to nix will be enabled.
# restart shell

$ cd dotfiles
$ ./install
[INFO] ❄  Installed Nix
[INFO] 📦 Installing home-manager...
...
[SUCCESS] 🏠 home-manager install is success!
[INFO] ⚙️ Applying home-manager configuration...
...
Starting Home Manager activation
...
[SUCCESS] ✅ Setup completed! Please restart your shell.
```

# Update and Add packages
After you edit `home.nix` or `flake.nix` and more `.nix` files, please run `install.sh` to apply changed configuration.

```bash
$ ./install.sh
```
