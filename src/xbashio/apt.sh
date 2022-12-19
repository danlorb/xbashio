#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------
# Updates the Package Cache
#
# ------------------------------------------------------------------------------
xbashio::apt.update() {

    xbashio::log.trace "${FUNCNAME[0]}:"

    xbashio::log.info "Update Package Cache"
    apt update || xbashio::exit.nok "Package Cache could not updated"
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Upgrade the System
#
# ------------------------------------------------------------------------------
xbashio::apt.upgrade() {

    xbashio::log.trace "${FUNCNAME[0]}:"

    xbashio::log.info "Upgrade System"

    export DEBIAN_FRONTEND=noninteractive

    xbashio::apt.update
    apt upgrade -qy --no-install-recommends || xbashio::exit.nok "System could not upgraded"
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Installs given Packages
#
# Arguments:
#   $1 Package to install
# ------------------------------------------------------------------------------
xbashio::apt.install() {
    local packages="$*"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Install Package '${packages}' System"

    export DEBIAN_FRONTEND=noninteractive

    # shellcheck disable=SC2086
    apt install -qy --no-install-recommends ${packages}  || xbashio::exit.nok "Packages '$packages' could not installed"
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Removes given Packages
#
# Arguments:
#   $1 Package to remove
# ------------------------------------------------------------------------------
xbashio::apt.remove() {
    local packages="$*"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Remove Package '${packages}' System"

    export DEBIAN_FRONTEND=noninteractive

    # shellcheck disable=SC2086
    apt purge -qy --no-install-recommends ${packages} || xbashio::exit.nok "Packages 'packages' could not removed"
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Install minimum default to system
#
# ------------------------------------------------------------------------------
xbashio::apt.prepare() {
    local packages="sudo nano apt-transport-https openssh-server openssl python3-pip"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Install minimum Packages '${packages}' on System"

    export DEBIAN_FRONTEND=noninteractive

    xbashio::apt.upgrade

    # shellcheck disable=SC2086
    apt install -qy --no-install-recommends ${packages} || xbashio::exit.nok "System could not prepared"
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Cleanup system caches
#
# ------------------------------------------------------------------------------
xbashio::apt.clean() {

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Cleanup the System"

    export DEBIAN_FRONTEND=noninteractive

    (apt clean \
        && rm -rf \
            /var/lib/apt/lists/* \
            /root/.cache) \
         || xbashio::exit.nok "System could not cleaned"

    return "${__XBASHIO_EXIT_OK}"
}
