# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Test twisted code with pytest"
HOMEPAGE="https://github.com/pytest-dev/pytest-twisted"

PATCH_HASHES=(
	24dff9f710a02ceb5bb63049ab6dfd591321ca3a	# specify just pytester as the plugin
)
PATCH_FILES=( "${PATCH_HASHES[@]/%/.patch}" )
PATCHES=(
	"${PATCH_FILES[@]/#/${DISTDIR%/}/}"
)

SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${PATCH_FILES[@]/#/${HOMEPAGE}/commit/}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	dev-python/greenlet[${PYTHON_USEDEP}]
	>=dev-python/pytest-2.3[${PYTHON_USEDEP}]
	>=dev-python/twisted-22.1.0[${PYTHON_USEDEP}]
"
DEPEND=""
BDEPEND=""

distutils_enable_tests pytest

scrub_pytest11_entry_points() {
	local prev_shopt=$(shopt -p nullglob)
	shopt -s nullglob
	set -- "${BUILD_DIR}/install$(python_get_sitedir)"/*.dist-info/entry_points.txt
	sed -ne '/^\[pytest11\]/{:0;n;/^\[/!b0};p' -i -- "${@}" || die
	local each ; for each ; do
		if [[ -s "${each}" ]] ; then
			sed -e 's/\(\.dist-info\/entry_points\.txt\),[^,]*,[[:digit:]]*$/\1,,/' \
				-i -- "${each%/*}/RECORD" || die
		else
			rm -- "${each}" || die
			sed -e '/\.dist-info\/entry_points\.txt,/d' -i -- "${each%/*}/RECORD" || die
		fi
	done
	${prev_shopt}
}

python_install() {
	# If we let pytest-twisted autoload everywhere, it breaks tests in
	# packages that don't expect it. Apply a similar hack as for bug
	# #661218. We can't do this in src_prepare() because the tests need
	# autoloading enabled.
	scrub_pytest11_entry_points

	distutils-r1_python_install
}
