#!/bin/bash

BUILD_ONLY=$1
BRANCH=`git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\1/p'`
TOKEN="YOUR_PERSONAL_API_TOKEN"
VCS="github"
USER="ronanociosoig-200"
PROJECT="Tuist-Pokedex"

if [ "$BUILD_ONLY" = "build-only-workflow" ]; then
  BUILD_AND_TEST_WORKFLOW="false"
  BUILD_ONLY_WORKFLOW="true"
else 
  BUILD_AND_TEST_WORKFLOW="true"
  BUILD_ONLY_WORKFLOW="false"
fi

curl --request POST \
  --url https://circleci.com/api/v2/project/$VCS/$USER/$PROJECT/pipeline \
  --header 'Circle-Token: '$TOKEN'' \
  --header 'content-type: application/json' \
  --data '{
    "branch": "'$BRANCH'",
    "parameters":{"build-and-test-workflow":'$BUILD_AND_TEST_WORKFLOW',
    "build-main-and-test-workflow":false,
    "build-only-workflow":'$BUILD_ONLY_WORKFLOW'}}'
