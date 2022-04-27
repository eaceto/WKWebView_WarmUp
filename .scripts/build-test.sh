#! /bin/sh

rm -rf .build
swift package clean

swift build --enable-code-coverage --build-path .build/coverage-build

swift test --enable-code-coverage --build-path .build/coverage-build
