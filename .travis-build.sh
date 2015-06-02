#!/bin/sh

set -e
set -x

if grep -r '\s$' src *.yml *.txt *.md Doxyfile .gitignore .gitmodules .travis* dist/*.desktop \
                 dist/*.svg dist/*.xml; then
    echo Trailing whitespace found, aborting
    exit 1
fi

#if OS is linux or is not set
if [ "$TRAVIS_OS_NAME" = "linux" -o -z "$TRAVIS_OS_NAME" ]; then
    mkdir build && cd build
    cmake -DUSE_QT5=OFF ..
    make -j4
elif [ "$TRAVIS_OS_NAME" = "osx" ]; then
    export Qt5_DIR=$(brew --prefix)/opt/qt5
    mkdir build && cd build
    cmake .. -GXcode
    xcodebuild -configuration Release | xcpretty -c && exit ${PIPESTATUS[0]}
fi
