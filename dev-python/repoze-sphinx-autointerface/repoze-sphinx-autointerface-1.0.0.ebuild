# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN//-/.}

inherit distutils-r1 pypi

DESCRIPTION="Sphinx extension: auto-generates API docs from Zope interfaces"
HOMEPAGE="https://pypi.org/project/repoze.sphinx.autointerface/"

LICENSE="repoze"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/sphinx-4.0[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_prepare() {
	default

	# don't install the unit tests
	sed -e 's/\(packages=find_packages\)()/\1(exclude=["repoze.sphinx.tests"])/' \
		-e 's/\(include_package_data=\)True/\1False/' \
		-i setup.py || die
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}
