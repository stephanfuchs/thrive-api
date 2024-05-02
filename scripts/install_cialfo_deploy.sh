#!/bin/bash

# remove sub module
git submodule deinit -f -- config/deploy/cialfo-deploy
rm -rf config/deploy/cialfo-deploy
rm -rf .git/modules/config/deploy/cialfo-deploy
git rm --cached config/deploy/cialfo-deploy

# add sub module again
git submodule add -f git@github.com:cialfo/app-cialfo-co-deploy config/deploy/cialfo-deploy
