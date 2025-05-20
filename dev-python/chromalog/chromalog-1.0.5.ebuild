# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Enhance Python with colored logging"
HOMEPAGE="https://github.com/freelan-developers/chromalog"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/colorama-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/parameterized[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	default

	# dev-python/nose-parameterized was renamed to dev-python/parameterized
	sed -e '/^from nose_parameterized\b/s/\bnose_//' \
		-i tests/common.py || die

	# setting a format string with no conversion specifiers is rejected on Python>=3.8
	sed -e 's/^from unittest import .*$/\0, skip/' \
		-e 's/^\([[:space:]]*\)def test_basic_config_sets_format/\1@skip("broken on Python>=3.8")\n\0/' \
		-i tests/test_log.py || die
}
