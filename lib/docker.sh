#!/bin/bash

# Détecte la plateforme Docker
detect_docker_platform() {
  if command -v docker >/dev/null 2>&1; then
    local platform
    platform=$(docker info --format '{{.OSType}}/{{.Architecture}}' 2>/dev/null || echo "linux/amd64")
    if [[ "$platform" == *"aarch64" ]]; then
      platform="${platform/aarch64/arm64}"
    fi
    echo "$platform"
  else
    echo "linux/amd64"
  fi
}