#!/bin/bash

# This script should be run after you clone the quorum-devops repo
# and you have cd'ed into quorum-devops
rm -rf .git/hooks/pre-commit
rm -rf .git/hooks/prepare-commit-msg
cwd=$(pwd)
ln -s $cwd/tests/pre-commit.sh $cwd/.git/hooks/pre-commit
ln -s $cwd/tests/prepare-commit-msg.sh $cwd/.git/hooks/prepare-commit-msg
