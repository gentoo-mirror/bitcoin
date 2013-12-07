# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils qt4-r2 git-r3

DESCRIPTION="An intuitive QT/C++ system tray client for Open-Transactions."
HOMEPAGE="http://opentransactions.org"
EGIT_REPO_URI="git://github.com/FellowTraveler/Moneychanger.git \
                           https://github.com/FellowTraveler/Moneychanger.git"
LICENSE="AGPL-3"

SLOT="0"
KEYWORDS=""
IUSE="debug doc"

RDEPEND="app-crypt/Open-Transactions[java]"

DEPEND="app-crypt/Open-Transactions[java] \
        dev-qt/qtgui:4 \
        dev-qt/qtsql:4 \    
        dev-qt/qtnetwork:4 \
        dev-qt/qtcore:4"

PATCHES=(
    "${FILESDIR}/c++11.patch"
)
 
src_configure() {
    eqmake4 "${S}"/src/"${PN}".pro || die "Configure failed"
}
 
src_compile() {   
    cd "${S}"/src/ || die                 
    emake || die "Compile failed"
}
 
src_install() {   
    cd "${S}"/src/ || die
    emake DESTDIR="${D}" PREFIX="/usr" INSTALL_ROOT="${D}" install || die
    dobin "${S}"/src/moneychanger/moneychanger-qt || die
    dodoc "${S}"/documentation/presentable_documentation/{object_connections.pdf,object_permissions.png} || die
    dodoc "${S}"/documentation/source_documentation/{object_connections.odg,object_permissions.odg} || die 
    dodoc "${S}"/documentation/translating || die
}

