# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit distutils-r1

DESCRIPTION="A python3 library providing an easy interface to the Bitcoin data structures"
HOMEPAGE="https://github.com/Simplexum/python-bitcointx"
SRC_URI="${HOMEPAGE}/archive/${PN}-v${PV}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/libsecp256k1
"
DEPEND=""
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${PN}-v${PV}"
