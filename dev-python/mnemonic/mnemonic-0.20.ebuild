# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5..10} )

inherit distutils-r1

MyPN="python-mnemonic"

DESCRIPTION="Mnemonic code for generating deterministic keys, BIP39"
HOMEPAGE="https://github.com/trezor/python-mnemonic"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND=""
BDEPEND=""

S="${WORKDIR}/${MyPN}-${PV}"

python_test() {
	python tests/test_mnemonic.py || die 'test failed'
}
