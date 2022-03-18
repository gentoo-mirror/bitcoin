# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Twisted-based Tor controller client, with state-tracking and config abstractions"
HOMEPAGE="https://github.com/meejah/txtorcon https://pypi.org/project/txtorcon/ https://txtorcon.readthedocs.org"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

PYTHON_DEPEND='
	dev-python/automat[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/incremental[${PYTHON_USEDEP}]
	>=dev-python/twisted-15.5.0[${PYTHON_USEDEP},crypt]
	>=dev-python/zope-interface-3.6.1[${PYTHON_USEDEP}]
'
RDEPEND="
	${PYTHON_DEPEND//'${PYTHON_USEDEP}'/${PYTHON_USEDEP}}
	sys-process/lsof
"
DEPEND=""
DOC_DEPEND="${PYTHON_DEPEND}"'
	>=dev-python/repoze-sphinx-autointerface-0.4[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
'
BDEPEND="
	doc? ( $(python_gen_any_dep "${DOC_DEPEND}") )
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/txtorcon-0.19.3-Removeunconditionalexamples.patch"
	"${FILESDIR}/txtorcon-0.19.3-Removeinstalldocs.patch"
)

python_check_deps() {
	use !doc || python_has_version ${DOC_DEPEND//'${PYTHON_USEDEP}'/${PYTHON_USEDEP}}
}

python_test() {
	trial --temp-directory="${T}/_trial_temp-${EPYTHON}" test ||
		die "Tests failed with ${EPYTHON}"
}

python_compile_all() {
	use doc && emake -C "${S}/docs" html
}

python_install() {
	distutils-r1_python_install
	rm -f "${D}$(python_get_sitedir)/twisted/plugins/dropin.cache" || die
}

python_install_all() {
	use examples && dodoc -r "${S}/examples/"
	if use doc ; then
		docinto html
		dodoc -r "${S}/docs/_build/html/"*
	fi
	distutils-r1_python_install_all
}

pkg_postinst() {
	python_foreach_impl twisted-regen-cache || die
}

pkg_postrm() {
	python_foreach_impl twisted-regen-cache || die
}
