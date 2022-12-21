#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------
# Cleans the System after run
#
# ------------------------------------------------------------------------------
function xbashio::trash.clean() {

    xbashio::log.trace "${FUNCNAME[0]}:"

    xbashio::log.info "Cleanup System"
    xbashio::security.clean
    xbashio::ssh.clean

    xbashio::log.info "System cleaned."

    return "${__XBASHIO_EXIT_OK}"
}
