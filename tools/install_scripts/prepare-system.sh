#!/usr/bin/env xbashio
# -*- coding: utf-8 -*-

user="support"

# Set Log Level
xbashio::log.level trace

xbashio::log.info "Prepare the System"
xbashio::apt.prepare

xbashio::log.info "Create '$user' user"
password=$(xbashio::security.createPassword 24)
xbashio::security.createUser "$user" "$password"

xbashio::log.info "Add '$user' user to group sudo"
xbashio::security.addUserToGroup "$user" sudo

xbashio::log.info "Create ssh Keys"
xbashio::ssh.createKey "$user"

xbashio::log.info "Install ssh Keys"
xbashio::ssh.installKey "$user"

xbashio::log.info "Enable and configure Open SSH Server"
xbashio::ssh.arm "$user"

xbashio::log.info "Disable root User"
xbashio::security.disableRoot

xbashio::log.notice ""
xbashio::log.notice "Your System is now configured and ready!"
xbashio::log.notice ""
xbashio::log.notice "Security Log   : /root/.xbashio-security"
xbashio::log.notice "SSH Keys       : /root"
xbashio::log.notice ""
xbashio::log.notice "Keep in Mind: Backup all needed Files, like Passwords, SSH Keys a.s.o., then"
xbashio::log.notice "cleanup the Installation with ..."
xbashio::log.notice "curl -s https://git.x-breitschaft.de/global/xbashio/raw/branch/main/src/xbashio.scripts/cleanup.sh | bash"
xbashio::log.notice ""
xbashio::log.notice "Have a nice Day"
xbashio::log.notice ""
