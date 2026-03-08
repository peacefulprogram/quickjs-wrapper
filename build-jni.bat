@echo off
cd wrapper-java\src\main
if exist build (
    echo Deleting old build folder...
    rmdir /s /q build
)
cmake -B build -S . -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release
cmake --build build
COPY build\libquickjs-java-wrapper.dll ..\..\..
echo Build success
pause