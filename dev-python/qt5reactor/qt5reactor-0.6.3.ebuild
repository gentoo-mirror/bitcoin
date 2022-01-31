# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5..10} )

inherit distutils-r1

DESCRIPTION="Twisted and PyQt5 eventloop integration"
HOMEPAGE="https://github.com/twisted/qt5reactor"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/twisted[${PYTHON_USEDEP}]
	|| (
		dev-python/PyQt5[${PYTHON_USEDEP}]
		dev-python/pyside2[${PYTHON_USEDEP}]
	)
"
DEPEND=""
BDEPEND="
	test? (
		dev-python/pytest-twisted[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
