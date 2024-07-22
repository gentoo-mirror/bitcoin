# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1

inherit autotools backports check-reqs distutils-r1 java-pkg-opt-2 multilib-minimal

BACKPORTS=(
)

DESCRIPTION="Collection of useful primitives for cryptocurrency wallets"
HOMEPAGE="https://github.com/ElementsProject/libwally-core"
BACKPORTS_BASE_URI="${HOMEPAGE}/commit/"
SRC_URI="${HOMEPAGE}/archive/release_${PV}.tar.gz -> ${P}.tar.gz
	$(backports_patch_uris)"

LICENSE="MIT CC0-1.0"
SLOT="0/1"  # subslot comes from soname
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
IUSE+=" +asm +elements minimal python test"
RESTRICT="!test? ( test )"

# TODO: js

JAVA_PKG_NV_DEPEND=">=virtual/jdk-1.7"
DEPEND+="
	!elements? ( >=dev-libs/libsecp256k1-0.3.1[${MULTILIB_USEDEP},ecdh,extrakeys,recovery,schnorr] )
	elements? ( >=dev-libs/libsecp256k1-zkp-0.1.0_pre20231101[${MULTILIB_USEDEP},ecdh,ecdsa-s2c,extrakeys,generator,rangeproof,recovery,schnorrsig,surjectionproof,whitelist] )
"
RDEPEND="${DEPEND}
	java? ( >=virtual/jre-1.7 )
	python? ( ${PYTHON_DEPS} )
"
DEPEND+="
	java? ( ${JAVA_PKG_NV_DEPEND} )
"
BDEPEND+="
	virtual/pkgconfig
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

# https://github.com/ElementsProject/libwally-core/pull/409#issuecomment-1713069590
RDEPEND="${RDEPEND//'dev-lang/python:3.12'/'>=dev-lang/python-3.12.0_rc2:3.12'}"
DEPEND="${DEPEND//'dev-lang/python:3.12'/'>=dev-lang/python-3.12.0_rc2:3.12'}"
BDEPEND="${BDEPEND//'dev-lang/python:3.12'/'>=dev-lang/python-3.12.0_rc2:3.12'}"

distutils_enable_sphinx docs/source dev-python/sphinx-rtd-theme

eval "distutils-r1_$(declare -f python_check_deps)"
python_check_deps() {
	case "${EBUILD_PHASE}" in
		compile)
			distutils-r1_python_check_deps ;;
		test)
			[[ "${EPYTHON}" != 'python3.12' ]] || python_has_version '>=dev-lang/python-3.12.0_rc2:3.12' ;;
	esac
}

pkg_pretend() {
	if use minimal ; then
		ewarn "You have enabled the ${PORTAGE_COLOR_HILITE-${HILITE}}minimal${PORTAGE_COLOR_NORMAL-${NORMAL}} USE flag, which is intended for embedded
environments and may adversely affect performance on standard systems."
	fi

	# test/test_scrypt.py is a real memory hog
	use test && CHECKREQS_MEMORY="1G" check-reqs_pkg_pretend
}

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
	use test && CHECKREQS_MEMORY="1G" check-reqs_pkg_setup
}

src_unpack() {
	unpack "${P}.tar.gz"
}

src_prepare() {
	backports_apply_patches
	default
	! use java || has_version '<virtual/jdk-20' ||
		sed -e 's/^\(JAVAC_TARGET\)=.*$/\1=8/' -i configure.ac || die
	eautoreconf
	use java && java-pkg-opt-2_src_prepare
}

multilib_src_configure() {
	multilib_is_native_abi && cd "${S}" # distutils needs in-tree native build
	use python && python_setup
	ECONF_SOURCE="${S}" econf \
		--includedir="${EPREFIX}/usr/include/libwally" \
		--enable-export-all \
		$(use_enable test tests) \
		$(use_enable elements) \
		$(use_enable !elements standard-secp) \
		$(use_enable minimal) \
		$(use_enable asm) \
		$(multilib_native_use_enable {,swig-}java) \
		$(multilib_native_use_enable {,swig-}python) \
		--with-system-secp256k1
}

src_compile() {
	multilib-minimal_src_compile
	if use python ; then
		WALLY_ABI_PY_WHEEL_USE_LIB=shared \
		WALLY_ABI_PY_WHEEL_USE_PKG_SECP256K1=libsecp256k1_zkp \
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
