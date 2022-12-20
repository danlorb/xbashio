#!/usr/bin/env bash
# -*- coding: utf-8 -*-

file=./prepare-system.sh

curl -s https://git.x-breitschaft.de/global/xbashio/raw/branch/main/src/xbashio.install/prepare-system.sh --output "$file"
chmod +x "$file"
$file
rm -f $file
