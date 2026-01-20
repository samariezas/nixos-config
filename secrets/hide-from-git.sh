#!/usr/bin/env bash
set -xe
git add --intent-to-add ./secrets/default.nix
git update-index --assume-unchanged ./secrets/default.nix
