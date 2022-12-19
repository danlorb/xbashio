#!/usr/bin/env /workspaces/xbashio/src/xbashio/xbashio
# shellcheck shell=bash
# -*- coding: utf-8 -*-

# Set Log Level
xbashio::log.level trace

# xbashio::apt.prepare

# Create an SSH Key
# xbashio::ssh.createKey MyTestContext

# Enables Hardening for SSH Server
xbashio::ssh.arm
