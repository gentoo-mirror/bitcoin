# Copyright 2010-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

BITCOINCORE_IUSE="dbus kde +qrcode qt5 test upnp +wallet zeromq"
LANGS="af af_ZA ar be_BY bg bg_BG ca ca@valencia ca_ES cs cy da de el el_GR en en_GB eo es es_AR es_CL es_CO es_DO es_ES es_MX es_UY es_VE et et_EE eu_ES fa fa_IR fi fr fr_CA fr_FR gl he hi_IN hr hu id_ID it it_IT ja ka kk_KZ ko_KR ku_IQ ky la lt lv_LV mk_MK mn ms_MY nb ne nl pam pl pt_BR pt_PT ro ro_RO ru ru_RU sk sl_SI sq sr sr@latin sv ta th_TH tr tr_TR uk ur_PK uz@Cyrl vi vi_VN zh zh_CN zh_HK zh_TW"
BITCOINCORE_NEED_LEVELDB=1
BITCOINCORE_NEED_LIBSECP256K1=1
inherit bitcoincore eutils fdo-mime gnome2-utils kde4-functions git-2

DESCRIPTION="An end-user Qt GUI for the Bitcoin crypto-currency"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="
	dev-libs/protobuf
	qrcode? (
		media-gfx/qrencode
	)
	!qt5? ( dev-qt/qtcore:4[ssl] dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtgui:5 dev-qt/qtnetwork:5 dev-qt/qtwidgets:5 )
	dbus? (
		!qt5? ( dev-qt/qtdbus:4 )
		qt5? ( dev-qt/qtdbus:5 )
	)
"
DEPEND="${RDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
"

for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

src_prepare() {
	bitcoincore_prepare

	sed -i 's/^\(Icon=\).*$/\1bitcoin-qt/;s/^\(Categories=.*\)$/\1P2P;Network;Qt;/' contrib/debian/bitcoin-qt.desktop

	local filt= yeslang= nolang= lan ts x

	for lan in $LANGS; do
		if [ ! -e src/qt/locale/bitcoin_$lan.ts ]; then
			ewarn "Language '$lan' no longer supported. Ebuild needs update."
		fi
	done

	for ts in src/qt/locale/*.ts
	do
		x="${ts/*bitcoin_/}"
		x="${x/.ts/}"
		if ! in_iuse "linguas_$x"; then
			ewarn "Language '$x' newly supported. Ebuild needs update."
			yeslang="$yeslang $x"
		elif ! use "linguas_$x"; then
			nolang="$nolang $x"
			rm "$ts" || die
			filt="$filt\\|$x"
		else
			yeslang="$yeslang $x"
		fi
	done
	filt="bitcoin_\\(${filt:2}\\)\\.\(qm\|ts\)"
	sed "/${filt}/d" -i 'src/qt/bitcoin_locale.qrc' || die
	sed "s/locale\/${filt}/bitcoin.qrc/" -i 'src/Makefile.qt.include' || die
	einfo "Languages -- Enabled:$yeslang -- Disabled:$nolang"

	bitcoincore_autoreconf
}

src_configure() {
	bitcoincore_conf \
		$(use_with dbus qtdbus)  \
		$(use_with qrcode qrencode)  \
		--with-gui=$(usex qt5 qt5 qt4)
}

src_install() {
	bitcoincore_src_install

	insinto /usr/share/pixmaps
	newins "share/pixmaps/bitcoin.ico" "${PN}.ico"
	insinto /usr/share/applications
	doins "contrib/debian/bitcoin-qt.desktop"

	dodoc doc/assets-attribution.md doc/bips.md doc/tor.md
	doman contrib/debian/manpages/bitcoin-qt.1

	use zeromq && dodoc doc/zmq.md

	if use kde; then
		insinto /usr/share/kde4/services
		doins contrib/debian/bitcoin-qt.protocol
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
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
