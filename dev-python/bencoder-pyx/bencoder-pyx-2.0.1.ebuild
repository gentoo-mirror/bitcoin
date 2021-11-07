# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5..10} )

inherit distutils-r1

MyPN="${PN/-/.}"

DESCRIPTION="A fast bencode implementation in Cython"
HOMEPAGE="https://github.com/whtsky/bencoder.pyx"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""
BDEPEND="
	>=dev-python/cython-0.29.21[${PYTHON_USEDEP}]
	test? (
		>=dev-python/coverage-4.5.4[${PYTHON_USEDEP}]
		>=dev-python/pytest-4.6.2[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MyPN}-${PV}"

distutils_enable_tests pytest
