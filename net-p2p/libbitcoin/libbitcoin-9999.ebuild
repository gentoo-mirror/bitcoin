# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://gitorious.org/libbitcoin/libbitcoin.git"
inherit git-2 autotools

DESCRIPTION="Rewrite bitcoin, make it super-pluggable, very easy to do and hack everything at every level, and very configurable."
HOMEPAGE="http://libbitcoin.org/"
SRC_URI=""

LICENSE="AGPL"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND=">=dev-libs/boost-1.41.0 >=dev-db/cppdb-0.0.3"
DEPEND=">=sys-devel/gcc-4.6 ${RDEPEND}"

src_prepare() {
	eautoreconf || die "Prepare failed"
}

src_configure() {
	econf || die "Configure failed"
}

src_compile() {
	emake || die "Compile failed"
}

src_install() {
	if use doc; then
		dodoc  AUTHORS COPYING ChangeLog INSTALL LICENSE NEWS README doc/style || die
		dohtml doc/libbitcoin/* || die
	fi

	emake DESTDIR="${D}" install || die "Install failed"
}

