#!/bin/bash

# apt --fix-broken install
apt-get -f install

cd pythonCam_dep-u2204-9
sudo apt install ./*.deb

