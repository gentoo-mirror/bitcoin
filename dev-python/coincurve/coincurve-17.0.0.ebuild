# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Cross-platform Python CFFI bindings for libsecp256k1"
HOMEPAGE="https://github.com/ofek/coincurve"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="
	>=dev-libs/libsecp256k1-0.1_pre20220127[ecdh,recovery]
	>=dev-python/cffi-1.3.0[${PYTHON_USEDEP}]
"
RDEPEND="${CDEPEND}
	dev-python/asn1crypto[${PYTHON_USEDEP}]
"
DEPEND="${CDEPEND}"
BDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	default

	# prevent dependency download
	mkdir -p libsecp256k1
}

python_test() {
	local EPYTEST_IGNORE=(
		test_bench.py
	)
	# awkward hack to help Python find the shared library
	cd tests || die
	epytest --import-mode=append
}
