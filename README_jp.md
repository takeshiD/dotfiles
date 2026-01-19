<h1 align="center">tkcd dotfiles</h1>

[Nix Flakes](https://nixos.wiki/wiki/Flakes) と [home-manager](https://github.com/nix-community/home-manager) で管理する個人用dotfiles。

## 対応環境

| 名前           | ホスト              | OS                | GUI   | IME         |
| ------         | --------            | -----             | ----- | -----       |
| dev-laptop     | tkcd@dev-laptop     | NixOS             | GNOME | fcitx5-mozc |
| company-laptop | tkcd@company-laptop | WSL2 (Arch Linux) | -     | Windows IME |

## ディレクトリ構成

```
dotfiles/
├── flake.nix                   # エントリポイント（NixOS + Home Manager）
├── hosts/
│   ├── dev-laptop.nix          # 個人ラップトップ（NixOS + GNOME + GUIアプリ）
│   └── company-laptop.nix      # 会社ラップトップ（WSL2、CLI中心）
├── home/
│   └── cli.nix                 # 共通CLIパッケージ（オプション）
├── nixos/
│   ├── configuration.nix       # NixOSシステム設定（GNOME、fcitx5等）
│   └── hardware-configuration.nix
├── config/                     # アプリ設定ファイル（シンボリックリンク）
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
└── install.sh                  # 初期セットアップスクリプト
```

## 必要なもの

- `git`
- `curl`（Nixインストール用）

## インストール

### 新規インストール（NixOS以外）

`install.sh`を2回実行 - 1回目でNixをインストール、2回目で設定を適用：

```bash
cd ~
git clone https://github.com/takeshiD/dotfiles.git
cd dotfiles
./install.sh
# Nixインストール後、シェルを再起動
./install.sh
```

### NixOS

```bash
cd ~/dotfiles
sudo nixos-rebuild switch --flake .#dev-laptop
```

## 使い方

### home-manager設定の適用

```bash
# 個人ラップトップ
home-manager switch --flake .#tkcd@dev-laptop

# 会社ラップトップ
home-manager switch --flake .#tkcd@company-laptop
```

### NixOS設定の適用

```bash
sudo nixos-rebuild switch --flake .#dev-laptop
```

### Flake入力の更新

```bash
nix flake update
```

## パッケージの追加

1. `hosts/`内の適切なホストファイルを編集：
   - `hosts/dev-laptop.nix` - 個人ラップトップ用
   - `hosts/company-laptop.nix` - 会社ラップトップ用

2. `home.packages`にパッケージを追加：
   ```nix
   home.packages = with pkgs; [
     # ここにパッケージを追加
     newpackage
   ];
   ```

3. 変更を適用：
   ```bash
   home-manager switch --flake .#tkcd@dev-laptop
   ```

## アプリ設定の追加

1. `config/<アプリ名>/`に設定ファイルを追加

2. ホストファイルにシンボリックリンクを追加：
   ```nix
   home.file = with config.lib.file; {
     ".config/<アプリ名>".source = mkOutOfStoreSymlink "${dotfilesPath}/config/<アプリ名>";
   };
   ```

## 主な特徴

- **Nix Flakes**: ロックファイルによる再現可能なビルド
- **home-manager**: 宣言的なユーザー環境管理
- **シンボリックリンク設定**: リビルドなしで設定ファイルを直接編集可能
- **マルチホスト対応**: マシンごとに異なる設定を管理
