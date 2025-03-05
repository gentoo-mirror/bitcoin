# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools cmake

COMMIT_HASH="d5cf50ed2babd60015b4068bbd5cfad5c0b48608"
BITCOIN_CORE_COMMIT_HASH="57b47c47ef0bd36e1c32d709c62998c51dc76f34"  # https://github.com/bitcoin/bitcoin/pull/29675
TREZOR_FIRMWARE_COMMIT_HASH="b957dfbddb4222c5f9e573f3d4dc21fcbc6ff3a9"
DESCRIPTION="C++ multisig library powered by Bitcoin Core"
HOMEPAGE="https://github.com/nunchuk-io/libnunchuk"
SRC_URI="
	${HOMEPAGE}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz
	https://github.com/bitcoin/bitcoin/archive/${BITCOIN_CORE_COMMIT_HASH}.tar.gz -> bitcoin-core-${BITCOIN_CORE_COMMIT_HASH}.tar.gz
	https://github.com/trezor/trezor-firmware/archive/${TREZOR_FIRMWARE_COMMIT_HASH}.tar.gz -> trezor-firmware-${TREZOR_FIRMWARE_COMMIT_HASH}.tar.gz
"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-db/sqlcipher-4.4.1:=
	>=dev-cpp/bbqr-cpp-0_pre20241203:=
	>=dev-cpp/bc-ur-cpp-0.1.0_pre20210208:=
	>=dev-cpp/tap-protocol-1.0.0_p20250218:=
	>=dev-libs/bc-ur-0.3.0-r1:=
	>=dev-libs/boost-1.47.0:=
	dev-libs/libevent:=
	>=dev-libs/libsecp256k1-0.2.0:=[ecdh,ellswift,musig,recovery,schnorr]
	>=dev-libs/openssl-1.1.1j:=
"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/syslibs.patch"
	"${FILESDIR}/compat-boost-1.87.patch"
)

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}/contrib" || die
	rm -r sqlite || die
	rmdir bitcoin trezor-firmware || die
	unpack "bitcoin-core-${BITCOIN_CORE_COMMIT_HASH}.tar.gz" "trezor-firmware-${TREZOR_FIRMWARE_COMMIT_HASH}.tar.gz"
	mv "bitcoin-${BITCOIN_CORE_COMMIT_HASH}" bitcoin || die
	mv "trezor-firmware-${TREZOR_FIRMWARE_COMMIT_HASH}" trezor-firmware || die
	rm -r bitcoin/src/secp256k1 || die
}

src_prepare() {
	cmake_src_prepare

	cd "${S}/contrib/bitcoin" || die
	eapply "${FILESDIR}/bitcoin-syslibs.patch"
}

src_configure() {
	local mycmakeargs=(
		-DWITH_CCACHE=OFF
	)
	cmake_src_configure
}
