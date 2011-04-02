# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# NOTE: The comments in this file are for instruction and documentation.
# They're not meant to appear with your final, production ebuild.  Please
# remember to remove them before submitting or committing your ebuild.  That
# doesn't mean you can't add your own comments though.

# The 'Header' on the third line should just be left alone.  When your ebuild
# will be committed to cvs, the details on that line will be automatically
# generated to contain the correct data.

# The EAPI variable tells the ebuild format in use.
# Defaults to 0 if not specified. The current PMS draft contains details on
# a proposed EAPI=0 definition but is not finalized yet.
# Eclasses will test for this variable if they need to use EAPI > 0 features.
EAPI=2

# inherit lists eclasses to inherit functions from. Almost all ebuilds should
# inherit eutils, as a large amount of important functionality has been
# moved there. For example, the epatch call mentioned below wont work
# without the following line:
inherit git


DESCRIPTION="An Python openCL bitcoin miner"
HOMEPAGE="https://github.com/m0mchil/poclbm"
EGIT_REPO_URI="git://github.com/m0mchil/poclbm.git"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pyopencl"

src_prepare() {
	      fperms 755 poclbm.py || die "fperms failed"
}

src_install() {
	      mkdir -p ${D}/opt/poclbm/ || die "mkdir failed"
	      cp -r * ${D}/opt/poclbm/ || die "copy failed"
	      dosym ${D}/opt/poclbm/poclbm.py /bin/poclbm || die "dosym failed"
}
