# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

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
		>=dev-python/pytest-twisted-1.13.4-r1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	epytest -p pytest_twisted
}
