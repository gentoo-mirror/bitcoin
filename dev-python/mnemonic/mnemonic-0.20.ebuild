# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

MyPN="python-mnemonic"

DESCRIPTION="Mnemonic code for generating deterministic keys, BIP39"
HOMEPAGE="https://github.com/trezor/python-mnemonic"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""
BDEPEND=""

S="${WORKDIR}/${MyPN}-${PV}"

distutils_enable_tests unittest

python_test() {
	eunittest -s tests
}
