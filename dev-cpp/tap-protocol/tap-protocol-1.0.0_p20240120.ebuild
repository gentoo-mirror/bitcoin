# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT_HASH="d7bf3ae88f08fd2c6575a2107bef6899550da314"
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
	>=dev-libs/libsecp256k1-0.2.0:=
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
		-DUSE_EXTERNAL_SECP256K1:BOOL=ON
	)
	cmake_src_configure
}
