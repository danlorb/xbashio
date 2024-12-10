#!/usr/bin/env bash
# -*- coding: utf-8 -*-

set -o errexit  # Exit script when a command exits with non-zero status
set -o errtrace # Exit on error inside any functions or sub-shells
set -o nounset  # Exit script on use of an undefined variable
set -o pipefail # Return exit status of the last command in the pipe that failed

# ==============================================================================
# GLOBALS
# ==============================================================================

# xBashIO version number
readonly XBASHIO_VERSION="1.0.1"

# Stores the location of this library
readonly __XBASHIO_LIB_DIR=$(dirname "${BASH_SOURCE[0]}")

# shellcheck source=/workspaces/xbashio/src/xbashio/const.sh
source "${__XBASHIO_LIB_DIR}/const.sh"

# Defaults
declare __XBASHIO_LOG_LEVEL=${LOG_LEVEL:-${__XBASHIO_DEFAULT_LOG_LEVEL}}
declare __XBASHIO_LOG_FORMAT=${LOG_FORMAT:-${__XBASHIO_DEFAULT_LOG_FORMAT}}
declare __XBASHIO_LOG_TIMESTAMP=${LOG_TIMESTAMP:-${__XBASHIO_DEFAULT_LOG_TIMESTAMP}}
declare __XBASHIO_CACHE_DIR=${CACHE_DIR:-${__XBASHIO_DEFAULT_CACHE_DIR}}
declare __XBASHIO_MODULE_DIR=${MODULE_DIR:-${__XBASHIO_DEFAULT_CACHE_DIR}}

# ==============================================================================
# Main Modules
# ==============================================================================
# shellcheck source=/workspaces/xbashio/src/xbashio/color.sh
source "${__XBASHIO_LIB_DIR}/color.sh"
# shellcheck source=/workspaces/xbashio/src/xbashio/var.sh
source "${__XBASHIO_LIB_DIR}/var.sh"
# shellcheck source=/workspaces/xbashio/src/xbashio/log.sh
source "${__XBASHIO_LIB_DIR}/log.sh"
# shellcheck source=/workspaces/xbashio/src/xbashio/string.sh
source "${__XBASHIO_LIB_DIR}/string.sh"
# shellcheck source=/workspaces/xbashio/src/xbashio/exit.sh
source "${__XBASHIO_LIB_DIR}/exit.sh"

# ==============================================================================
# Other Modules
# ==============================================================================
# shellcheck source=/workspaces/xbashio/src/xbashio/trash.sh
source "${__XBASHIO_LIB_DIR}/trash.sh"
# shellcheck source=/workspaces/xbashio/src/xbashio/apt.sh
source "${__XBASHIO_LIB_DIR}/apt.sh"
# shellcheck source=/workspaces/xbashio/src/xbashio/security.sh
source "${__XBASHIO_LIB_DIR}/security.sh"
# shellcheck source=/workspaces/xbashio/src/xbashio/ssh.sh
source "${__XBASHIO_LIB_DIR}/ssh.sh"

# ==============================================================================
# Extended Modules
# ==============================================================================
modules="${__XBASHIO_LIB_DIR}/modules"
if [ -d "${modules}" ]; then
    for file in "${modules}"/*.sh; do
        chmod +x "${file}"
        source "${file}"
    done
fi