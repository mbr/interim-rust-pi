#!/bin/sh

set -e
set -x

BUILDDIR=pi-tools_1
TOOLSDIR=tools/arm-bcm2708
CCDEST=${BUILDDIR}/opt/pi-tools/gcc-linaro-arm-linux-gnueabihf-raspbian-x64
SRDEST=${BUILDDIR}/opt/pi-tools/arm-bcm2708hardfp-linux-gnueabi

mkdir -p $(dirname ${CCDEST})
rm -rf ${CCDEST} ${SRDEST}
cp -r ${TOOLSDIR}/gcc-linaro-arm-linux-gnueabihf-raspbian-x64 ${CCDEST}
cp -r ${TOOLSDIR}/arm-bcm2708hardfp-linux-gnueabi ${SRDEST}
chmod -R a+rX ${BUILDDIR}
fakeroot dpkg-deb --build $(basename ${BUILDDIR})
