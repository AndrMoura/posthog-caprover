#!/bin/bash

DOCKER_DIR="docker"
mkdir -p "$DOCKER_DIR"

curl -L https://github.com/PostHog/posthog/tarball/c25b571388a9ad05d529a14daee8f49819280496 | tar -xz --wildcards --strip-components=2 -C "./" '*/posthog/idl/*'
curl -L https://github.com/PostHog/posthog/tarball/c25b571388a9ad05d529a14daee8f49819280496 | tar -xz --wildcards --strip-components=2 -C "$DOCKER_DIR" '*/docker/*'

echo "Extraction completed successfully."
