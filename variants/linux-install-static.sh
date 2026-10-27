#!/bin/bash

package_variant() {
    IN="$1"
    OUT="$2"

    mkdir -p "$OUT"/bin
    cp -a "$IN"/bin/* "$OUT"/bin

    mkdir -p "$OUT"/lib
    shopt -s nullglob
    for lib in "$IN"/lib/*.a "$IN"/lib/*.so*; do
        [ -e "$lib" ] && cp -a "$lib" "$OUT"/lib/
    done
    shopt -u nullglob

    if [ -d "$IN"/lib/pkgconfig ]; then
        mkdir -p "$OUT"/lib/pkgconfig
        cp -a "$IN"/lib/pkgconfig/*.pc "$OUT"/lib/pkgconfig
        find "$OUT"/lib/pkgconfig -type f -name '*.pc' -exec sed -i \
            -e 's|^prefix=.*|prefix=${pcfiledir}/../..|' \
            -e 's|/ffbuild/prefix|${prefix}|' \
            -e '/Libs.private:/d' {} +
    fi

    if [ -d "$IN"/lib/cmake ]; then
        mkdir -p "$OUT"/lib/cmake
        cp -a "$IN"/lib/cmake/* "$OUT"/lib/cmake
    fi

    mkdir -p "$OUT"/include
    cp -a "$IN"/include/* "$OUT"/include

    mkdir -p "$OUT"/doc
    cp -a "$IN"/share/doc/ffmpeg/* "$OUT"/doc

    mkdir -p "$OUT"/man
    cp -a "$IN"/share/man/* "$OUT"/man

    mkdir -p "$OUT"/presets
    cp -a "$IN"/share/ffmpeg/*.ffpreset "$OUT"/presets
}
