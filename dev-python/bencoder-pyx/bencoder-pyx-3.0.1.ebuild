# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

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
	>=dev-python/cython-0.29.32[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-7.2.0[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${MyPN}-${PV}"

distutils_enable_tests pytest
