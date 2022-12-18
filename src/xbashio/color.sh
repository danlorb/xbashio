#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# ------------------------------------------------------------------------------
# Reset color output (background and foreground colors).
# ------------------------------------------------------------------------------
function xbashio::color.reset() {
    echo -n -e "${__XBASHIO_COLORS_RESET}"
}

# ------------------------------------------------------------------------------
# Set default output color.
# ------------------------------------------------------------------------------
function xbashio::color.default() {
    echo -n -e "${__XBASHIO_COLORS_DEFAULT}"
}

# ------------------------------------------------------------------------------
# Set font output color to black.
# ------------------------------------------------------------------------------
function xbashio::color.black() {
    echo -n -e "${__XBASHIO_COLORS_BLACK}"
}

# ------------------------------------------------------------------------------
# Set font output color to red.
# ------------------------------------------------------------------------------
function xbashio::color.red() {
    echo -n -e "${__XBASHIO_COLORS_RED}"
}

# ------------------------------------------------------------------------------
# Set font output color to green.
# ------------------------------------------------------------------------------
function xbashio::color.green() {
    echo -n -e "${__XBASHIO_COLORS_GREEN}"
}

# ------------------------------------------------------------------------------
# Set font output color to yellow.
# ------------------------------------------------------------------------------
function xbashio::color.yellow() {
    echo -n -e "${__XBASHIO_COLORS_YELLOW}"
}

# ------------------------------------------------------------------------------
# Set font output color to blue.
# ------------------------------------------------------------------------------
function xbashio::color.blue() {
    echo -n -e "${__XBASHIO_COLORS_BLUE}"
}

# ------------------------------------------------------------------------------
# Set font output color to magenta.
# ------------------------------------------------------------------------------
function xbashio::color.magenta() {
    echo -n -e "${__XBASHIO_COLORS_MAGENTA}"
}

# ------------------------------------------------------------------------------
# Set font output color to cyan.
# ------------------------------------------------------------------------------
function xbashio::color.cyan() {
    echo -n -e "${__XBASHIO_COLORS_CYAN}"
}

# ------------------------------------------------------------------------------
# Set font output color background to default.
# ------------------------------------------------------------------------------
function xbashio::color.bg.default() {
    echo -n -e "${__XBASHIO_COLORS_BG_DEFAULT}"
}

# ------------------------------------------------------------------------------
# Set font output color background to black.
# ------------------------------------------------------------------------------
function xbashio::color.bg.black() {
    echo -n -e "${__XBASHIO_COLORS_BG_BLACK}"
}

# ------------------------------------------------------------------------------
# Set font output color background to red.
# ------------------------------------------------------------------------------
function xbashio::color.bg.red() {
    echo -n -e "${__XBASHIO_COLORS_BG_RED}"
}

# ------------------------------------------------------------------------------
# Set font output color background to green.
# ------------------------------------------------------------------------------
function xbashio::color.bg.green() {
    echo -n -e "${__XBASHIO_COLORS_BG_GREEN}"
}

# ------------------------------------------------------------------------------
# Set font output color background to yellow.
# ------------------------------------------------------------------------------
function xbashio::color.bg.yellow() {
    echo -n -e "${__XBASHIO_COLORS_BG_YELLOW}"
}

# ------------------------------------------------------------------------------
# Set font output color background to blue.
# ------------------------------------------------------------------------------
function xbashio::color.bg.blue() {
    echo -n -e "${__XBASHIO_COLORS_BG_BLUE}"
}

# ------------------------------------------------------------------------------
# Set font output color background to magenta.
# ------------------------------------------------------------------------------
function xbashio::color.bg.magenta() {
    echo -n -e "${__XBASHIO_COLORS_BG_MAGENTA}"
}

# ------------------------------------------------------------------------------
# Set font output color background to cyan.
# ------------------------------------------------------------------------------
function xbashio::color.bg.cyan() {
    echo -n -e "${__XBASHIO_COLORS_BG_CYAN}"
}

# ------------------------------------------------------------------------------
# Set font output color background to white.
# ------------------------------------------------------------------------------
function xbashio::color.bg.white() {
    echo -n -e "${__XBASHIO_COLORS_BG_WHITE}"
}
