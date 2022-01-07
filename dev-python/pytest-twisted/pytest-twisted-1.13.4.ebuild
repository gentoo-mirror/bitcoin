# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

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
"
DEPEND=""
BDEPEND=""

distutils_enable_tests --install pytest

src_prepare() {
	# https://github.com/pytest-dev/pytest-twisted/issues/146
	use python_targets_python3_10 &&
		eapply "${FILESDIR}/1.13.4-python3_10-ignore-deprecated-currentThread.patch"

	default
}
