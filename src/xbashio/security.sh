#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------
# Creates a new User
#
# Arguments:#
#   $1 User Name to create
#   $2 Password for the new User
# ------------------------------------------------------------------------------
xbashio::security.createUser() {
    local user="${1:-}"
    local password="${2:-}"
    local min_user_id=4999

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"
    xbashio::log.info "Create User '${user}'"

    if ! xbashio::var.has_value "$user"; then
        xbashio::log.error "No User given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    if ! xbashio::var.has_value "$password"; then
        xbashio::log.error "No Password given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    user_exists=$(getent passwd "${user}" || true)
    if xbashio::var.is_empty "${user_exists}"; then
        xbashio::log.info "User '${user}' does not exists. It will created now"

        ids=()
        mapfile -t ids < <(getent passwd | cut -d ":" -f3)

        xbashio::log.trace "Look for the hightest available Number ..."
        for i in "${ids[@]}"; do
            id=$((min_user_id + 0))
            if [ $((i + 0)) -gt $((min_user_id + 0)) ]; then
                id=$i
            fi
        done

        xbashio::log.trace "Highest ID is '$id'"

        xbashio::log.trace "Increment User Id '$id' ..."
        id=$((id + 1))

        xbashio::log.trace "Create an new Group with ID '$id' ..."
        groupadd -g $id -p "${password}" "${user}" > /dev/null 2>&1 || xbashio::exit.nok "Group '$user' could not created"

        xbashio::log.trace "Create a new User with ID '$id' ..."
        useradd -s /bin/bash -u $id -g $id -p "${password}" -m "${user}" >/dev/null 2>&1 || xbashio::exit.nok "User '$user' could not created"

        xbashio::log.info "User '$user' and Group created."
    else
        xbashio::log.info "User '$user' already exists. Nothing to do."
    fi

    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Delete a User
#
# Arguments:
#   $1 User to delete
# ------------------------------------------------------------------------------
xbashio::security.deleteUser() {
    local user="${1:-}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"
    xbashio::log.info "Delete User '${user}'"

    if ! xbashio::var.has_value "$user"; then
        xbashio::log.error "No User given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    user_exists=$(getent passwd "${user}" || true)
    if xbashio::var.has_value "${user_exists}"; then
        userdel -f "$user" >/dev/null 2>&1 || xbashio::exit:nok "User '$user' could not removed"
    else
        xbashio::log.info "User '$user' not exists"
    fi

    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Delete a Group
#
# Arguments:
#   $1 Group to delete
# ------------------------------------------------------------------------------
xbashio::security.deleteGroup() {
    local group="${1:-}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"
    xbashio::log.info "Delete Group '${group}'"

    if ! xbashio::var.has_value "$user"; then
        xbashio::log.error "No Group given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    group_exists=$(getent group "${group}" || true)
    if xbashio::var.has_value "${group_exists}"; then
        groupdel "$group" >/dev/null 2>&1 || xbashio::exit:nok "Group '$group' could not removed"
    else
        xbashio::log.info "Group '$group' not exists"
    fi

    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Adds a User to Group
#
# Arguments:
#   $1 User to add
#   $2 Group where the User will addes
# ------------------------------------------------------------------------------
xbashio::security.addUserToGroup() {
    local user="${1:-}"
    local group="${2:-}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Add User '${user}' to Group '${group}'"

    if ! xbashio::var.has_value "$user"; then
        xbashio::log.error "No User given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    if ! xbashio::var.has_value "$group"; then
        xbashio::log.error "No Group given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    usermod -aG "$group" "$user" >/dev/null 2>&1 || xbashio::exit.nok "User '$user' could not added to Group '$group'"

    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Removes a User from Group
#
# Arguments:
#   $1 User to add
#   $2 Group where the User will addes
# ------------------------------------------------------------------------------
xbashio::security.removeUserFromGroup() {
    local user="${1:-}"
    local group="${2:-}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Remove User '${user}' from Group '${group}'"

    if ! xbashio::var.has_value "$user"; then
        xbashio::log.error "No User given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    if ! xbashio::var.has_value "$group"; then
        xbashio::log.error "No Group given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    gpasswd -d "$user" "$group" >/dev/null 2>&1 || xbashio::exit.nok "User '$user' could not removed from Group"

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

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

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

    xbashio::log.trace "${FUNCNAME[0]}:" "$@"

    xbashio::log.info "Create a random Password"
    openssl rand -base64 "$length"
}

# ------------------------------------------------------------------------------
# Change Password for a User
#
# Arguments:
#   $1 User where the Password should changed
#   $2 Old Password
#   $3 New Password
# ------------------------------------------------------------------------------
xbashio::security.changePassword() {
    local user="${1:-}"
    local oldpassword="${1:-}"
    local newpassword="${1:-}"

    xbashio::log.trace "${FUNCNAME[0]}:" "$user"

    xbashio::log.info "Change Password for User '$user'"

    if ! xbashio::var.has_value "$user"; then
        xbashio::log.error "No User given"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    if ! xbashio::var.has_value "$oldpassword"; then
        xbashio::log.error "Old Password is missing"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    if ! xbashio::var.has_value "$newpassword"; then
        xbashio::log.error "New Password is missing"
        return "${__XBASHIO_EXIT_NOK}"
    fi

    (echo -e "${oldpassword}\n${newpassword}\n${newpassword}" | passwd "$user") || xbashio::exit.nok "Password for User '$user' could not changed"

    return "${__XBASHIO_EXIT_OK}"
}
