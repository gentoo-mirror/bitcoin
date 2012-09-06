# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_COMPAT="python2_7"

inherit eutils python-distutils-ng

DESCRIPTION="PyQt4 commodity market client, supports BTC-e, CampBX, MtGox."
HOMEPAGE="https://github.com/3M3RY/${PN}"
SRC_URI="https://github.com/downloads/3M3RY/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-python/PyQt4"
DEPEND="${RDEPEND}"
