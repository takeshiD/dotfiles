# Target OS
- ArchLinux
- Ubuntu22.04
- Ubuntu24.04

# Requirement

- `git`: git

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

### Program Language and Ecosystems

| tool           | description             |
| -----          | ------------            |
| `rustup`       | Rust Toolchain          |
| `uv`           | python project manager  |
| `pnpm`         | node project manager    |
| `clang`        | C, C++ compiler by llvm |
| `clang-format` | C, C++ Formatter        |
| `clangd`       | C, C++ LSP              |
| `cmake`        | cmake                   |
| `gcc`          | C, C++ compiler by gnu  |
| `make`      | make                    |

### Editor and Improve Terminal Environment
| tool       | description         |
| -----      | ------------        |
| `neovim`   | GreatEditor         |
| `tmux`     | TerminalMultiplexer |
| `lazygit`  | GitUI               |
| `starship` | Prompt              |
| `ripgrep`  | Grep                |
| `fzf`      | FuzzyFinder         |
| `lld`      | Alternative `ls`    |
| `bat`      | Alternative `cat`   |
| `delta`    | Alternative `diff`  |
| `fd`       | Alternative `find`  |

### LLM
| tool     | description  |
| -----    | ------------ |
| `claude` | ClaudeCode   |

### Misc
| tool          | description                    |
| -----         | ------------                   |
| `tree-sitter` | Increment Parser for highlight |

## Install tools via `pacman`
### GUI Envionment
| tool  | description  |
| ----- | ------------ |
| ``    | unzip        |
