# Copyright 2010-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DB_VER="4.8"

inherit autotools bash-completion-r1 db-use eutils user versionator systemd

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"
LJR_PV() { echo "${PV}.${1}-20141204"; }
LJR_PATCHDIR="${MyPN}-$(LJR_PV ljr).patches"
LJR_PATCH() { echo "${WORKDIR}/${LJR_PATCHDIR}/${MyPN}-$(LJR_PV "$@").patch"; }
LJR_PATCH_DESC="http://luke.dashjr.org/programs/${MyPN}/files/${MyPN}d/luke-jr/0.10.x/$(LJR_PV ljr)/${MyPN}-$(LJR_PV ljr).desc.txt"

DESCRIPTION="Original Bitcoin crypto-currency wallet for automated services"
HOMEPAGE="http://bitcoin.org/"
SRC_URI="https://github.com/${MyPN}/${MyPN}/archive/a0417b8cc840ff6f49b4fb1f8ceef54f8e3d0df1.tar.gz -> ${MyPN}-v${PV}.tgz
	http://luke.dashjr.org/programs/${MyPN}/files/${MyPN}d/luke-jr/0.10.x/$(LJR_PV ljr)/${LJR_PATCHDIR}.txz -> ${LJR_PATCHDIR}.tar.xz
"

LICENSE="MIT ISC GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="examples +ljr logrotate test upnp +wallet"
MyPolicies="cpfp spamfilter"
for mypolicy in ${MyPolicies}; do
	IUSE="$IUSE +bitcoin_policy_${mypolicy}"
done

RDEPEND="
	>=dev-libs/boost-1.52.0[threads(+)]
	dev-libs/openssl:0[-bindist]
	logrotate? (
		app-admin/logrotate
	)
	upnp? (
		net-libs/miniupnpc
	)
	wallet? (
		sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]
	)
	virtual/bitcoin-leveldb
	dev-libs/libsecp256k1
"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.1
	sys-apps/sed
"

S="${WORKDIR}/${MyPN}-a0417b8cc840ff6f49b4fb1f8ceef54f8e3d0df1"

pkg_pretend() {
	if use ljr; then
		einfo "Extra functionality improvements to Bitcoin Core are enabled."
	fi
	local enabledpolicies=
	if use bitcoin_policy_cpfp; then
		einfo "CPFP policy is enabled: If you mine, you will give consideration to child transaction fees to pay for their parents."
	else
		einfo "CPFP policy is disabled: If you mine, you will ignore transactions unless they have sufficient fee themselves, even if child transactions offer a fee to cover their cost."
	fi
	if use bitcoin_policy_spamfilter; then
		einfo "Enhanced spam filter policy is enabled: Notorious spammers will not be assisted by your node."
	else
		einfo "Enhanced spam filter policy is DISABLED: Your node will not be checking for notorious spammers, and may assist them. Set BITCOIN_POLICY=spamfilter to enable."
	fi
	einfo "For more information, see ${LJR_PATCH_DESC}"
}

pkg_setup() {
	local UG='bitcoin'
	enewgroup "${UG}"
	enewuser "${UG}" -1 -1 /var/lib/bitcoin "${UG}"
}

src_prepare() {
	epatch "$(LJR_PATCH syslibs)"
	if use ljr; then
		epatch "$(LJR_PATCH ljrF)"
	fi
	for mypolicy in ${MyPolicies}; do
		use bitcoin_policy_${mypolicy} && epatch "$(LJR_PATCH ${mypolicy})"
	done
	eautoreconf
	rm -r src/leveldb src/secp256k1
}

src_configure() {
	econf \
		--disable-ccache \
		$(use_with upnp miniupnpc) $(use_enable upnp upnp-default) \
		$(use_enable test tests)  \
		$(use_enable wallet)  \
		--with-system-leveldb  \
		--with-system-libsecp256k1  \
		--without-libs \
		--without-utils  \
		--without-gui
}

src_test() {
	emake check
}

src_install() {
	emake DESTDIR="${D}" install

	rm "${D}/usr/bin/test_bitcoin"

	insinto /etc/bitcoin
	newins "${FILESDIR}/bitcoin.conf" bitcoin.conf
	fowners bitcoin:bitcoin /etc/bitcoin/bitcoin.conf
	fperms 600 /etc/bitcoin/bitcoin.conf

	newconfd "${FILESDIR}/bitcoin.confd" ${PN}
	newinitd "${FILESDIR}/bitcoin.initd-r1" ${PN}
	systemd_dounit "${FILESDIR}/bitcoind.service"

	keepdir /var/lib/bitcoin/.bitcoin
	fperms 700 /var/lib/bitcoin
	fowners bitcoin:bitcoin /var/lib/bitcoin/
	fowners bitcoin:bitcoin /var/lib/bitcoin/.bitcoin
	dosym /etc/bitcoin/bitcoin.conf /var/lib/bitcoin/.bitcoin/bitcoin.conf

	dodoc doc/README.md doc/release-notes.md
	dodoc doc/assets-attribution.md doc/tor.md
	doman contrib/debian/manpages/{bitcoind.1,bitcoin.conf.5}

	newbashcomp contrib/${PN}.bash-completion ${PN}

	if use examples; then
		docinto examples
		dodoc -r contrib/{bitrpc,pyminer,qos,spendfrom,tidy_datadir.sh}
	fi

	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/bitcoind.logrotate" bitcoind
	fi
}
