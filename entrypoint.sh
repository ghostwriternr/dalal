#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /dalal/tmp/pids/server.pid

# Setup / Run migrations
rake db:exists && rake db:migrate || rake db:setup
rake db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec bundle exec puma
