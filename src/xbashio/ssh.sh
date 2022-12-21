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
    passphrase=$(xbashio::security.createPassword 64)

    ssh-keygen -b "$__XBASHIO_SSH_BITS" -t "$__XBASHIO_SSH_CRYPT" -N "$passphrase" -C "$comment" -f "$file"
    mv "$file" "${file}${__XBASHIO_SSH_PRIVATE_KEY_EXT}"

    xbashio::security.writeSecurityLog "Passphrase for Context/Machine '${context}' is '${passphrase}'"

    xbashio::log.info "SSH key for Context/Machine '$context' created"

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

    xbashio::log.info "SSH key for Context/Machine '$context' and User '$user' installed"

    return "${__XBASHIO_EXIT_OK}"
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

    xbashio::log.info "Create default Configuration"
    xbashio::ssh.defaultConfig

    xbashio::log.info "Re-generate the RSA and ED25519 keys"
    rm /etc/ssh/ssh_host_*
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

    xbashio::log.info "Remove small Diffie-Hellman moduli"
    awk '$5 >= 3071' /etc/ssh/moduli > /etc/ssh/moduli.safe
    mv /etc/ssh/moduli.safe /etc/ssh/moduli

    xbashio::log.info "Restrict supported key exchange, cipher, and MAC algorithms"
    cat >/etc/ssh/sshd_config.d/ssh-audit_hardening.conf <<EOF
# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com hardening guide.
KexAlgorithms sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org,gss-curve25519-sha256-,diffie-hellman-group16-sha512,gss-group16-sha512-,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com
HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com
EOF

    xbashio::log.info "Configure other ssh settings"

    touch "/etc/ssh/sshd_config.d/hardening.conf"
    cat >"/etc/ssh/sshd_config.d/hardening.conf" <<EOF
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

# ------------------------------------------------------------------------------
# Create default Config for SSH Server
#
# ------------------------------------------------------------------------------
xbashio::ssh.defaultConfig() {

    xbashio::log.trace "${FUNCNAME[0]}:"

    xbashio::log.info "Create default ssh config file"

    port=$(shuf -i 2000-65000 -n 1)


    cat > "/etc/sshd_config"<<EOF
# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Include /etc/ssh/sshd_config.d/*.conf

Port ${port}
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# Expect .ssh/authorized_keys2 to be disregarded by default in future.
#AuthorizedKeysFile     .ssh/authorized_keys .ssh/authorized_keys2

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
#KbdInteractiveAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
#UsePAM yes

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
PrintMotd no
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
#PidFile /run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

# override default of no subsystems
Subsystem       sftp    /usr/lib/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#       X11Forwarding no
#       AllowTcpForwarding no
#       PermitTTY no
#       ForceCommand cvs server
EOF

    xbashio::log.info "Default ssh config file created"

    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Remove Grabage Files
#
# ------------------------------------------------------------------------------
xbashio::ssh.clean(){

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Cleanup SSH Keys"
    rm -f /root/*.key
    rm -f /root/*.pub

    xbashio::log.info "SSH Keys deleted"
}
