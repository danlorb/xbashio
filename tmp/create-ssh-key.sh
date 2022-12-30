#!/usr/bin/env xbashio


xbashio::log.info "Create ssh Keys"
xbashio::ssh.createKey "$1"
