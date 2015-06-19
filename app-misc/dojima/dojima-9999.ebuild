# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{3_1,3_2,3_3} )

inherit eutils git-2 distutils-r1

DESCRIPTION="Graphical bitcoin exchange client in PyQt."
HOMEPAGE="https://github.com/3M3RY/Dojima"
EGIT_REPO_URI="git://github.com/3M3RY/Dojima.git \
			   https://github.com/3M3RY/Dojima.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-python/matplotlib[qt4,${PYTHON_USEDEP}]
		 dev-python/numpy[${PYTHON_USEDEP}]
		 dev-python/PyQt4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

pkg_preinst() {
	#cd "${S}/graphics"
	#for SIZE in 16 22 24 32 36 48 64 72 96 128 192 256 ; do
	#	newicon --size ${SIZE} icon-${SIZE}x${SIZE}.png ${PN}.png
	#done
	make_desktop_entry ${PN} Dōjima ${PN} "Economy;Finance"
}
