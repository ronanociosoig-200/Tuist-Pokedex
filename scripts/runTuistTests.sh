#!/bin/sh

#[ -d output/tests.xcresult ] && rm -r output/tests.xcresult || echo "No test data to delete" 
tuist test --result-bundle-path output/tests --device "iPhone 14" --os "16.4"

