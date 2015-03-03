# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# @ECLASS: bitcoincore.eclass
# @MAINTAINER:
# Luke Dashjr <luke_gentoo_bitcoin@dashjr.org>
# @BLURB: common code for Bitcoin Core ebuilds
# @DESCRIPTION:
# This eclass is used in Bitcoin Core ebuilds (bitcoin-qt, bitcoind,
# libbitcoinconsensus) to provide a single common place for the common ebuild
# stuff.
#
# The eclass provides all common dependencies as well as common use flags.

has "${EAPI:-0}" 5 || die "EAPI=${EAPI} not supported"

if [[ ! ${_BITCOINCORE_ECLASS} ]]; then

in_bcc_iuse() {
	local liuse=( ${BITCOINCORE_IUSE} )
	has "${1}" "${liuse[@]#[+-]}"
}

in_bcc_policy() {
	local liuse=( ${BITCOINCORE_POLICY_PATCHES} )
	has "${1}" "${liuse[@]#[+-]}"
}

DB_VER="4.8"
inherit autotools db-use eutils

if [ -z "$BITCOINCORE_COMMITHASH" ]; then
	inherit git-2
fi

fi

EXPORT_FUNCTIONS src_prepare src_test src_install

if in_bcc_iuse ljr || in_bcc_iuse 1stclassmsg || in_bcc_iuse zeromq || [ -n "$BITCOINCORE_POLICY_PATCHES" ]; then
	EXPORT_FUNCTIONS pkg_pretend
fi

if [[ ! ${_BITCOINCORE_ECLASS} ]]; then

# @ECLASS-VARIABLE: BITCOINCORE_COMMITHASH
# @DESCRIPTION:
# Set this variable before the inherit line, to the upstream commit hash.

# @ECLASS-VARIABLE: BITCOINCORE_IUSE
# @DESCRIPTION:
# Set this variable before the inherit line, to the USE flags supported.

# @ECLASS-VARIABLE: BITCOINCORE_LJR_DATE
# @DESCRIPTION:
# Set this variable before the inherit line, to the datestamp of the ljr
# patchset.

# @ECLASS-VARIABLE: BITCOINCORE_POLICY_PATCHES
# @DESCRIPTION:
# Set this variable before the inherit line, to a space-delimited list of
# supported policies.

# These are expected to change in future versions
DOCS="${DOCS} doc/README.md doc/release-notes.md"
OPENSSL_DEPEND="dev-libs/openssl:0[-bindist]"
WALLET_DEPEND="sys-libs/db:$(db_ver_to_slot "${DB_VER}")[cxx]"

case "${PV}" in
0.10*)
	BITCOINCORE_SERIES="0.10.x"
	LIBSECP256K1_DEPEND="=dev-libs/libsecp256k1-0.0.0_pre20141212"
	BITCOINCORE_RBF_DIFF="e43f25c5b1c7b38d28cd0fba09098a9d56d9ac6b...eb22364e5a7cd2595d98c890e3668e97c0905a06"
	BITCOINCORE_XT_DIFF="047a89831760ff124740fe9f58411d57ee087078...d4084b62c42c38bfe302d712b98909ab26ecce2f"
	;;
9999*)
	BITCOINCORE_SERIES="9999"
	LIBSECP256K1_DEPEND="=dev-libs/libsecp256k1-9999"
	;;
*)
	die "Unrecognised version"
	;;
esac

MyPV="${PV/_/}"
MyPN="bitcoin"
MyP="${MyPN}-${MyPV}"
LJR_PV() { echo "${MyPV}.${1}${BITCOINCORE_LJR_DATE}"; }
LJR_PATCHDIR="${MyPN}-$(LJR_PV ljr).patches"
LJR_PATCH() { echo "${WORKDIR}/${LJR_PATCHDIR}/${MyPN}-$(LJR_PV ljr).$@.patch"; }
LJR_PATCH_DESC="http://luke.dashjr.org/programs/${MyPN}/files/${MyPN}d/luke-jr/${BITCOINCORE_SERIES}/$(LJR_PV ljr)/${MyPN}-$(LJR_PV ljr).desc.txt"

HOMEPAGE="https://github.com/bitcoin/bitcoin"

if [ -z "$BITCOINCORE_COMMITHASH" ]; then
	EGIT_PROJECT='bitcoin'
	EGIT_REPO_URI="git://github.com/bitcoin/bitcoin.git https://github.com/bitcoin/bitcoin.git"
else
	SRC_URI="https://github.com/${MyPN}/${MyPN}/archive/${BITCOINCORE_COMMITHASH}.tar.gz -> ${MyPN}-v${PV}.tgz"
	if [ -z "${BITCOINCORE_NO_SYSLIBS}" ]; then
		SRC_URI="${SRC_URI} http://luke.dashjr.org/programs/${MyPN}/files/${MyPN}d/luke-jr/${BITCOINCORE_SERIES}/$(LJR_PV ljr)/${LJR_PATCHDIR}.txz -> ${LJR_PATCHDIR}.tar.xz"
	fi
	if in_bcc_iuse xt; then
		BITCOINXT_PATCHFILE="${MyPN}xt-v${PV}.patch"
		SRC_URI="${SRC_URI} xt? ( https://github.com/bitcoinxt/bitcoinxt/compare/${BITCOINCORE_XT_DIFF}.diff -> ${BITCOINXT_PATCHFILE} )"
	fi
	if in_bcc_policy rbf; then
		BITCOINCORE_RBF_PATCHFILE="${MyPN}-rbf-v${PV}.patch"
		SRC_URI="${SRC_URI} bitcoin_policy_rbf? ( https://github.com/petertodd/bitcoin/compare/${BITCOINCORE_RBF_DIFF}.diff -> ${BITCOINCORE_RBF_PATCHFILE} )"
	fi
	S="${WORKDIR}/${MyPN}-${BITCOINCORE_COMMITHASH}"
fi

bitcoincore_policy_iuse() {
	local mypolicy iuse_def new_BITCOINCORE_IUSE=
	for mypolicy in ${BITCOINCORE_POLICY_PATCHES}; do
		if [[ "${mypolicy:0:1}" =~ ^[+-] ]]; then
			iuse_def=${mypolicy:0:1}
			mypolicy="${mypolicy:1}"
		else
			iuse_def=
		fi
		new_BITCOINCORE_IUSE="$new_BITCOINCORE_IUSE ${iuse_def}bitcoin_policy_${mypolicy}"
	done
	echo $new_BITCOINCORE_IUSE
}
IUSE="$IUSE $BITCOINCORE_IUSE $(bitcoincore_policy_iuse)"
if in_bcc_policy rbf && in_bcc_iuse xt; then
	REQUIRED_USE="${REQUIRED_USE} bitcoin_policy_rbf? ( !xt )"
fi

BITCOINCORE_COMMON_DEPEND="
	${OPENSSL_DEPEND}
"
if [ "${BITCOINCORE_NEED_LIBSECP256K1}" = "1" ]; then
	BITCOINCORE_COMMON_DEPEND="${BITCOINCORE_COMMON_DEPEND} $LIBSECP256K1_DEPEND"
fi
if [ "${PN}" != "libbitcoinconsensus" ]; then
	BITCOINCORE_COMMON_DEPEND="${BITCOINCORE_COMMON_DEPEND} >=dev-libs/boost-1.52.0[threads(+)]"
fi
bitcoincore_common_depend_use() {
	in_bcc_iuse "$1" || return
	BITCOINCORE_COMMON_DEPEND="${BITCOINCORE_COMMON_DEPEND} $1? ( $2 )"
}
bitcoincore_common_depend_use upnp net-libs/miniupnpc
bitcoincore_common_depend_use wallet "${WALLET_DEPEND}"
bitcoincore_common_depend_use zeromq net-libs/zeromq
RDEPEND="${RDEPEND} ${BITCOINCORE_COMMON_DEPEND}"
DEPEND="${DEPEND} ${BITCOINCORE_COMMON_DEPEND}
	>=app-shells/bash-4.1
	sys-apps/sed
"
if [ "${BITCOINCORE_NEED_LEVELDB}" = "1" ]; then
	RDEPEND="${RDEPEND} virtual/bitcoin-leveldb"
fi
if in_bcc_iuse ljr && [ "$BITCOINCORE_SERIES" = "0.10.x" ]; then
	DEPEND="${DEPEND} ljr? ( dev-vcs/git )"
fi

bitcoincore_policymsg() {
	local USEFlag="bitcoin_policy_$1"
	in_iuse "${USEFlag}" || return
	if use "${USEFlag}"; then
		[ -n "$2" ] && einfo "$2"
	else
		[ -n "$3" ] && einfo "$3"
	fi
	bitcoincore_policymsg_flag=true
}

bitcoincore_pkg_pretend() {
	bitcoincore_policymsg_flag=false
	if use_if_iuse ljr || use_if_iuse 1stclassmsg || use_if_iuse xt || use_if_iuse zeromq; then
		einfo "Extra functionality improvements to Bitcoin Core are enabled."
		bitcoincore_policymsg_flag=true
	fi
	bitcoincore_policymsg cpfp \
		"CPFP policy is enabled: If you mine, you will give consideration to child transaction fees to pay for their parents." \
		"CPFP policy is disabled: If you mine, you will ignore transactions unless they have sufficient fee themselves, even if child transactions offer a fee to cover their cost."
	bitcoincore_policymsg dcmp \
		"Data Carrier Multi-Push policy is enabled: Your node will assist transactions with at most a single multiple-'push' data carrier output." \
		"Data Carrier Multi-Push policy is disabled: Your node will assist transactions with at most a single data carrier output with only a single 'push'."
	bitcoincore_policymsg rbf \
		"Replace By Fee policy is enabled: Your node will preferentially mine and relay transactions paying the highest fee, regardless of receive order." \
		"Replace By Fee policy is disabled: Your node will only accept the first transaction seen consuming a conflicting input, regardless of fee offered by later ones."
	bitcoincore_policymsg spamfilter \
		"Enhanced spam filter policy is enabled: Your node will identify notorious spam scripts and avoid assisting them. This may impact your ability to use some services (see link for a list)." \
		"Enhanced spam filter policy is disabled: Your node will not be checking for notorious spam scripts, and may assist them."
	$bitcoincore_policymsg_flag && einfo "For more information on any of the above, see ${LJR_PATCH_DESC}"
}

bitcoincore_prepare() {
	if [ -n "${BITCOINCORE_NO_SYSLIBS}" ]; then
		true
	elif [ "${PV}" = "9999" ]; then
		epatch "${FILESDIR}/0.9.0-sys_leveldb.patch"
		# Temporarily use embedded secp256k1 while API is in flux
		#epatch "${FILESDIR}/${PV}-sys_libsecp256k1.patch"
	else
		epatch "$(LJR_PATCH syslibs)"
	fi
	if use_if_iuse ljr; then
		if [ "${BITCOINCORE_SERIES}" = "0.10.x" ]; then
			# Regular epatch won't work with binary files
			local patchfile="$(LJR_PATCH ljrF)"
			einfo "Applying ${patchfile##*/} ..."
			git apply --whitespace=nowarn "${patchfile}" || die
		else
			epatch "$(LJR_PATCH ljrF)"
		fi
	fi
	if use_if_iuse 1stclassmsg; then
		epatch "$(LJR_PATCH 1stclassmsg)"
	fi
	if use_if_iuse xt; then
		epatch "${DISTDIR}/${BITCOINXT_PATCHFILE}"
	fi
	use_if_iuse zeromq && epatch "$(LJR_PATCH zeromq)"
	for mypolicy in ${BITCOINCORE_POLICY_PATCHES}; do
		mypolicy="${mypolicy#[-+]}"
		use bitcoin_policy_${mypolicy} || continue
		case "${mypolicy}" in
		rbf)
			epatch "${DISTDIR}/${BITCOINCORE_RBF_PATCHFILE}"
			;;
		*)
			epatch "$(LJR_PATCH ${mypolicy})"
			;;
		esac
	done
}

bitcoincore_autoreconf() {
	eautoreconf
	rm -r src/leveldb || die
	
	# Temporarily using embedded secp256k1 for 9999 while API is in flux
	if [ "${PV}" != "9999" ]; then
		rm -r src/secp256k1 || die
	fi
}

bitcoincore_src_prepare() {
	 bitcoincore_prepare
	 bitcoincore_autoreconf
}

bitcoincore_conf() {
	local my_econf=
	if use_if_iuse upnp; then
		my_econf="${my_econf} --with-miniupnpc --enable-upnp-default"
	else
		my_econf="${my_econf} --without-miniupnpc --disable-upnp-default"
	fi
	if use_if_iuse test; then
		my_econf="${my_econf} --enable-tests"
	else
		my_econf="${my_econf} --disable-tests"
	fi
	if use_if_iuse wallet; then
		my_econf="${my_econf} --enable-wallet"
	else
		my_econf="${my_econf} --disable-wallet"
	fi
	if [ -z "${BITCOINCORE_NO_SYSLIBS}" ] && [ "${PV}" != "9999" ]; then
		my_econf="${my_econf} --disable-util-cli --disable-util-tx"
	else
		my_econf="${my_econf} --without-utils"
	fi
	if [ "${BITCOINCORE_NEED_LEVELDB}" = "1" ]; then
		# Passing --with-system-leveldb fails if leveldb is not installed, so only use it for targets that use LevelDB
		my_econf="${my_econf} --with-system-leveldb"
	fi
	econf \
		--disable-ccache \
		--disable-static \
		--with-system-libsecp256k1  \
		--without-libs    \
		--without-daemon  \
		--without-gui     \
		${my_econf}  \
		"$@"
}

bitcoincore_src_test() {
	emake check
}

bitcoincore_src_install() {
	default
	[ "${PN}" = "libbitcoinconsensus" ] || rm "${D}/usr/bin/test_bitcoin"
}

_BITCOINCORE_ECLASS=1
fi
