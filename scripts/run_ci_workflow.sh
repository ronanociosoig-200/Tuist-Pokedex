#!/bin/bash

BRANCH=`git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\1/p'`
TOKEN="YOUR_PERSONAL_API_TOKEN"
VCS="github"
USER="ronanociosoig-200"
PROJECT="Tuist-Pokedex"

curl --request POST \
  --url https://circleci.com/api/v2/project/$VCS/$USER/$PROJECT/pipeline \
  --header 'Circle-Token: '$TOKEN'' \
  --header 'content-type: application/json' \
  --data '{
    "branch": "'$BRANCH'",
    "parameters":{"build-and-test-workflow":false,
    "build-main-and-test-workflow":false,
    "build-only-workflow":true}}'
