# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( {12..16} )

inherit postgres-multi

DESCRIPTION="Base58Check functions and base type for PostgreSQL"
HOMEPAGE="https://github.com/whitslack/pg_base58check"
SRC_URI="${HOMEPAGE}/archive/v${PV/_}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${PV/_}"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

REQUIRED_USE="${POSTGRES_REQ_USE}"

RDEPEND="
	${POSTGRES_DEP}
	dev-libs/libbase58check:=
"
DEPEND="${RDEPEND}"
BDEPEND="${POSTGRES_DEP}"

pkg_postinst() {
	elog "To install ${PN} in your database, execute as the database superuser:"
	elog
	elog "=> CREATE EXTENSION ${PN};"
}
