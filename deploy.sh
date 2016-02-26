#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo -d release # if using a theme, replace by `hugo -t <yourtheme>`

# Go To Public folder
cd release
# Add changes to git.
git add -A

# Commit changes.
msg="Rebuilding site on `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push -f origin master

# Come Back
cd ..
