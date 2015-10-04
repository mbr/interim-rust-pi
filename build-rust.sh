#!/bin/sh

set -e
set -x

export PATH=/opt/pi-tools/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/:$PATH

cd rust
./configure --target=arm-unknown-linux-gnueabihf --prefix=/opt/pi-tools/rust

# uses a lot of RAM, might have to go down to -j4
make -j4
