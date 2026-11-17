#!/usr/bin/env bash
# Build FFmpegKit exactly as shipped in the Vocal Remover Android app (app/libs/ffmpeg-kit.aar).
#
#   ffmpeg-kit : arthenica/ffmpeg-kit tag v6.0 (this repository)
#   FFmpeg     : n6.0 (arthenica/FFmpeg)
#   NDK        : 28.2.13676358 (16 KB page size by default)
#   API level  : 26
#   Libraries  : lame, libass, fontconfig, freetype, fribidi, libiconv (+ their dependencies:
#                harfbuzz, libpng, expat, libuuid, cpu_features, android-zlib)
#
# Output: prebuilt/bundle-android-aar/ffmpeg-kit/ffmpeg-kit.aar
set -euo pipefail
: "${ANDROID_SDK_ROOT:?set ANDROID_SDK_ROOT}"
# Always NDK r28 (ignore any ANDROID_NDK_ROOT from the shell profile); override with VR_NDK_ROOT.
export ANDROID_NDK_ROOT="${VR_NDK_ROOT:-$ANDROID_SDK_ROOT/ndk/28.2.13676358}"
cd "$(dirname "$0")"
./android.sh --api-level=26 \
  --enable-lame --enable-libass --enable-fontconfig --enable-freetype --enable-fribidi --enable-libiconv --reconf-libiconv
