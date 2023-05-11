# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="A mkdocs plugin that lets you exclude files or trees from your output."
HOMEPAGE="https://github.com/apenwarr/mkdocs-exclude https://pypi.org/project/mkdocs-exclude/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
IUSE=""
