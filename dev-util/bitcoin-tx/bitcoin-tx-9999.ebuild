# Copyright 2010-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils git-2

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"

DESCRIPTION="Command-line Bitcoin transaction tool"
HOMEPAGE="http://bitcoin.org/"
SRC_URI="
"
EGIT_PROJECT='bitcoin'
EGIT_REPO_URI="git://github.com/bitcoin/bitcoin.git https://github.com/bitcoin/bitcoin.git"

LICENSE="MIT ISC"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=dev-libs/boost-1.52.0[threads(+)]
	dev-libs/openssl:0[-bindist]
	dev-libs/libsecp256k1
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i 's/bitcoin-cli//' src/Makefile.am
	epatch "${FILESDIR}/${PV}-sys_libsecp256k1.patch"
	rm -r src/secp256k1
	eautoreconf
}

src_configure() {
	econf \
		--disable-ccache \
		--without-miniupnpc  \
		--disable-tests  \
		--disable-wallet  \
		--without-daemon  \
		--without-libs \
		--without-gui
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc doc/release-notes.md
}
