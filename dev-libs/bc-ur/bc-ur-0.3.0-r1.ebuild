# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Uniform Resources reference library in C++"
HOMEPAGE="https://github.com/BlockchainCommons/bc-ur"
SRC_URI="${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2-with-patent"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

PATCHES=(
	"${FILESDIR}/0.3.0-automake.patch"
)

src_prepare() {
	default
	rm {,src/,test/}Makefile.in config.h.in configure || die
	eautoreconf

	# add missing includes (after all existing includes)
	local header files ; while read -r header files ; do
		sed -e 'H;/^#include\b/!{$!d};s/.*//;x;s/^\n//;$s|^|#include '"${header}"'\n|' \
			-i ${files} || die
	done <<-EOF
		<cstdint> src/cbor-lite.hpp src/ur.hpp
		<cstring> src/xoshiro256.cpp
	EOF
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
