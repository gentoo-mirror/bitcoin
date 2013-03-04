# Copyright 2010-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DB_VER="4.8"

LANGS="bg ca_ES cs da de el_GR en es es_CL et eu_ES fa fa_IR fi fr fr_CA he hr hu it lt nb nl pl pt_BR pt_PT ro_RO ru sk sr sv tr uk zh_CN zh_TW"
inherit db-use eutils qt4-r2 git-2 versionator

DESCRIPTION="An end-user Qt4 GUI for the Bitcoin crypto-currency"
HOMEPAGE="http://bitcoin.org/"
SRC_URI="
"
EGIT_PROJECT='bitcoin'
EGIT_REPO_URI="git://gitorious.org/~Luke-Jr/bitcoin/luke-jr-bitcoin.git https://git.gitorious.org/~Luke-Jr/bitcoin/luke-jr-bitcoin.git"
EGIT_BRANCH='next'

LICENSE="MIT ISC GPL-3 LGPL-2.1 public-domain || ( CC-BY-SA-3.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS=""
IUSE="$IUSE 1stclassmsg dbus +eligius ipv6 +qrcode upnp"

RDEPEND="
	>=dev-libs/boost-1.41.0[threads(+)]
	dev-libs/openssl[-bindist]
	qrcode? (
		media-gfx/qrencode
	)
	upnp? (
		net-libs/miniupnpc
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]
	x11-libs/qt-gui:4
	dbus? (
		x11-libs/qt-dbus:4
	)
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
"

DOCS="doc/README"

src_prepare() {
	cd src || die
	use eligius && epatch "${FILESDIR}/9999.1-eligius_sendfee.patch"

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
	OPTS=()

	use dbus && OPTS+=("USE_DBUS=1")
	if use upnp; then
		OPTS+=("USE_UPNP=1")
	else
		OPTS+=("USE_UPNP=-")
	fi
	use qrcode && OPTS+=("USE_QRCODE=1")
	use 1stclassmsg && OPTS+=("FIRST_CLASS_MESSAGING=1")
	use ipv6 || OPTS+=("USE_IPV6=-")

	OPTS+=("BDB_INCLUDE_PATH=$(db_includedir "${DB_VER}")")
	OPTS+=("BDB_LIB_SUFFIX=-${DB_VER}")

	eqmake4 "${PN}.pro" "${OPTS[@]}"
}

src_compile() {
	emake
}

src_test() {
	cd src || die
	emake -f makefile.unix "${OPTS[@]}" test_bitcoin
	./test_bitcoin || die 'Tests failed'
}

src_install() {
	qt4-r2_src_install
	dobin ${PN}
	insinto /usr/share/pixmaps
	newins "share/pixmaps/bitcoin.ico" "${PN}.ico"
	make_desktop_entry ${PN} "Bitcoin-Qt" "/usr/share/pixmaps/${PN}.ico" "Network;P2P"
}
