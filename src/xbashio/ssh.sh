#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------
# Configures the SSH Server
#
# Arguments:
#   $1 Context or Destination Machine Name
# ------------------------------------------------------------------------------
xbashio::ssh.createKey() {
    local context="${1:-}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Create new SSH Key for Context/Machine '$context'"

    if ! xbashio::var.has_value "$context"; then
        xbashio::log.error "No Context/Machine Name given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    crypt="rsa"
    bits=4096
    private_key_ext="key"

    file="${PWD}/${context}_${bits}"
    comment="Generated_for_${context}_from_$(whoami)_on_$(hostname)_at_$(date +'%Y%m%d_%H%M%S')"

    ssh-keygen -b $bits -t $crypt -N "" -C "${comment}" -f "${file}"
    mv "$file" "${file}.${private_key_ext}"

    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Configure/Harden the SSH Server
#
# Arguments:
#   $1 User to allow login
# ------------------------------------------------------------------------------
xbashio::ssh.arm() {
    local user="${1:-}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    port=$(shuf -i 2000-65000 -n 1)

    cat > "/etc/ssh/sshd_config.d/hardening.conf" <<EOF
Port ${port}
AuthenticationMethods publickey
PubkeyAuthentication yes
PermitRootLogin no
PermitEmptyPasswords no
PasswordAuthentication no
UsePAM no
RSAAuthentication yes
StrictModes yes
LoginGraceTime 30
MaxAuthTries 6
AllowUsers ${user}
ClientAliveInterval 300
ClientAliveCountMax 0
IgnoreRhosts yes
HostbasedAuthentication no
EOF

    systemctl restart sshd

    return "${__XBASHIO_EXIT_OK}"
}
