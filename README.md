<h1 align="center">tkcd Nix Environment</h1>

| Name          | Description        |
| ------        | -------------      |
| dev-wsl       | for private wsl    |
| dev-laptop    | for private laptop |
| work-laptop-a | for compnay laptop |



# 概要

NixOS、home-manager、将来のmacOS (nix-darwin)に対応、ホストの追加・削除が容易なdotfiles構成

## ディレクトリ構成

```
dotfiles/
├── flake.nix                       # Entry point
├── lib/                            # helper functions
│   └── default.nix
│
├── modules/                        # NixOS modules
│   └── default.nix

├── home/                           # home-manager config
│   └── default.nix
│
├── hosts/                          # host configs
│   ├── tkcd-desktop/               # WSL2 + Arch
│   │   └── home.nix
│   ├── tkcd-xlaptop-arch/          # Arch + GNOME
│   │   └── home.nix
│   ├── tkcd-laptop-nixos/          # NixOS + GNOME
│   │   ├── default.nix
│   │   ├── home.nix
│   │   └── hardware-configuration.nix
│   ├── company-laptop/             # WSL2 (CLI)
│   │   └── home.nix
│   └── docker/                     # Docker NixOS
│       ├── default.nix
│       └── home.nix
│
├── overlays/                       # Package overlays
│   └── default.nix
│
└── config/                         # Config files tools
```

## flake.nix設計

ホストをデータとして定義し、ヘルパー関数で設定を生成:

```nix
hosts = {
  tkcd-xOS moduleslaptop-nixos = {
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

| モジュール         | 内容                                     | 対象ホスト |
| -----------        | ------                                   | ---------- |
| `home/core`        | fish, bash, neovim, tmux, git, ripgrep等 | 全環境     |
| `home/development` | rustup, nodejs, python, LSP群            | 全環境     |
| `home/desktop`     | ghostty, wezterm, chrome, fonts          | GUI環境    |
| `home/wsl`         | wslu, clipboard統合                      | WSL環境    |
| `nixos/core`       | nix設定, locale, users                   | NixOS      |
| `nixos/desktop`    | GNOME, pipewire, fcitx5                  | NixOS GUI  |

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
