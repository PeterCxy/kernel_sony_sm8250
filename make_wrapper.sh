#!/bin/bash

if [ -z "$ANDROID_ROOT" ]; then
  exit 1
fi

export PATH=$ANDROID_ROOT/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$ANDROID_ROOT/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin:$ANDROID_ROOT/prebuilts/clang/host/linux-x86/clang-r416183b/bin/:$PATH

exec make O=$PWD/../edo-4.19-out ARCH=arm64 CROSS_COMPILE=aarch64-linux-android- CROSS_COMPILE_ARM32=arm-linux-androideabi- CC=$ANDROID_ROOT/prebuilts/clang/host/linux-x86/clang-r416183b/bin/clang CLANG_TRIPLE=aarch64-linux-gnu -j12 $@
