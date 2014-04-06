# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

COMMIT="adc9e82f3a703920551339ffc4d764849f4a6ecf"

DESCRIPTION="anynomous secure microblogging platform based on Bitcoin and BitTorrent protocols"
HOMEPAGE="http://twister.net.co"
SRC_URI="https://github.com/miguelfreitas/twister-core/archive/${COMMIT}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="logging +debug +dht +encryption sse2 upnp pool-allocators invariant-checks statistics disk-stats geoip"

RDEPEND="
encryption? ( dev-libs/openssl )
sys-libs/db
dev-libs/boost
geoip? ( dev-libs/geoip )
virtual/libiconv
upnp? ( net-libs/miniupnpc )"

DEPEND="${RDEPEND}
	sys-apps/sed
"

S="${WORKDIR}/twister-core-${COMMIT}"

src_prepare() {
	sed s/'#include <db_cxx.h>'/'#include DB_CXX_HEADER'/ -i src/db.h
	echo "twisterd_LDADD += @BOOST_CHRONO_LIB@" >> Makefile.am
}

src_configure() {
	./autotool.sh || die
	econf $(use_enable logging) $(use_enable debug) $(use_enable dht) $(use_enable encryption) $(use_enable sse2) $(use_enable upnp) $(use_enable pool-allocators) $(use_enable invariant-checks) $(use_enable statistics) $(use_enable disk-stats) $(use_enable geoip) $(use geoip && echo "--with-libgeoip") --with-libiconv
}

src_compile() {
	emake
}

src_install() {
	mkdir -p "${D}usr/bin/"
	cp "${S}/twisterd" "${D}usr/bin/twisterd"
}
