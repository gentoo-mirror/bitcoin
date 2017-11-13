# Copyright 2010-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"
BITCOINCORE_COMMITHASH="3751912e8e044958d5ccea847a3f8eab0b026dc1"
KNOTS_PV="${PV}.knots20170914"
KNOTS_P="${MyPN}-${KNOTS_PV}"

IUSE="+asm libressl"

DESCRIPTION="Bitcoin Core consensus library"
HOMEPAGE="http://bitcoincore.org/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"

SRC_URI="
	https://github.com/${MyPN}/${MyPN}/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> ${MyPN}-v${PV}.tar.gz
	http://bitcoinknots.org/files/0.15.x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
"
KNOTS_PATCH_DESC="http://bitcoinknots.org/files/0.15.x/${KNOTS_PV}/${KNOTS_P}.desc.html"

RDEPEND="
	!libressl? ( dev-libs/openssl:0[-bindist] ) libressl? ( dev-libs/libressl )
	>=dev-libs/libsecp256k1-0.0.0_pre20151118[recovery]
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
	sys-apps/sed
"

DOCS="doc/README.md doc/release-notes.md"

S="${WORKDIR}/${MyPN}-${BITCOINCORE_COMMITHASH}"

KNOTS_PATCH() { echo "${WORKDIR}/${KNOTS_P}.patches/${KNOTS_P}.$@.patch"; }

src_prepare() {
	epatch "$(KNOTS_PATCH syslibs)"

	eapply_user

	echo '#!/bin/true' >share/genbuild.sh
	mkdir -p src/obj
	echo "#define BUILD_SUFFIX gentoo${PVR#${PV}}" >src/obj/build.h

	eautoreconf
	rm -r src/leveldb src/secp256k1 || die
}

src_configure() {
	local my_econf=(
		--disable-tests
		--with-libs
		--disable-util-cli --disable-util-tx --disable-bench --without-daemon --without-gui
		--disable-ccache --disable-static
		--with-system-libsecp256k1
	)
	econf "${my_econf[@]}"
}

src_install() {
	default

	rm "${D}/usr/bin/test_bitcoin"

	dodoc doc/bips.md
	find "${D}" -name '*.la' -delete || die
}
