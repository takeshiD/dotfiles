title: Rust製TUIファイラーyazi
====================================
date: 2024-07-03 17:08:29
tags: []
category: []
====================================

# yazi
* Github: https://github.com/sxyazi/yazi
* OfficialWeb: https://yazi-rs.github.io/

# 特徴
* フル非同期サポート
* 強力なタスクスケジューリング&マネジメント
* 豊富な組み込み機能群
    * 画像プレビュー
    * コードプレビュー&ハイライト
    * これらがほぼ全てのターミナルエミュレータヘ対応
* 

# Installation
詳しくは公式を参照ください。
対応しているインストール方法だけ以下に記載します。

* Arch Linux(pacman, AUR)
* Nix
* Homebrew
* scoop(Windows)
* cargo

UbuntuやDebianなどはまだ対応していなさそうでした。その場合はcargoで入れるしかなさそう。

## cargoの場合
`yazi-fm`と`yazi-cli`の2つを入れます。

```bash
cargo install --locked yazi-fm yazi-cli
```

# 紹介動画
https://github.com/sxyazi/yazi/assets/17523360/92ff23fa-0cd5-4f04-b387-894c12265cc7

# 基本
## Shell wrapper
`yazi`から抜ける際に`yazi`で移動した作業ディレクトリへ移動するシェルラッパーを定義することをオススメされています。

bash,zshの場合は以下。

```sh:bash,zsh
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd"  ] && [ "$cwd" != "$PWD"  ]; then
    cd -- "$cwd"
    fi
    rm -f -- "$tmp"
    }
}
```

これで`yy`というコマンドで開始すればディレクトリ移動ができます。

## キーバインド
vim風のキーバインドが基本なので慣れやすいです。

### 移動
| Key                        | Action                 |
|:---------------------------|:-----------------------|
| <kbd>k</kbd>, <kbd>↑</kbd> | カーソル上移動         |
| <kbd>j</kbd>, <kbd>↓</kbd> | カーソル下移動         |
| <kbd>l</kbd>, <kbd>←</kbd>  | 選択ディレクトリへ移動 |
| <kbd>h</kbd>, <kbd>→</kbd> | 親ディレクトリヘ移動   |
| <kbd>K</kbd>               | カーソル5行上移動      |
| <kbd>J</kbd>               | カーソル5行下移動      |
| <kbd>gg</kbd>              | 一番上に移動           |
| <kbd>G</kbd>               | 一番下に移動           |

### 選択

| Key              | Action                          |
|:-----------------|:--------------------------------|
| <kbd>Space</kbd> | ファイル/ディレクトリ選択トグル |

### ファイル/ディレクトリ操作

| Key          | Action                                         |
|:-------------|:-----------------------------------------------|
| <kbd>o</kbd>, <kbd>Enter</kbd> | ファイルオープン($EDITOR に設定されたエディタ) |
| <kbd>O</kbd> | ファイルオープン($EDITOR に設定されたエディタ) |
