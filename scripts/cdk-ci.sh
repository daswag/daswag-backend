#!/bin/bash

# Check that the first argument is not empty
if [ -z "$1" ]; then
    echo "Usage: ./cdk-ci.sh <cdk command> [<cdk options>]"
    echo "Runs a 'cdk' command on all CDK projects in the current directory and its subdirectories."
    exit 1
fi

# Get the cdk command and options from the arguments
CDK_CMD=$1
shift
CDK_OPTS=${*:-""}

# Find all directories that contain a cdk.json file
PROJECTS=$(find . -type f -name cdk.json -exec grep -q "\[workspace\]" {} \; -print | xargs -n1 dirname | sort | uniq)

# Exclude test directory
TOP_WORKSPACES=()
for workspace in $WORKSPACES; do
    if [[ ! "$workspace" =~ "/ui_test_envs/" ]]; then
        TOP_WORKSPACES+=("$workspace")
    fi
done

# Iterate over each workspace and run `cargo check`
for workspace in "${TOP_WORKSPACES[@]}"; do
    echo "Running 'cargo $CARGO_CMD $CARGO_OPTS' in workspace: $workspace"
    (cd "$workspace" && cargo $CARGO_CMD $CARGO_OPTS)
done
