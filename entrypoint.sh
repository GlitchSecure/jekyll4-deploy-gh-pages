#!/bin/bash

set -e

DEST="${JEKYLL_DESTINATION:-_site}"
REPO="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
PUBLIC_REPO="https://x-access-token:${GITHUB_PUSH_TOKEN}@github.com/${GITHUB_REPOSITORY_PUBLIC}.git"
BRANCH="gh-pages"
BUNDLE_BUILD__SASSC=--disable-march-tune-native

echo "Installing gems..."

bundle config path vendor/bundle
bundle install --jobs 4 --retry 3

echo "Installing dependencies..."
npm install

echo "Building Jekyll site..."

npm run build

echo "Publishing..."

cd ${DEST}

git init
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git add .
git commit -m "published via GitHub Actions"
git push --force ${REPO} master:${BRANCH}
git push --force ${PUBLIC_REPO} master:${BRANCH}
