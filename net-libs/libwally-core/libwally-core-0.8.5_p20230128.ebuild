# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools backports multilib-minimal

MyPV=$(ver_cut 1-3)
BACKPORTS=(
	d839dbab4279e1d3d1ece4e52d4766f523b3f7ee	# script: merge back multisig fix to 0.8.5
)

DESCRIPTION="Collection of useful primitives for cryptocurrency wallets"
HOMEPAGE="https://github.com/ElementsProject/libwally-core"
BACKPORTS_BASE_URI="${HOMEPAGE}/commit/"
SRC_URI="${HOMEPAGE}/archive/release_${MyPV}.tar.gz -> ${PN}-${MyPV}.tar.gz
	$(backports_patch_uris)"

LICENSE="MIT CC0-1.0"
SLOT="0/0.8.2"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
IUSE="+asm elements minimal test"
RESTRICT="!test? ( test )"

# TODO: python, java, js

DEPEND="
	!elements? ( >=dev-libs/libsecp256k1-0.1.0_pre20220329[${MULTILIB_USEDEP},ecdh,recovery] )
	elements? ( >=dev-libs/libsecp256k1-zkp-0.1.0_pre20220401[${MULTILIB_USEDEP},ecdh,ecdsa-s2c,generator,rangeproof,recovery,surjectionproof,whitelist] )
"
RDEPEND="${DEPEND}
	!<net-p2p/core-lightning-0.9.3-r2
	!=net-p2p/core-lightning-9999
"

S="${WORKDIR}/${PN}-release_${MyPV}"

PATCHES=(
	"${FILESDIR}/0.8.5-sys_libsecp256k1_zkp.patch"
)

pkg_pretend() {
	if has_version "<${CATEGORY}/${PN}-0.8.2" &&
		[[ -x "${EROOT%/}/usr/bin/lightningd" ]] &&
		{ has_version '<net-p2p/core-lightning-0.9.3-r2' || has_version '=net-p2p/core-lightning-9999' ; } &&
		[[ "$(find /proc/[0-9]*/exe -xtype f -lname "${EROOT%/}/usr/bin/lightningd*" -print -quit 2>/dev/null)" ||
			-x "${EROOT%/}/run/openrc/started/lightningd" ]]
	then
		eerror "${CATEGORY}/${PN}-0.8.2 introduced a binary-incompatible change.
Installing version ${PV} while running an instance of Core Lightning that
was compiled against a pre-0.8.2 version of ${PN} will cause
assertion failures in newly spawned Core Lightning subdaemons. Please stop
the running lightningd daemon and then reattempt this installation."
		die 'lightningd is running'
	fi

	if use minimal ; then
		ewarn "You have enabled the ${PORTAGE_COLOR_HILITE-${HILITE}}minimal${PORTAGE_COLOR_NORMAL-${NORMAL}} USE flag, which is intended for embedded
environments and may adversely affect performance on standard systems."
	fi
}

src_unpack() {
	unpack "${PN}-${MyPV}.tar.gz"
}

src_prepare() {
	backports_apply_patches
	sed -e 's|\(#[[:space:]]*include[[:space:]]\+\)"\(src/\)\?secp256k1/include/\(.*\)"|\1<\3>|' \
		-i src/*.{c,h} || die
	rm -r src/secp256k1
	default
	sed -e 's/==/=/g' -i configure.ac || die
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--includedir="${EPREFIX}/usr/include/libwally" \
		--enable-export-all \
		$(use_enable test tests) \
		$(use_enable elements) \
		$(use_enable !elements standard-secp) \
		$(use_enable minimal) \
		$(use_enable asm)
}

multilib_src_install_all() {
	default
	find "${ED}" -name '*.la' -delete || die
}
