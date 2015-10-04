Rust on Raspberry Pi
====================

tl;dr: Cross-compiling for Raspberry Pi / ARM is a little complicated. Here are
some debian jessie packages to make it easy:


Building from scratch
=====================

The build-process is not fully automatic, but fairly straight-forward:

0. Ensure you have ``fakeroot``, ``libc++-dev``, ``build-essential`` installed
1. ``git clone --recursive https://github.com/mbr/interim-rust-pi``
2. ``./build-pi-tools.sh``
3. Install the resulting ``pi-tools_*.deb``
4. ``./build-rust.sh``. This might take some time. If you have little RAM,
   adjust the ``-j4`` down inside the script.
5. ``cd rust && sudo make install``. Note that prefix is set to
   ``/opt/pi-tools/rust``, make sure it is empty!
6. ``./package-rust.sh``
7. ``sudo rm -rf /opt/pi-tools/rust``
8. Install ``pi-tools-rust_*.deb``
