#!/bin/sh

# This is the pre-commit command that runs linters and other checks
# upon committing.
# To install:
# rm -rf .git/hooks/pre-commit; cwd=$(pwd); ln -s $cwd/tests/pre-commit.sh $cwd/.git/hooks/pre-commit
# chmod +x .git/hooks/pre-commit

# First, run the linters
python tests/check.py

if [ -n  "$(python tests/check.py|grep 'FAILED')" ];
then
    echo "Aborting commit. Fix the above errors before committing."
    exit 1
fi

echo "checking for ^M characters"
grep -r -l \
    --include \*\*.py \
    --include \*\*.yml . | xargs dos2unix -q
echo "^M characters were all removed"

# Now ensure that you aren't trying to commit directly to master or dev-main
protected_branches='master dev-main'
for protected_branch in $protected_branches
do
    current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,');
    if [ "$protected_branch" = $current_branch ]
    then
        echo "Never commit to the '$protected_branch' branch!";
        echo "Commit Aborted"
        exit 1
    fi
done

echo "Commit Passed Check.py!"
exit 0
