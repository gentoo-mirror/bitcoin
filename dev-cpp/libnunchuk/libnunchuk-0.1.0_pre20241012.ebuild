# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools cmake

COMMIT_HASH="4c8e43cab5a5c0ff66c3b12e02d8b68bb4a59c4b"
BITCOIN_CORE_PV="22.0"
TREZOR_FIRMWARE_COMMIT_HASH="b957dfbddb4222c5f9e573f3d4dc21fcbc6ff3a9"
DESCRIPTION="C++ multisig library powered by Bitcoin Core"
HOMEPAGE="https://github.com/nunchuk-io/libnunchuk"
SRC_URI="
	${HOMEPAGE}/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz
	https://github.com/bitcoin/bitcoin/archive/refs/tags/v${BITCOIN_CORE_PV}.tar.gz -> bitcoin-core-${BITCOIN_CORE_PV}.tar.gz
	https://github.com/trezor/trezor-firmware/archive/${TREZOR_FIRMWARE_COMMIT_HASH}.tar.gz -> trezor-firmware-${TREZOR_FIRMWARE_COMMIT_HASH}.tar.gz
"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	>=dev-db/sqlcipher-4.4.1:=
	>=dev-cpp/bbqr-cpp-0_pre20240319:=
	>=dev-cpp/bc-ur-cpp-0.1.0_pre20210208:=
	>=dev-cpp/tap-protocol-1.0.0_p20231114:=
	>=dev-libs/bc-ur-0.3.0:=
	>=dev-libs/boost-1.47.0:=
	dev-libs/libevent:=
	>=dev-libs/libsecp256k1-0.2.0:=[ecdh,recovery,schnorr]
	>=dev-libs/openssl-1.1.1j:=
"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/syslibs.patch"
)

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}/contrib" || die
	rmdir bitcoin trezor-firmware || die
	unpack "bitcoin-core-${BITCOIN_CORE_PV}.tar.gz" "trezor-firmware-${TREZOR_FIRMWARE_COMMIT_HASH}.tar.gz"
	mv "bitcoin-${BITCOIN_CORE_PV}" bitcoin || die
	mv "trezor-firmware-${TREZOR_FIRMWARE_COMMIT_HASH}" trezor-firmware || die
	rm -r bitcoin/src/secp256k1 || die
}

src_prepare() {
	cmake_src_prepare

	cd "${S}/contrib/bitcoin" || die
	eapply "${FILESDIR}/bitcoin-syslibs.patch"
	eautoreconf
}

src_configure() {
	cmake_src_configure

	cd "${S}/contrib/bitcoin" || die
	econf --disable-wallet --disable-ebpf --disable-tests --disable-bench --disable-fuzz{,-binary} --disable-zmq --disable-external-signer --without-sqlite --without-bdb --without-miniupnpc --without-natpmp --without-libs --without-gui
}
