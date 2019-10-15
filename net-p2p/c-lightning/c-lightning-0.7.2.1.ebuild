# Copyright 2010-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_5,3_6,3_7} )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 toolchain-funcs user

MyPN=lightning

DESCRIPTION="An implementation of Bitcoin's Lightning Network in C"
HOMEPAGE="https://github.com/ElementsProject/${MyPN}"
SRC_URI="https://github.com/ElementsProject/${MyPN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/zserge/jsmn/archive/v1.0.0.tar.gz -> jsmn-1.0.0.tar.gz"

LICENSE="MIT CC0-1.0 GPL-2 LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
IUSE="developer experimental python test"

RDEPEND="
	acct-group/lightning
	acct-user/lightning
	dev-db/sqlite
	>=dev-libs/libbacktrace-0.0.0_pre20180606
	>=dev-libs/libsecp256k1-0.1_pre20181017[ecdh,recovery]
	>=dev-libs/libsodium-1.0.16
	>=net-libs/libwally-core-0.7.4
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	dev-python/mako
	test? ( dev-python/pytest )
	python? ( dev-python/setuptools[${PYTHON_USEDEP}] )
"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"
# FIXME: bundled deps: ccan

S=${WORKDIR}/${MyPN}-${PV}

src_unpack() {
	unpack "${P}.tar.gz"
	rm -r "${S}/external"/*/
	cd "${S}/external" || die
	unpack jsmn-1.0.0.tar.gz
	mv jsmn{-1.0.0,}
}

src_prepare() {
	default

	if use python ; then
		pushd contrib/pylightning >/dev/null || die
		distutils-r1_src_prepare
		popd >/dev/null || die
	fi
}

src_configure() {
	local BUNDLED_LIBS="external/libjsmn.a"
	CLIGHTNING_MAKEOPTS=(
		VERSION="${PV}"
		DISTRO=Gentoo
		COVERAGE=
		BOLTDIR="${WORKDIR}/does_not_exist"
		CWARNFLAGS=
		CDEBUGFLAGS="${CFLAGS}"
		LIBSODIUM_HEADERS=
		LIBWALLY_HEADERS=
		LIBSECP_HEADERS=
		SUBMODULES=none
		CC="$(tc-getCC)"
		CONFIGURATOR_CC="$(tc-getBUILD_CC)"
		EXTERNAL_LIBS="${BUNDLED_LIBS}"
		EXTERNAL_INCLUDE_FLAGS="-I external/jsmn/ $("$(tc-getPKG_CONFIG)" --cflags libsodium wallycore libsecp256k1)"
		EXTERNAL_LDLIBS="${BUNDLED_LIBS} $("$(tc-getPKG_CONFIG)" --libs libsodium wallycore libsecp256k1) -lbacktrace"
		docdir="/usr/share/doc/${P}"
	)
	use test || CLIGHTNING_MAKEOPTS+=( all-programs )

	./configure \
		--prefix="${EPREFIX}"/usr \
		$(use_enable developer) \
		$(use_enable experimental{,-features}) \
		--disable-compat \
		--disable-valgrind \
		--disable-static \
		--disable-address-sanitizer

	# hack to suppress tools/refresh-submodules.sh
	mkdir .refresh-submodules

	if use python ; then
		pushd contrib/pylightning >/dev/null || die
		distutils-r1_src_configure
		popd >/dev/null || die
	fi
}

src_compile() {
	emake "${CLIGHTNING_MAKEOPTS[@]}"

	if use python ; then
		pushd contrib/pylightning >/dev/null || die
		distutils-r1_src_compile
		popd >/dev/null || die
	fi
}

src_install() {
	emake "${CLIGHTNING_MAKEOPTS[@]}" DESTDIR="${D}" install

	insinto /etc/lightning
	doins "${FILESDIR}/config"

	newinitd "${FILESDIR}/init.d-lightningd" lightningd
	newconfd "${FILESDIR}/conf.d-lightningd" lightningd

	if use python ; then
		pushd contrib/pylightning >/dev/null || die
		distutils-r1_src_install
		popd >/dev/null || die
	fi
}

pkg_postinst() {
	elog 'To use lightning-cli with the /etc/init.d/lightningd service:'
	elog " - Add your user(s) to the 'lightning' group."
	elog ' - Symlink ~/.lightning to /var/lib/lightning.'
}
