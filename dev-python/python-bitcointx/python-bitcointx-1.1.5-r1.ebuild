# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

MyPV=${PV/_p/.post}

DESCRIPTION="A python3 library providing an easy interface to the Bitcoin data structures"
HOMEPAGE="https://github.com/Simplexum/python-bitcointx"
SRC_URI="${HOMEPAGE}/archive/${PN}-v${MyPV}.tar.gz"
S="${WORKDIR}/${PN}-${PN}-v${MyPV}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/libsecp256k1-0.4.0
"

PATCHES=(
	"${FILESDIR}/python3_14-asyncio-fix.patch"
)

distutils_enable_tests unittest

src_prepare() {
	default

	# don't install the unit tests
	sed -e 's/\(packages=find_packages\)()/\1(exclude=["bitcointx.tests"])/' \
		-i setup.py || die
}
