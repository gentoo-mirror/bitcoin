# Copyright 2010-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DB_VER="4.8"
WX_GTK_VER="2.9"

inherit db-use eutils git wxwidgets

DESCRIPTION="A P2P network based digital currency."
HOMEPAGE="http://bitcoin.org/"
EGIT_REPO_URI="https://github.com/bitcoin/bitcoin.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="daemon debug nls selinux sse2 ssl upnp wxwidgets"
LANGS="de es fr it nl"

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

pkg_setup() {
	if use daemon || ! use wxwidgets; then
		ebegin "Creating ${PN} user and group"
		enewgroup ${PN}
		enewuser ${PN} -1 -1 /var/lib/bitcoin ${PN}
	fi;
}

src_prepare() {
	cp "${FILESDIR}/${PN}-Makefile.gentoo" "Makefile"
}

src_compile() {
	local OPTS=() dodaemon=false
	
	OPTS+=("CXXFLAGS=${CXXFLAGS}")
	OPTS+=( "LDFLAGS=${LDFLAGS}")
	
	OPTS+=("DB_CXXFLAGS=-I$(db_includedir "${DB_VER}")")
	OPTS+=("DB_LDFLAGS=-ldb_cxx-${DB_VER}")
	
	use debug&& OPTS+=(USE_DEBUG=1)
	use sse2 && OPTS+=(USE_SSE2=1)
	use ssl  && OPTS+=(USE_SSL=1)
	use upnp && OPTS+=(USE_UPNP=1)
	
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
		dobin bitcoind

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
		newbin bitcoin wxbitcoin
		dosym wxbitcoin /usr/bin/bitcoin
		insinto /usr/share/pixmaps
		doins "${S}/rc/bitcoin.ico"
		make_desktop_entry ${PN} "wxBitcoin" "/usr/share/pixmaps/bitcoin.ico" "Network;P2P"
	fi
	if use nls; then
		einfo "Installing language files"
		for val in ${LANGS}
		do
			if use "linguas_$val"; then
				domo "locale/$val/LC_MESSAGES/bitcoin.mo" || die "failed to install $val locale"
			fi
		done
	fi
	
	newdoc license.txt COPYING
}
