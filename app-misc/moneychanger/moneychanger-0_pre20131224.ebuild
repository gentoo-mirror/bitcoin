# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils qt4-r2 git-r3 multilib

DESCRIPTION="An intuitive QT/C++ system tray client for Open-Transactions."
HOMEPAGE="http://opentransactions.org"
EGIT_REPO_URI="git://github.com/Open-Transactions/Moneychanger.git \
			 https://github.com/Open-Transactions/Moneychanger.git"
EGIT_COMMIT="c14614e499c54d87074b551dd48468537cd41610"
LICENSE="AGPL-3"

SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="app-crypt/Open-Transactions[java]"

DEPEND="app-crypt/Open-Transactions[java]
		dev-qt/qtgui:4
		dev-qt/qtsql:4
		dev-qt/qtcore:4"

PATCHES=(
	"${FILESDIR}/c++11.patch"
)

src_configure() {
	eqmake4 "${S}"/src/"${PN}".pro 	LIBDIR="$(get_libdir)" || die "Configure failed"
}

src_compile() {
	cd "${S}"/src/ || die
	emake || die "Compile failed"
}

src_install() {
	dobin src/moneychanger/moneychanger-qt

	if use doc ; then
		dodoc documentation/presentable_documentation/{object_connections.pdf,object_permissions.png}
		dodoc documentation/source_documentation/{object_connections.odg,object_permissions.odg}
		dodoc documentation/translating
	fi

	cd "${S}"/src/ || die
	emake DESTDIR="${D}" PREFIX="/usr" INSTALL_ROOT="${D}" install || die

	insinto /usr/share/applications
	doins "${FILESDIR}/moneychanger.desktop"
	insinto /usr/share/moneychanger/img/
	doins "${FILESDIR}/moneychanger_icon_64x64.png"
}

pkg_postinst() {
		xdg-icon-resource install --novendor --context apps --size 64 /usr/share/moneychanger/img/moneychanger_icon_64x64.png moneychangericon
}
