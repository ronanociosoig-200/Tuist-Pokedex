#!/bin/sh
echo "Compress simulator builds in Derived Data if it exists. Exclude test runners. "
echo "Copy each .app to simulatorApps"
if [ -d /Users/distiller/Library/Developer/Xcode/DerivedData ]; then
  find /Users/distiller/Library/Developer/Xcode/DerivedData -name "*.app" | grep -v "Tests-Runner" | while read in; do tar -cvzf "$in".tar.gz -C "$in" .; done
  mkdir "simulatorApps"
  echo "mkdir simulatorApps"
  find /Users/distiller/Library/Developer/Xcode/DerivedData -name "*.app.tar.gz" | while read in; do cp "$in" simulatorApps; done
  ls -l simulatorApps
  echo "Done"
fi

