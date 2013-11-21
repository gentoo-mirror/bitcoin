# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2

DESCRIPTION="Bitmessage is a P2P communications protocol used to send encrypted messages to another person or to many subscribers."
HOMEPAGE="http://bitmessage.org"

EGIT_REPO_URI="git://github.com/Bitmessage/PyBitmessage.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="dev-python/PyQt4
		dev-libs/openssl"
                                                                                                                                                                                                                              
RDEPEND="${DEPEND}"

pkg_setup() {
        enewgroup bitmessage
        enewuser bitmessage -1 -1 /var/lib/bitmessage bitmessage
}

src_install() {
    emake DESTDIR="${D}" PREFIX="/usr" install
    keepdir /var/lib/bitmessage
    keepdir /var/log/bitmessage
    # Install README and (Debian) changelog
    dodoc README.md debian/changelog
    doinitd ${FILESDIR}/bitmessage
}

