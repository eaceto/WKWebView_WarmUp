
#!/bin/sh

BIN_PATH="$(swift build --show-bin-path)"
XCTEST_PATH="$(find ${BIN_PATH} -name '*.xctest')"
XCODE_PATH=`xcode-select -p`
TESTS_PATH=".build/coverage-build/debug/WKWebView_WarmUpPackageTests.xctest/Contents/MacOS/WKWebView_WarmUpPackageTests"
PROFDATA_PATH=".build/coverage-build/debug/codecov/default.profdata"

$XCODE_PATH/Toolchains/XcodeDefault.xctoolchain/usr/bin/llvm-cov report \
    -instr-profile="$PROFDATA_PATH" \
    $TESTS_PATH \
    -ignore-filename-regex=".build|Tests" \
    -use-color

$XCODE_PATH/Toolchains/XcodeDefault.xctoolchain/usr/bin/llvm-cov export -format=lcov -instr-profile $PROFDATA_PATH $TESTS_PATH -ignore-filename-regex=".build|Tests" > "docs/coverage/lcov.info" > "docs/coverage/lcov.info" 

genhtml docs/coverage/lcov.info --config-file .lcovrc --show-details --legend --keep-descriptions --output-directory docs/coverage
