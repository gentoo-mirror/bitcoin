# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Enhance Python with colored logging"
HOMEPAGE="https://github.com/freelan-developers/chromalog"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"  # unreasonable dependencies for such a simple package

RDEPEND="
	>=dev-python/colorama-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/future-0.14.3[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
"
DEPEND=""
BDEPEND=""
