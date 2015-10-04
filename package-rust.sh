#!/bin/sh

set -e
set -x

BUILDDIR=pi-tools-rust_1.1.0-1

rm -rf ${BUILDDIR}/opt/pi-tools/rust
cp -r /opt/pi-tools/rust ${BUILDDIR}/opt/pi-tools/
chmod -R a+rX ${BUILDDIR}
fakeroot dpkg-deb --build $(basename ${BUILDDIR})
