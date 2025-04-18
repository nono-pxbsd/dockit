#!/bin/bash

# Vérifie si un port est utilisé
is_port_used() {
  local port=$1
  netstat -tuln | grep -q ":$port "
}

# Trouve un port libre
find_free_port() {
  local port=$1
  while is_port_used "$port"; do
    port=$((port + 1))
  done
  echo "$port"
}