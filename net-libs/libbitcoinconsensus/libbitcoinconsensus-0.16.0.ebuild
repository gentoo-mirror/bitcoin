# Copyright 2010-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"
BITCOINCORE_COMMITHASH="4b4d7eb255ca8f9a94b92479e6061d129c91a991"
KNOTS_PV="${PV}.knots20180322"
KNOTS_P="${MyPN}-${KNOTS_PV}"

IUSE="+asm +knots libressl"

DESCRIPTION="Bitcoin Core consensus library"
HOMEPAGE="https://bitcoincore.org/ https://bitcoinknots.org/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"

SRC_URI="
	https://github.com/${MyPN}/${MyPN}/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> ${MyPN}-v${PV}.tar.gz
	https://bitcoinknots.org/files/0.16.x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
"
CORE_DESC="https://bitcoincore.org/en/2017/11/11/release-${PV}/"
KNOTS_DESC="https://bitcoinknots.org/files/0.16.x/${KNOTS_PV}/${KNOTS_P}.desc.html"

RDEPEND="
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	>=dev-libs/libsecp256k1-0.0.0_pre20151118[recovery]
"
DEPEND="${RDEPEND}"

DOCS=( doc/bips.md doc/release-notes.md doc/shared-libraries.md )

S="${WORKDIR}/${MyPN}-${BITCOINCORE_COMMITHASH}"

pkg_pretend() {
	if use knots; then
		einfo "You are building ${PN} from Bitcoin Knots."
		einfo "For more information, see ${KNOTS_DESC}"
	else
		einfo "You are building ${PN} from Bitcoin Core."
		einfo "For more information, see ${CORE_DESC}"
	fi
}

KNOTS_PATCH() { echo "${WORKDIR}/${KNOTS_P}.patches/${KNOTS_P}.$@.patch"; }

src_prepare() {
	eapply "$(KNOTS_PATCH syslibs)"

	if use knots; then
		eapply "$(KNOTS_PATCH f)"
		eapply "$(KNOTS_PATCH branding)"
		eapply "$(KNOTS_PATCH ts)"
	fi

	eapply_user

	echo '#!/bin/true' >share/genbuild.sh || die
	mkdir -p src/obj || die
	echo "#define BUILD_SUFFIX gentoo${PVR#${PV}}" >src/obj/build.h || die

	eautoreconf
	rm -r src/leveldb src/secp256k1 || die
}

src_configure() {
	local my_econf=(
		$(use_enable asm)
		--without-qtdbus
		--without-libevent
		--without-qrencode
		--without-miniupnpc
		--disable-tests
		--disable-wallet
		--disable-zmq
		--with-libs
		--disable-util-cli
		--disable-util-tx
		--disable-bench
		--without-daemon
		--without-gui
		--disable-ccache
		--disable-static
		--with-system-libsecp256k1
	)
	econf "${my_econf[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
