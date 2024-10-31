# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT_HASH="c265130b7884fc944c2381bcf79b5aad2c01a258"
DESCRIPTION="A C++ implementation of BCR-0004 and BCR-0005"
HOMEPAGE="https://github.com/nunchuk-io/bc-ur-cpp"
SRC_URI="${HOMEPAGE}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-cpp/doctest )
"

PATCHES=(
	"${FILESDIR}/install.patch"
)

src_prepare() {
	! use test || ln -sfn -- "${EROOT}/usr/include/doctest/doctest.h" tests/src/ || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUR__DISABLE_TESTS:BOOL=$(usex !test)
	)
	cmake_src_configure
}
