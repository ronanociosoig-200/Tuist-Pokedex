#!/bin/sh
export TERM=xterm-256color
set -e

if [ "${CIRCLECI}" == true ]; then
    echo "CI == true, skipping this script"
    exit 0
fi


# Variables
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)
hasErrors=0
SWIFT_LINT=../../Pods/SwiftLint/swiftlint
SWIFT_FORMAT=../../Pods/SwiftFormat/CommandLineTool/swiftformat

if ! [[ -e "${SWIFT_LINT}" ]]; then
    echo "${SWIFT_LINT} is not installed."
    exit 0
fi

echo "SwiftLint $(${SWIFT_LINT} version)"

# Run SwiftLint
START_DATE=$(date +"%s")
run_checks() {
    echo "../../"${filename}
    if [ -f "../../"${filename} ]; then
        echo " exists."
        # Ignore Pods and Vendor paths.
        [[ ${filename} =~ /Pods/ ]] && return 0
        [[ ${filename} =~ Vendor/ ]] && return 0
        # Ignore templates and generated files.
        [[ ${filename} =~ .generated.* ]] && return 0
            
        ${SWIFT_FORMAT} "../../"${filename}

        # Ignore files.
        [[ ${filename} =~ .*Tests.swift ]] && return 0
        [[ ${filename} =~ .Package.swift ]] && return 0
        [[ ${filename} =~ .Dangerfile.swift ]] && return 0
        [[ ${filename} =~ .DangerfileCoverage.swift ]] && return 0
        [[ ${filename} =~ .swiftlint ]] && return 0
        [[ ${filename} =~ .swiftformat ]] && return 0

        ${SWIFT_LINT} lint --progress --config "../../.swiftlint.yml" "../../"${filename}
        # Need to fix folders with space ex "UI Test" before enable swiftlint here

        # if [[ $? != 0 ]]; then
            hasErrors=0
        # fi
    else
        echo "NO exists."
        return 0
    fi    
}

# Run for staged files
for filename in $(git diff --diff-filter=d --name-only | grep "\.swift"); do
   run_checks "${filename}";
done

# Run for unstaged files
for filename in $(git diff --cached --diff-filter=d --name-only | grep "\.swift"); do
   run_checks "${filename}";
done

# Run for added files
for filename in $(git ls-files --others --exclude-standard | grep "\.swift"); do
   run_checks "${filename}";
done

END_DATE=$(date +"%s")
DIFF=$(($END_DATE - $START_DATE))
echo "${GREEN}SwiftLint completed in $(($DIFF / 60)) minutes and $(($DIFF % 60)) seconds.${RESET}"

exit $hasErrors
