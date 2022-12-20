#!/usr/bin/env xbashio
# shellcheck shell=bash
# -*- coding: utf-8 -*-

# Set Log Level
xbashio::log.level trace

# Creates a random Password
# xbashio::security.createPassword

# Creates a random Password with Length 16
# xbashio::security.createPassword 16

# Create User
# password=$(xbashio::security.createPassword 16)
# xbashio::security.createUser support1 "$password"

# Add User to Group
# xbashio::security.addUserToGroup support1 sudo

# Remove User from Group
xbashio::security.removeUserFromGroup support1 sudo
