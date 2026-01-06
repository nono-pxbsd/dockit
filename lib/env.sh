#!/bin/bash

# Fonction pour générer un fichier .env à partir d'un template
# $1 = template source, $2 = target, $3+ = substitutions KEY=VALUE
generate_env_file() {
  local template_file="$1"
  local target_file="$2"
  shift 2

  cp "$template_file" "$target_file"

  for pair in "$@"; do
    key="${pair%%=*}"
    value="${pair#*=}"
    escaped_value=$(printf '%s\n' "$value" | sed -e 's/[\/&]/\\&/g') # Échappe les caractères spéciaux
    sed -i "s|^${key}=.*|${key}=${escaped_value}|" "$target_file"
  done
}