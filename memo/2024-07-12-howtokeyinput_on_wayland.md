title: howtokeyinput_on_wayland
====================================
date: 2024-07-12 09:24:04
tags: []
category: ["libinput", "evdev", "wayland", "X.org", "xkbcommon"]
====================================

weztermをUbuntu22.04で使用していたらフルスクリーン周りでバグを発見。スクリーンショットの動画を撮影しようとツールを探していたところ2つ見つけた。

|                        name(with link)                        | wayland | x.org |
|:-------------------------------------------------------------:|:-------:|:-----:|
|      [screenkey](https://github.com/wavexx/screenkey.git)     |    ❌   |   ✅  |
| [showmethekey](https://github.com/AlynxZhou/showmethekey.git) |    ✅   |   ✅  |

waylandなので選ぶ余地なくshowmethekeyをcloneして手順通りにビルドしたが、なぜかエラーに、、
調べたところlibadwaitaのバージョンが暗黙で1.5以上であることが必須のよう(`set_body_use_markup`などの関数が1.5から)。Ubuntu22.04では1.2が標準レポジトリとなっている。

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

libadwaitaをソースビルドすれば入れられると思われるけど他のライブラリも怪しいし、環境立ち上げるときも忘れそうなので自分で作ることにした。

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

コンセプトはこれでいいとして、実装までの基礎知識がないので調べながらメモしながらやっていく。


# wayland, x11のアーキテチャ
まずはここからです。

[公式HP - Wayland](https://wayland.freedesktop.org/)

まずX11から。

![](https://wayland.freedesktop.org/x-architecture.png)
> 画像引用: wayland.freedesktop.org

基本構造は簡単で、各アプリケーション(X Client)がX Serverとやりとりをし続ける形です。
X11のクライアントはウィンドウ描画のために木構造になっています。

![](/memo/images/x11_architecture.drawio.svg)



次にwayland。
![](https://wayland.freedesktop.org/wayland-architecture.png)
> 画像引用: wayland.freedesktop.org
