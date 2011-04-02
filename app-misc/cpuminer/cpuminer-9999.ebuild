# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit git

DESCRIPTION="CPU miner for bitcoin"
HOMEPAGE="https://github.com/jgarzik/cpuminer"
EGIT_REPO_URI="git://github.com/jgarzik/cpuminer.git"
EGIT_BOOTSTRAP="autogen.sh"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	net-misc/curl
	dev-libs/jansson"

src_install() {
        emake DESTDIR="${D}" install || die
        dodoc README AUTHORS NEWS || die
}
