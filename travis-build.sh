#!/usr/bin/env bash

echo "TRAVIS_BRANCH: $TRAVIS_BRANCH"
echo "TRAVIS_REPO_SLUG: $TRAVIS_REPO_SLUG"
echo "TRAVIS_PULL_REQUEST: $TRAVIS_PULL_REQUEST"
echo "TRAVIS_TAG: $TRAVIS_TAG"
echo "TRAVIS_PWD: $PWD"

/opt/chefdk/embedded/bin/chef --version || exit 1
/opt/chefdk/embedded/bin/rubocop --version || exit 1
/opt/chefdk/embedded/bin/rubocop || exit 1
/opt/chefdk/embedded/bin/foodcritic --version || exit 1
/opt/chefdk/embedded/bin/foodcritic . --exclude spec -f any || exit 1
/opt/chefdk/embedded/bin/rspec spec || exit 1

if [[ -n $TRAVIS_TAG && $TRAVIS_PULL_REQUEST == 'false' ]]; then
  /opt/chefdk/embedded/bin/knife cookbook site share java "Other" -o ../ --config .travis/config.rb
else
  echo "Not a tagged commit, skipping deploy."
fi
