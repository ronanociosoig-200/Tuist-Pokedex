#!/bin/sh 

xcodebuild -workspace Pokedex.xcworkspace -scheme Pokedex -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 15,OS=17" test

