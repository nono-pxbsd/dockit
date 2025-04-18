#!/bin/bash

# Demande un nom de projet
ask_project_name() {
  read -p "📝 Nom du projet : " PROJECT_NAME
  echo "$PROJECT_NAME"
}

# Sanitize le nom du projet
sanitize_project_name() {
  local name="$1"
  echo "$name" | tr -cd 'a-zA-Z0-9._-' | tr '[:upper:]' '[:lower:]'
}

# Crée le répertoire du projet
create_project_directory() {
  local base_dir="$1"
  local project_name="$2"
  local project_dir="$base_dir/$project_name"
  mkdir -p "$project_dir"
  echo "$project_dir"
}

# Prépare les répertoires du projet
setup_project() {
  local CMS_NAME="$1"
  local PROJECT_ROOT="$2"

  echo "📁 Création du répertoire $PROJECT_ROOT..."
  mkdir -p "$PROJECT_ROOT"

  echo "🧬 Copie du template .env..."
  cp "$(dirname "$0")/../templates/env.tpl" "$PROJECT_ROOT/.env"
  echo "CMS_NAME=$CMS_NAME" >> "$PROJECT_ROOT/.env"
}