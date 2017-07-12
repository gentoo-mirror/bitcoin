# Copyright 2010-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

BITCOINCORE_COMMITHASH="0d719145b018e28d48d35c2646a5962b87c60436"
BITCOINCORE_LJR_DATE="20170102"
BITCOINCORE_IUSE="addrindex bip148 examples +knots no-bip148 test upnp +wallet zeromq"
BITCOINCORE_ADDRINDEX_DIFF="b31e13eeb6d9ba5d0add381e86feb3460eb208b0...3ae4ba22a04fc57876c006f9e26095f3fe289a65"
BITCOINCORE_ADDRINDEX_PATCHFILE="bitcoin-addrindex-v0.13.2.patch"
BITCOINCORE_POLICY_PATCHES="+rbf spamfilter"
BITCOINCORE_NEED_LEVELDB=1
BITCOINCORE_NEED_LIBSECP256K1=1
inherit bash-completion-r1 bitcoincore systemd user

DESCRIPTION="Original Bitcoin crypto-currency wallet for automated services"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 mips ppc x86 amd64-linux x86-linux"

REQUIRED_USE="
	^^ ( bip148 no-bip148 )
	?? ( addrindex knots )
"

pkg_setup() {
	enewgroup bitcoin
	enewuser bitcoin -1 -1 /var/lib/bitcoin bitcoin
}

src_prepare() {
	sed -i 's/have bitcoind &&//;s/^\(complete -F _bitcoind bitcoind\) bitcoin-cli$/\1/' contrib/${PN}.bash-completion || die
	bitcoincore_src_prepare
}

src_configure() {
	bitcoincore_conf \
		--with-daemon
}

src_install() {
	bitcoincore_src_install

	insinto /etc/bitcoin
	newins "${FILESDIR}/bitcoin.conf" bitcoin.conf
	fowners bitcoin:bitcoin /etc/bitcoin/bitcoin.conf
	fperms 600 /etc/bitcoin/bitcoin.conf

	newconfd "contrib/init/bitcoind.openrcconf" ${PN}
	newinitd "contrib/init/bitcoind.openrc" ${PN}
	systemd_dounit "${FILESDIR}/bitcoind.service"

	keepdir /var/lib/bitcoin/.bitcoin
	fperms 700 /var/lib/bitcoin
	fowners bitcoin:bitcoin /var/lib/bitcoin/
	fowners bitcoin:bitcoin /var/lib/bitcoin/.bitcoin
	dosym /etc/bitcoin/bitcoin.conf /var/lib/bitcoin/.bitcoin/bitcoin.conf

	dodoc doc/assets-attribution.md doc/bips.md doc/tor.md
	doman contrib/debian/manpages/{bitcoind.1,bitcoin.conf.5}

	use zeromq && dodoc doc/zmq.md

	newbashcomp contrib/${PN}.bash-completion ${PN}

	if use examples; then
		docinto examples
		dodoc -r contrib/{qos,spendfrom,tidy_datadir.sh}
		use zeromq && dodoc -r contrib/zmq
	fi

	insinto /etc/logrotate.d
	newins "${FILESDIR}/bitcoind.logrotate-r1" bitcoind
}
