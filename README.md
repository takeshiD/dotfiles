# Target OS
- ArchLinux
- Ubuntu22.04
- Ubuntu24.04

# Requirement

- `git`: git
- `mise`: Runtime manager
- `dotbot`: dotfiles symbolic link manager

# Installation

## Install `git` and `curl`

- Arch Linux
```
$ sudo pacman -Syu git curl
```

- Ubuntu
```
$ sudo apt install git curl
```

## Install `mise`
```
$ curl https://mise.run | sh
```

## Install tools via `mise`

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
