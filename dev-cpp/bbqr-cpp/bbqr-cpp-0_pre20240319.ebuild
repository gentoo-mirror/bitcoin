# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT_HASH="56b59c19ad1ab419cf8b2beac07a3d9c8c667db2"
DESCRIPTION="Encodes larger files into a series of QR codes so they can cross air gaps"
HOMEPAGE="https://github.com/nunchuk-io/bbqr-cpp"
SRC_URI="${HOMEPAGE}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=sys-libs/zlib-1.3.1:=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/install.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBBQR_BUILD_EXAMPLES:BOOL=OFF
	)
	cmake_src_configure
}
