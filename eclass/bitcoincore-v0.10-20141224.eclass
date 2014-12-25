# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# @ECLASS: bitcoincore-v0.10-20141224.eclass
# @MAINTAINER:
# Luke Dashjr <luke_gentoo_bitcoin@dashjr.org>
# @BLURB: common code for Bitcoin Core 0.10 ebuilds
# @DESCRIPTION:
# This eclass is used in Bitcoin Core ebuilds (bitcoin-qt, bitcoind,
# libbitcoinconsensus) to provide a single common place for the common ebuild
# stuff.
#
# The eclass provides all common dependencies as well as common use flags.

has "${EAPI:-0}" 5 || die "EAPI=${EAPI} not supported"

DB_VER="4.8"
inherit db-use

hasiuse() {
	has "$1" ${IUSE} || has "+$1" ${IUSE}
}

hasuse() {
	hasiuse "$1" && use "$1"
}

EXPORT_FUNCTIONS src_prepare src_test src_install

if hasiuse ljr || hasiuse 1stclassmsg || hasiuse zeromq || [ -n "$BITCOINCORE_POLICY_PATCHES" ]; then
	EXPORT_FUNCTIONS pkg_pretend
fi

# @ECLASS-VARIABLE: BITCOINCORE_COMMITHASH
# @DESCRIPTION:
# Set this variable before the inherit line, to the upstream commit hash.

# @ECLASS-VARIABLE: BITCOINCORE_POLICY_PATCHES
# @DESCRIPTION:
# Set this variable before the inherit line, to a space-delimited list of
# supported policies.

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"
LJR_PV() { echo "${MyPV}.${1}20141224"; }
LJR_PATCHDIR="${MyPN}-$(LJR_PV ljr).patches"
LJR_PATCH() { echo "${WORKDIR}/${LJR_PATCHDIR}/${MyPN}-$(LJR_PV ljr).$@.patch"; }
LJR_PATCH_DESC="http://luke.dashjr.org/programs/${MyPN}/files/${MyPN}d/luke-jr/0.10.x/$(LJR_PV ljr)/${MyPN}-$(LJR_PV ljr).desc.txt"

HOMEPAGE="http://bitcoin.org/"
SRC_URI="https://github.com/${MyPN}/${MyPN}/archive/${COMMITHASH}.tar.gz -> ${MyPN}-v${PV}.tgz
	http://luke.dashjr.org/programs/${MyPN}/files/${MyPN}d/luke-jr/0.10.x/$(LJR_PV ljr)/${LJR_PATCHDIR}.txz -> ${LJR_PATCHDIR}.tar.xz
"

for mypolicy in ${BITCOINCORE_POLICY_PATCHES}; do
	IUSE="$IUSE +bitcoin_policy_${mypolicy}"
done

BITCOINCORE_COMMON_DEPEND="
	>=dev-libs/boost-1.52.0[threads(+)]
	dev-libs/openssl:0[-bindist]
	virtual/bitcoin-leveldb
	=dev-libs/libsecp256k1-0.0.0_pre20141212
"
bitcoincore_common_depend_use() {
	hasiuse "$1" || return
	BITCOINCORE_COMMON_DEPEND="${BITCOINCORE_COMMON_DEPEND} $1? ( $2 )"
}
bitcoincore_common_depend_use upnp net-libs/miniupnpc
bitcoincore_common_depend_use wallet "sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]"
bitcoincore_common_depend_use zeromq net-libs/zeromq
RDEPEND="${RDEPEND} ${BITCOINCORE_COMMON_DEPEND}"
DEPEND="${DEPEND} ${BITCOINCORE_COMMON_DEPEND}
	>=app-shells/bash-4.1
	dev-vcs/git
"

S="${WORKDIR}/${MyPN}-${BITCOINCORE_COMMITHASH}"

bitcoincore_policymsg() {
	local USEFlag="bitcoin_policy_$1"; shift
	hasiuse "${USEFlag}" || return
	if use "${USEFlag}"; then
		[ -n "$2" ] && einfo "$2"
	else
		[ -n "$3" ] && einfo "$3"
	fi
	bitcoincore_policymsg_flag=true
}

bitcoincore_pkg_pretend() {
	bitcoincore_policymsg_flag=false
	if hasuse ljr || hasuse 1stclassmsg || hasuse zeromq; then
		einfo "Extra functionality improvements to Bitcoin Core are enabled."
		bitcoincore_policymsg_flag=true
	fi
	bitcoincore_policymsg cpfp \
		"CPFP policy is enabled: If you mine, you will give consideration to child transaction fees to pay for their parents." \
		"CPFP policy is disabled: If you mine, you will ignore transactions unless they have sufficient fee themselves, even if child transactions offer a fee to cover their cost."
	bitcoincore_policymsg dcmp \
		"Data Carrier Multi-Push policy is enabled: Your node will assist transactions with at most a single multiple-'push' data carrier output." \
		"Data Carrier Multi-Push policy is disabled: Your node will assist transactions with at most a single data carrier output with only a single 'push'."
	bitcoincore_policymsg spamfilter \
		"Enhanced spam filter policy is enabled: Notorious spammers will not be assisted by your node. This may impact your ability to use some spammy services (see link for a list)." \
		"Enhanced spam filter policy is DISABLED: Your node will not be checking for notorious spammers, and may assist them. Set BITCOIN_POLICY=spamfilter to enable."
	$bitcoincore_policymsg_flag && einfo "For more information, see ${LJR_PATCH_DESC}"
}

bitcoincore-v0.10-20141224_pkg_pretend() {
	 bitcoincore_pkg_pretend
}

bitcoincore_prepare() {
	epatch "$(LJR_PATCH syslibs)"
	if hasuse ljr; then
		# Regular epatch won't work with binary files
		local patchfile="$(LJR_PATCH ljrF)"
		einfo "Applying ${patchfile##*/} ..."
		git apply --whitespace=nowarn "${patchfile}"
	fi
	if hasuse 1stclassmsg; then
		epatch "$(LJR_PATCH 1stclassmsg)"
	fi
	hasuse zeromq && epatch "$(LJR_PATCH zeromq)"
	for mypolicy in ${BITCOINCORE_POLICY_PATCHES}; do
		use bitcoin_policy_${mypolicy} && epatch "$(LJR_PATCH ${mypolicy})"
	done
}

bitcoincore_autoreconf() {
	eautoreconf
	rm -r src/leveldb src/secp256k1
}

bitcoincore-v0.10-20141224_src_prepare() {
	 bitcoincore_prepare
	 bitcoincore_autoreconf
}

bitcoincore_conf() {
	local my_econf=
	if hasuse upnp; then
		my_econf="${my_econf} --with-miniupnpc --enable-upnp-default"
	else
		my_econf="${my_econf} --without-miniupnpc --disable-upnp-default"
	fi
	if hasuse test; then
		my_econf="${my_econf} --enable-tests"
	else
		my_econf="${my_econf} --disable-tests"
	fi
	econf \
		--disable-ccache \
		--with-system-leveldb       \
		--with-system-libsecp256k1  \
		--without-libs    \
		--without-daemon  \
		--without-utils   \
		--without-gui     \
		${my_econf}  \
		"$@"
}

bitcoincore_src_test() {
	emake check
}

bitcoincore-v0.10-20141224_src_test() {
	 bitcoincore_src_test
}

bitcoincore_install() {
	emake DESTDIR="${D}" install

	rm "${D}/usr/bin/test_bitcoin"

	dodoc doc/README.md doc/release-notes.md
}

bitcoincore-v0.10-20141224_src_install() {
	 bitcoincore_install
}
