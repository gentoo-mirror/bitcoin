# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils cmake-utils

DESCRIPTION="cppDB is an SQL connectivity library for platform and database independent connectivity"
HOMEPAGE="http://cppcms.sourceforge.net/wikipp/en/page/main"
SRC_URI="mirror://sourceforge/cppcms/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc internal mysql odbc +postgres sqlite"

DEPEND="sqlite? ( dev-db/sqlite:3 )
mysql? ( virtual/mysql )
postgres? ( dev-db/postgresql-base )
odbc? ( dev-db/unixODBC )
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_disable sqlite SQLITE)
		$(cmake-utils_use_disable mysql MYSQL)
		$(cmake-utils_use_disable postgres PQ)
		$(cmake-utils_use_disable odbc ODBC)
		$(cmake-utils_use internal SQLITE_BACKEND_INTERNAL)
		$(cmake-utils_use internal MYSQL_BACKEND_INTERNAL)
		$(cmake-utils_use internal PQ_BACKEND_INTERNAL)
		$(cmake-utils_use internal ODBC_BACKEND_INTERNAL) )

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	if use doc; then
		cd "docs" || die "Failed to create docs"
		rm build.txt
		for i in $(ls -1 *.txt); do
			dodoc "${i}"
		done
	fi
}
