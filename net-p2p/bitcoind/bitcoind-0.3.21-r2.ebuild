# Copyright 2010-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DB_VER="4.8"

inherit db-use eutils versionator

DESCRIPTION="A P2P network based digital currency."
HOMEPAGE="http://bitcoin.org/"
myP="bitcoin-${PV}"
SRC_URI="mirror://sourceforge/bitcoin/${myP}-linux.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="selinux sse2 ssl upnp +volatile-fees"

DEPEND="
	>=dev-libs/boost-1.41.0
	dev-libs/crypto++
	dev-libs/openssl[-bindist]
	selinux? (
		sys-libs/libselinux
	)
	upnp? (
		<net-libs/miniupnpc-1.6
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")
	!net-p2p/bitcoin
"
RDEPEND="${DEPEND}
	dev-util/pkgconfig
"
DEPEND="${DEPEND}
	>=app-shells/bash-4.1
"

S="${WORKDIR}/${myP}/src"

pkg_setup() {
	local UG='bitcoin'
	ebegin "Creating ${UG} user and group"
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/bitcoin "${UG}"
}

src_prepare() {
	cp "${FILESDIR}/bitcoin-Makefile.gentoo" "Makefile"
	if use x86 ; then
		epatch "${FILESDIR}/fix_textrel_x86.patch"
	else 
		epatch "${FILESDIR}/fix_textrel_amd64.patch"
	fi
	
	epatch "${FILESDIR}/0.3.19-Limit-response-to-getblocks-to-half-of-output-buffer.patch"
	
	einfo 'Since 0.3.20.2 was released, suggested fees have been reduced from'
	einfo ' 0.01 BTC to 0.0005 BTC (per KB)'
	if use volatile-fees; then
		einfo '    USE=volatile-fees enabled, adjusting...'
		epatch "${FILESDIR}/0.3.19-Backport-reduced-base-fee-of-0.0005-BTC.patch"
	else
		ewarn '    Enable USE=volatile-fees to apply fee adjustments'
	fi
}

src_compile() {
	local OPTS=()
	
	OPTS+=("CXXFLAGS=${CXXFLAGS}")
	OPTS+=( "LDFLAGS=${LDFLAGS}")
	
	OPTS+=("DB_CXXFLAGS=-I$(db_includedir "${DB_VER}")")
	OPTS+=("DB_LDFLAGS=-ldb_cxx-${DB_VER}")
	
	local BOOST_PKG BOOST_VER BOOST_INC
	BOOST_PKG="$(best_version 'dev-libs/boost')"
	BOOST_VER="$(get_version_component_range 1-2 "${BOOST_PKG/*boost-/}")"
	BOOST_VER="$(replace_all_version_separators _ "${BOOST_VER}")"
	BOOST_INC="/usr/include/boost-${BOOST_VER}"
	OPTS+=("BOOST_CXXFLAGS=-I${BOOST_INC}")
	OPTS+=("BOOST_LIB_SUFFIX=-${BOOST_VER}")
	
	use sse2 && OPTS+=(USE_SSE2=1)
	use ssl  && OPTS+=(USE_SSL=1)
	use upnp && OPTS+=(USE_UPNP=1)
	
	emake "${OPTS[@]}" bitcoind || die "emake bitcoind failed";
}

src_install() {
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
	
	newdoc license.txt COPYING
}
