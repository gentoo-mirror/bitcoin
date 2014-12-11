# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils versionator git-r3 cmake-utils

DESCRIPTION="Financial cryptography library, API, CLI"
HOMEPAGE="http://opentransactions.org"
EGIT_REPO_URI="git://github.com/Open-Transactions/opentxs.git \
			 https://github.com/Open-Transactions/opentxs.git"
EGIT_BRANCH="stable-client"

LICENSE="AGPL-3"

SLOT="0"
KEYWORDS=""
IUSE="doc flat gnome kde"

DEPEND="
	doc? ( app-doc/doxygen )
	gnome? ( gnome-base/gnome-keyring )
	kde? ( kde-frameworks/kwallet )
	dev-libs/openssl
	dev-libs/protobuf
	sys-libs/zlib
	~net-libs/zeromq-4.0.4"

src_prepare() {
	local required_version="4.7"
	einfo "checking current gcc profile"
	if ! version_is_at_least ${required_version} $(gcc-version) ; then
		eerror "${P} requires gcc-${required_version} or greater to build."
		eerror "Have you gcc-config'ed to the latest version?"
		die "current gcc profile is less than ${required_version}"
	fi

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use gnome KEYRING_GNOME)
		$(cmake-utils_use kde KEYRING_KWALLET)
		$(cmake-utils_use flat KEYRING_FLATFILE)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	
	dodoc README.md
}
