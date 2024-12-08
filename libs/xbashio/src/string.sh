#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------
# Converts a string to lower case.
#
# Arguments:
#   $1 String to convert
# ------------------------------------------------------------------------------
function xbashio::string.lower() {
    local string="${1}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    printf "%s" "${string,,}"
}

# ------------------------------------------------------------------------------
# Converts a string to upper case.
#
# Arguments:
#   $1 String to convert
# ------------------------------------------------------------------------------
function xbashio::string.upper() {
    local string="${1}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    printf "%s" "${string^^}"
}

# ------------------------------------------------------------------------------
# Replaces parts of the string with an other string.
#
# Arguments:
#   $1 String to make replacements in
#   $2 String part to replace
#   $3 String replacement
# ------------------------------------------------------------------------------
function xbashio::string.replace() {
    local string="${1}"
    local needle="${2}"
    local replacement="${3}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    printf "%s" "${string//${needle}/${replacement}}"
}

# ------------------------------------------------------------------------------
# Returns the length of a string.
#
# Arguments:
#   $1 String to determine the length of
# ------------------------------------------------------------------------------
xbashio::string.length() {
    local string="${1}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    printf "%s" "${#string}"
}

# ------------------------------------------------------------------------------
# Returns a substring of a string.
#
# stringZ=abcABC123ABCabc
# xbashio::string.substring "${stringZ}" 0      # abcABC123ABCabc
# xbashio::string.substring "${stringZ}" 1      # bcABC123ABCabc
# xbashio::string.substring "${stringZ}" 7      # 23ABCabc
# xbashio::string.substring "${stringZ}" 7 3    # 23AB
#
# Arguments:
#   $1 String to return a substring off
#   $2 Position to start
#   $3 Length of the substring (optional)
# ------------------------------------------------------------------------------
xbashio::string.substring() {
    local string="${1}"
    local position="${2}"
    local length="${3:-}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    if xbashio::var.has_value "${length}"; then
        printf "%s" "${string:${position}:${length}}"
    else
        printf "%s" "${string:${position}}"
    fi
}
