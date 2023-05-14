#!/bin/sh 

xcodebuild -workspace Pokedex.xcworkspace -scheme Pokedex -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 14,OS=16.4" test

