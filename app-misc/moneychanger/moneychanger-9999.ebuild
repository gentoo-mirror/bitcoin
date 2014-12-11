# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils qmake-utils git-r3 multilib

DESCRIPTION="An intuitive QT/C++ system tray client for Open-Transactions."
HOMEPAGE="http://opentransactions.org"
EGIT_REPO_URI="git://github.com/yamamushi/Moneychanger.git \
			 https://github.com/yamamushi/Moneychanger.git"
EGIT_BRANCH="develop"
LICENSE="AGPL-3"

SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="app-crypt/opentxs"

DEPEND="app-crypt/opentxs
		dev-libs/xmlrpc-c
		dev-qt/qtgui:4
		dev-qt/qtsql:4
		dev-qt/qtcore:4"

src_configure() {
	eqmake4 "${S}"/project/"${PN}.pro" 	LIBDIR="$(get_libdir)" || die "Configure failed"
}

src_compile() {
	cd "${S}"/project/ || die
	emake || die "Compile failed"
}

src_install() {
	dobin "${S}"/project/moneychanger-qt/moneychanger-qt

	if use doc ; then
		dodoc documentation/presentable_documentation/{object_connections.pdf,object_permissions.png}
		dodoc documentation/source_documentation/{object_connections.odg,object_permissions.odg}
		dodoc documentation/translating
	fi

	cd "${S}"/project/ || die
	emake DESTDIR="${D}" PREFIX="/usr" INSTALL_ROOT="${D}" install || die

	insinto /usr/share/applications
	doins "${FILESDIR}/moneychanger.desktop"
	insinto /usr/share/moneychanger/img/
	doins "${FILESDIR}/moneychanger_icon_64x64.png"
}

pkg_postinst() {
		xdg-icon-resource install --novendor --context apps --size 64 /usr/share/moneychanger/img/moneychanger_icon_64x64.png moneychangericon
}
