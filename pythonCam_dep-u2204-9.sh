#!/bin/bash
# shellcheck disable=SC2316

local="$(pwd)"
aptcache="/var/cache/apt/archives"
export local
export aptcache
export APT_CONFIG=/dev/null

# apt --fix-broken install
sudo apt-get -f install

cp -a "$local"/pythonCam_dep-u2204-9/* "$aptcache"
sudo apt install "$aptcache"/*.deb

