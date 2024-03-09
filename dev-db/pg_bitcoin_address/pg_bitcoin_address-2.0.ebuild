# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( {12..16} )

inherit postgres-multi

DESCRIPTION="PostgreSQL extension supporting Bitcoin addresses"
HOMEPAGE="https://github.com/whitslack/pg_bitcoin_address"
SRC_URI="${HOMEPAGE}/archive/v${PV/_}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV/_}"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

REQUIRED_USE="${POSTGRES_REQ_USE}"

RDEPEND="
	${POSTGRES_DEP}
	dev-libs/libbase58check:=
	dev-libs/libbech32:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	${POSTGRES_DEP}
	virtual/pkgconfig
"

src_install() {
	postgres-multi_src_install
	einstalldocs
}

pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-2" ; then
		ewarn 'Because this extension was renamed in version 2.0, you will need to'
		ewarn '"DROP EXTENSION pg_base58check" on your databases before proceeding to'
		ewarn 'instantiate the new extension.'
	fi
}

pkg_postinst() {
	elog "To instantiate ${PN} in your database, execute:"
	elog
	elog "=> CREATE EXTENSION ${PN};"
}
