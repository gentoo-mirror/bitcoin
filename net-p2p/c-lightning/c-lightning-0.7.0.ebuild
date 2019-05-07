# Copyright 2010-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs user

MyPN=lightning

DESCRIPTION="An implementation of Bitcoin's Lightning Network in C"
HOMEPAGE="https://github.com/ElementsProject/${MyPN}"
SRC_URI="https://github.com/ElementsProject/${MyPN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/zserge/jsmn/archive/v1.0.0.tar.gz -> jsmn-1.0.0.tar.gz"

LICENSE="MIT CC0-1.0 GPL-2 LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
IUSE="test"

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
	sys-apps/sed
"
# FIXME: bundled deps: ccan

S=${WORKDIR}/${MyPN}-${PV}

pkg_setup() {
	enewgroup lightning
	enewuser lightning -1 /sbin/nologin /var/lib/lightning lightning
}

src_unpack() {
	unpack "${P}.tar.gz"
	rm -r "${S}/external"/*/
	cd "${S}/external" || die
	unpack jsmn-1.0.0.tar.gz
	mv jsmn{-1.0.0,}
}

src_prepare() {
	sed -e '/configdir_register_opts(.*&lightning_dir,/a\	lightning_dir = tal_strdup(ctx, "/var/lib/lightning");' -i cli/lightning-cli.c
	default
}

src_configure() {
	local BUNDLED_LIBS="external/libjsmn.a"
	CLIGHTNING_MAKEOPTS=(
		VERSION="${PV}"
		DISTRO=Gentoo
		DEVELOPER=
		COVERAGE=
		BOLTDIR="${WORKDIR}/does_not_exist"
		CWARNFLAGS=
		CDEBUGFLAGS="${CFLAGS}"
		LIBSODIUM_HEADERS=
		LIBBASE58_HEADERS=
		LIBWALLY_HEADERS=
		LIBSECP_HEADERS=
		SUBMODULES=none
		CC="$(tc-getCC)"
		CONFIGURATOR_CC="$(tc-getBUILD_CC)"
		EXTERNAL_LIBS="${BUNDLED_LIBS}"
		EXTERNAL_INCLUDE_FLAGS="-I external/jsmn/ $("$(tc-getPKG_CONFIG)" --cflags libbase58 libsodium wallycore libsecp256k1)"
		EXTERNAL_LDLIBS="${BUNDLED_LIBS} $("$(tc-getPKG_CONFIG)" --libs libbase58 libsodium wallycore libsecp256k1) -lbacktrace"
		docdir="/usr/share/doc/${P}"
	)
	use test || CLIGHTNING_MAKEOPTS+=( all-programs )

	./configure \
		--prefix="${EPREFIX}"/usr \
		--disable-developer \
		--disable-experimental-features \
		--disable-compat \
		--disable-valgrind \
		--disable-static \
		--disable-address-sanitizer

	# hack to suppress tools/refresh-submodules.sh
	mkdir .refresh-submodules
}

src_compile() {
	emake "${CLIGHTNING_MAKEOPTS[@]}"
}

src_install() {
	emake "${CLIGHTNING_MAKEOPTS[@]}" DESTDIR="${D}" install

	keepdir /var/lib/lightning
	fowners lightning:lightning /var/lib/lightning

	insinto /etc/lightning
	doins "${FILESDIR}/config"

	newinitd "${FILESDIR}/init.d-lightningd" lightningd
	newconfd "${FILESDIR}/conf.d-lightningd" lightningd
}

pkg_postinst() {
	elog "You must add your user(s) to the 'lightning' group to use lightning-cli"
	elog "with the /etc/init.d/lightningd service."
}
