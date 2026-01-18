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


# tkcd Nix Environment
| Host          | Name    | OS              | GUI     | IME         |
| ------------- | ------  | -----           | ------- | ----        |
| tkcd          | Desktop | WSL2 Arch Linux | -       | GoogleIME   |
| tkcd          | Laptop  | Arch Linux      | GNOME   | fcitx5-mocz |
| tkcd          | Laptop  | NixOS           | GNOME   | fcitx5-mocz |
| Company       | Laptop  | WSL2 Arch Linux | -       | GoogleIME   |
| -             | Docker  | NixOS           | -       | -           |


# dotfiles 複数環境対応計画

## 概要

NixOS、home-manager、将来のmacOS (nix-darwin)に対応した、ホストの追加・削除が容易なdotfiles構成への移行。

## 推奨ディレクトリ構成

```
dotfiles/
├── flake.nix                      # エントリポイント（ホスト定義）
├── lib/
│   └── default.nix                # mkNixosHost, mkHomeConfiguration等
│
├── modules/
│   ├── home/                      # home-managerモジュール
│   │   ├── core/                  # 全環境共通（shell, editor, git, dev-tools）
│   │   ├── development/           # 開発ツール（rust, nodejs, python, lsp）
│   │   ├── desktop/               # GUI環境（terminal, browser, fonts）
│   │   └── wsl/                   # WSL固有（wslu等）
│   │
│   └── nixos/                     # NixOSモジュール
│       ├── core/                  # 必須設定（nix, locale, users）
│       └── desktop/               # デスクトップ（gnome, sound, ime）
│
├── hosts/                         # ホスト固有設定
│   ├── tkcd-desktop/              # WSL2 (CLI)
│   │   └── home.nix
│   ├── tkcd-laptop-arch/          # Arch + GNOME
│   │   └── home.nix
│   ├── tkcd-laptop-nixos/         # NixOS + GNOME
│   │   ├── default.nix
│   │   ├── home.nix
│   │   └── hardware-configuration.nix
│   ├── company-laptop/            # WSL2 (CLI)
│   │   └── home.nix
│   └── docker/                    # Docker NixOS
│       ├── default.nix
│       └── home.nix
│
├── overlays/                      # パッケージオーバーレイ
│   └── default.nix
│
└── config/                        # 設定ファイル（既存維持）
```

## flake.nix設計

ホストをデータとして定義し、ヘルパー関数で設定を生成:

```nix
hosts = {
  tkcd-laptop-nixos = {
    system = "x86_64-linux";
    type = "nixos";           # または "home-manager"
    username = "tkcd";
    modules = {
      nixos = [ "core" "desktop" ];
      home = [ "core" "development" "desktop" ];
    };
  };
  tkcd-desktop = {
    system = "x86_64-linux";
    type = "home-manager";
    username = "tkcd";
    modules.home = [ "core" "development" "wsl" ];
  };
  # ...
};
```

## 新しいホストの追加手順

1. `hosts/new-host/` フォルダを作成
2. `home.nix`（全ホスト）と `default.nix`（NixOSのみ）を作成
3. `flake.nix`の`hosts`定義に追加
4. `home-manager switch --flake .#username` または `nixos-rebuild switch --flake .#hostname`

## モジュール分割方針

| モジュール | 内容 | 対象ホスト |
|-----------|------|----------|
| `home/core` | fish, bash, neovim, tmux, git, ripgrep等 | 全環境 |
| `home/development` | rustup, nodejs, python, LSP群 | 全環境 |
| `home/desktop` | ghostty, wezterm, chrome, fonts | GUI環境 |
| `home/wsl` | wslu, clipboard統合 | WSL環境 |
| `nixos/core` | nix設定, locale, users | NixOS |
| `nixos/desktop` | GNOME, pipewire, fcitx5 | NixOS GUI |

## 実装ステップ

### Phase 1: 基盤作成
- [ ] `lib/default.nix`にヘルパー関数を実装
- [ ] `modules/`ディレクトリ構造を作成
- [ ] `overlays/default.nix`を作成

### Phase 2: home-managerモジュール分割
- [ ] 現在の`home.nix`を`modules/home/core/`に分割
- [ ] GUI専用設定を`modules/home/desktop/`に移動
- [ ] 開発ツールを`modules/home/development/`に整理
- [ ] WSL設定を`modules/home/wsl/`に作成

### Phase 3: NixOSモジュール分割
- [ ] `nixos/configuration.nix`を`modules/nixos/core/`に分割
- [ ] GNOME/音声/IMEを`modules/nixos/desktop/`に移動

### Phase 4: ホスト定義
- [ ] 各ホストの`hosts/`ディレクトリを作成
- [ ] `flake.nix`を新構成に更新

### Phase 5: 検証
- [ ] `nix flake check`で構文確認
- [ ] 各ホストでビルドテスト
- [ ] 実環境で`home-manager switch`/`nixos-rebuild switch`を実行

## 主要ファイルの変更

| ファイル                         | 変更内容                                   |
| ---------                        | ---------                                  |
| `flake.nix`                      | hosts定義とヘルパー関数呼び出しに書き換え  |
| `home.nix`                       | モジュールに分割後、削除または参照用に保持 |
| `nixos/configuration.nix`        | モジュールに分割後、ホスト固有部分のみ残す |
| `lib/default.nix`                | 新規作成                                   |
| `modules/home/core/default.nix`  | 新規作成                                   |
| `modules/nixos/core/default.nix` | 新規作成                                   |

## 将来のmacOS対応

```nix
inputs.darwin.url = "github:lnl7/nix-darwin";

darwinConfigurations.macbook = darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  modules = [ ./hosts/macbook/darwin.nix ];
};
```

`modules/darwin/`を追加してmacOS固有モジュールを配置。
