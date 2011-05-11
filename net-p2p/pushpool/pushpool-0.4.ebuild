# Copyright 2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="bitcoin push-mining pool server"
HOMEPAGE="https://github.com/jgarzik/pushpool"
SRC_URI="https://download.github.com/jgarzik-${PN}-v${PV}-0-g495ec6c.zip"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="postgres sqlite"

DEPEND="
	=dev-libs/jansson-1*
	dev-libs/libevent
	dev-libs/libmemcached
	dev-libs/openssl
	net-misc/curl
	sys-libs/zlib
	postgres? (
		dev-db/postgresql-server
	)
	sqlite? (
		dev-db/sqlite
	)
"
RDEPEND="${DEPEND}
"
DEPEND="${DEPEND}
	app-arch/unzip
"

S="${WORKDIR}/jgarzik-${PN}-b1f6d80"

src_prepare() {
	./autogen.sh
}

src_configure() {
	# MySQL is broken in this version
	econf \
		--without-mysql \
		$(use_with postgres postgresql) \
		$(use_with sqlite sqlite3) \
	|| die 'econf failed'
}

src_install() {
	emake install DESTDIR="${D}" || die 'emake install failed'
	dodoc example-blkmon.cfg
	dodoc example-cfg.json
}
