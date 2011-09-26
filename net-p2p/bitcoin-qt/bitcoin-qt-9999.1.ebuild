# Copyright 2010-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DB_VER="4.8"

# TODO: LANGS="de es fr it nl pt ru"
inherit db-use eutils qt4-r2 git versionator

DESCRIPTION="A P2P network based digital currency."
HOMEPAGE="http://bitcoin.org/"
EGIT_PROJECT='bitcoin-qt'
EGIT_REPO_URI="git://github.com/laanwj/bitcoin-qt.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="$IUSE dbus selinux ssl upnp"

# TODO: IUSE=eligius

DEPEND="
	>=dev-libs/boost-1.41.0
	dev-libs/crypto++
	dev-libs/openssl[-bindist]
	selinux? (
		sys-libs/libselinux
	)
	upnp? (
		>=net-libs/miniupnpc-1.6
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")
	x11-libs/qt-gui
	dbus? (
		x11-libs/qt-dbus
	)
"
RDEPEND="${DEPEND}
"
DEPEND="${DEPEND}
	>=app-shells/bash-4.1
"

DOCS="COPYING doc/README"

src_prepare() {
	cd src
	use eligius && epatch "${DISTDIR}/0.3.24-eligius_sendfee.patch"
}

src_configure() {
	local x=
	use dbus && x="$x USE_DBUS=1"
	use ssl  && x="$x DEFINES+=USE_SSL"
	use upnp && x="$x USE_UPNP=1"
	
	x="$x BDB_INCLUDE_PATH='$(db_includedir "${DB_VER}")'"
	sed -i 's/\(-ldb_cxx\)/\1-'"${DB_VER}"'/' bitcoin-qt.pro
	
	local BOOST_PKG BOOST_VER
	BOOST_PKG="$(best_version 'dev-libs/boost')"
	BOOST_VER="$(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}")"
	BOOST_VER="$(replace_all_version_separators _ "${BOOST_VER}")"
	x="$x BOOST_INCLUDE_PATH='/usr/include/boost-${BOOST_VER}'"
	x="$x BOOST_LIB_SUFFIX='-${BOOST_VER}'"
	
	eqmake4 "${PN}.pro" $x
}

src_compile() {
	emake || die "emake bitcoin failed";
}

src_install() {
	qt4-r2_src_install
	dobin bitcoin-qt
	insinto /usr/share/pixmaps
	newins "share/pixmaps/bitcoin.ico" 'bitcoin-qt.ico'
	make_desktop_entry ${PN} "Bitcoin-Qt" "/usr/share/pixmaps/bitcoin-qt.ico" "Network;P2P"
}
