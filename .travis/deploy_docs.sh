#!/bin/bash

set -o errexit -o nounset

if [ "$TRAVIS_REPO_SLUG" != "ofek/bit" ] || [ "$TRAVIS_PULL_REQUEST" != "false" ] || [ "$TRAVIS_BRANCH" != "master" ]
then
  echo "This commit was made against the $TRAVIS_BRANCH and not the master! No deploy!"
  exit 0
fi

rev=$(git rev-parse --short HEAD)

cd docs
make clean
make html
cd build\html

git init
git config user.name "Ofek Lev"
git config user.email "ofekmeister@gmail.com"

git remote add upstream "https://$GH_TOKEN@github.com/ofek/bit.git"
git fetch upstream
git reset upstream/gh-pages

touch .

git add -A .
git commit -m "rebuild pages at ${rev}"
git push -q upstream HEAD:gh-pages
