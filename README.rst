Rust on Raspberry Pi
====================

**tl;dr**: Cross-compiling for Raspberry Pi / ARM is a little complicated. How
to
use:

1. Use dpkg to install `pi-tools_1.deb
   <https://github.com/mbr/interim-rust-pi/releases/download/v3/pi-tools_2.deb>`_
   and `pi-tools-rust_1.8.0-1.3c9442f.deb
   <https://github.com/mbr/interim-rust-pi/releases/download/v3/pi-tools-rust_1.8.0-1.3c9442f.deb>`_.
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


Handling C-dependencies
-----------------------

When dealing with crates that are not pure Rust packages the missing
dependencies can be installed using the ``pi-tools-install`` script. Assuming a
hyper build fails because of OpenSSL:

.. code-block:: text

    src/openssl_shim.c:1:26: fatal error: openssl/hmac.h: No such file or directory
     #include <openssl/hmac.h>

The required debian packages are ``libssl-dev`` and ``libssl1.0.0``:

.. code-block:: shell

    $ sudo pi-tools-install libssl-dev libssl1.0.0
    Downloading libssl-dev:armhf using apt-get...
    Get:1 http://http.debian.net/debian/ jessie/main libssl-dev armhf 1.0.1k-3+deb8u2 [1,105 kB]
    Fetched 1,105 kB in 0s (1,806 kB/s)
    Extracting to /opt/pi-tools/arm-bcm2708hardfp-linux-gnueabi/arm-bcm2708hardfp-linux-gnueabi/sysroot/

    [...]

Files will only be extracted
into
``/opt/pi-tools/arm-bcm2708hardfp-linux-gnueabi/arm-bcm2708hardfp-linux-gnueabi/sysroot/``

For this to work, your system must be setup to support foreign archs,
otherweise apt will not be able to download ``:armhf`` packages:


.. code-block:: shell

   $ sudo dpkg --add-architecture armhf
   $ sudo apt-get update

More details can be found at https://wiki.debian.org/Multiarch/HOWTO


Built for Debian Jessie
=======================

Currently, there is Rust 1.3.0 is available in sid, without a jessie backport.
Increased libc version requirements in sid make it rather hard to install the
package without proper backports. Building these backports is also nontrivial,
as some of the build-dependencies set are not available in jessie in the
correct versions. At this point, Rust's ``install.sh`` script seems to be the
lesser evil.

Both ``.deb`` packages contain no scripts that are run on install, they merely
extract content into ``/opt/pi-tools`` and a single symlink
``/usr/bin/pi-cargo``.

The ``pi-tools``-package contains the necessary `Raspberri Pi cross-compiling
toolchains <https://github.com/raspberrypi/tools>`_, these are not only
required to compile the Rust compiler, but also a dependency for building rust
programs later on (specifically, the linker and ``ar``). For this reason they
need to be installed even if there's no intention of building Rust itself from
source.

A better way to install these on a system would be the actual cross-compilation
support provided by debian
(see https://wiki.debian.org/MultiarchCrossToolchainBuild), however these are
not entirely stable yet and I had issues trying to get them to install. This
whole project is just a stopgap measure, until these tools mature a little
more.

Rust itself
~~~~~~~~~~~

The cross-compilation support in Rust is also improving quite fast, but not
100% there yet (there being a golang-level of toolchain goodness). Hopefully,
this project here will become obsolete in the future.

None of the packages provided here are even trying to fit into good debian
packaging guidelines; their sole purpose is to make it easy to get rid of them
if you can and just work in the meantime.


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
