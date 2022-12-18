#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------
# Creates a Support User on System and add its to Sudo
#
# Arguments:#
#   $1 User Name to create
#   $2 Password for the new User
# ------------------------------------------------------------------------------
xbashio::security.createUser() {
    local user="${1:-}"
    local password="${2:-}"
    local min_user_id=4999

    xbashio::log.info "Create User '${user}'"

    if [ -z "$user" ]; then
        xbashio::log.error "No User given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    if [ -z "$password" ]; then
        xbashio::log.error "No Password given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    user_exists=$(getent passwd "${user}" || true)
    if [ -z "${user_exists}" ]; then
        xbashio::log.info "User '${user}' does not exists. It will created now"

        ids=$(getent passwd | cut -d":" -f3)

        xbashio::log.trace "Look for the hightest available Number ..."
        for i in "${ids[@]}"; do
            id=$min_user_id
            if [ $i -gt $min_user_id ]; then
                id=$i
            fi
        done

        xbashio::log.trace "Highest ID is '$id'"

        xbashio::log.trace "Increment User Id '$id' ..."
        id=$(($id + 1))

        xbashio::log.trace "Create an new Group with ID '$id' ..."
        echo $root_user_pass | sudo -S groupadd -g $id -p "${password}" $new_user

        xbashio::log.trace "Create a new User with ID '$id' ..."
        echo $root_user_pass | sudo -S useradd -s /bin/bash -u $id -g $id -p "${password}" -m $new_user
    else
        xbashio::log.info "User '$user' already exists. Nothing to do."
    fi

    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Creates a random Password
#
# Arguments:
#   $1 Length of the Password (default is 24)
# ------------------------------------------------------------------------------
# shellcheck disable=SC2120
xbashio::security.createPassword() {
    local length="${1:-24}"

    xbashio::log.info "Create a encrypted, random Password"
    password=$(xbashio::security.createPlainPassword "$length")
    openssl passwd -1 "${password}"
}

# ------------------------------------------------------------------------------
# Creates a random unencrypted Password
#
# Arguments:
#   $1 Length of the Password (default is 24)
# ------------------------------------------------------------------------------
# shellcheck disable=SC2120
xbashio::security.createPlainPassword() {
    local length="${1:-24}"

    xbashio::log.info "Create a random Password"
    openssl rand -base64 "$length"
}
