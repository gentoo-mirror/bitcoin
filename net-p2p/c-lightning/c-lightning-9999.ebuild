# Copyright 2010-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="An implementation of Bitcoin's Lightning Network in C"
HOMEPAGE="https://github.com/ElementsProject/lightning"
EGIT_REPO_URI="https://github.com/ElementsProject/lightning.git"
EGIT_SUBMODULES=( daemon/jsmn )

LICENSE="MIT CC0-1.0 GPL-2 LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	dev-libs/protobuf
	dev-db/sqlite
	dev-libs/libbase58
	dev-libs/libsodium
	dev-libs/libbacktrace
"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest )
"
# FIXME: bundled deps: ccan & jsmn
# FIXME: system libwally-core and libsecp256k1 (needs zkp libsecp256k1 mess)

src_prepare() {
	eapply "${FILESDIR}/leave-cflags-alone.patch"
	default
}

src_configure() {
	default
	local BUNDLED_LIBS="external/libwallycore.a external/libsecp256k1.a external/libjsmn.a"
	CLIGHTNING_MAKEOPTS=(
		NO_VALGRIND=1
		DEVELOPER=
		COVERAGE=
		BOLTDIR="${WORKDIR}/does_not_exist"
		CWARNFLAGS=
		CDEBUGFLAGS="${CFLAGS}"
		LIBSODIUM_HEADERS=
		LIBBASE58_HEADERS=
		EXTERNAL_LIBS="${BUNDLED_LIBS}"
		EXTERNAL_INCLUDE_FLAGS="-I external/libwally-core/include/ -I external/libwally-core/src/secp256k1/include/ -I external/jsmn/ $(pkg-config --cflags libbase58 libsodium)"
		EXTERNAL_LDLIBS="${BUNDLED_LIBS} $(pkg-config --libs libbase58 libsodium) -lbacktrace"
	)
}

src_compile() {
	emake "${CLIGHTNING_MAKEOPTS[@]}"
}

src_install() {
	emake "${CLIGHTNING_MAKEOPTS[@]}" DESTDIR="${D}" install
}
