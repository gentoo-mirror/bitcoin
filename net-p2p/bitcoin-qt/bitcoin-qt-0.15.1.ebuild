# Copyright 2010-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DB_VER="4.8"
inherit autotools bash-completion-r1 db-use fdo-mime gnome2-utils kde4-functions

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"
BITCOINCORE_COMMITHASH="7b57bc998f334775b50ebc8ca5e78ca728db4c58"
KNOTS_PV="${PV}.knots20171111"
KNOTS_P="${MyPN}-${KNOTS_PV}"

IUSE="+asm +bip70 +bitcoin_policy_rbf dbus kde +libevent +knots libressl +qrcode qt5 +http test +tor upnp +wallet zeromq"
LANGS="af af_ZA am ar be_BY bg bg_BG bn bs ca ca@valencia ca_ES cs cy da de de_DE el el_GR en en_AU en_GB en_US eo es es_419 es_AR es_CL es_CO es_DO es_ES es_MX es_UY es_VE et et_EE eu_ES fa fa_IR fi fr fr_CA fr_FR gl he he_IL hi_IN hr hu hu_HU id id_ID is it it_IT ja ja_JP ka kk_KZ ko_KR ku_IQ ky la lt lv_LV mk_MK mn ms ms_MY my nb nb_NO ne nl nl_NL pam pl pl_PL pt pt_BR pt_PT ro ro_RO ru ru_RU si sk sl_SI sn sq sr sr@latin sv ta te th th_TH tr tr_TR uk ur_PK uz@Cyrl vi vi_VN zh zh_CN zh_HK zh_TW"
KNOTS_LANGS="am hu_HU is ms pl_PL pt sn"

DESCRIPTION="An end-user Qt GUI for the Bitcoin crypto-currency"
HOMEPAGE="http://bitcoincore.org/ http://bitcoinknots.org/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"

SRC_URI="
	https://github.com/${MyPN}/${MyPN}/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> ${MyPN}-v${PV}.tar.gz
	http://bitcoinknots.org/files/0.15.x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
"
CORE_DESC="https://bitcoincore.org/en/2017/11/11/release-${PV}/"
KNOTS_DESC="http://bitcoinknots.org/files/0.15.x/${KNOTS_PV}/${KNOTS_P}.desc.html"

RDEPEND="
	!libressl? ( dev-libs/openssl:0[-bindist] ) libressl? ( dev-libs/libressl )
	libevent? ( dev-libs/libevent )
	>=dev-libs/libsecp256k1-0.0.0_pre20151118[recovery]
	dev-libs/univalue
	>=dev-libs/boost-1.52.0[threads(+)]
	upnp? ( >=net-libs/miniupnpc-1.9.20150916 )
	wallet? ( sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx] )
	zeromq? ( net-libs/zeromq )
	virtual/bitcoin-leveldb
	bip70? ( dev-libs/protobuf )
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
	>=app-shells/bash-4.1
	sys-apps/sed
	qt5? ( dev-qt/linguist-tools:5 )
	knots? (
		gnome-base/librsvg
		media-gfx/imagemagick[png]
	)
"
REQUIRED_USE="
	http? ( libevent ) tor? ( libevent ) libevent? ( http tor )
"

for lang in ${LANGS}; do
	IUSE+=" linguas_${lang}"
done

for lang in ${KNOTS_LANGS}; do
	REQUIRED_USE="${REQUIRED_USE} linguas_${lang}? ( knots )"
done

DOCS="doc/bips.md doc/files.md doc/release-notes.md"

S="${WORKDIR}/${MyPN}-${BITCOINCORE_COMMITHASH}"

pkg_pretend() {
	if use knots; then
		einfo "You are building ${PN} from Bitcoin Knots."
		einfo "For more information, see ${KNOTS_DESC}"
	else
		einfo "You are building ${PN} from Bitcoin Core."
		einfo "For more information, see ${CORE_DESC}"
	fi
	if use bitcoin_policy_rbf; then
		einfo "Replace By Fee policy is enabled: Your node will preferentially mine and relay transactions paying the highest fee, regardless of receive order."
	else
		einfo "Replace By Fee policy is disabled: Your node will only accept the first transaction seen consuming a conflicting input, regardless of fee offered by later ones."
	fi
}

KNOTS_PATCH() { echo "${WORKDIR}/${KNOTS_P}.patches/${KNOTS_P}.$@.patch"; }

src_prepare() {
	sed -i 's/^\(complete -F _bitcoind \)bitcoind \(bitcoin-qt\)$/\1\2/' contrib/bitcoind.bash-completion || die

	eapply "$(KNOTS_PATCH syslibs)"

	if use knots; then
		eapply "$(KNOTS_PATCH f)"
		eapply "$(KNOTS_PATCH branding)"
		eapply "$(KNOTS_PATCH ts)"
	fi

	eapply_user

	if ! use bitcoin_policy_rbf; then
		sed -i 's/\(DEFAULT_ENABLE_REPLACEMENT = \)true/\1false/' src/validation.h || die
	fi

	echo '#!/bin/true' >share/genbuild.sh
	mkdir -p src/obj
	echo "#define BUILD_SUFFIX gentoo${PVR#${PV}}" >src/obj/build.h

	sed -i 's/^\(Icon=\).*$/\1bitcoin-qt/;s/^\(Categories=.*\)$/\1P2P;Network;Qt;/' contrib/debian/bitcoin-qt.desktop || die

	local filt= yeslang= nolang= lan ts x

	for lan in $LANGS; do
		if [ ! -e src/qt/locale/bitcoin_$lan.ts ]; then
			if has $lan $KNOTS_LANGS && ! use knots; then
				# Expected
				continue
			fi
			die "Language '$lan' no longer supported. Ebuild needs update."
		fi
	done

	for ts in src/qt/locale/*.ts
	do
		x="${ts/*bitcoin_/}"
		x="${x/.ts/}"
		if ! use "linguas_$x"; then
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

	eautoreconf
	rm -r src/leveldb src/secp256k1 || die
}

src_configure() {
	local my_econf=(
		$(use_enable asm experimental-asm)
		$(use_enable bip70)
		$(use_with dbus qtdbus)
		$(use_with libevent)
		$(use_with qrcode qrencode)
		$(use_with upnp miniupnpc) $(use_enable upnp upnp-default)
		$(use_enable test tests)
		$(use_enable wallet)
		$(use_enable zeromq zmq)
		--with-gui=$(usex qt5 qt5 qt4)
		--disable-util-cli --disable-util-tx --disable-bench --without-libs --without-daemon
		--disable-ccache --disable-static
		--with-system-leveldb
		--with-system-libsecp256k1
		--with-system-univalue
	)
	econf "${my_econf[@]}"
}

src_install() {
	default

	rm "${D}/usr/bin/test_bitcoin"

	insinto /usr/share/pixmaps
	if use knots; then
		newins "src/qt/res/rendered_icons/bitcoin.ico" "${PN}.ico"
	else
		newins "share/pixmaps/bitcoin.ico" "${PN}.ico"
	fi
	insinto /usr/share/applications
	doins "contrib/debian/bitcoin-qt.desktop"

	use libevent && dodoc doc/REST-interface.md doc/tor.md

	use zeromq && dodoc doc/zmq.md

	newbashcomp contrib/bitcoind.bash-completion ${PN}

	if use kde; then
		insinto /usr/share/kde4/services
		doins contrib/debian/bitcoin-qt.protocol
		dosym "../kde4/services/bitcoin-qt.protocol" "/usr/share/kservices5/bitcoin-qt.protocol"
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
