#!/bin/bash

./xcresulttool_get_json_data.sh ../output
swift ./parse-xcresulttool-json-coverage.swift ../output/tests_xcresult.json
