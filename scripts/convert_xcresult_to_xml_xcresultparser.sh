#!/bin/bash
XCRESULT_PATH=$1
tools/xcresultparser -c --project-root /Users/ronan.ocoisoig/Projects/Tuist-Pokedex -o xml $XCRESULT_PATH > output/sonar/xcresultparser_coverage.xml
  
