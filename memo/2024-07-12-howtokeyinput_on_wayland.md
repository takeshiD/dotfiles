title: howtokeyinput_on_wayland
====================================
date: 2024-07-12 09:24:04
tags: []
category: ["libinput", "evdev", "wayland", "X.org", "xkbcommon"]
====================================

weztermをUbuntu22.04で使用していたらフルスクリーン周りでバグを発見。スクリーンショットの動画を撮影しようとツールを探していたところ2つ見つけました。

| name(with link)                                               | wayland | x.org |
|:--------------------------------------------------------------|:-------:|:-----:|
| [screenkey](https://github.com/wavexx/screenkey.git)          |    ❌   |   ✅  |
| [showmethekey](https://github.com/AlynxZhou/showmethekey.git) |    ✅   |   ✅  |

waylandなので選ぶ余地なくshowmethekeyをcloneして手順通りにビルドしたが、なぜかエラーに、、
調べたところlibadwaitaのバージョンが暗黙で1.5以上であることが必須のよう(`set_body_use_markup`などの関数が1.5から)。Ubuntu22.04では1.2が標準レポジトリとなっています。

```sh
$ meson compile
[1/1] Linking target showmethekey-gtk/showmethekey-gtk
FAILED: showmethekey-gtk/showmethekey-gtk
cc  -o showmethekey-gtk/showmethekey-gtk showmethekey-gtk/showmethekey-gtk.p/meson-generated_.._smtk-resources.c.o showmethekey-gtk/showmethekey-gtk.p/meson-generated_.._smtk-enum-types.c.o showmethekey-gtk/showmethekey-gtk.p/main.c.o showmethekey-gtk/showmethekey-gtk.p/smtk-app.c.o showmethekey-gtk/showmethekey-gtk.p/smtk-app-win.c.o showmethekey-gtk/showmethekey-gtk.p/smtk-keys-win.c.o showmethekey-gtk/showmethekey-gtk.p/smtk-keys-area.c.o showmethekey-gtk/showmethekey-gtk.p/smtk-keys-emitter.c.o showmethekey-gtk/showmethekey-gtk.p/smtk-keys-mapper.c.o showmethekey-gtk/showmethekey-gtk.p/smtk-keymap-list.c.o showmethekey-gtk/showmethekey-gtk.p/smtk-event.c.o -Wl,--as-needed -Wl,--no-undefined -Wl,--start-group /usr/lib/x86_64-linux-gnu/libgtk-4.so /usr/lib/x86_64-linux-gnu/libpangocairo-1.0.so /usr/lib/x86_64-linux-gnu/libpango-1.0.so /usr/lib/x86_64-linux-gnu/libharfbuzz.so /usr/lib/x86_64-linux-gnu/libgdk_pixbuf-2.0.so /usr/lib/x86_64-linux-gnu/libcairo-gobject.so /usr/lib/x86_64-linux-gnu/libcairo.so /usr/lib/x86_64-linux-gnu/libgraphene-1.0.so /usr/lib/x86_64-linux-gnu/libgio-2.0.so /usr/lib/x86_64-linux-gnu/libgobject-2.0.so /usr/lib/x86_64-linux-gnu/libglib-2.0.so /usr/lib/x86_64-linux-gnu/libadwaita-1.so /usr/lib/x86_64-linux-gnu/libX11.so /usr/lib/x86_64-linux-gnu/libjson-glib-1.0.so /usr/lib/x86_64-linux-gnu/libxkbcommon.so /usr/lib/x86_64-linux-gnu/libxkbregistry.so -Wl,--end-group
/usr/bin/ld: showmethekey-gtk/showmethekey-gtk.p/smtk-app-win.c.o: in function `smtk_app_win_show_usage_dialog':
/home/tkcd/ex_prog/apps/showmethekey/build/../showmethekey-gtk/smtk-app-win.c:531: undefined reference to `adw_message_dialog_new'
/usr/bin/ld: .../showmethekey/build/../showmethekey-gtk/smtk-app-win.c:571: undefined reference to `ADW_MESSAGE_DIALOG'
/usr/bin/ld: .../showmethekey/build/../showmethekey-gtk/smtk-app-win.c:571: undefined reference to `adw_message_dialog_set_body_use_markup'
/usr/bin/ld: .../showmethekey/build/../showmethekey-gtk/smtk-app-win.c:573: undefined reference to `ADW_MESSAGE_DIALOG'
/usr/bin/ld: .../showmethekey/build/../showmethekey-gtk/smtk-app-win.c:573: undefined reference to `adw_message_dialog_add_response'
/usr/bin/ld: showmethekey-gtk/showmethekey-gtk.p/smtk-app-win.c.o: in function `smtk_app_win_show_about_dialog':
.../showmethekey/build/../showmethekey-gtk/smtk-app-win.c:613: undefined reference to `adw_show_about_window'
collect2: error: ld returned 1 exit status
ninja: build stopped: subcommand failed.
```

まあ確かにshowmethekeyのインストール方法が基本pacmanで、debian/ubuntuが記載されてないので依存ライブラリは最新が前提のよう、、、mesonって依存ライブラリのバージョン指定できるよね、、、書いておいてほしい。

libadwaitaをソースビルドすれば入れられると思われるけど他のライブラリも怪しいし、環境立ち上げるときも忘れそうなので自分で作ることにしました。

コンセプトは以下。

* 対応環境
    * Wayland, X11対応
    * GNOME41以上対応
    * 他デスクトップ環境も出来るだけ対応したい
* 配布
    * Rust実装
    * crates.io登録
    * AUR登録
* UI
    * CLI,GUI実装
    * GUIは見た目カスタム可能(透過, カラーテーマ適用など)

コンセプトはこれでいいとして、実装までの基礎知識がないので調べながらメモしながらやっていきます。


# wayland, x11のアーキテチャ
まずはここからです。

* [公式HP - Wayland](https://wayland.freedesktop.org/)

## X11アーキテクチャ
X11から。

![](https://wayland.freedesktop.org/x-architecture.png)
> 画像引用: wayland.freedesktop.org

基本構造は簡単で、各アプリケーション(X Client)がX Serverとやりとりをし続ける形です。
X11のクライアントはウィンドウ描画のために木構造になっています。X11でscreenkeyのようなアプリを作るときはここがポイントです。
下図のようにキー入力が流れていくのですが、このときwindow1(root window)というX Serverが生成するウィンドウを全てのキー入力を通過します。

![](/memo/images/x11_architecture.drawio.svg)

そしてx11のライブラリにはroot windowを取得するAPIが用意されていますので、これを取得しキーを監視すればいいわけですね。


## waylandアーキテクチャ
続けてwayland。waylandはクライアントの構造が異なります。そもそも木構造ではないのでroot windowが存在しません。
全てをCompositerが引き受けます。

![](https://wayland.freedesktop.org/wayland-architecture.png)
> 画像引用: wayland.freedesktop.org

X11のようなrootがないのでどこからキーを取得すれば、、と思いますが、図を見るとcompositerから取ってこれるのでは？と思えそうです。
まさにそのとおりで、waylandの場合はcompositerからキー入力を取得することになります。(というかX11でもServerからとってこいよって思いました)
そのためにwaylandに用意されているのが`libinput`です。


# libinput

* [libinput概要](https://wayland.freedesktop.org/libinput/doc/latest/index.html)
* [libinput API](https://wayland.freedesktop.org/libinput/doc/latest/api/index.html)


Wayland上でのlibinputの立ち位置を表わしているのが以下の図です。

![](https://wayland.freedesktop.org/libinput/doc/latest/_images/graphviz-6c83ce78daef94eb484f25f6a61ddb0599f6897f.png)
> 引用: https://wayland.freedesktop.org/libinput/doc/latest/what-is-libinput.html


Kernelからのデバイスたちをlibinputで引き受けています。
libinputは本来wayland専用ですが、ver1.1からx.orgでも対応するようになりました。ありがたいことです。
ということでwayland、x.org両対応のキーハックをするにはlibinputを利用すれば解決です。

## おまけ1: evdev

先程のlibinputの図の左側に`/dev/input/event0`というデバイスがあります。
これはカーネルモジュールが生成している入力デバイスの抽象化であるイベントデバイスといいます。
evdevと略され、そのAPI用ライブラリもlibevdevという名前です。

evdevはlibinputより古くより低レイヤのAPIを提供しています

こちらの図が関係性が分かりやすいです。

![](https://slackware.jp/blog/images/libevdev_and_libinput_on_x_and_wayland.sv://slackware.jp/blog/images/libevdev_and_libinput_on_x_and_wayland.svg)
> 引用: https://slackware.jp/blog/blog-2023-11-17.htm://slackware.jp/blog/blog-2023-11-17.html


## おまけ2: udev
デバイスといえばudevという単語も聞いたことがあります。(USBメモリの番号固定したりとか)
udevもデバイスに関係するシステムですがレイヤーと役割が違います。
udevの役割はデバイスを検知してデバイスファイルを作成することです。
evdevやlibinputはデバイスファイルありきで、デバイスのキーイベントを提供するAPIになります。


# libinputをRustで扱う

Rustにlibinputのバインディングがありますのでこれを使います。

[inpu.rs - github](https://github.com/Smithay/input.rs.git)

使用にはlibinput-devが必要ですので事前にインストールします。

* Ubuntu/Debian
```sh
$ sudo apt install libinput-dev
```
Ubuntu22.04では1.20でした。

* ArchLinux
```sh
$ sudo pacman -Sy libinput-dev
```

input.rsはlibinputのバージョン1.19.1以上でしか使用できませんのでご注意下さい。


インストールを終えたらRustのプロジェクトを作成し、input.rsをインストールします。

```bash
$ cargo new ex_input
$ cd ex_input
$ cargo add input
```

# Memo
## /dev/input/event{n}へのアクセスパーミッション
/dev/input/event{n}はパーミッションが`crw-rw---- root input`であるため一般ユーザーで上記のプログラムを実行しようとするとPermission Deniedで読み取り時点で弾かれる。
これを解消するために最も簡単なのは、プログラムを実行する際sudoしてもらうこと。とはいえそれは面倒だしセキュリティ的に問題があるので以下の方法がよいと思われる。

1. 実行する一般ユーザーを`input`グループに追加する
2. 実行するプログラムのパーミッションを`input`グループの実効グループに変更する

sudoで実行すると権限が強力すぎるのでハックされたときのリスクが高い。
一方でinputグループでの実効に絞ればsudoよりは安全だと思う。

### 1. 一般ユーザーの`input`グループへの追加
これはとても簡単で、以下のコマンドを実行する。

```bash
$ sudo usermod -aG $USER input
```

いろいろなところで書かれていますが、`-a`を忘れるとユーザーの所属サブグループがinputだけになってしまうので絶対に忘れないようにしましょう。

### 2. プログラムのパーミッションを`input`グループの実効グループに変更する
実効グループとは何かというのは[Linuxの実ユーザIDと実効ユーザIDについて](https://www.khstasaba.com/?p=454)を参照ください。とても詳しく分かりやすいです。

作成したプログラム名を`ex_libinput`とします。
このプログラムのパーミッションは一般ユーザーを`myuser`とすると

```bash
$ ls -la ./ex_libinput
-rwxrwxr-x   2 myuser myuser 5196456  7月 12 15:49 ex_libinput*
```

となり、所有者、グループともにmyuserです。

まずはプログラムのグループをinputに変更します。
```bash
$ sudo chown myuser:input ./ex_libinput
$ ls -la ./ex_libinput
-rwxrwxr-x   2 myuser input 5196456  7月 12 15:49 ex_libinput*
```

次に実効グループを設定します。
```bash
$ sudo chmod g+s ./ex_libinput
$ ls -la ./ex_libinput
-rwxrwsr-x   2 myuser input 5196456  7月 12 15:49 ex_libinput*
```

パーミッションのうちグループに該当するところが`rws`になっています。これでこのプログラムを実行するとき、まるでinputグループが実行しているように振る舞えます。/dev/input/event{n}はinputグループなのでパーミッションは満たしていることになります。

```bash
$ ./ex_libinput
open_restricted /dev/input/event2, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event7, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event1, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event0, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event13, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event14, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event15, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event16, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event8, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event9, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event10, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event11, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event12, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event4, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event6, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event3, flag=0o2004002, RDONLY:0, RDWR:2
open_restricted /dev/input/event5, flag=0o2004002, RDONLY:0, RDWR:2
Key: 0x26, State: Pressed, Sym: "a"(0x61), Repeat: true
aKey: 0x26, State: Released, Sym: "a"(0x61), Repeat: true
Key: 0x37, State: Pressed, Sym: "v"(0x76), Repeat: true
vKey: 0x37, State: Released, Sym: "v"(0x76), Repeat: true
Key: 0x42, State: Pressed, Sym: "Eisu_toggle"(0xff30), Repeat: false
Key: 0x26, State: Pressed, Sym: "a"(0x61), Repeat: true
Key: 0x42, State: Released, Sym: "Eisu_toggle"(0xff30), Repeat: false
Key: 0x26, State: Released, Sym: "a"(0x61), Repeat: true
Key: 0x23, State: Pressed, Sym: "bracketleft"(0x5b), Repeat: true
```
こんな感じです。
