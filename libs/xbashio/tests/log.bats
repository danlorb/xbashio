#!/usr/bin/env bats

load ../../src/xbashio/xbashio.sh

@test "test default logging" {
    run xbashio::log "Default logging output"
    [ "$status" -eq 0 ]
    [ "$output" == "Default logging output" ]
}
