# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils versionator git-r3 cmake-utils

DESCRIPTION="Protobuf message library for Open-Transactions"
HOMEPAGE="http://opentransactions.org"
EGIT_REPO_URI="git://github.com/Open-Transactions/opentxs-proto.git \
			 https://github.com/Open-Transactions/opentxs-proto.git"
EGIT_BRANCH="pre-1.0"
LICENSE="MPL-2"

SLOT="0"
KEYWORDS=""

DEPEND=">=dev-libs/protobuf-2.6"
RDEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install

	dodoc README.md
}
