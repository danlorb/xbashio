#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------
# Cleans the System after run
#
# ------------------------------------------------------------------------------
function xbashio::trash.clean() {

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::security.clean
    xbashio::ssh.clean

    return "${__XBASHIO_EXIT_OK}"
}
