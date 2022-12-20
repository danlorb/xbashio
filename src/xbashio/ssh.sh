#!/usr/bin/env bash
# -*- coding: utf-8 -*-

readonly __XBASHIO_SSH_BITS=4096
readonly __XBASHIO_SSH_CRYPT="rsa"
readonly __XBASHIO_SSH_PRIVATE_KEY_EXT=".key"

# ------------------------------------------------------------------------------
# Creates ssh keys
#
# Arguments:
#   $1 Context or Destination Machine Name
# ------------------------------------------------------------------------------
xbashio::ssh.createKey() {
    local context="${1:-}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Create new ssh key for Context/Machine '$context'"

    if ! xbashio::var.has_value "$context"; then
        xbashio::log.error "No Context/Machine Name given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    file=$(xbashio::ssh.createFileName "$context")
    comment="Generated_for_${context}_from_$(whoami)_on_$(hostname)_at_$(date +'%Y%m%d_%H%M%S')"

    ssh-keygen -b $__XBASHIO_SSH_BITS -t $__XBASHIO_SSH_CRYPT -N "" -C "${comment}" -f "${file}"
    mv "$file" "${file}${__XBASHIO_SSH_PRIVATE_KEY_EXT}"

    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Install the ssh Key to current User
#
# Arguments:
#   $1 Context or Destination Machine Name
# ------------------------------------------------------------------------------
xbashio::ssh.installKey() {
    local context="${1:-}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Copy ssh key for Context/Machine '$context' and User '$user'"

    if ! xbashio::var.has_value "$context"; then
        xbashio::log.error "No Context/Machine Name given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    file=$(xbashio::ssh.createFileName "$context")
    dest=/home/"${context}"/.ssh

    if [ ! -d "$dest" ]; then
        xbashio::log.info "Directory '.ssh' not exists. Will create"
        mkdir -p "$dest"
    fi

    xbashio::log.trace "Modify Rights for Directory '.ssh' ..."
    chmod -R 777 "$dest"

    xbashio::log.trace "Copy Public Key to authorized Keys ..."
    cat "$file".pub >> "$dest"/authorized_keys

    xbashio::log.trace "Modify Rights for new installed Key ..."
    chmod -R 700 "$dest"
    chmod 600 "$dest"/authorized_keys
    chown -R "$context":"$context" "$dest"
}

xbashio::ssh.createFileName() {
    local context="${1:-}"

    if ! xbashio::var.has_value "$context"; then
        xbashio::log.error "No Context/Machine Name given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    echo -e "${PWD}/${context}_${__XBASHIO_SSH_BITS}"
}

# ------------------------------------------------------------------------------
# Configure/Harden the SSH Server
#
# Arguments:
#   $1 User to allow login
# ------------------------------------------------------------------------------
xbashio::ssh.arm() {
    local user="${1:-}"

    # following the Hardening Guide of https://www.sshaudit.com

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Enable and configure OpenSSH Server"

    xbashio::log.info "Re-generate the RSA and ED25519 keys"
    rm /etc/ssh/ssh_host_*
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

    xbashio::log.info "Remove small Diffie-Hellman moduli"
    awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe
    mv /etc/ssh/moduli.safe /etc/ssh/moduli

    xbashio::log.info "Enable the RSA and ED25519 keys"
    sed -i 's/^\#HostKey \/etc\/ssh\/ssh_host_\(rsa\|ed25519\)_key$/HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config

    xbashio::log.info "Restrict supported key exchange, cipher, and MAC algorithms"
    cat >/etc/ssh/sshd_config.d/ssh-audit_hardening.conf <<EOF
# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com hardening guide.
KexAlgorithms sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org,gss-curve25519-sha256-,diffie-hellman-group16-sha512,gss-group16-sha512-,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com
HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com
EOF

    xbashio::log.info "Configure other ssh settings"
    port=$(shuf -i 2000-65000 -n 1)

    touch "/etc/ssh/sshd_config.d/hardening.conf"
    cat >"/etc/ssh/sshd_config.d/hardening.conf" <<EOF
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

    xbashio::log.info "Open SSH Server configured and hardened"

    return "${__XBASHIO_EXIT_OK}"
}
