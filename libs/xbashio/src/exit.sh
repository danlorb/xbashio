#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------
# Exit the script with as failed with an optional error message.
#
# Arguments:
#   $1 Error message (optional)
# ------------------------------------------------------------------------------
function xbashio::exit.nok() {
    local message=${1:-}

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    if xbashio::var.has_value "${message}"; then
        xbashio::log.fatal "${message}"
    fi

    exit "${__XBASHIO_EXIT_NOK}"
}

# ------------------------------------------------------------------------------
# Exit the script when given value is false, with an optional error message.
#
# Arguments:
#   $1 Value to check if false
#   $2 Error message (optional)
# ------------------------------------------------------------------------------
function xbashio::exit.die_if_false() {
    local value=${1:-}
    local message=${2:-}

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    if xbashio::var.false "${value}"; then
        xbashio::exit.nok "${message}"
    fi
}

# ------------------------------------------------------------------------------
# Exit the script nicely.
# ------------------------------------------------------------------------------
function xbashio::exit.ok() {
    xbashio::log.trace "${FUNCNAME[0]}" "$@"
    exit "${__XBASHIO_EXIT_OK}"
}
