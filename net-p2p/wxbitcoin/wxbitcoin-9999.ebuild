# Copyright 2010-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DB_VER="4.8"
WX_GTK_VER="2.9"

inherit db-use eutils git versionator wxwidgets

DESCRIPTION="A P2P network based digital currency."
HOMEPAGE="http://bitcoin.org/"
EGIT_PROJECT='bitcoin'
EGIT_REPO_URI="https://github.com/bitcoin/bitcoin.git"
SRC_URI="
	eligius? ( http://luke.dashjr.org/programs/bitcoin/files/0.3.24-eligius_sendfee.patch )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +eligius nls selinux ssl upnp"
LANGS="cs de eo es fr it lt nl pl pt ru sv zh_cn"

for X in ${LANGS}; do
	IUSE="$IUSE linguas_$X"
done

DEPEND="
	>=dev-libs/boost-1.41.0
	dev-libs/crypto++
	dev-libs/glib
	dev-libs/openssl[-bindist]
	nls? (
		sys-devel/gettext
	)
	selinux? (
		sys-libs/libselinux
	)
	upnp? (
		>=net-libs/miniupnpc-1.6
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")
	>=app-admin/eselect-wxwidgets-0.7-r1
	x11-libs/wxGTK:2.9[X]
	!net-p2p/bitcoin
"
RDEPEND="${DEPEND}
"
DEPEND="${DEPEND}
	>=app-shells/bash-4.1
"

src_prepare() {
	cd src
	cp "${FILESDIR}/0.4.0-Makefile.gentoo" "Makefile"
	epatch "${FILESDIR}/Support-for-boost-filesystem-version-3.patch"
	use eligius && epatch "${DISTDIR}/0.3.24-eligius_sendfee.patch"
}

src_compile() {
	local OPTS=()
	
	OPTS+=("CXXFLAGS=${CXXFLAGS}")
	OPTS+=( "LDFLAGS=${LDFLAGS}")
	
	OPTS+=("DB_CXXFLAGS=-I$(db_includedir "${DB_VER}")")
	OPTS+=("DB_LDFLAGS=-ldb_cxx-${DB_VER}")
	
	local BOOST_PKG BOOST_VER BOOST_INC
	BOOST_PKG="$(best_version 'dev-libs/boost')"
	BOOST_VER="$(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}")"
	BOOST_VER="$(replace_all_version_separators _ "${BOOST_VER}")"
	BOOST_LIB="/usr/include/boost-${BOOST_VER}"
	OPTS+=("BOOST_CXXFLAGS=-I${BOOST_LIB}")
	OPTS+=("BOOST_LIB_SUFFIX=-${BOOST_VER}")
	
	use debug&& OPTS+=(USE_DEBUG=1)
	use ssl  && OPTS+=(USE_SSL=1)
	use upnp && OPTS+=(USE_UPNP=1)
	
	cd src
	emake "${OPTS[@]}" bitcoin || die "emake bitcoin failed";
}

src_install() {
	newbin src/bitcoin wxbitcoin
	insinto /usr/share/pixmaps
	doins "share/pixmaps/bitcoin.ico"
	make_desktop_entry ${PN} "wxBitcoin" "/usr/share/pixmaps/bitcoin.ico" "Network;P2P"
	
	if use nls; then
		einfo "Installing language files"
		for val in ${LANGS}
		do
			if use "linguas_$val"; then
				mv "locale/$val/LC_MESSAGES/bitcoin.mo" "$val.mo" &&
				domo "$val.mo" || die "failed to install $val locale"
			fi
		done
	fi
	
	dodoc COPYING doc/README
}

pkg_postinst() {
	einfo "net-p2p/wxbitcoin no longer installs the 'bitcoin' symlink starting with 0.4."
	einfo "To run it, you must use 'wxbitcoin'"
	einfo "Please note that this is the last planned release of wxbitcoin, and future"
	einfo "development is taking place on net-p2p/bitcoin-qt"
}
