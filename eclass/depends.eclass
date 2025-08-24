# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @FUNCTION: _has_depend
# @INTERNAL
# @USAGE: <dep-spec> [<ignored-arg>...]
# @DESCRIPTION:
# Verifies that <dep-spec> is satisfied. <dep-spec> may be: a single dependency
# atom, a blocker atom, a USE-conditional dependency block, a parenthesized
# dependency block, or an any-of-many dependency block. These are all specified
# using the same syntax as in the *DEPEND variables.
# Calls "${_has_version[@]}" to check each atom in <dep-spec> as needed.
# Emits to stdout the number of positional arguments spanned by <dep-spec> and
# thus consumed by this function. Any remaining arguments are ignored.
# The return code is 0 if <dep-spec> is satisfied, non-zero otherwise.
_has_depend() {
	debug-print-function ${FUNCNAME} "${@}"
	local -i n r _sc=${_sc}
	case "${1}" in
		*\?)
			[[ ${2} == '(' ]] || die "Illegal USE-conditional dependency spec: ${1} ${2}"
			(( _sc )) || _sc=$(usex "${1%\?}" 0 -1)
			shift 2 ; let n+=3
			while [[ ${1} != ')' ]] ; do
				(( ${#} )) || die 'Unterminated USE-conditional dependency spec'
				let r=$(_has_depend "${@}") _sc\|=${?}
				shift "${r}" ; let n+=r
			done
			if (( _sc < 0 )) ; then
				let r=0  # USE-conditional was false; pass
			else
				let r=_sc  # return 0 if none failed
			fi
			;;
		'(')
			shift ; let n+=2
			while [[ ${1} != ')' ]] ; do
				(( ${#} )) || die 'Unterminated all-of dependency spec'
				let r=$(_has_depend "${@}") _sc\|=${?}
				shift "${r}" ; let n+=r
			done
			let r=_sc  # return 0 if none failed
			;;
		'||')
			[[ ${2} == '(' ]] || die "Illegal any-of-many dependency spec: ${1} ${2}"
			shift 2 ; let n+=3
			while [[ ${1} != ')' ]] ; do
				(( ${#} )) || die 'Unterminated any-of-many dependency spec'
				let r=$(_has_depend "${@}") _sc\|=\!${?}
				shift "${r}" ; let n+=r
			done
			let r=\!_sc  # return 0 if any passed
			;;
		\!\!*)
			(( _sc )) || ! "${_has_version[@]?}" "${1#!!}" ; r=${?}
			let ++n
			;;
		\!*)
			(( _sc )) || ! "${_has_version[@]?}" "${1#!}" ; r=${?}
			let ++n
			;;
		*)
			(( _sc )) || "${_has_version[@]?}" "${1}" ; r=${?}
			let ++n
			;;
	esac
	echo "${n}"
	return "${r}"
}

# @FUNCTION: has_depends
# @USAGE: [-p] [[-b|-d|-r] <dep-spec>]...
# @DESCRIPTION:
# Verifies that the given <dep-spec>s are satisfied by passing each in turn to
# _has_depend. The return code is 0 if all of the specs are satisfied or
# non-zero otherwise. The syntax of the <dep-spec>s is the same as in *DEPEND
# variables. The function that will be called to check for the presence of each
# dependency atom is has_version, but the -p option will change this to
# python_has_version for use in python_check_deps(). A -b/-d/-r option may be
# given, to be passed to the atom checking function to specify the system root
# to check, and will remain in effect for all subsequent <dep-spec>s
# until/unless another such option is given.
has_depends() {
	local _hv_func=has_version
	if [[ ${1} == -p ]] ; then
		_hv_func=python_has_version
		shift
	fi
	local _has_version=( "${_hv_func}" )
	while (( ${#} )) ; do
		if [[ ${1} == -[bdr] ]] ; then
			_has_version=( "${_hv_func}" "${1}" )
		else
			local -i _sc=0 r
			r=$(_has_depend "${@}") || return
			shift "${r}"
		fi
	done
}
