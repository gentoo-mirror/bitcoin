# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT_HASH="90e1d6b9bdb2b86097ddd09213bac1f3e3efbf94"
DESCRIPTION="Coinkite Tap Protocol"
HOMEPAGE="https://github.com/nunchuk-io/tap-protocol"
SRC_URI="${HOMEPAGE}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
# the tests seem to require some sockets of external daemons
RESTRICT="test"

RDEPEND="
	dev-cpp/nlohmann_json:=
	>=dev-libs/libsecp256k1-0.4.0:=
"
DEPEND="${RDEPEND}
	test? ( >=dev-libs/boost-1.47.0 )
"

PATCHES=(
	"${FILESDIR}/gentoo.patch"
)

src_prepare() {
	rm -r contrib/{bitcoin-core/src/secp256k1,include/nlohmann} || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIB_TAPPROTOCOL:BOOL=ON
		-DBUILD_TESTING:BOOL=$(usex test)
	)
	cmake_src_configure
}
