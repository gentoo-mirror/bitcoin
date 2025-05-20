# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 edo pypi

DESCRIPTION="HMAC-based Extract-and-Expand Key Derivation Function (HKDF) implemented in Python"
HOMEPAGE="https://github.com/casebeer/python-hkdf https://pypi.org/project/hkdf/"
SRC_URI+="
	test? ( https://github.com/casebeer/python-hkdf/raw/cc3c9dbf0a271b27a7ac5cd04cc1485bbc3b4307/tests.py -> ${P}-tests.py )
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_unpack() {
	unpack "${P}.tar.gz"
	! use test || cp "${DISTDIR}/${P}-tests.py" "${S}/tests.py" || die
}

python_test() {
	edo "${PYTHON}" -m tests
}
