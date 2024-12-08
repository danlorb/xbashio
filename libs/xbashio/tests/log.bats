#!/usr/bin/env bats

load ../../src/xbashio/xbashio.sh

@test "test default logging" {
    run xbashio::log "Default logging output"
    [ "$status" -eq 0 ]
    [ "$output" == "Default logging output" ]
}

@test "set log level" {
    # Possible Levels: All, Trace, Debug, Info, Notice, Warning, Error, Fatal
    run xbashio::log.level all
    [ "$__XBASHIO_LOG_LEVEL" == "all" ]
}



# xbashio::log.red "Red logging output"
# xbashio::log.green "Green logging output"
# xbashio::log.yellow "Yellow logging output"
# xbashio::log.blue "Blue logging output"
# xbashio::log.cyan "Cyan logging output"


# Set here the Log Level
# Possible Levels: All, Trace, Debug, Info, Notice, Warning, Error, Fatal
# xbashio::log.level all

# xbashio::log.trace "Trace Logging"
# xbashio::log.debug "Debug Logging"
# xbashio::log.info "Information Logging"
# xbashio::log.notice "Notice Logging"
# xbashio::log.warning "Warn Logging"
# xbashio::log.error "Error Logging"
# xbashio::log.fatal "Fatal Logging"