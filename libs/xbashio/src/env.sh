#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------
# Sets and saves environment variables
#
# Arguments:
#   $1 Keyname of the variable
#   $2 Value of the variable
# ------------------------------------------------------------------------------
xbashio::env.set() {
    local key="${1:-}"
    local value=${2:-}

    xbashio::log.trace "${FUNCNAME[0]}:"

    if xbashio::var.is_empty "${value}"; then
        xbashio::log.error "Value for key '${key}' is empty"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    xbashio::log.info "Set environment variable '${key}' to '${value}'"
    export "${key}"="${value}"
    echo "${key}"="${value}" | tee -a "${__XBASHIO_ETC_DIR}"/environment

    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Exports saved environment variables
#
# ------------------------------------------------------------------------------
xbashio::env.export() {
    xbashio::log.trace "${FUNCNAME[0]}:"

    xbashio::log.info "Export saved environment variables"
    if [ -f "${__XBASHIO_ETC_DIR}"/environment ]; then
        export $(xargs <"${__XBASHIO_ETC_DIR}"/environment)
    fi

    return "${__XBASHIO_EXIT_OK}"
}

xbashio::env.configure() {
    xbashio::log.trace "${FUNCNAME[0]}:"

    if [ -f "${__XBASHIO_ETC_DIR}"/environment ]; then
        if [ -f "${HOME}"/.bashrc ]; then
            xbashio::log.info "configure bash"
            echo "export $(xargs <"${__XBASHIO_ETC_DIR}"/environment)" | tee -a "${HOME}"/.bashrc
        fi

        if [ -f "${HOME}"/.zshrc ]; then
            xbashio::log.info "configure zsh"
            echo "export $(xargs <"${__XBASHIO_ETC_DIR}"/environment)" | tee -a "${HOME}"/.zshrc
        fi
    fi

    return "${__XBASHIO_EXIT_OK}"
}
