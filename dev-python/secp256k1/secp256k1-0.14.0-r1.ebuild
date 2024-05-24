# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Python FFI bindings for libsecp256k1"
COMMIT_HASH="0ce2ec5e423b9e1b5d135eba9061cbb81140751c"
HOMEPAGE="https://github.com/rustyrussell/secp256k1-py https://pypi.org/project/secp256k1/"
SRC_URI+="
	test? ( https://github.com/rustyrussell/secp256k1-py/archive/${COMMIT_HASH}.tar.gz -> ${P}-tests.tar.gz )
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/libsecp256k1:="
DEPEND="${RDEPEND}"

distutils_enable_tests pytest

src_unpack() {
	default
	! use test || mv "${PN}-py-${COMMIT_HASH}/tests" "${S}/tests" || die
}

src_prepare() {
	default

	# re-enable usage of system-installed libsecp256k1.so
	sed -e '/^def has_system_lib():$/,$ s/^\([[:space:]]\+return \)False/\1_has_system_lib/' \
		-i setup_support.py || die
}

src_test() {
	# awkward hack to help Python find the shared library beneath ${BUILD_DIR}/install
	# instead of trying and failing to find it in ${S}/secp256k1
	mv -T secp256k1{,~} || die
	distutils-r1_src_test
	mv -T secp256k1{~,} || die
}
