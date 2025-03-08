# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=hatchling
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="Cross-platform Python CFFI bindings for libsecp256k1"
HOMEPAGE="https://github.com/ofek/coincurve"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=dev-libs/libsecp256k1-0.6.0:=[ecdh,extrakeys,recovery,schnorr]
"
RDEPEND="${DEPEND}
	>=dev-python/cffi-1.3.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-build/cmake-3.26
	dev-python/cffi[${PYTHON_USEDEP}]
	>=dev-python/hatchling-1.24.2[${PYTHON_USEDEP}]
	dev-python/pypkgconf[${PYTHON_USEDEP}]
	>=dev-python/scikit-build-core-0.9.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	default
	sed -e '/^\[tool\.hatch\.build\.targets\.wheel\.hooks\.custom\]$/d' -i pyproject.toml || die
}

src_compile() {
	local -x COINCURVE_IGNORE_SYSTEM_LIB=0 COINCURVE_VENDOR_CFFI=0
	distutils-r1_src_compile
}

python_test() {
	# https://projects.gentoo.org/python/guide/test.html#importerrors-for-c-extensions
	rm -rf coincurve || die

	local EPYTEST_IGNORE=(
		tests/test_bench.py
	)
	distutils-r1_python_test
}
