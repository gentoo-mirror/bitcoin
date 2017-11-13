# Copyright 2010-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools bash-completion-r1

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"
BITCOINCORE_COMMITHASH="3751912e8e044958d5ccea847a3f8eab0b026dc1"
KNOTS_PV="${PV}.knots20170914"
KNOTS_P="${MyPN}-${KNOTS_PV}"

IUSE="+knots libressl"

DESCRIPTION="Command-line Bitcoin transaction tool"
HOMEPAGE="http://bitcoincore.org/ http://bitcoinknots.org/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"

SRC_URI="
	https://github.com/${MyPN}/${MyPN}/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> ${MyPN}-v${PV}.tar.gz
	http://bitcoinknots.org/files/0.15.x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
"
CORE_DESC="https://bitcoincore.org/en/2017/09/01/release-${PV}/"
KNOTS_DESC="http://bitcoinknots.org/files/0.15.x/${KNOTS_PV}/${KNOTS_P}.desc.html"

RDEPEND="
	!libressl? ( dev-libs/openssl:0[-bindist] ) libressl? ( dev-libs/libressl )
	>=dev-libs/libsecp256k1-0.0.0_pre20151118[recovery]
	dev-libs/univalue
	>=dev-libs/boost-1.52.0[threads(+)]
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
"

DOCS="doc/bips.md doc/release-notes.md"

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

	echo '#!/bin/true' >share/genbuild.sh
	mkdir -p src/obj
	echo "#define BUILD_SUFFIX gentoo${PVR#${PV}}" >src/obj/build.h

	eautoreconf
	rm -r src/leveldb src/secp256k1 || die
}

src_configure() {
	local my_econf=(
		--disable-tests
		--enable-util-tx
		--disable-util-cli --disable-bench --without-libs --without-daemon --without-gui
		--disable-ccache --disable-static
		--with-system-libsecp256k1
		--with-system-univalue
	)
	econf "${my_econf[@]}"
}

src_install() {
	default

	newbashcomp contrib/${PN}.bash-completion ${PN}
}
