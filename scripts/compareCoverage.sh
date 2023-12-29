#!/bin/bash

# Generate JSON file from the XCResult bundle
xcrun xccov view --report --json output/tests.xcresult > output/xccov_coverage.json

# Parse the JSON data and compare it with the reference coverage file
swift scripts/compareCoverage.swift output/xccov_coverage.json
