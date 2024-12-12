#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------
# Updates the Package Cache
#
# ------------------------------------------------------------------------------
xbashio::apt.update() {

    xbashio::log.trace "${FUNCNAME[0]}:"

    export DEBIAN_FRONTEND=noninteractive

    xbashio::log.info "Update package cache"
    apt-get update || xbashio::exit.nok "Package cache could not updated"
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Upgrade the System
#
# ------------------------------------------------------------------------------
xbashio::apt.upgrade() {

    xbashio::log.trace "${FUNCNAME[0]}:"

    xbashio::log.info "Upgrade system"

    export DEBIAN_FRONTEND=noninteractive

    xbashio::apt.update
    apt-get upgrade -qy --no-install-recommends || xbashio::exit.nok "System could not upgraded"
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

    xbashio::log.info "Install package '${packages}' on system"

    export DEBIAN_FRONTEND=noninteractive

    # shellcheck disable=SC2086
    apt-get install -qy --no-install-recommends ${packages}  || xbashio::exit.nok "Packages '$packages' could not installed"
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

    xbashio::log.info "Remove package '${packages}' on system"

    export DEBIAN_FRONTEND=noninteractive

    # shellcheck disable=SC2086
    apt-get purge -qy --no-install-recommends ${packages} || xbashio::exit.nok "Packages 'packages' could not removed"
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Install minimum default to system
#
# ------------------------------------------------------------------------------
xbashio::apt.prepare() {
    local packages="sudo nano apt-transport-https openssh-server openssl"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Install minimum packages '${packages}' on system"

    export DEBIAN_FRONTEND=noninteractive

    xbashio::apt.upgrade

    # shellcheck disable=SC2086
    apt-get install -qy --no-install-recommends ${packages} || xbashio::exit.nok "System could not prepared"
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Cleanup system caches
#
# ------------------------------------------------------------------------------
xbashio::apt.clean() {

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Cleanup system"

    export DEBIAN_FRONTEND=noninteractive

    (apt-get clean \
        && apt-get autoremove \
        && rm -rf \
            /var/lib/apt/lists/* \
            /var/cache/apt/archives/partial/* \
            /root/.cache) \
         || xbashio::exit.nok "System could not cleaned"

    return "${__XBASHIO_EXIT_OK}"
}
