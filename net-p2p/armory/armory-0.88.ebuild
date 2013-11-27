# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2

DESCRIPTION="Armory is a Bitcoin client, offering a dozen innovative features not found anywhere else."
HOMEPAGE="http://bitcoinarmory.com/"

EGIT_REPO_URI="git://github.com/etotheipi/BitcoinArmory.git"
EGIT_COMMIT="v0.88-beta"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="network"

DEPEND="dev-libs/crypto++
	dev-python/PyQt4[X]
	dev-lang/swig
	dev-python/twisted-core
	x11-misc/xdg-utils"

RDEPEND="network? ( || ( net-p2p/bitcoind net-p2p/bitcoin-qt ) )
	dev-python/psutil
	${DEPEND}"

src_prepare() {
	sed -e 's/`python -c/`python2 -c/' -i cppForSwig/Makefile
	echo python2 /usr/share/armory/ArmoryQt.py > armory
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc README
	dobin armory
}

pkg_postinst() {
	xdg-icon-resource install --novendor --context apps --size 64 /usr/share/armory/img/armory_icon_64x64.png armoryicon
	xdg-icon-resource install --novendor --context apps --size 64 /usr/share/armory/img/armory_icon_64x64.png armoryofflineicon
	xdg-icon-resource install --novendor --context apps --size 64 /usr/share/armory/img/armory_icon_green_64x64.png armorytestneticon
}

