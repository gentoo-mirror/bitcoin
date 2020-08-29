# Copyright 2010-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 9.5 9.6 10 11 12 13 )

PYTHON_COMPAT=( python{3_6,3_7,3_8} )
PYTHON_SUBDIRS=( contrib/{pyln-client,pylightning} )
DISTUTILS_OPTIONAL=1

inherit bash-completion-r1 distutils-r1 postgres toolchain-funcs

MyPN=lightning
MyPV=$(ver_rs 3 - "${PV//_}")
PATCH_HASHES=(
	0a501b3646d298f11420a9cdd8892742f7bad498	# configure: Use pg_config to locate the header location
)
PATCH_FILES=( "${PATCH_HASHES[@]/%/.patch}" )
PATCHES=(
	"${PATCH_FILES[@]/#/${DISTDIR%/}/}"
	"${FILESDIR}/${PV}-configure-database-support.patch"
)

DESCRIPTION="An implementation of Bitcoin's Lightning Network in C"
HOMEPAGE="https://github.com/ElementsProject/${MyPN}"
SRC_URI="${HOMEPAGE}/archive/v${MyPV}.tar.gz -> ${P}.tar.gz
	https://github.com/zserge/jsmn/archive/v1.0.0.tar.gz -> jsmn-1.0.0.tar.gz
	${PATCH_FILES[@]/#/${HOMEPAGE}/commit/}"

LICENSE="MIT CC0-1.0 GPL-2 LGPL-2.1 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm64 ~mips ~ppc ~x86 ~x86-linux"
IUSE="developer experimental postgres python sqlite test"

CDEPEND="
	>=dev-libs/libbacktrace-0.0.0_pre20180606
	>=dev-libs/libsecp256k1-0.1_pre20181017[ecdh,recovery]
	>=dev-libs/libsodium-1.0.16
	>=net-libs/libwally-core-niftynei-0.7.9_pre20200713[elements]
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
	$(python_gen_any_dep '
		dev-python/mako[${PYTHON_USEDEP}]
		test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	' -3)
	python? ( dev-python/setuptools[${PYTHON_USEDEP}] )
	sys-devel/gettext
"
REQUIRED_USE="
	|| ( postgres sqlite )
	postgres? ( ${POSTGRES_REQ_USE} )
	${PYTHON_REQUIRED_USE}
"
# FIXME: bundled deps: ccan

S=${WORKDIR}/${MyPN}-${MyPV}

python_check_deps() {
	has_version "dev-python/mako[${PYTHON_USEDEP}]" &&
		{ ! use test || has_version "dev-python/pytest[${PYTHON_USEDEP}]" ; }
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
	unpack "${P}.tar.gz"
	rm -r "${S}/external"/*/
	cd "${S}/external" || die
	unpack jsmn-1.0.0.tar.gz
	mv jsmn{-1.0.0,}
}

src_prepare() {
	default

	use sqlite || sed -e $'/^var=HAVE_SQLITE3/,/\\bEND\\b/{/^code=/a#error\n}' -i configure || die

	use python && do_python_phase distutils-r1_src_prepare
}

src_configure() {
	local BUNDLED_LIBS="external/${CHOST}/libjsmn.a"
	CLIGHTNING_MAKEOPTS=(
		V=1
		VERSION="${MyPV}"
		DISTRO=Gentoo
		COVERAGE=
		BOLTDIR="${WORKDIR}/does_not_exist"
		LIBSODIUM_HEADERS=
		LIBWALLY_HEADERS=
		LIBSECP_HEADERS=
		SUBMODULES=none
		EXTERNAL_LIBS="${BUNDLED_LIBS}"
		EXTERNAL_INCLUDE_FLAGS="-I external/jsmn/ $("$(tc-getPKG_CONFIG)" --cflags libsodium wallycore libsecp256k1)"
		EXTERNAL_LDLIBS="${BUNDLED_LIBS} $("$(tc-getPKG_CONFIG)" --libs libsodium wallycore libsecp256k1) -lbacktrace"
		CHANGED_FROM_GIT=false
		docdir="/usr/share/doc/${PF}"
	)

	python_setup
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

	# hack to suppress tools/refresh-submodules.sh
	mkdir .refresh-submodules

	use python && do_python_phase distutils-r1_src_configure
}

src_compile() {
	python_setup
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
	newins "${FILESDIR}/lightningd-$(ver_cut 1-3).conf" lightningd.conf
	fowners :lightning /etc/lightning/lightningd.conf
	fperms 0640 /etc/lightning/lightningd.conf

	newinitd "${FILESDIR}/init.d-lightningd" lightningd
	newconfd "${FILESDIR}/conf.d-lightningd" lightningd

	newbashcomp contrib/lightning-cli.bash-completion lightning-cli

	use python && do_python_phase distutils-r1_src_install
}

pkg_preinst() {
	has_version '<net-p2p/c-lightning-0.8' && had_pre_0_8_0=1

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

	# warn when upgrading from pre-0.8.0
	if [[ ${had_pre_0_8_0} || -e ${EROOT%/}/var/lib/lightning/hsm_secret ]] ; then
		ewarn 'This version of C-Lightning maintains its data files in network-specific'
		ewarn 'subdirectories of its base directory. Your existing data files will be'
		ewarn 'migrated automatically upon first startup of the new version.'
	fi

	if [[ ${had_hsmtool} ]] ; then
		ewarn "Upstream has renamed the ${HILITE}hsmtool${NORMAL} executable to ${HILITE}lightning-hsmtool${NORMAL}."
		ewarn 'Please adjust your scripts and workflows accordingly.'
	fi
}
