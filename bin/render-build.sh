#!/usr/bin/env bash
set -o errexit

bundle install

bin/rails assets:precompile
bin/rails assets:clean

# On free plans, keep migrations in the build script
bin/rails db:migrate
