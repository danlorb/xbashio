#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------
# Log a message to output.
#
# Arguments:
#   $1 Message to display
# ------------------------------------------------------------------------------
xbashio::log() {
    local message=$*
    echo -e "${message}" >&2
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Log a message to output (in red).
#
# Arguments:
#   $1 Message to display
# ------------------------------------------------------------------------------
xbashio::log.red() {
    local message=$*
    echo -e "${__XBASHIO_COLORS_RED}${message}${__XBASHIO_COLORS_RESET}" >&2
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Log a message to output (in green).
#
# Arguments:
#   $1 Message to display
# ------------------------------------------------------------------------------
xbashio::log.green() {
    local message=$*
    echo -e "${__XBASHIO_COLORS_GREEN}${message}${__XBASHIO_COLORS_RESET}" >&2
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Log a message to output (in yellow).
#
# Arguments:
#   $1 Message to display
# ------------------------------------------------------------------------------
xbashio::log.yellow() {
    local message=$*
    echo -e "${__XBASHIO_COLORS_YELLOW}${message}${__XBASHIO_COLORS_RESET}" >&2
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Log a message to output (in blue).
#
# Arguments:
#   $1 Message to display
# ------------------------------------------------------------------------------
xbashio::log.blue() {
    local message=$*
    echo -e "${__XBASHIO_COLORS_BLUE}${message}${__XBASHIO_COLORS_RESET}" >&2
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Log a message to output (in magenta).
#
# Arguments:
#   $1 Message to display
# ------------------------------------------------------------------------------
xbashio::log.magenta() {
    local message=$*
    echo -e "${__XBASHIO_COLORS_MAGENTA}${message}${__XBASHIO_COLORS_RESET}" >&2
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Log a message to output (in cyan).
#
# Arguments:
#   $1 Message to display
# ------------------------------------------------------------------------------
xbashio::log.cyan() {
    local message=$*
    echo -e "${__XBASHIO_COLORS_CYAN}${message}${__XBASHIO_COLORS_RESET}" >&2
    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Log a message using a log level.
#
# Arguments:
#   $1 Log level
#   $2 Message to display
# ------------------------------------------------------------------------------
function xbashio::log.log() {
    local level=${1}
    local message=${2}
    local timestamp
    local output

    if [[ "${level}" -gt "${__XBASHIO_LOG_LEVEL}" ]]; then
        return "${__XBASHIO_EXIT_OK}"
    fi

    timestamp=$(date +"${__XBASHIO_LOG_TIMESTAMP}")

    output="${__XBASHIO_LOG_FORMAT}"
    output="${output//\{TIMESTAMP\}/${timestamp}}"
    output="${output//\{MESSAGE\}/${message}}"
    output="${output//\{LEVEL\}/${__XBASHIO_LOG_LEVELS[$level]}}"

    echo -e "${output}" >&2

    return "${__XBASHIO_EXIT_OK}"
}

# ------------------------------------------------------------------------------
# Log a message @ trace level.
#
# Arguments:
#   $* Message to display
# ------------------------------------------------------------------------------
function xbashio::log.trace() {
    local message=$*
    xbashio::log.log "${__XBASHIO_LOG_LEVEL_TRACE}" "${message}"
}

# ------------------------------------------------------------------------------
# Log a message @ debug level.
#
# Arguments:
#   $* Message to display
# ------------------------------------------------------------------------------
function xbashio::log.debug() {
    local message=$*
    xbashio::log.log "${__XBASHIO_LOG_LEVEL_DEBUG}" "${message}"
}

# ------------------------------------------------------------------------------
# Log a message @ info level.
#
# Arguments:
#   $* Message to display
# ------------------------------------------------------------------------------
function xbashio::log.info() {
    local message=$*
    xbashio::log.log \
        "${__XBASHIO_LOG_LEVEL_INFO}" \
        "${__XBASHIO_COLORS_GREEN}${message}${__XBASHIO_COLORS_RESET}"
}

# ------------------------------------------------------------------------------
# Log a message @ notice level.
#
# Arguments:
#   $* Message to display
# ------------------------------------------------------------------------------
function xbashio::log.notice() {
    local message=$*
    xbashio::log.log \
        "${__XBASHIO_LOG_LEVEL_NOTICE}" \
        "${__XBASHIO_COLORS_CYAN}${message}${__XBASHIO_COLORS_RESET}"
}

# ------------------------------------------------------------------------------
# Log a message @ warning level.
#
# Arguments:
#   $* Message to display
# ------------------------------------------------------------------------------
function xbashio::log.warning() {
    local message=$*
    xbashio::log.log \
        "${__XBASHIO_LOG_LEVEL_WARNING}" \
        "${__XBASHIO_COLORS_YELLOW}${message}${__XBASHIO_COLORS_RESET}"
}

# ------------------------------------------------------------------------------
# Log a message @ error level.
#
# Arguments:
#   $* Message to display
# ------------------------------------------------------------------------------
function xbashio::log.error() {
    local message=$*
    xbashio::log.log \
        "${__XBASHIO_LOG_LEVEL_ERROR}" \
        "${__XBASHIO_COLORS_MAGENTA}${message}${__XBASHIO_COLORS_RESET}"
}

# ------------------------------------------------------------------------------
# Log a message @ fatal level.
#
# Arguments:
#   $* Message to display
# ------------------------------------------------------------------------------
function xbashio::log.fatal() {
    local message=$*
    xbashio::log.log \
        "${__XBASHIO_LOG_LEVEL_FATAL}" \
        "${__XBASHIO_COLORS_RED}${message}${__XBASHIO_COLORS_RESET}"
}

# ------------------------------------------------------------------------------
# Changes the log level of Bashio on the fly.
#
# Arguments:
#   $1 Log level
# ------------------------------------------------------------------------------
function xbashio::log.level() {
    local log_level=${1}

    # Find the matching log level
    case "$(xbashio::string.lower "${log_level}")" in
    all)
        log_level="${__XBASHIO_LOG_LEVEL_ALL}"
        ;;
    trace)
        log_level="${__XBASHIO_LOG_LEVEL_TRACE}"
        ;;
    debug)
        log_level="${__XBASHIO_LOG_LEVEL_DEBUG}"
        ;;
    info)
        log_level="${__XBASHIO_LOG_LEVEL_INFO}"
        ;;
    notice)
        log_level="${__XBASHIO_LOG_LEVEL_NOTICE}"
        ;;
    warning)
        log_level="${__XBASHIO_LOG_LEVEL_WARNING}"
        ;;
    error)
        log_level="${__XBASHIO_LOG_LEVEL_ERROR}"
        ;;
    fatal | critical)
        log_level="${__XBASHIO_LOG_LEVEL_FATAL}"
        ;;
    off)
        log_level="${__XBASHIO_LOG_LEVEL_OFF}"
        ;;
    *)
        xbashio::exit.nok "Unknown log_level: ${log_level}"
        ;;
    esac

    export __XBASHIO_LOG_LEVEL="${log_level}"
}
