# Copyright 2010-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 9.5 9.6 10 11 12 13 )

PYTHON_COMPAT=( python3_{6..9} )
PYTHON_SUBDIRS=( contrib/{pyln-client,pylightning} )
DISTUTILS_OPTIONAL=1

inherit bash-completion-r1 distutils-r1 git-r3 postgres toolchain-funcs

MyPN=lightning
PATCHES=(
)

DESCRIPTION="An implementation of Bitcoin's Lightning Network in C"
HOMEPAGE="https://github.com/ElementsProject/${MyPN}"
SRC_URI="https://github.com/zserge/jsmn/archive/v1.0.0.tar.gz -> jsmn-1.0.0.tar.gz"
EGIT_REPO_URI="${HOMEPAGE}.git"
EGIT_SUBMODULES=( '-*' 'external/gheap' )

LICENSE="MIT CC0-1.0 GPL-2 LGPL-2.1 LGPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
KEYWORDS=""
IUSE="developer experimental postgres python sqlite test"

CDEPEND="
	>=dev-libs/libbacktrace-0.0.0_pre20180606
	>=dev-libs/libsecp256k1-0.1_pre20200907[ecdh,extrakeys(-),recovery,schnorr(-)]
	>=dev-libs/libsodium-1.0.16
	>=net-libs/libwally-core-0.8.3:=[elements]
	postgres? ( ${POSTGRES_DEP} )
	python? ( ${PYTHON_DEPS} )
	sqlite? ( dev-db/sqlite:= )
"
RDEPEND="${CDEPEND}
	acct-group/lightning
	acct-user/lightning
"
DEPEND="${CDEPEND}
"
BDEPEND="
	test? ( $(python_gen_any_dep '
		dev-python/mako[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	' -3) )
	python? ( dev-python/setuptools[${PYTHON_USEDEP}] )
	sys-devel/gettext
"
REQUIRED_USE="
	|| ( postgres sqlite )
	postgres? ( ${POSTGRES_REQ_USE} )
	${PYTHON_REQUIRED_USE}
"
# FIXME: bundled deps: ccan

python_check_deps() {
	! use test || {
		has_version "dev-python/mako[${PYTHON_USEDEP}]" &&
		has_version "dev-python/pytest[${PYTHON_USEDEP}]" ; }
}

do_python_phase() {
	local subdir
	for subdir in "${PYTHON_SUBDIRS[@]}" ; do
		pushd "${subdir}" >/dev/null || die
		"${@}"
		popd >/dev/null || die
	done
}

pkg_setup() {
	if use postgres ; then
		postgres_pkg_setup
	else
		export PG_CONFIG=
	fi
}

src_unpack() {
	git-r3_src_unpack
	find "${S}/external" -depth -mindepth 1 -maxdepth 1 -type d ! -name 'gheap' -delete || die
	cd "${S}/external" || die
	unpack jsmn-1.0.0.tar.gz
	mv jsmn{-1.0.0,} || die
}

src_prepare() {
	default

	# hack to suppress tools/refresh-submodules.sh
	sed -e '/^submodcheck:/,/^$/{/^\t/d}' -i external/Makefile

	use sqlite || sed -e $'/^var=HAVE_SQLITE3/,/\\bEND\\b/{/^code=/a#error\n}' -i configure || die

	use python && do_python_phase distutils-r1_src_prepare
}

src_configure() {
	local BUNDLED_LIBS="external/${CHOST}/libjsmn.a"
	. "${FILESDIR}/compat_vars.bash"
	CLIGHTNING_MAKEOPTS=(
		V=1
		DISTRO=Gentoo
		COVERAGE=
		BOLTDIR="${WORKDIR}/does_not_exist"
		COMPAT_CFLAGS="${COMPAT_CFLAGS[*]}"
		SHA256STAMP_CHANGED=false
		LIBSODIUM_HEADERS=
		LIBWALLY_HEADERS=
		LIBSECP_HEADERS=
		LIBBACKTRACE_HEADERS=
		EXTERNAL_LIBS="${BUNDLED_LIBS}"
		EXTERNAL_INCLUDE_FLAGS="-I external/jsmn/ -I external/gheap/ $("$(tc-getPKG_CONFIG)" --cflags libsodium wallycore libsecp256k1)"
		EXTERNAL_LDLIBS="${BUNDLED_LIBS} $("$(tc-getPKG_CONFIG)" --libs libsodium wallycore libsecp256k1) -lbacktrace"
		docdir="/usr/share/doc/${PF}"
	)

	use sqlite || CLIGHTNING_MAKEOPTS+=(
		SQLITE3_CFLAGS=
		SQLITE3_LDLIBS=
	)

	use test && python_setup
	./configure \
		CC="$(tc-getCC)" \
		CONFIGURATOR_CC="$(tc-getBUILD_CC)" \
		CWARNFLAGS= \
		CDEBUGFLAGS='-std=gnu11' \
		COPTFLAGS="${CFLAGS}" \
		--prefix="${EPREFIX}"/usr \
		$(use_enable developer) \
		$(use_enable experimental{,-features}) \
		--disable-compat \
		--disable-valgrind \
		--disable-static \
		--disable-address-sanitizer \
		|| die

	use python && do_python_phase distutils-r1_src_configure
}

src_compile() {
	use test && python_setup
	emake "${CLIGHTNING_MAKEOPTS[@]}" \
		all-programs \
		$(usex test 'all-test-programs' '') \
		doc-all

	use python && do_python_phase distutils-r1_src_compile
}

python_install_all() {
	DOCS= distutils-r1_python_install_all
	docinto "${PWD##*/}"
	dodoc README*
}

src_install() {
	emake "${CLIGHTNING_MAKEOPTS[@]}" DESTDIR="${D}" install

	dodoc doc/{PLUGINS.md,TOR.md}

	insinto /etc/lightning
	newins "${FILESDIR}/lightningd-${PV}.conf" lightningd.conf
	fowners :lightning /etc/lightning/lightningd.conf
	fperms 0640 /etc/lightning/lightningd.conf

	newinitd "${FILESDIR}/init.d-lightningd" lightningd
	newconfd "${FILESDIR}/conf.d-lightningd" lightningd

	newbashcomp contrib/lightning-cli.bash-completion lightning-cli

	use python && do_python_phase distutils-r1_src_install

	insinto "/etc/portage/savedconfig/${CATEGORY}"
	newins compat.vars "${PN}"
}

pkg_preinst() {
	if [[ -e ${EROOT%/}/etc/lightning/config && ! -e ${EROOT%/}/etc/lightning/lightningd.conf ]] ; then
		elog "Moving your /etc/lightning/config to /etc/lightning/lightningd.conf"
		mv --no-clobber -- "${EROOT%/}/etc/lightning/"{config,lightningd.conf}
	fi

	[[ -e ${EROOT%/}/usr/bin/hsmtool ]] && had_hsmtool=1
}

pkg_postinst() {
	elog 'To use lightning-cli with the /etc/init.d/lightningd service:'
	elog " - Add your user(s) to the 'lightning' group."
	elog ' - Symlink ~/.lightning to /var/lib/lightning.'

	if [[ ${had_hsmtool} ]] ; then
		ewarn "Upstream has renamed the ${HILITE}hsmtool${NORMAL} executable to ${HILITE}lightning-hsmtool${NORMAL}."
		ewarn 'Please adjust your scripts and workflows accordingly.'
	fi
}
