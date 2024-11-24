# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

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
		dev-python/pyqt5[${PYTHON_USEDEP}]
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

src_prepare() {
	default

	# don't install the unit tests
	sed -e 's/\(packages=find_packages([^)]\+\))/\1, exclude=["qt5reactor.tests"])/' \
		-i setup.py || die
}

python_test() {
	epytest -p pytest_twisted
}
