# Copyright 2010-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="An implementation of Bitcoin's Lightning Network in C"
HOMEPAGE="https://github.com/ElementsProject/lightning"
EGIT_REPO_URI="https://github.com/ElementsProject/lightning.git"
EGIT_SUBMODULES=( daemon/jsmn )
EGIT_COMMIT=ced486e727bca49175982846ac155292d3b5cac7

LICENSE="MIT CC0-1.0 GPL-2 LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/protobuf
	dev-db/sqlite
	dev-libs/libbase58
	dev-libs/libsodium
	dev-libs/libbacktrace
	dev-libs/libsecp256k1[ecdh,recovery]
	net-libs/libwally-core
"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest )
"
# FIXME: bundled deps: ccan & jsmn

src_prepare() {
	eapply "${FILESDIR}/leave-cflags-alone.patch"
	rm -r external/libwally-core
	default
}

src_configure() {
	default
	local BUNDLED_LIBS="external/libjsmn.a"
	CLIGHTNING_MAKEOPTS=(
		NO_VALGRIND=1
		DEVELOPER=
		COVERAGE=
		BOLTDIR="${WORKDIR}/does_not_exist"
		CWARNFLAGS=
		CDEBUGFLAGS="${CFLAGS}"
		LIBSODIUM_HEADERS=
		LIBBASE58_HEADERS=
		LIBWALLY_HEADERS=
		LIBSECP_HEADERS=
		EXTERNAL_LIBS="${BUNDLED_LIBS}"
		EXTERNAL_INCLUDE_FLAGS="-I external/jsmn/ $(pkg-config --cflags libbase58 libsodium wallycore libsecp256k1)"
		EXTERNAL_LDLIBS="${BUNDLED_LIBS} $(pkg-config --libs libbase58 libsodium wallycore libsecp256k1) -lbacktrace"
	)
}

src_compile() {
	emake "${CLIGHTNING_MAKEOPTS[@]}"
}

src_install() {
	emake "${CLIGHTNING_MAKEOPTS[@]}" DESTDIR="${D}" install
}
