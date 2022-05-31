#!/bin/bash

if [ -z "$BOOT_ORIG" ]; then
  BOOT_ORIG=$(readlink -f build/boot_orig.img)
fi

if [ -z "$MAGISKBOOT" ]; then
  MAGISKBOOT=$(readlink -f build/magiskboot)
fi

if [ -z "$MAGISKBOOT" ] || [ -z "$BOOT_ORIG" ]; then
  echo "Please set MAGISKBOOT and BOOT_ORIG or use symlinks into build/"
  exit 1
fi

if [ ! -f out/.config ]; then
  ./make_wrapper.sh vendor/pdx206_defconfig
fi
./make_wrapper.sh -j$(nproc) Image-dtb

OUTDIR="$PWD/out"
TMPDIR="$(mktemp -d sony-kernel-XXXX --tmpdir=/tmp)"
pushd "$TMPDIR"
"$MAGISKBOOT" unpack "$BOOT_ORIG"
rm -rf kernel dtb
"$MAGISKBOOT" split "$OUTDIR/arch/arm64/boot/Image-dtb"
mv kernel_dtb dtb
"$MAGISKBOOT" repack "$BOOT_ORIG" boot.img
popd

cp "$TMPDIR/boot.img" out/
rm -rf "$TMPDIR"


echo "Boot image built"
ls -lah out/boot.img
