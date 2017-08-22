#!/usr/bin/env bash

echo "TRAVIS_BRANCH: $TRAVIS_BRANCH"
echo "TRAVIS_REPO_SLUG: $TRAVIS_REPO_SLUG"
echo "TRAVIS_PULL_REQUEST: $TRAVIS_PULL_REQUEST"
echo "TRAVIS_TAG: $TRAVIS_TAG"
echo "TRAVIS_PWD: $PWD"
echo "TRAVIS: $TRAVIS"

chef --version || exit 1
cookstyle --version || exit 1
cookstyle || exit 1
foodcritic --version || exit 1
foodcritic . || exit 1
rspec spec || exit 1

if [[ -n $TRAVIS_TAG && $TRAVIS_PULL_REQUEST == 'false' ]]; then
  echo "Deploying java cookbook - release"
  openssl aes-256-cbc -K $encrypted_f7982e51c0b5_key -iv $encrypted_f7982e51c0b5_iv -in .travis/publish-key.pem.enc -out .travis/publish-key.pem -d
  knife cookbook site share java "Other" -o ../ --config .travis/config.rb
else
  echo "Skipping deploy."
fi
