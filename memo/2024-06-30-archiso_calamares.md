title: archiso_calamares
====================================
date: 2024-06-30 21:01:54
tags: []
category: []
====================================
# calamaresとは
Official: https://calamares.io/

Linux Distributionのインストーラです。

AUR: https://aur.archlinux.org/packages/calamares
参考動画: https://youtu.be/pg8a_Br11Ng?si=2qpfJ9pYoeqVNETW


# Archisoへのcalamaresの追加方法
基本は動画に沿ってやりかたをメモするだけです。

# 1. calamaresをAURからclone
```bash
$ git clone https://aur.archlinux.org/calamares.git
$ cd calamares
```

(1) calamaresのPKGBUILDの`calamares-qt5`はコメントアウトする。
(2) 依存関係をインストール
これらはAURからインストールする必要があり、yayからインストールします。

```bash
depends=(
    'ckbcomp'
	'efibootmgr'
	'gtk-update-icon-cache'
	'hwinfo'
	'icu'
    # 'kpmcore>=24.01.75'
	'kpmcore'
	'libpwquality'
	'mkinitcpio-openswap'
	'squashfs-tools'
	'yaml-cpp'
)
makedepends=('extra-cmake-modules' 'git')
```

ちなみにkpmcoreからはバージョンを消さないとエラーが出るらしい。

```bash
$ yay -Sy ckbcomp efiboomgr gtk-update-icon-cache hwinfo icu kpmcore libpwquality mkinitcpio-openswap squashfs-tools yaml-cpp extra-cmake-modules git
```

## ckbcompについて
タイミングが悪かったらしく、ckbcompがインストールできない状態であった。(version 1.226, out-of-dateフラグが立っている)仕方ないので個別対応する。

1. ckbcompをAURからcloneする
2. http://ftp.debian.org/debian/pool/main/c/console-setup/console-setup_1.228.tar.xz をダウンロードしてハッシュを出力する

```bash
$ sha512sum console-setup_1.228.tar.xz
a835d3458390b93b280fa3f77a2f4912e43c5c40a0f51069313c158e9373a96d507b78fcde694646dd2259e46b8d0fe7589501bbf65e6d6a3278f8cda8803793  ./console-setup_1.228.tar.xz
```

3. ckbcompのPKBGLDを以下のように変更する  

```diff
# Maintainer: Nissar Chababy <funilrys at outlook dot com>
# Ex-Maintainer: 	Jeroen Bollen <jbinero at gmail dot comau>

pkgname=ckbcomp
- pkgver=1.226
+ pkgver=1.228
pkgrel=1
pkgdesc="Compile a XKB keyboard description to a keymap suitable for loadkeys or kbdcontrol"
arch=(any)
url="http://anonscm.debian.org/cgit/d-i/console-setup.git/"
license=('GPL2')
depends=('perl')
source=("http://ftp.debian.org/debian/pool/main/c/console-setup/console-setup_${pkgver}.tar.xz")
- sha512sums=('1b742ec2f43d50d1ab233864fdace5f1bda6ae40d6a3d16768dd804825c769f198e3a0ddb2b4e7420d13678073cd146e7a784e3e5de74f9d2726ba4a01a88006')
+ sha512sums=('a835d3458390b93b280fa3f77a2f4912e43c5c40a0f51069313c158e9373a96d507b78fcde694646dd2259e46b8d0fe7589501bbf65e6d6a3278f8cda8803793')
conflicts=(ckbcomp-bin)

package() {
    if [[ -d "${srcdir}/console-setup" ]]
    then
        cd console-setup
    elif [[ -d "${srcdir}/console-setup-${pkgver}" ]]
    then 
        cd console-setup-${pkgver} 
    elif [[ -d "${srcdir}/work" ]]
    then
        cd work
    else
	echo "Source directory not found.".
	exit 1
    fi


    if [[ ${?} != 0 ]]
    then
        cd console-setup-${pkgver}
    fi

    install -d ${pkgdir}/usr/bin/
    install -m755 Keyboard/ckbcomp ${pkgdir}/usr/bin/
}
```

PKGBUILDを修正したらmakepkgしてインストールする。

```bash
$ makepkg -si
```

# calamaresをビルド

```bash
$ makepkg -s
```

46分かかりました。
