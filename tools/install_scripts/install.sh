#!/usr/bin/env bash
# -*- coding: utf-8 -*-

version="1.0.1"
file=xbashio-"${version}".tar.gz
url="https://git.x-breitschaft.de/global/xbashio/archive/${version}.tar.gz"
apt update && apt install -qy --no-install-recommends curl
curl -fSL "$url" --output /tmp/"${file}"
rm -rf /usr/lib/xbashio || true
rm -f /usr/bin/xbashio
mkdir -p /usr/lib/xbashio
tar -xvzf /tmp/"${file}" --directory /tmp
mv /tmp/xbashio/src/xbashio/* /usr/lib/xbashio
chmod 755 /usr/lib/xbashio/*
ln -s /usr/lib/xbashio/xbashio /usr/bin/xbashio
chmod 755 /usr/bin/xbashio
rm -rf /tmp/xbashio*
