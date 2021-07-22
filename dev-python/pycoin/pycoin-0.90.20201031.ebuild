# Copyright 2013-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7,3_8,3_9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Utilities for Bitcoin addresses and transaction manipulation"
HOMEPAGE="https://pypi.python.org/pypi/pycoin
https://github.com/richardkiss/pycoin"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!app-i18n/transifex-client
	!net-misc/keychain
"

distutils_enable_tests pytest

DOCS=(
	BIP32.txt
	CHANGES
	COMMAND-LINE-TOOLS.md
	CREDITS
	docs/api.rst
	docs/bitcoin.rst
	README.md
)

src_prepare() {
	sed 's/\(packages=\[\)/version="'"$PV"'",\n\1/' -i setup.py || die

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install

	if use examples; then
		dodoc -r recipes
	fi
}

python_test() {
        pytest --deselect 'tests/services/services_test.py::ServicesTest::test_InsightProvider' || die "Tests failed with ${EPYTHON}"
}
