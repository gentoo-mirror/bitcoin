# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="HMAC-based Extract-and-Expand Key Derivation Function (HKDF) implemented in Python"
HOMEPAGE="https://github.com/casebeer/python-hkdf https://pypi.org/project/hkdf/"
SRC_URI+="
	test? ( https://github.com/casebeer/python-hkdf/raw/cc3c9dbf0a271b27a7ac5cd04cc1485bbc3b4307/tests.py -> ${P}-tests.py )
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests nose

src_unpack() {
	unpack "${P}.tar.gz"
	! use test || cp "${DISTDIR}/${P}-tests.py" "${S}/tests.py" || die
}

python_test() {
	distutils-r1_python_test tests.py
}