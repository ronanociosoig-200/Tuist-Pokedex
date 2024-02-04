#!/bin/bash

SOURCES=`git diff master --name-only | grep Sources | sed -e 's/\/Sources\/.*//' | sed -e 's/Features\///'`
echo $SOURCES

