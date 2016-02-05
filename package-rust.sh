#!/bin/sh

set -e
set -x

BUILDDIR=pi-tools-rust_1.8.0-1~3c9442f

rm -rf ${BUILDDIR}/opt/pi-tools/rust
cp -r /opt/pi-tools/rust ${BUILDDIR}/opt/pi-tools/
chmod -R a+rX ${BUILDDIR}
chmod -R a+rx ${BUILDDIR}/opt/pi-tools/bin
fakeroot dpkg-deb --build $(basename ${BUILDDIR})
