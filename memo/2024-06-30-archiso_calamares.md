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
```

ちなみにkpmcoreからはバージョンを消さないとエラーが出るらしい。

```bash
$ yay -S ckbcomp efiboomgr gtk-update-icon-cache hwinfo icu kpmcore libpwquality mkinitcpio-openswap squashfs-tools yaml-cpp
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
```bash&diff
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

#
<details>
<summary>PKGBUILD</summary>
```bash
# Maintainer: Rustmilian Rustmilian@proton.me

pkgname=(
    'calamares'
    )
    # 'calamares-qt5'
    # )

pkgver=3.3.5
pkgrel=1
pkgdesc='Distribution-independent installer framework'
arch=($CARCH)
url="https://github.com/calamares/calamares"

license=('BSD-2-Clause'
	'CC-BY-4.0'
	'CC0-1.0'
	'GPL-3.0-or-later'
	'LGPL-2.1-only'
	'LGPL-3.0-or-later'
	'MIT')

depends=('ckbcomp'
	'efibootmgr'
	'gtk-update-icon-cache'
	'hwinfo'
	'icu'
	'kpmcore>=24.01.75'
	'libpwquality'
	'mkinitcpio-openswap'
	'squashfs-tools'
	'yaml-cpp')

makedepends=('extra-cmake-modules' 'git')

backup=('usr/share/calamares/modules/bootloader.conf'
	'usr/share/calamares/modules/displaymanager.conf'
	'usr/share/calamares/modules/initcpio.conf'
	'usr/share/calamares/modules/unpackfs.conf')

source=("$pkgname-$pkgver.tar.gz::$url/archive/v$pkgver.tar.gz"
	"calamares.desktop"
	"calamares_polkit"
	"49-nopasswd-calamares.rules"
	"paru-support.patch"
	"flag.patch")

sha256sums=('65b11d6bb2ba76fc74fed08faa4b6fe43d1a5bf4a2522b30fc43b44151686c47'
            'b9e65ab87f69b2d3f8f8eaea60c78625aef57dd336314ab75389f31a447445be'
            'c176b28007bd1c1f23d8dbb2c936fa54d0c01bacfb67290ddad597606c129df3'
            '56d85ff6bf860b9559b8c9f997ad9b1002f3fccc782073760eca505e3bddd176'
            'f00c90bd87d6dfd73b3ec53fa9a145ac25234676be41604807f05f05a4bf5bbb'
            '0830c8fe57c94a63ef87b6a025eb729b4f098a9e46e729b63415f4d3a2755762')

prepare() {
	makedepends() {
	if [[ $pkgname == 'calamares' ]]; then
		makedepends+=('qt6-tools' 'qt6-translations')
	elif [[ $pkgname == 'calamares-qt5' ]]; then
		makedepends+=('qt5-tools' 'qt5-translations')
	fi
	handle_qt_version
	}

	handle_qt_version() {
	if [[ $pkgname == 'calamares' ]]; then
		qt=6
		handle_qt6_base
	elif [[ $pkgname == 'calamares-qt5' ]]; then
		qt=5
	fi
	cd "${srcdir}/${pkgname}-${pkgver}" || return
		sed -i 's/"Install configuration files" OFF/"Install configuration files" ON/' "${srcdir}/${pkgname}-${pkgver}/CMakeLists.txt"
		sed -i "s|\${CALAMARES_VERSION_MAJOR}.\${CALAMARES_VERSION_MINOR}.\${CALAMARES_VERSION_PATCH}|${pkgver}-${pkgrel}|g" CMakeLists.txt
		sed -i "s|CALAMARES_VERSION_RC 1|CALAMARES_VERSION_RC 0|g" CMakeLists.txt
		git apply --verbose ../paru-support.patch
	}

##	Non-standard ##
	handle_qt6_base() {
	if ls ./qt6-base/qt6-base-*.pkg.tar.zst 1> /dev/null 2>&1; then
		echo "qt6-base already exists"
		update_qt6_base
	else
		clone_and_build_qt6_base
	fi
	}

	update_qt6_base() {
		cd qt6-base || exit
		echo -e "\e[1;32mUpdate qt6-base? (y/n) : \e[0m\c"
		read -r input
	if [ "$input" = "y" ]; then
		git pull
		git apply --verbose ../flag.patch
		makepkg -sif
	else
		makepkg -si
	fi
	}

	clone_and_build_qt6_base() {
		git clone https://gitlab.archlinux.org/archlinux/packaging/packages/qt6-base.git
		cd qt6-base || exit
		git apply --verbose ../flag.patch
		makepkg -si
	}
##	Non-standard ##

	# Call the function to start the process
	makedepends

}

build() {
	cd "${srcdir}/${pkgname}-${pkgver}" || return
	mkdir -p build
	cd build || return
	cmake .. \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DCMAKE_INSTALL_LIBDIR=lib \
		-DWITH_QT"${qt}"=ON \
		-DWITH_PYTHONQT=OFF \
		-DWITH_KF5DBus=OFF \
		-DBoost_NO_BOOST_CMAKE=ON \
		-DWEBVIEW_FORCE_WEBKIT=OFF \
		-DSKIP_MODULES="webview \
						tracking \
						interactiveterminal \
						initramfs \
						initramfscfg \
						dracut \
						dracutlukscfg \
						dummyprocess \
						dummypython \
						dummycpp \
						dummypythonqt \
						services-openrc \
						keyboardq \
						localeq \
						welcomeq"
	make
}

package_calamares() {
	depends=('kconfig>=5.246'
		'kcoreaddons>=5.246'
		'ki18n>=5.246'
		'kiconthemes>=5.246'
		'kio>=5.246'
		'polkit-qt6>=0.175.0'
		'qt6-base>=6.6.0'
		'qt6-svg>=6.6.0'
		'solid>=5.246')

	cd "${srcdir}/${pkgname}-${pkgver}/build" || return
	make DESTDIR="$pkgdir" install
	install -Dm644 "${srcdir}/calamares.desktop" "$pkgdir/etc/xdg/autostart/calamares.desktop"
	install -Dm755 "${srcdir}/calamares_polkit" "$pkgdir/usr/bin/calamares_polkit"
	install -Dm644 "${srcdir}/49-nopasswd-calamares.rules" "$pkgdir/etc/polkit-1/rules.d/49-nopasswd-calamares.rules"
	chmod 750 "$pkgdir"/etc/polkit-1/rules.d

}

package_calamares-qt5() {
	depends=('kconfig5>=5.113.0'
		'kcoreaddons5>=5.113.0'
		'kiconthemes5>=5.113.0'
		'ki18n5>=5.113.0'
		'kio5>=5.113.0'
		'solid5>=5.113.0'
		'qt5-base>=5.15.11'
		'qt5-svg>=5.15.11'
		'polkit-qt5>=0.175.0'
		'plasma-framework5>=5.58'
		'qt5-xmlpatterns>=5.15.11')

	cd "${srcdir}/${pkgname}-${pkgver}/build" || return
	make DESTDIR="$pkgdir" install
	install -Dm644 "${srcdir}/calamares.desktop" "$pkgdir/etc/xdg/autostart/calamares.desktop"
	install -Dm755 "${srcdir}/calamares_polkit" "$pkgdir/usr/bin/calamares_polkit"
	install -Dm644 "${srcdir}/49-nopasswd-calamares.rules" "$pkgdir/etc/polkit-1/rules.d/49-nopasswd-calamares.rules"
	chmod 750 "$pkgdir"/etc/polkit-1/rules.d
}
```
</details>
