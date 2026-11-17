# FFmpegKit build used by Vocal Remover (Android)

This repository holds the complete corresponding source and build scripts for the FFmpeg libraries
shipped in the Vocal Remover - Karaoke Maker Android app (`app/libs/ffmpeg-kit.aar`), as required by
the GNU LGPL v3.

It is [arthenica/ffmpeg-kit](https://github.com/arthenica/ffmpeg-kit) at tag `v6.0`, plus the small
build fixes listed below. FFmpeg and the bundled libraries are used unmodified at the versions listed.

## Versions

| Component | Version | License |
|---|---|---|
| FFmpegKit | v6.0 (+ patches below) | LGPL v3 |
| FFmpeg | n6.0 | LGPL v3 (configured with `--enable-version3`, no `--enable-gpl`) |
| LAME | 3.100 | LGPL v2 |
| libass | 0.17.1 | ISC |
| FreeType | 2.13.0 | FreeType License |
| FriBidi | 1.0.13 | LGPL v2.1 |
| HarfBuzz | 8.0.1 | MIT ("Old MIT") |
| Fontconfig | 2.14.2 | MIT-style |
| libpng | 1.6.40 | libpng License |
| Expat | 2.5.0 | MIT |
| libiconv | 1.17 (gnulib `4bc2b6f6`) | LGPL v2.1 (library) |
| libuuid | 1.0.3 | BSD 3-Clause |
| cpu_features | 0.8.0 | Apache 2.0 |

The exact source trees of all components are attached to this repository's release as
`ffmpeg-kit-vocalremover-sources-6.0.tar.xz`, in case the upstream download locations disappear.

## Build

Requirements: macOS or Linux, Android SDK, Android NDK **28.2.13676358**, JDK 21, autoconf, automake,
libtool, pkg-config, nasm, cmake, gperf.

```sh
export ANDROID_SDK_ROOT=/path/to/Android/sdk
./build-vocalremover.sh
```

Output: `prebuilt/bundle-android-aar/ffmpeg-kit/ffmpeg-kit.aar` (arm-v7a, arm-v7a-neon, arm64-v8a,
x86, x86-64; API level 26; 16 KB page size).

## Patches on top of ffmpeg-kit v6.0

- `scripts/android/libiconv.sh`: pin gnulib to `4bc2b6f6` (the revision matching libiconv 1.17);
  gnulib master no longer works with libiconv 1.17's `configure.ac`.
- `scripts/function-android.sh`: `-Wno-error=implicit-function-declaration -Wno-error=int-conversion
  -Wno-error=incompatible-function-pointer-types`, which newer clang turns into errors in older C code
  (e.g. libuuid).
- `android/ffmpeg-kit-android-lib/src/main/cpp/fftools_ffmpeg_mux_init.c`: one-bit bit-fields made
  `unsigned` (newer clang rejects storing 1 in a signed one-bit field).
- `android/build.gradle`: Android Gradle Plugin 8.1.0 → 8.2.2 (8.1 cannot package with JDK 21).

## Replacing the libraries in the app

FFmpeg is loaded from separate shared libraries (`libavcodec.so`, `libavformat.so`, …). You can build
a modified version with this repository and replace those libraries in the app.

Contact: apptinz.sp@gmail.com
