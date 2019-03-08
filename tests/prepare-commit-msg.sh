#!/bin/bash

# This way you can customize which branches should be skipped when
# prepending commit message.

# To install:
# rm -rf .git/hooks/prepare-commit-msg; cwd=$(pwd); ln -s $cwd/tests/prepare-commit-msg.sh $cwd/.git/hooks/prepare-commit-msg

if [ -z "$BRANCHES_TO_SKIP" ]; then
  BRANCHES_TO_SKIP=(master dev-main)
fi

BRANCH_NAME=$(git symbolic-ref --short HEAD)
BRANCH_NAME="${BRANCH_NAME##*/}"

BRANCH_EXCLUDED=$(printf "%s\n" "${BRANCHES_TO_SKIP[@]}" | grep -c "^$BRANCH_NAME$")
BRANCH_IN_COMMIT=$(grep -c "\[$BRANCH_NAME\]" $1)

# Check commit message length
if [ "$(sed 's/\s//g' $1 | wc -c)" -le 12 ] ; then
    echo Commit message is too short. Please make it more descriptive!! >&2;
    echo "Commit Aborted";
    exit 1
fi

# Append branch's name to the beginning of the commit message
# unless it's dev-main or master
if [ -n "$BRANCH_NAME" ] && ! [[ $BRANCH_EXCLUDED -eq 1 ]] && ! [[ $BRANCH_IN_COMMIT -ge 1 ]]; then
  sed -i.bak -e "1s/^/[$BRANCH_NAME] /" $1
fi
