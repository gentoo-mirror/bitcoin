# Copyright 2010-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DB_VER="4.8"
WX_GTK_VER="2.9"

inherit db-use eutils wxwidgets

DESCRIPTION="A P2P network based digital currency."
HOMEPAGE="http://bitcoin.org/"
myP="bitcoin-${PV/_/}"
SRC_URI="mirror://sourceforge/bitcoin/${myP}-linux.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug nls selinux sse2 ssl upnp"
LANGS="de es fr it nl pt ru"

for X in ${LANGS}; do
	IUSE="$IUSE linguas_$X"
done

DEPEND="dev-libs/boost
	dev-libs/crypto++
	dev-libs/glib
	dev-libs/openssl[-bindist]
	nls? (
		sys-devel/gettext
	)
	selinux? (
		sys-libs/libselinux
	)
	upnp? (
		net-libs/miniupnpc
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")
	>=app-admin/eselect-wxwidgets-0.7-r1
	x11-libs/wxGTK:2.9[X]
	!net-p2p/bitcoin
"
RDEPEND="${DEPEND}
"
DEPEND="${DEPEND}
	>=app-shells/bash-4.1
"

S="${WORKDIR}/${myP/rc/}/src"

src_prepare() {
	cp "${FILESDIR}/bitcoin-Makefile.gentoo" "Makefile"
	if use x86 ; then
		epatch "${FILESDIR}/fix_textrel_x86.patch"
	else 
		epatch "${FILESDIR}/fix_textrel_amd64.patch"
	fi

}

src_compile() {
	local OPTS=()
	
	OPTS+=("CXXFLAGS=${CXXFLAGS}")
	OPTS+=( "LDFLAGS=${LDFLAGS}")
	
	OPTS+=("DB_CXXFLAGS=-I$(db_includedir "${DB_VER}")")
	OPTS+=("DB_LDFLAGS=-ldb_cxx-${DB_VER}")
	
	use debug&& OPTS+=(USE_DEBUG=1)
	use sse2 && OPTS+=(USE_SSE2=1)
	use ssl  && OPTS+=(USE_SSL=1)
	use upnp && OPTS+=(USE_UPNP=1)
	
	emake "${OPTS[@]}" bitcoin || die "emake bitcoin failed";
}

src_install() {
	newbin bitcoin wxbitcoin
	dosym wxbitcoin /usr/bin/bitcoin
	insinto /usr/share/pixmaps
	doins "${S}/rc/bitcoin.ico"
	make_desktop_entry ${PN} "wxBitcoin" "/usr/share/pixmaps/bitcoin.ico" "Network;P2P"
	
	if use nls; then
		einfo "Installing language files"
		for val in ${LANGS}
		do
			if use "linguas_$val"; then
				mv "../locale/$val/LC_MESSAGES/bitcoin.mo" "$val.mo" &&
				domo "$val.mo" || die "failed to install $val locale"
			fi
		done
	fi
	
	newdoc license.txt COPYING
}
