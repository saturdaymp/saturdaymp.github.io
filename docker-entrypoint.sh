#!/bin/bash
set -e

if ! bundle check > /dev/null 2>&1; then
    echo "Running bundle install..."
    bundle install
fi

exec "$@"