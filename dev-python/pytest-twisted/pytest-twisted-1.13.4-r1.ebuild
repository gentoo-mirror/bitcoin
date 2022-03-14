# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Test twisted code with pytest"
HOMEPAGE="https://github.com/pytest-dev/pytest-twisted"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	>=dev-python/pytest-2.3[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
"
DEPEND=""
BDEPEND=""

distutils_enable_tests pytest

src_prepare() {
	# https://github.com/pytest-dev/pytest-twisted/issues/146
	use python_targets_python3_10 &&
		eapply "${FILESDIR}/1.13.4-python3_10-ignore-deprecated-currentThread.patch"

	# https://github.com/pytest-dev/pytest/issues/9280
	sed -e '/^pytest_plugins =/d' -i testing/conftest.py || die

	default
}

python_test() {
	distutils_install_for_testing
	epytest -p pytester
}

src_install() {
	# If we let pytest-twisted autoload everywhere, it breaks tests in
	# packages that don't expect it. Apply a similar hack as for bug
	# #661218. We can't do this in src_prepare() because the tests need
	# autoloading enabled.
	sed -e 's/"pytest11": \[[^]]*\]//' -i setup.py || die

	distutils-r1_src_install
}
