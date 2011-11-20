# Copyright 2010-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DB_VER="4.8"

inherit db-use eutils versionator

DESCRIPTION="Original Bitcoin crypto-currency wallet for automated services"
HOMEPAGE="http://bitcoin.org/"
myP="bitcoin-${PV/_/}"
SRC_URI="http://gitorious.org/bitcoin/bitcoind-stable/archive-tarball/v${PV/_/} -> bitcoin-v${PV}.tgz
	eligius? ( http://luke.dashjr.org/programs/bitcoin/files/0.3.24-eligius_sendfee.patch )
"

LICENSE="MIT ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+eligius ssl upnp"

RDEPEND="
	>=dev-libs/boost-1.41.0
	dev-libs/crypto++
	dev-libs/openssl[-bindist]
	upnp? (
		>=net-libs/miniupnpc-1.6
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
"

S="${WORKDIR}/bitcoin-bitcoind-stable"

pkg_setup() {
	local UG='bitcoin'
	ebegin "Creating ${UG} user and group"
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/bitcoin "${UG}"
}

src_prepare() {
	cd src || die
	cp "${FILESDIR}/0.4.0-Makefile.gentoo" "Makefile" || die
	use eligius && epatch "${DISTDIR}/0.3.24-eligius_sendfee.patch"
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

	use ssl  && OPTS+=(USE_SSL=1)
	use upnp && OPTS+=(USE_UPNP=1)

	cd src || die
	emake "${OPTS[@]}" bitcoind
}

src_install() {
	dobin src/bitcoind

	insinto /etc/bitcoin
	newins "${FILESDIR}/bitcoin.conf" bitcoin.conf
	fowners bitcoin:bitcoin /etc/bitcoin/bitcoin.conf
	fperms 600 /etc/bitcoin/bitcoin.conf

	newconfd "${FILESDIR}/bitcoin.confd" bitcoind
	newinitd "${FILESDIR}/bitcoin.initd" bitcoind

	keepdir /var/lib/bitcoin/.bitcoin
	fperms 700 /var/lib/bitcoin
	fowners bitcoin:bitcoin /var/lib/bitcoin/
	fowners bitcoin:bitcoin /var/lib/bitcoin/.bitcoin
	dosym /etc/bitcoin/bitcoin.conf /var/lib/bitcoin/.bitcoin/bitcoin.conf

	dodoc doc/README
}
