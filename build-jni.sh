#!/usr/bin/env bash
set -euo pipefail


run() {
    echo "> $*"
    "$@"
}

cd wrapper-java/src/main

if [ -d build ]; then
    echo "Deleting old build folder..."
    rm -rf build
fi

if command -v ninja >/dev/null 2>&1; then
    GENERATOR_ARGS="-G Ninja"
    BUILD_ARGS="-j $(nproc 2>/dev/null || sysctl -n hw.ncpu)"
else
    GENERATOR_ARGS=""
    BUILD_ARGS=""
fi

run cmake -B build -S . $GENERATOR_ARGS -DCMAKE_BUILD_TYPE=Release
run cmake --build build $BUILD_ARGS

OS_NAME=$(uname)
if [[ "$OS_NAME" == "Darwin" ]]; then
    DYLIB_EXT="dylib"
else
    DYLIB_EXT="so"
fi

run cp "build/libquickjs-java-wrapper.$DYLIB_EXT" ../../..

echo "Build success"