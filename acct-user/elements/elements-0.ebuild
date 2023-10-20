# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="System-wide Elements services user"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( elements bitcoin )

acct-user_add_deps
