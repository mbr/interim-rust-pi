#!/bin/sh

set -e
set -x

BUILDDIR=pi-tools-rust_1.1.0-1

mkdir -p ${BUILDDIR}/opt/pi-tools/
cp -r /opt/pi-tools/rust ${BUILDDIR}/opt/pi-tools/
chmod -R a+rX ${BUILDDIR}
fakeroot dpkg-deb --build $(basename ${BUILDDIR})
