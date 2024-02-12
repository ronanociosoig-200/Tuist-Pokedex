#!/bin/bash 

xcrun xccov view --report --json output/tests.xcresult > output/xccov_coverage.json
