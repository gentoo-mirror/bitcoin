# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

myPN="${PN/s/S}"
myPV="${PV/_/.}"
myP="${myPN}-${myPV}"
DESCRIPTION="PySide Bitcoin user interface"
HOMEPAGE="https://gitorious.org/bitcoin/spesmilo"
SRC_URI="http://luke.dashjr.org/programs/bitcoin/files/${myPN}_${myPV}_source.tbz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="kde +local"

DEPEND="
"
RDEPEND="${DEPEND}
	dev-python/pyside
	virtual/python-serviceproxy
	dev-python/anynumber
	local? (
		net-p2p/bitcoind
	)
"
DEPEND="${DEPEND}
	media-gfx/imagemagick
"

S="${WORKDIR}/${myP}"

src_compile() {
	emake all || die
}

src_install() {
	local KDESERVICEDIR=
	if use kde; then
		KDESERVICEDIR="/usr/share/kde4/services"
	fi
	emake DESTDIR="${D}" \
		PREFIX="/usr" \
		KDESERVICEDIR="${KDESERVICEDIR}" \
		install || die
}
