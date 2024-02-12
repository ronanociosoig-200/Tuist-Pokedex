#!/usr/bash

[ ! -d ../output/sonar ] && mkdir ../output/sonar || echo "Sonar dir exists."
./xccov_to_sonarqube_generic.sh ../output/tests.xcresult > ../output/sonar/coverage_generic.xml

