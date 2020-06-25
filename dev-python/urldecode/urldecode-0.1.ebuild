# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7,3_8} )

inherit python-r1

COMMIT_HASH="7c9030fe3b39b02c1598b86bacddf174a0ad9f5f"
DESCRIPTION="A simple function to decode an encoded URL"
HOMEPAGE="https://github.com/jennyq/urldecode"
SRC_URI="${HOMEPAGE}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
BDEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${COMMIT_HASH}"

src_install() {
	python_foreach_impl python_domodule url_decode.py
	dodoc README
}
