#!/bin/sh

echo "Extract out code coverage using llvm-cov for the Pokedex app binary and sources"

# /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/llvm-cov

xcrun llvm-cov show -instr-profile ~/Library/Developer/Xcode/DerivedData/Pokedex-fymastwcltphqmatpkppmomxhdyo/Build/ProfileData/A2EB5683-FDB2-4B51-9F85-D2928B2CB01D/Coverage.profdata ~/Library/Developer/Xcode/DerivedData/Pokedex-fymastwcltphqmatpkppmomxhdyo/Build/Products/Debug-iphonesimulator/Pokedex.app/Pokedex ./App/Pokedex/Sources

