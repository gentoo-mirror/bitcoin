# Copyright 2010-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DB_VER="4.8"

inherit db-use eutils versionator user

DESCRIPTION="A P2P network based domain name system"
HOMEPAGE="http://namecoin.info/"
SRC_URI="https://github.com/${PN}/${PN}/archive/nc${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT ISC"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ssl upnp"

RDEPEND="
	>=dev-libs/boost-1.41.0[threads(+)]
	dev-libs/crypto++
	dev-libs/openssl[-bindist]
	upnp? (
		<net-libs/miniupnpc-1.6
	)
	sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
"

S="${WORKDIR}/${PN}-nc${PV}"

pkg_setup() {
	enewgroup "namecoin"
	enewuser "namecoin" -1 -1 /var/lib/namecoin "namecoin"
}

src_prepare() {
	cd src
	cp "${FILESDIR}/0.3.72-Makefile.gentoo" "Makefile"
}

src_compile() {
	local OPTS=()

	OPTS+=("CXXFLAGS=${CXXFLAGS} -I$(db_includedir "${DB_VER}")")
	OPTS+=("LDFLAGS=${LDFLAGS} -ldb_cxx-${DB_VER}")

	use ssl  && OPTS+=(USE_SSL=1)
	use upnp && OPTS+=(USE_UPNP=1)

	cd src
	emake "${OPTS[@]}" ${PN}d
}

src_install() {
	dobin src/${PN}d

	insinto /etc/namecoin
	newins "${FILESDIR}/namecoin.conf" namecoin.conf
	fowners namecoin:namecoin /etc/namecoin/namecoin.conf
	fperms 600 /etc/namecoin/namecoin.conf

	newconfd "${FILESDIR}/${PN}.confd" ${PN}d
	newinitd "${FILESDIR}/0.3.50-${PN}.initd" ${PN}d

	keepdir /var/lib/namecoin/.namecoin
	fperms 700 /var/lib/namecoin
	fowners namecoin:namecoin /var/lib/namecoin/
	fowners namecoin:namecoin /var/lib/namecoin/.namecoin
	dosym /etc/namecoin/namecoin.conf /var/lib/namecoin/.namecoin/namecoin.conf

	dodoc doc/README
	dodoc DESIGN-namecoin.md FAQ.md doc/README_merged-mining.md
}
