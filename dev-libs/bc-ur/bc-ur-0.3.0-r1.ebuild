# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools backports

BACKPORTS=(
	9a21a885b2b49d56eb2b0b2f81551daab2838ef8	# Fix nunchuk
)

DESCRIPTION="Uniform Resources reference library in C++"
HOMEPAGE="https://github.com/BlockchainCommons/bc-ur"
BACKPORTS_BASE_URI="https://github.com/bakaoh/bc-ur/commit/"
SRC_URI="
	${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	$(backports_patch_uris)
"

LICENSE="BSD-2-with-patent"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

PATCHES=(
	"${FILESDIR}/0.3.0-automake.patch"
)

src_prepare() {
	backports_apply_patches
	default
	rm {,src/,test/}Makefile.in config.h.in configure || die
	eautoreconf

	# avoid declaring namespace std inside namespace ur
	sed -e 's/^#include <stdint\.h>$/#include <cstdint>/' -i src/xoshiro256.hpp || die
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
