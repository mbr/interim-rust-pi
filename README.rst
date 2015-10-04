Rust on Raspberry Pi
====================

**tl;dr**: Cross-compiling for Raspberry Pi / ARM is a little complicated. How
to
use:

1. Use dpkg to install `pi-tools_1.deb
   <https://github.com/mbr/interim-rust-pi/releases/download/v1/pi-tools_1.deb>`_
   and `pi-tools-rust_1.1.0-1.deb
   <https://github.com/mbr/interim-rust-pi/releases/download/v1/pi-tools-rust_1.1.0-1.deb>`_.
2. Add the following to ``~/.cargo/config``:

.. code-block:: ini

   [target.arm-unknown-linux-gnueabihf]
   ar = "arm-linux-gnueabihf-gcc-ar"
   linker = "gcc-sysroot"

3. Test it:

.. code-block:: shell

   $ cargo new --bin hello-pi
   $ cd hello-pi
   $ pi-cargo build
   Compiling hellopi v0.1.0 (file:///tmp/hellopi)
   $ file target/arm-unknown-linux-gnueabihf/debug/hellopi
   target/arm-unknown-linux-gnueabihf/debug/hellopi: ELF 32-bit LSB shared object, ARM, EABI5 version 1 (SYSV), dynamically linked, interpreter /lib/ld-linux-armhf.so.3, for GNU/Linux 3.1.9, BuildID[sha1]=693739227d38cfacb8a45a49b615c375ced88a35, not stripped

You can still run ``cargo build``/``run`` normally to build the amd64 version.

SHA256 sums
~~~~~~~~~~~
.. code-block:: text

    5ea2ed13370d0df76754200515b21d6759cae8f9a79ed4a3df4c4a08b04ce197  cargo-nightly_201506280409~a34e69b~trusty_amd64.deb
    287a57d0fec9cdafd6e89dc7499ee275094eda5f9810d2016c3e892c7b9154de  pi-tools-rust_1.1.0-1.deb
    9587895f8542b7d212d896a128e844d7cc33c61e4257d2d9ecc4610a13206b44  pi-tools_1.deb



Sources
=======

All information on how things are done was taken from
https://github.com/Ogeon/rust-on-raspberry-pi, although I've made some
adjustments to the process.


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
