#!/usr/bin/env bash
# -*- coding: utf-8 -*-

file=cleanup-system.sh

curl -s https://git.x-breitschaft.de/global/xbashio/raw/branch/main/src/xbashio.scripts/"$file" --output ./"$file"
chmod +x ./"$file"
./"$file"
rm -f ./$file
