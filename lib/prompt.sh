#!/bin/bash

# Sélection interactive via fzf (si dispo) ou select
select_option() {
  local prompt="$1"
  shift
  local options=("$@")
  local selection=""

  if command -v fzf >/dev/null 2>&1; then
    selection=$(printf "%s\n" "${options[@]}" | fzf --height=40% --reverse --prompt="$prompt")
  else
    echo "$prompt"
    select opt in "${options[@]}"; do
      selection="$opt"
      break
    done
  fi
  echo "$selection"
}

# Sanitize le nom du projet
sanitize_project_name() {
  local name="$1"
  name=$(echo "$name" | tr '[:upper:]' '[:lower:]')
  name=$(echo "$name" | tr ' ' '-')
  name=$(echo "$name" | sed 's/[^a-z0-9._-]//g')
  if [[ ! "$name" =~ ^[a-z0-9] ]]; then
    echo "❌ Le nom doit commencer par une lettre ou un chiffre."
    exit 1
  fi
  echo "$name"
}