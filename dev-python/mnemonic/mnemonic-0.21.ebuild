# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

MyPN="python-mnemonic"

DESCRIPTION="Mnemonic code for generating deterministic keys, BIP39"
HOMEPAGE="https://github.com/trezor/python-mnemonic"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MyPN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# hashlib.pbkdf2_hmac is available only when Python 3.12+ is built with OpenSSL
RDEPEND="
	$(python_gen_impl_dep 'ssl' python3_{12..14})
"

distutils_enable_tests unittest

python_test() {
	eunittest -s tests
}
