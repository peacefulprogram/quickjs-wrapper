#!/bin/bash
set -e
cd wrapper-java/src/main
if [ -d build ]; then
    echo "Deleting old build folder..."
    rm -rf build
fi
cmake -B build -S . -DCMAKE_BUILD_TYPE=Release
cmake --build build
OS_NAME=$(uname)
if [[ "$OS_NAME" == "Darwin" ]]; then
    DYLIB_EXT="dylib"   # macOS
else
    DYLIB_EXT="so"      # Linux
fi
cp build/libquickjs-java-wrapper.$DYLIB_EXT ../../..
echo Build success