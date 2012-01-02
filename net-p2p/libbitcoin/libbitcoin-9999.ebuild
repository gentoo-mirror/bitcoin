# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://gitorious.org/libbitcoin/libbitcoin.git"
inherit git-2 autotools

DESCRIPTION="Modular library for implementing Bitcoin (crypto-currency) tools and clients"
HOMEPAGE="http://libbitcoin.org/"
SRC_URI=""

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="berkdb postgres doc"

RDEPEND="
	>=dev-libs/boost-1.48.0
	postgres? ( >=dev-db/cppdb-0.0.3[postgres] )
	berkdb? ( sys-libs/db:5.1[cxx] >=dev-libs/protobuf-2.3 )
	>=dev-libs/openssl-0.9
"

DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.6
"

src_prepare() {
	eaclocal
	_elibtoolize
	eautoconf
	eautomake
}

src_configure() {
	econf $(use_enable berkdb bdb) $(use_enable postgres) || die "Configure failed"
}

src_compile() {
	emake || die "Compile failed"
}

src_install() {
	if use doc; then
		dodoc  AUTHORS ChangeLog INSTALL NEWS README doc/style || die
		dohtml doc/libbitcoin/* || die
	fi

	emake DESTDIR="${D}" install || die "Install failed"
}
