#!/bin/bash
set -e

# Start docker
docker login --username ${OPENFAAS_PREFIX} --password ${DOCKER_PASS}
faas-cli login --password ${OPENFAAS_PASSWORD}

# Remove a potentially pre-existing server.pid for Rails.
rm -f /dalal/tmp/pids/server.pid

# Setup / Run migrations
rake db:exists && rake db:migrate || rake db:setup
rake db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec bundle exec puma
