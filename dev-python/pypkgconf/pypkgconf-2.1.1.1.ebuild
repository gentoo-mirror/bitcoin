# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=meson-python
DISTUTILS_EXT=1

inherit distutils-r1 pypi toolchain-funcs

PKGCONF_PV="$(ver_cut 1-3)"
DESCRIPTION="Python bindings to libpkgconf"
HOMEPAGE="https://gitlab.com/optelgroup-public/pypkgconf https://pypi.org/project/pypkgconf/"
SRC_URI+="
	test? ( https://distfiles.ariadne.space/pkgconf/pkgconf-${PKGCONF_PV}.tar.xz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"

DEPEND="
	>=dev-util/pkgconf-2.1.1:=
"
RDEPEND="${DEPEND}
	dev-python/cffi[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-build/meson-1.1.0
	dev-python/cffi[${PYTHON_USEDEP}]
	>=dev-python/meson-python-0.13.2[${PYTHON_USEDEP}]
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/2.1.1.1-use-system-libpkgconf.patch"
	"${FILESDIR}/2.1.1.1-fix-test_provides.patch"
	"${FILESDIR}/2.1.1.1-skip-broken-test-on-Python-3.12.patch"
)

distutils_enable_tests pytest

src_unpack() {
	unpack "${P}.tar.gz"

	if use test ; then
		cd "${S}/subprojects" || die
		unpack "pkgconf-${PKGCONF_PV}.tar.xz"
	fi
}

src_prepare() {
	sed -e 's/\r$//' -i meson.build tests/test_{parser,provides}.py || die  # DOS line endings?!
	default
}

python_test() {
	# https://projects.gentoo.org/python/guide/test.html#importerrors-for-c-extensions
	rm -rf pypkgconf || die

	if has_version '>=dev-util/pkgconf-2.2' ; then
		local EPYTEST_DESELECT=(
			'tests/test_basic.py::test_libs_circular_directpc'  # 2.2 chooses a different order
			'tests/test_regress.py::test_virtual_variable'  # fails for unknown reason (regression?)
			'tests/test_requires.py::test_libs_static'  # 2.2 omits a redundant -L option
			'tests/test_requires.py::test_libs_static_pure'  # 2.2 omits a redundant -L option
			'tests/test_requires.py::test_private_duplication'  # 2.2 omits a redundant -l option
		)
	fi
	local -x PKG_DEFAULT_PATH="$("$(tc-getPKG_CONFIG)" --variable=pc_path pkg-config)"
	distutils-r1_python_test
}
