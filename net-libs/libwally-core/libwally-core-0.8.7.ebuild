# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools

inherit autotools distutils-r1 java-pkg-opt-2 multilib-minimal

PATCH_HASHES=(
	312d688ddcc0889f644d81c2fe37d2432186051d	# test: skip non-applicable tests if BUILD_STANDARD_SECP
)
PATCH_FILES=( "${PATCH_HASHES[@]/%/.patch}" )
PATCHES=(
	"${PATCH_FILES[@]/#/${DISTDIR%/}/}"
)

DESCRIPTION="Collection of useful primitives for cryptocurrency wallets"
HOMEPAGE="https://github.com/ElementsProject/libwally-core"
SRC_URI="${HOMEPAGE}/archive/release_${PV}.tar.gz -> ${P}.tar.gz
	${PATCH_FILES[@]/#/${HOMEPAGE}/commit/}"

LICENSE="MIT CC0-1.0"
SLOT="0/0.8.7"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
IUSE+=" +asm doc elements minimal python test"
RESTRICT="!test? ( test )"

# TODO: js

JAVA_PKG_NV_DEPEND=">=virtual/jdk-1.7"
DEPEND+="
	!elements? ( >=dev-libs/libsecp256k1-0.1.0_pre20220329[${MULTILIB_USEDEP},ecdh,extrakeys,recovery] )
	elements? ( >=dev-libs/libsecp256k1-zkp-0.1.0_pre20220721[${MULTILIB_USEDEP},ecdh,ecdsa-s2c,extrakeys,generator,rangeproof,recovery,surjectionproof,whitelist] )
"
RDEPEND="${DEPEND}
	!<net-p2p/core-lightning-0.9.3-r2
	!=net-p2p/core-lightning-9999
	java? ( >=virtual/jre-1.7 )
	python? ( ${PYTHON_DEPS} )
"
DEPEND+="
	java? ( ${JAVA_PKG_NV_DEPEND} )
"
BDEPEND+="
	java? (
		dev-lang/swig[pcre]
		${JAVA_PKG_NV_DEPEND}
	)
	python? (
		>=dev-lang/swig-3.0.12[pcre]
		${PYTHON_DEPS}
		${DISTUTILS_DEPS}
		>=dev-python/pkgconfig-1.5.3[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		!python? ( $(python_gen_any_dep) )
	)
"
REQUIRED_USE="
	java? ( elements )
	python? ( ${PYTHON_REQUIRED_USE} elements )
"

S="${WORKDIR}/${PN}-release_${PV}"

PATCHES+=(
	"${FILESDIR}/0.8.6-sys_libsecp256k1_zkp.patch"
	"${FILESDIR}/0.8.6-python-module-dynamic-link.patch"
)

distutils_enable_sphinx docs/source dev-python/sphinx_rtd_theme

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
}

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
}

src_unpack() {
	unpack "${P}.tar.gz"
}

src_prepare() {
	sed -e 's|\(#[[:space:]]*include[[:space:]]\+\)"\(src/\)\?secp256k1/include/\(.*\)"|\1<\3>|' \
		-i src/*.{c,h} || die
	rm -r src/secp256k1
	default
	sed -e 's/==/=/g' -i configure.ac || die
	sed -e '/^if not is_windows/,/make -j/d' -i setup.py || die
	eautoreconf
	use java && java-pkg-opt-2_src_prepare
}

multilib_src_configure() {
	multilib_is_native_abi && cd "${S}" # distutils needs in-tree native build
	ECONF_SOURCE="${S}" econf \
		--includedir="${EPREFIX}/usr/include/libwally" \
		--enable-export-all \
		$(use_enable test tests) \
		$(use_enable elements) \
		$(use_enable !elements standard-secp) \
		$(use_enable minimal) \
		$(use_enable asm) \
		$(multilib_native_use_enable {,swig-}java) \
		$(multilib_native_use_enable {,swig-}python)
}

src_compile() {
	multilib-minimal_src_compile
	if use python ; then
		distutils-r1_src_compile
	elif use doc ; then
		python_setup
		sphinx_compile_all
	fi
}

multilib_src_compile() {
	multilib_is_native_abi && cd "${S}"
	default
}

python_test() {
	emake -C src check-swig-python PYTHON="${EPYTHON}"
}

src_test() {
	python_setup
	multilib-minimal_src_test
	use java && emake -C src check-swig-java
	use python && distutils-r1_src_test
}

multilib_src_test() {
	multilib_is_native_abi && cd "${S}"
	emake -C src check-{TESTS,libwallycore} PYTHON="${EPYTHON}"
}

src_install() {
	multilib-minimal_src_install
	find "${ED}" -name '*.la' -delete || die
	use java && java-pkg_dojar src/swig_java/wallycore.jar
	use python && distutils-r1_src_install
}

multilib_src_install() {
	multilib_is_native_abi && cd "${S}"
	emake DESTDIR="${ED}" install
}

pkg_preinst() {
	use java && java-pkg-opt-2_pkg_preinst
}
