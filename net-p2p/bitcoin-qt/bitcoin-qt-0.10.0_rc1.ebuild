# Copyright 2010-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/bitcoin-qt/bitcoin-qt-0.9.3.ebuild,v 1.2 2014/10/10 11:30:23 blueness Exp $

EAPI=5

DB_VER="4.8"

LANGS="ach af_ZA ar be_BY bg bs ca ca@valencia ca_ES cmn cs cy da de el_GR en eo es es_CL es_DO es_MX es_UY et eu_ES fa fa_IR fi fr fr_CA gl gu_IN he hi_IN hr hu id_ID it ja ka kk_KZ ko_KR ky la lt lv_LV mn ms_MY nb nl pam pl pt_BR pt_PT ro_RO ru sah sk sl_SI sq sr sv th_TH tr uk ur_PK uz@Cyrl vi vi_VN zh_HK zh_CN zh_TW"
inherit autotools db-use eutils fdo-mime gnome2-utils kde4-functions qt4-r2 user versionator

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"
COMMITHASH="4e0bfa581438a662147fe4459522b308406d7f57"
LJR_PV() { echo "${MyPV}.${1}20141224"; }
LJR_PATCHDIR="${MyPN}-$(LJR_PV ljr).patches"
LJR_PATCH() { echo "${WORKDIR}/${LJR_PATCHDIR}/${MyPN}-$(LJR_PV ljr).$@.patch"; }
LJR_PATCH_DESC="http://luke.dashjr.org/programs/${MyPN}/files/${MyPN}d/luke-jr/0.10.x/$(LJR_PV ljr)/${MyPN}-$(LJR_PV ljr).desc.txt"

DESCRIPTION="An end-user Qt4 GUI for the Bitcoin crypto-currency"
HOMEPAGE="http://bitcoin.org/"
SRC_URI="https://github.com/${MyPN}/${MyPN}/archive/${COMMITHASH}.tar.gz -> ${MyPN}-v${PV}.tgz
	http://luke.dashjr.org/programs/${MyPN}/files/${MyPN}d/luke-jr/0.10.x/$(LJR_PV ljr)/${LJR_PATCHDIR}.txz -> ${LJR_PATCHDIR}.tar.xz
"

LICENSE="MIT ISC GPL-3 LGPL-2.1 public-domain || ( CC-BY-SA-3.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS=""
IUSE="$IUSE 1stclassmsg dbus kde +ljr +qrcode test upnp +wallet zeromq"
MyPolicies="cpfp dcmp spamfilter"
for mypolicy in ${MyPolicies}; do
	IUSE="$IUSE +bitcoin_policy_${mypolicy}"
done

RDEPEND="
	>=dev-libs/boost-1.52.0[threads(+)]
	dev-libs/openssl:0[-bindist]
	dev-libs/protobuf
	qrcode? (
		media-gfx/qrencode
	)
	upnp? (
		net-libs/miniupnpc
	)
	wallet? (
		sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]
	)
	zeromq? (
		net-libs/zeromq
	)
	virtual/bitcoin-leveldb
	=dev-libs/libsecp256k1-0.0.0_pre20141212
	dev-qt/qtgui:4
	dbus? (
		dev-qt/qtdbus:4
	)
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
	dev-vcs/git
"

S="${WORKDIR}/${MyPN}-${COMMITHASH}"

pkg_pretend() {
	if use ljr || use zeromq; then
		einfo "Extra functionality improvements to Bitcoin Core are enabled."
	fi
	local enabledpolicies=
	if use bitcoin_policy_cpfp; then
		einfo "CPFP policy is enabled: If you mine, you will give consideration to child transaction fees to pay for their parents."
	else
		einfo "CPFP policy is disabled: If you mine, you will ignore transactions unless they have sufficient fee themselves, even if child transactions offer a fee to cover their cost."
	fi
	if use bitcoin_policy_dcmp; then
		einfo "Data Carrier Multi-Push policy is enabled: Your node will assist transactions with at most a single multiple-'push' data carrier output."
	else
		einfo "Data Carrier Multi-Push policy is disabled: Your node will assist transactions with at most a single data carrier output with only a single 'push'."
	fi
	if use bitcoin_policy_spamfilter; then
		einfo "Enhanced spam filter policy is enabled: Notorious spammers will not be assisted by your node. This may impact your ability to use some spammy services (see link for a list)."
	else
		einfo "Enhanced spam filter policy is DISABLED: Your node will not be checking for notorious spammers, and may assist them. Set BITCOIN_POLICY=spamfilter to enable."
	fi
	einfo "For more information, see ${LJR_PATCH_DESC}"
}

src_prepare() {
	epatch "$(LJR_PATCH syslibs)"
	if use ljr; then
		# Regular epatch won't work with binary files
		local patchfile="$(LJR_PATCH ljrF)"
		einfo "Applying ${patchfile##*/} ..."
		git apply --whitespace=nowarn "${patchfile}"
	fi
	if use 1stclassmsg; then
		epatch "$(LJR_PATCH 1stclassmsg)"
	fi
	use zeromq && epatch "$(LJR_PATCH zeromq)"
	for mypolicy in ${MyPolicies}; do
		use bitcoin_policy_${mypolicy} && epatch "$(LJR_PATCH ${mypolicy})"
	done

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

	eautoreconf
	rm -r src/leveldb src/secp256k1
}

src_configure() {
	# NOTE: --enable-zmq actually disables it
	econf \
		--disable-ccache \
		$(use_with dbus qtdbus)  \
		$(use_with upnp miniupnpc) $(use_enable upnp upnp-default) \
		$(use_with qrcode qrencode)  \
		$(use_enable test tests)  \
		$(usex 1stclassmsg --enable-first-class-messaging)  \
		--with-system-leveldb  \
		--with-system-libsecp256k1  \
		--without-libs \
		--without-daemon \
		--without-utils
		--with-gui
}

src_test() {
	emake check
}

src_install() {
	emake DESTDIR="${D}" install

	rm "${D}/usr/bin/test_bitcoin"

	insinto /usr/share/pixmaps
	newins "share/pixmaps/bitcoin.ico" "${PN}.ico"
	make_desktop_entry "${PN} %u" "Bitcoin-Qt" "/usr/share/pixmaps/${PN}.ico" "Qt;Network;P2P;Office;Finance;" "MimeType=x-scheme-handler/bitcoin;\nTerminal=false"

	dodoc doc/README.md doc/release-notes.md
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
