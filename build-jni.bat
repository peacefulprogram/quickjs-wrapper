@echo off
setlocal

cd wrapper-java\src\main

set args=
set build_args=

where ninja >nul 2>nul
if errorlevel 1 (
    set args=%args% -G "MinGW Makefiles"
) else (
    set args=%args% -G Ninja -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++
    set build_args=%build_args% -j %NUMBER_OF_PROCESSORS%
)

if exist build (
    echo Deleting old build folder...
    rmdir /s /q build
)

call :run cmake -B build -S . %args% -DCMAKE_BUILD_TYPE=Release || exit /b 1
call :run cmake --build build %build_args% || exit /b 1
call :run copy build\libquickjs-java-wrapper.dll ..\..\.. || exit /b 1

echo Build success
exit /b

:run
echo ^> %*
%*
exit /b %errorlevel%