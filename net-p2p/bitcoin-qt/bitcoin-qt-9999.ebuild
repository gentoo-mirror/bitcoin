# Copyright 2010-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DB_VER="4.8"

LANGS="da de en es es_CL nb nl ru zh_TW"
inherit db-use eutils qt4-r2 git-2 versionator

DESCRIPTION="An end-user Qt4 GUI for the Bitcoin crypto-currency"
HOMEPAGE="http://bitcoin.org/"
EGIT_PROJECT='bitcoin'
EGIT_REPO_URI="https://github.com/bitcoin/bitcoin.git"
SRC_URI="
	eligius? ( http://luke.dashjr.org/programs/bitcoin/files/0.5-eligius_sendfee.patch )
"

LICENSE="MIT ISC CCPL-Attribution-3.0 GPL-3 md2k7-asyouwish LGPL-2.1 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="$IUSE dbus +eligius ssl upnp"

RDEPEND="
	>=dev-libs/boost-1.41.0
	dev-libs/openssl[-bindist]
	upnp? (
		>=net-libs/miniupnpc-1.6
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")
	x11-libs/qt-gui
	dbus? (
		x11-libs/qt-dbus
	)
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
"

DOCS="doc/README"

src_prepare() {
	cd src || die
	use eligius && epatch "${DISTDIR}/0.5-eligius_sendfee.patch"

	local filt= yeslang= nolang=

	for lan in $LANGS; do
		if [ ! -e qt/locale/bitcoin_$lan.ts ]; then
			ewarn "Language '$lan' no longer supported. Ebuild needs update."
		fi
	done

	for ts in $(ls qt/locale/*.ts)
	do
		x="${ts/*bitcoin_/}"
		x="${x/.ts/}"
		if ! use "linguas_$x"; then
			nolang="$nolang $x"
			rm "$ts"
			filt="$filt\\|$x"
		else
			yeslang="$yeslang $x"
		fi
	done
	filt="bitcoin_\\(${filt:2}\\)\\.qm"
	sed "/${filt}/d" -i 'qt/bitcoin.qrc'
	einfo "Languages -- Enabled:$yeslang -- Disabled:$nolang"
}

src_configure() {
	local x=
	use dbus && x="$x USE_DBUS=1"
	use ssl  && x="$x DEFINES+=USE_SSL"
	if use upnp; then
		x="$x USE_UPNP=1"
	else
		x="$x USE_UPNP=-"
	fi

	x="$x BDB_INCLUDE_PATH='$(db_includedir "${DB_VER}")'"
	x="$x BDB_LIB_SUFFIX='-${DB_VER}'"

	local BOOST_PKG BOOST_VER
	BOOST_PKG="$(best_version 'dev-libs/boost')"
	BOOST_VER="$(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}")"
	BOOST_VER="$(replace_all_version_separators _ "${BOOST_VER}")"
	x="$x BOOST_INCLUDE_PATH='/usr/include/boost-${BOOST_VER}'"
	x="$x BOOST_LIB_SUFFIX='-${BOOST_VER}'"

	eqmake4 "${PN}.pro" $x
}

src_compile() {
	emake
}

src_install() {
	qt4-r2_src_install
	dobin bitcoin-qt
	insinto /usr/share/pixmaps
	newins "share/pixmaps/bitcoin.ico" 'bitcoin-qt.ico'
	make_desktop_entry ${PN} "Bitcoin-Qt" "/usr/share/pixmaps/bitcoin-qt.ico" "Network;P2P"
}
