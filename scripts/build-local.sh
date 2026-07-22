#!/usr/bin/env bash
set -euo pipefail
IMAGE="${IMAGE:-fusion360-selkies:24.04}"
docker build --pull=false --tag "$IMAGE" .
echo "Built $IMAGE"
