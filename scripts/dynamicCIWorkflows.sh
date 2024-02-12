#!/bin/bash

RUN_CI_WORKFLOW="scripts/run_ci_workflow.sh"
BUILD_ONLY="build-only-workflow"
BUILD_AND_TEST="build-and-test-workflow"

SOURCES=`git diff master --name-only | grep Sources | sed -e 's/\/Sources\/.*//' | sed -e 's/Features\///'`

[ -z "$SOURCES" ] && bash $RUN_CI_WORKFLOW $BUILD_ONLY || bash $RUN_CI_WORKFLOW $BUILD_AND_TEST
