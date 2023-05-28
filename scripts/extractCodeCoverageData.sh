#!/bin/sh

cat output/test_results.html | grep "Total coverage" | sed -e 's/<[^>]*>//g' > output/coverageSummary.txt
cat output/test_results.html | grep "Pokedex.app" | sed -e 's/<[^>]*>//g' >> output/coverageSummary.txt
cat output/test_results.html | grep ".framework" | grep -v "JGProgressHUD.framework" | grep -v "SnapshotTesting.framework" | sed -e 's/<[^>]*>//g' >> output/coverageSummary.txt

