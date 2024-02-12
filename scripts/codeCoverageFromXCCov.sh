#!/bin/bash

# xcrun xccov view --report --json output/tests.xcresult > output/xccov_coverage.json
swift scripts/parse-xccov-json-coverage.swift output/xccov_coverage.json terse
