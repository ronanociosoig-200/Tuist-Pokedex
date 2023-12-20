#!/usr/bin/bash

XCRESULT_PATH=$1 
xcrun xcresulttool get --path $XCRESULT_PATH/tests.xcresult --format json > $XCRESULT_PATH/tests_xcresult.json


