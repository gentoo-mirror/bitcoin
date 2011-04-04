# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

EGIT_MASTER="install"
EGIT_BRANCH="install"

inherit git

DESCRIPTION="PySide Bitcoin user interface"
HOMEPAGE="https://gitorious.org/bitcoin/spesmilo"
EGIT_REPO_URI="git://gitorious.org/bitcoin/spesmilo.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="kde"

DEPEND="
	dev-python/pyside
"
RDEPEND="${DEPEND}
"
DEPEND="${DEPEND}
	media-gfx/imagemagick
"

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
