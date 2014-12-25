# Copyright 2010-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/bitcoin-qt/bitcoin-qt-0.9.3.ebuild,v 1.2 2014/10/10 11:30:23 blueness Exp $

EAPI=5

BITCOINCORE_COMMITHASH="4e0bfa581438a662147fe4459522b308406d7f57"
BITCOINCORE_POLICY_PATCHES="cpfp dcmp spamfilter"
LANGS="ach af_ZA ar be_BY bg bs ca ca@valencia ca_ES cmn cs cy da de el_GR en eo es es_CL es_DO es_MX es_UY et eu_ES fa fa_IR fi fr fr_CA gl gu_IN he hi_IN hr hu id_ID it ja ka kk_KZ ko_KR ky la lt lv_LV mn ms_MY nb nl pam pl pt_BR pt_PT ro_RO ru sah sk sl_SI sq sr sv th_TH tr uk ur_PK uz@Cyrl vi vi_VN zh_HK zh_CN zh_TW"
inherit bitcoincore-v0.10-20141224 eutils fdo-mime gnome2-utils kde4-functions qt4-r2

DESCRIPTION="An end-user Qt4 GUI for the Bitcoin crypto-currency"
LICENSE="MIT GPL-3 LGPL-2.1 || ( CC-BY-SA-3.0 LGPL-2.1 ) ljr? ( CC-BY-3.0 )"
SLOT="0"
KEYWORDS=""

IUSE="$IUSE 1stclassmsg dbus kde +ljr +qrcode test upnp +wallet zeromq"

RDEPEND="
	virtual/bitcoin-leveldb
	dev-libs/protobuf
	qrcode? (
		media-gfx/qrencode
	)
	dev-qt/qtgui:4
	dbus? (
		dev-qt/qtdbus:4
	)
"
DEPEND="${RDEPEND}"

src_prepare() {
	bitcoincore_prepare

	local filt= yeslang= nolang=

	for lan in $LANGS; do
		if [ ! -e src/qt/locale/bitcoin_$lan.ts ]; then
			ewarn "Language '$lan' no longer supported. Ebuild needs update."
		fi
	done

	for ts in $(ls src/qt/locale/*.ts)
	do
		x="${ts/*bitcoin_/}"
		x="${x/.ts/}"
		if ! use "linguas_$x"; then
			nolang="$nolang $x"
			rm "$ts"
			filt="$filt\\|$x"
		else
			yeslang="$yeslang $x"
		fi
	done
	filt="bitcoin_\\(${filt:2}\\)\\.\(qm\|ts\)"
	sed "/${filt}/d" -i 'src/qt/bitcoin_locale.qrc'
	sed "s/locale\/${filt}/bitcoin.qrc/" -i 'src/Makefile.qt.include'
	einfo "Languages -- Enabled:$yeslang -- Disabled:$nolang"

	bitcoincore_autoreconf
}

src_configure() {
	# NOTE: --enable-zmq actually disables it
	bitcoincore_conf \
		$(use_with dbus qtdbus)  \
		$(use_with qrcode qrencode)  \
		$(usex 1stclassmsg --enable-first-class-messaging)  \
		--with-gui
}

src_install() {
	bitcoincore_install

	insinto /usr/share/pixmaps
	newins "share/pixmaps/bitcoin.ico" "${PN}.ico"
	make_desktop_entry "${PN} %u" "Bitcoin-Qt" "/usr/share/pixmaps/${PN}.ico" "Qt;Network;P2P;Office;Finance;" "MimeType=x-scheme-handler/bitcoin;\nTerminal=false"

	dodoc doc/assets-attribution.md doc/tor.md
	doman contrib/debian/manpages/bitcoin-qt.1

	if use kde; then
		insinto /usr/share/kde4/services
		doins contrib/debian/bitcoin-qt.protocol
	fi
}

update_caches() {
	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	buildsycoca
}

pkg_postinst() {
	update_caches
}

pkg_postrm() {
	update_caches
}
