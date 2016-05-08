Rust on Raspberry Pi
====================

State: Summer 2016

This project has been superceded by [rustup.rs](https://rustup.rs>). Instead
of using the debian packages supplied here, creating a workin cross-compiler
now involves these high-level steps:

1. Install `rustup`
2. Get a working gcc cross-compilation toolchain (rust needs the linker and
   other tools that aren't the compiler). For debian jessie, see
   https://wiki.debian.org/CrossToolchains#In_jessie_.28Debian_8.29
3. Install the standard-library and libcore by adding the target:
   `rustup target add arm-unknown-linux-gnueabihf`
4. Set the correct linker in Cargo configuration:

   ```
   [target.arm-unknown-linux-gnueabihf]
   linker = "arm-linux-gnueabihf-gcc"
   ```

5. If you have any C-library dependencies (OpenSSL is a popular example), these
   libs can be installed on debian using `dpkg add-architecture` (see 2.) and
   running `apt-get install libssl-dev:armhf`

A lot more detailed and in-depth information can be found (and should be read)
at https://github.com/japaric/rust-cross.

Gotchas
-------

* Having `CC` and other environment variables set will override when compiler
  selected by Cargo for the target tuple. Ensure that these are not set.
* The outdated, but still working packages and everything else are available
  in [older commits](https://github.com/mbr/interim-rust-pi/tree/last-relevant).
