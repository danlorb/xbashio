#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# cleanup old install if exists
if [ -d /usr/lib/xbashio ]; then
    rm -rf /usr/lib/xbashio || true
    rm -f /usr/bin/xbashio || true
fi

# create new folders
mkdir -p /usr/lib/xbashio

# install files
mv -f ./* /usr/lib/xbashio
chmod 755 /usr/lib/xbashio/*
ln -s /usr/lib/xbashio/xbashio /usr/bin/xbashio
chmod 755 /usr/bin/xbashio
