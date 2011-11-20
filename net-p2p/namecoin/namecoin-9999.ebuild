# Copyright 2010-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DB_VER="4.8"

inherit db-use eutils git-2 versionator

DESCRIPTION="A P2P network based domain name system."
HOMEPAGE="https://dot-bit.org/"
EGIT_PROJECT='namecoin'
EGIT_REPO_URI="https://github.com/namecoin/namecoin.git"

LICENSE="MIT ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl upnp"

RDEPEND="
	>=dev-libs/boost-1.41.0
	dev-libs/crypto++
	dev-libs/openssl[-bindist]
	upnp? (
		<net-libs/miniupnpc-1.6
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
"

S="${WORKDIR}/namecoin-namecoin-b7d3a08"

pkg_setup() {
	local UG='namecoin'
	ebegin "Creating ${UG} user and group"
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/namecoin "${UG}"
}

src_prepare() {
	cd src
	cp "${FILESDIR}/0.3.24-Makefile.gentoo" "Makefile"
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

	cd src
	emake "${OPTS[@]}" namecoind || die "emake namecoind failed"
}

src_install() {
	dobin src/namecoind

	insinto /etc/namecoin
	newins "${FILESDIR}/namecoin.conf" namecoin.conf
	fowners namecoin:namecoin /etc/namecoin/namecoin.conf
	fperms 600 /etc/namecoin/namecoin.conf

	newconfd "${FILESDIR}/namecoin.confd" namecoind
	newinitd "${FILESDIR}/namecoin.initd" namecoind

	keepdir /var/lib/namecoin/.namecoin
	fperms 700 /var/lib/namecoin
	fowners namecoin:namecoin /var/lib/namecoin/
	fowners namecoin:namecoin /var/lib/namecoin/.namecoin
	dosym /etc/namecoin/namecoin.conf /var/lib/namecoin/.namecoin/bitcoin.conf

	dodoc doc/README
	dodoc DESIGN-namecoin.md FAQ.md doc/README_merged-mining.md
}
