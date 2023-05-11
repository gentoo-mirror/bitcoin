# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Base58 and Base58Check implementation compatible with what is used by the bitcoin network"
HOMEPAGE="https://github.com/keis/base58"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
PATCHES=(
	"${FILESDIR}"/2.1.1-test-no-benchmark.patch
)

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""
BDEPEND="
	test? (
		>=dev-python/pyhamcrest-2.0.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-4.6[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
