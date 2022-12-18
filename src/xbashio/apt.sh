#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------
# Updates the Package Cache
#
# ------------------------------------------------------------------------------
xbashio::apt.update() {
    xbashio::log.info "Update Package Cache"
    sudo apt update
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Upgrade the System
#
# ------------------------------------------------------------------------------
xbashio::apt.upgrade() {
    xbashio::log.info "Upgrade System"

    xbashio::apt.update
    sudo apt upgrade -qy --no-install-recommends
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

    xbashio::log.info "Install Package '${packages}' System"

    # shellcheck disable=SC2086
    sudo apt install -qy --no-install-recommends ${packages}
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

    xbashio::log.info "Remove Package '${packages}' System"

    # shellcheck disable=SC2086
    sudo apt purge -qy --no-install-recommends ${packages}
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Install minimum default to system
#
# ------------------------------------------------------------------------------
xbashio::apt.prepare() {
    local packages="sudo nano apt-transport-https openssh-server openssl"

    xbashio::log.info "Install minimum Packages '${packages}' on System"

    xbashio::apt.upgrade

    # shellcheck disable=SC2086
    sudo apt install -qy --no-install-recommends ${packages}
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Cleanup system caches
#
# ------------------------------------------------------------------------------
xbashio::apt.clean() {

    xbashio::log.info "Cleanup the System"

    sudo apt clean \
        && sudo rm -rf \
            /var/lib/apt/lists/* \
            /root/.cache

    return "${__XBASHIO_EXIT_OK}"
}
