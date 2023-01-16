# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Write man pages using Markdown, and convert them to Roff or HTML"
HOMEPAGE="https://github.com/refi64/mrkd"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/jinja-2[${PYTHON_USEDEP}]
		<dev-python/mistune-2[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
	')
"
DEPEND=""
BDEPEND=""
