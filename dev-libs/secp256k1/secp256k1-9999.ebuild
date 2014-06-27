# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://github.com/bitcoin/secp256k1.git"
inherit git-2 autotools

DESCRIPTION=""
HOMEPAGE=""

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND=""

DEPEND="${RDEPEND}
        >=sys-devel/gcc-4.7"

src_prepare() {
        eautoreconf
}

src_configure() {
        econf 
}

src_compile() {
        emake || die "Compile failed"
}

src_install() {
        if use doc; then
                dodoc README || die
        fi

        emake DESTDIR="${D}" install || die "Install failed"
}
