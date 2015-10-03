#!/bin/sh

set -e
set -x

BUILDDIR=pi-tools_1
TOOLSDIR=tools/arm-bcm2708
CCDEST=${BUILDDIR}/opt/pi-tools/gcc-linaro-arm-linux-gnueabihf-raspbian-x64

mkdir -p $(dirname ${CCDEST})
cp -r ${TOOLSDIR}/gcc-linaro-arm-linux-gnueabihf-raspbian-x64 ${CCDEST}
chmod -R a+rX ${BUILDDIR}
fakeroot dpkg-deb --build pi-tools_1
