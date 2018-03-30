# Copyright 2010-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DB_VER="4.8"
inherit autotools bash-completion-r1 db-use gnome2-utils xdg-utils

BITCOINCORE_COMMITHASH="4b4d7eb255ca8f9a94b92479e6061d129c91a991"
KNOTS_PV="${PV}.knots20180322"
KNOTS_P="bitcoin-${KNOTS_PV}"

DESCRIPTION="An end-user Qt GUI for the Bitcoin crypto-currency"
HOMEPAGE="https://bitcoincore.org/ https://bitcoinknots.org/"
SRC_URI="
	https://github.com/bitcoin/bitcoin/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> bitcoin-v${PV}.tar.gz
	https://bitcoinknots.org/files/0.16.x/${KNOTS_PV}/${KNOTS_P}.patches.txz -> ${KNOTS_P}.patches.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"

IUSE="+asm +bip70 +bitcoin_policy_rbf dbus kde +libevent +knots libressl +qrcode qt5 +http test +tor upnp +wallet zeromq"
LANGS="af af:af_ZA am ar be:be_BY bg bg:bg_BG bn bs ca ca@valencia ca:ca_ES cs cs:cs_CZ cy da de de:de_DE el el:el_GR en en_AU en_GB en_US eo es es_419 es_AR es_CL es_CO es_DO es_ES es_MX es_UY es_VE et et:et_EE eu:eu_ES fa fa:fa_IR fi fr fr_CA fr:fr_FR gl he he:he_IL hi:hi_IN hr hu hu:hu_HU id id:id_ID is it it:it_IT ja ja:ja_JP ka kk:kk_KZ km:km_KH ko ko:ko_KR ku:ku_IQ ky la lt lv:lv_LV mk:mk_MK ml mn mr:mr_IN ms ms:ms_MY my nb nb:nb_NO ne nl nl:nl_NL pam pl pl:pl_PL pt pt_BR pt_PT ro ro:ro_RO ru ru:ru_RU si sk sl:sl_SI sn sq sr sr-Latn:sr@latin sv ta ta:ta_IN te th th:th_TH tr tr:tr_TR uk ur_PK uz@Cyrl vi vi:vi_VN zh zh:zh-Hans zh_CN zh_HK zh_TW"

REQUIRED_USE="
	http? ( libevent ) tor? ( libevent ) libevent? ( http tor )
"
RDEPEND="
	>=dev-libs/boost-1.52.0:=[threads(+)]
	>=dev-libs/libsecp256k1-0.0.0_pre20151118:=[recovery]
	dev-libs/univalue:=
	!qt5? (
		dev-qt/qtcore:4[ssl]
		dev-qt/qtgui:4
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	virtual/bitcoin-leveldb
	bip70? ( dev-libs/protobuf:= )
	dbus? (
		!qt5? ( dev-qt/qtdbus:4 )
		qt5? ( dev-qt/qtdbus:5 )
	)
	libevent? ( dev-libs/libevent:= )
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	qrcode? (
		media-gfx/qrencode:=
	)
	upnp? ( >=net-libs/miniupnpc-1.9.20150916:= )
	wallet? ( sys-libs/db:$(db_ver_to_slot "${DB_VER}")=[cxx] )
	zeromq? ( net-libs/zeromq:= )
"
DEPEND="${RDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
	knots? (
		gnome-base/librsvg
		media-gfx/imagemagick[png]
	)
"

declare -A LANG2USE USE2LANGS
bitcoin_langs_prep() {
	local lang l10n
	for lang in ${LANGS}; do
		l10n="${lang/:*/}"
		l10n="${l10n/[@_]/-}"
		lang="${lang/*:/}"
		LANG2USE["${lang}"]="${l10n}"
		USE2LANGS["${l10n}"]+=" ${lang}"
	done
}
bitcoin_langs_prep

bitcoin_lang2use() {
	local l
	for l; do
		echo l10n_${LANG2USE["${l}"]}
	done
}

IUSE+=" $(bitcoin_lang2use ${!LANG2USE[@]})"

DOCS=( doc/bips.md doc/files.md doc/release-notes.md )

S="${WORKDIR}/bitcoin-${BITCOINCORE_COMMITHASH}"

pkg_pretend() {
	if use knots; then
		elog "You are building ${PN} from Bitcoin Knots."
		elog "For more information, see:"
		elog "https://bitcoinknots.org/files/0.16.x/${KNOTS_PV}/${KNOTS_P}.desc.html"
	else
		elog "You are building ${PN} from Bitcoin Core."
		elog "For more information, see:"
		elog "https://bitcoincore.org/en/2017/11/11/release-${PV}/"
	fi
	if use bitcoin_policy_rbf; then
		elog "Replace By Fee policy is enabled: Your node will preferentially mine and"
		elog "relay transactions paying the highest fee, regardless of receive order."
	else
		elog "Replace By Fee policy is disabled: Your node will only accept the first"
		elog "transaction seen consuming a conflicting input, regardless of fee"
		elog "offered by later ones."
	fi
}

src_prepare() {
	sed -i 's/^\(complete -F _bitcoind \)bitcoind \(bitcoin-qt\)$/\1\2/' contrib/bitcoind.bash-completion || die

	local knots_patchdir="${WORKDIR}/${KNOTS_P}.patches/"

	eapply "${knots_patchdir}/${KNOTS_P}.syslibs.patch"

	if use knots; then
		eapply "${knots_patchdir}/${KNOTS_P}.f.patch"
		eapply "${knots_patchdir}/${KNOTS_P}.branding.patch"
		eapply "${knots_patchdir}/${KNOTS_P}.ts.patch"
		eapply "${FILESDIR}/${P}-fix_mempoolstats.patch"
	fi

	eapply_user

	if ! use bitcoin_policy_rbf; then
		sed -i 's/\(DEFAULT_ENABLE_REPLACEMENT = \)true/\1false/' src/validation.h || die
	fi

	echo '#!/bin/true' >share/genbuild.sh || die
	mkdir -p src/obj || die
	echo "#define BUILD_SUFFIX gentoo${PVR#${PV}}" >src/obj/build.h || die

	sed -i 's/^\(Icon=\).*$/\1bitcoin-qt/;s/^\(Categories=.*\)$/\1P2P;Network;Qt;/' contrib/debian/bitcoin-qt.desktop || die

	local filt= yeslang= nolang= lan ts x

	for lan in $LANGS; do
		lan="${lan/*:/}"
		if [ ! -e src/qt/locale/bitcoin_$lan.ts ]; then
			die "Language '$lan' no longer supported. Ebuild needs update."
		fi
	done

	for ts in src/qt/locale/*.ts
	do
		x="${ts/*bitcoin_/}"
		x="${x/.ts/}"
		if ! use "$(bitcoin_lang2use "$x")"; then
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
		$(use_enable asm)
		$(use_enable bip70)
		$(use_with dbus qtdbus)
		$(use_with libevent)
		$(use_with qrcode qrencode)
		$(use_with upnp miniupnpc)
		$(use_enable upnp upnp-default)
		$(use_enable test tests)
		$(use_enable wallet)
		$(use_enable zeromq zmq)
		--with-gui=$(usex qt5 qt5 qt4)
		--disable-util-cli
		--disable-util-tx
		--disable-bench
		--without-libs
		--without-daemon
		--disable-ccache
		--disable-static
		--with-system-leveldb
		--with-system-libsecp256k1
		--with-system-univalue
	)
	econf "${my_econf[@]}"
}

src_install() {
	default

	rm -f "${ED%/}/usr/bin/test_bitcoin" || die

	insinto /usr/share/pixmaps
	if use knots; then
		newins "src/qt/res/rendered_icons/bitcoin.ico" "${PN}.ico"
	else
		newins "share/pixmaps/bitcoin.ico" "${PN}.ico"
	fi
	insinto /usr/share/applications
	newins "contrib/debian/bitcoin-qt.desktop" "org.bitcoin.bitcoin-qt.desktop"

	use libevent && dodoc doc/REST-interface.md doc/tor.md

	use zeromq && dodoc doc/zmq.md

	newbashcomp contrib/bitcoind.bash-completion ${PN}

	if use kde; then
		insinto /usr/share/kde4/services
		doins contrib/debian/bitcoin-qt.protocol
		dosym "../kde4/services/bitcoin-qt.protocol" "/usr/share/kservices5/bitcoin-qt.protocol"
	fi
}

update_caches() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postinst() {
	update_caches

	if use tor; then
		elog "To have ${PN} automatically use Tor when it's running, be sure your"
		elog "'torrc' config file has 'ControlPort' and 'CookieAuthentication' setup"
		elog "correctly, and add your user to the 'tor' user group."
	fi
}

pkg_postrm() {
	update_caches
}
