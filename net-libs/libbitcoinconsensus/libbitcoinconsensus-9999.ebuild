# Copyright 2010-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils git-2 user versionator

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"

DESCRIPTION="Bitcoin Core consensus library"
HOMEPAGE="http://bitcoin.org/"
SRC_URI="
"
EGIT_PROJECT='bitcoin'
EGIT_REPO_URI="git://github.com/bitcoin/bitcoin.git https://github.com/bitcoin/bitcoin.git"

LICENSE="MIT ISC GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	>=dev-libs/boost-1.52.0[threads(+)]
	dev-libs/openssl:0[-bindist]
"
DEPEND="${RDEPEND}
"

src_prepare() {
	epatch "${FILESDIR}/0.9.0-sys_leveldb.patch"
	epatch "${FILESDIR}/${PV}-sys_libsecp256k1.patch"
	rm -r src/leveldb src/secp256k1
	eautoreconf
}

src_configure() {
	econf \
		--disable-ccache \
		--disable-static \
		--without-miniupnpc \
		$(use_enable test tests)  \
		--disable-wallet  \
		--with-system-leveldb  \
		--without-daemon \
		--without-utils  \
		--without-gui
}

src_test() {
	emake check
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files

	dodoc doc/README.md doc/release-notes.md
}
