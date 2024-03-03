# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit distutils-r1

DESCRIPTION="Cross-platform Python CFFI bindings for libsecp256k1"
HOMEPAGE="https://github.com/ofek/coincurve"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-libs/libsecp256k1-0.4.1:=[ecdh,extrakeys,recovery,schnorr]
	>=dev-python/cffi-1.3.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	dev-python/asn1crypto[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	default

	# upstream logic is broken when pkg-config returns no flags/dirs
	sed -e 's/^\(_has_system_lib\s*=\s*\).*$/\1True/' -i setup_support.py || die
	sed -e '/^\s*extension\.extra_\w\+_args\s*=\s*\[$/{s/$/a for a in [/;:0;n;/^\s*\]$/!b0;s/$/ if a]/}' \
		-i setup.py || die
}

python_test() {
	# https://projects.gentoo.org/python/guide/test.html#importerrors-for-c-extensions
	rm -rf coincurve || die

	local EPYTEST_IGNORE=(
		tests/test_bench.py
	)
	distutils-r1_python_test
}
