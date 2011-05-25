# Copyright 2010-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DB_VER="4.8"
WX_GTK_VER="2.9"

inherit db-use eutils wxwidgets

DESCRIPTION="A P2P network based digital currency."
HOMEPAGE="http://bitcoin.org/"
SRC_URI="mirror://sourceforge/bitcoin/${P/_/}-linux.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="daemon debug nls selinux ssl upnp wxwidgets"
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
	wxwidgets? (
		>=app-admin/eselect-wxwidgets-0.7-r1
		x11-libs/wxGTK:2.9[X]
	)"
RDEPEND="${DEPEND}
	daemon? ( dev-util/pkgconfig )
"
DEPEND="${DEPEND}
	>=app-shells/bash-4.1
"

S="${WORKDIR}/${P/_/-}/src"

pkg_setup() {
	if use daemon || ! use wxwidgets; then
		ebegin "Creating ${PN} user and group"
		enewgroup ${PN}
		enewuser ${PN} -1 -1 /var/lib/bitcoin ${PN}
	fi;
}

src_prepare() {
	cd src
	cp "${FILESDIR}/Makefile.gentoo" "Makefile"
}

src_compile() {
	local OPTS=() dodaemon=false
	
	OPTS+=("CXXFLAGS=${CXXFLAGS}")
	OPTS+=( "LDFLAGS=${LDFLAGS}")
	
	OPTS+=("DB_CXXFLAGS=-I$(db_includedir "${DB_VER}")")
	OPTS+=("DB_LDFLAGS=-ldb_cxx-${DB_VER}")
	
	use debug&& OPTS+=(USE_DEBUG=1)
	use ssl  && OPTS+=(USE_SSL=1)
	use upnp && OPTS+=(USE_UPNP=1)
	
	cd src
	if use daemon; then
		dodaemon=true
	elif ! use wxwidgets; then
		ewarn "No daemon or wxwidgets USE flag selected, compiling daemon by default."
		dodaemon=true
	fi
	
	if $dodaemon; then
		emake "${OPTS[@]}" bitcoind || die "emake bitcoind failed";
	fi
	if use wxwidgets; then
		emake "${OPTS[@]}" bitcoin || die "emake bitcoin failed";
	fi
}

src_install() {
	if use daemon || ! use wxwidgets; then
		einfo "Installing daemon"
		dobin src/bitcoind

		insinto /etc/bitcoin
		newins "${FILESDIR}/bitcoin.conf" bitcoin.conf
		fowners bitcoin:bitcoin /etc/bitcoin/bitcoin.conf
		fperms 600 /etc/bitcoin/bitcoin.conf

		newconfd "${FILESDIR}/bitcoin.confd" bitcoind
		# Init script still nonfunctional.
		newinitd "${FILESDIR}/bitcoin.initd" bitcoind

		keepdir /var/lib/bitcoin/.bitcoin
		fperms 700 /var/lib/bitcoin
		fowners bitcoin:bitcoin /var/lib/bitcoin/
		fowners bitcoin:bitcoin /var/lib/bitcoin/.bitcoin
		dosym /etc/bitcoin/bitcoin.conf /var/lib/bitcoin/.bitcoin/bitcoin.conf
	fi
	if use wxwidgets; then
		einfo "Installing wxwidgets gui"
		newbin src/bitcoin wxbitcoin
		dosym wxbitcoin /usr/bin/bitcoin
		insinto /usr/share/pixmaps
		doins "share/pixmaps/bitcoin.ico"
		make_desktop_entry ${PN} "wxBitcoin" "/usr/share/pixmaps/bitcoin.ico" "Network;P2P"
	fi
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
	
	dodoc COPYING doc/README
}
