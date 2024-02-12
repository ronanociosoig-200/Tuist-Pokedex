#!/bin/bash

# This script does not work, and it here for reference. 

# Specify the path to your XCResult bundle
xcresult_path=$1

# Use xcresulttool to get the code coverage
coverage=$(xcrun xcresulttool get --format json --path "$xcresult_path" | \
           jq '.metrics | .[] | select(.name == "coverage") | .doubleValue')

echo "Code Coverage: $coverage%"

