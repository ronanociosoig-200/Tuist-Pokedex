#!/bin/sh

#[ -d output/tests.xcresult ] && rm -r output/tests.xcresult || echo "No test data to delete" 
# tuist test --result-bundle-path output/tests --device "iPhone 15" --os "17.0"
tuist test --device "iPhone 15" --os "17.2" --skip-ui-tests --result-bundle-path output/tests --skip-test-targets HomeSnapshotTests,CatchSnapshotTests,PokedexSnapshotTests,BackpackSnapshotTests,DetailSnapshotTests

