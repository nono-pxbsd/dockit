#!/bin/bash

check_dependencies() {
  local missing_dependencies=()

  # Liste des dépendances nécessaires
  local dependencies=("netstat" "fzf" "curl" "unzip" "docker")

  echo "🔍 Vérification des dépendances nécessaires..."

  # Vérifie chaque dépendance
  for dep in "${dependencies[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      echo "❌ Dépendance manquante : $dep"
      missing_dependencies+=("$dep")
    fi
  done

  # Si des dépendances sont manquantes
  if [ ${#missing_dependencies[@]} -gt 0 ]; then
    echo "⚠️  Les dépendances suivantes sont manquantes : ${missing_dependencies[*]}"
    read -p "Souhaitez-vous les installer maintenant ? (y/N) " INSTALL_DEPS
    if [[ "$INSTALL_DEPS" =~ ^[Yy]$ ]]; then
      install_dependencies "${missing_dependencies[@]}"
    else
      echo "❌ Impossible de continuer sans les dépendances nécessaires."
      exit 1
    fi
  else
    echo "✅ Toutes les dépendances sont installées."
  fi
}

install_dependencies() {
  local dependencies=("$@")

  echo "🔧 Installation des dépendances manquantes..."
  for dep in "${dependencies[@]}"; do
    case "$dep" in
      netstat)
        echo "📦 Installation de net-tools (pour netstat)..."
        sudo apt-get install -y net-tools
        ;;
      fzf)
        echo "📦 Installation de fzf..."
        sudo apt-get install -y fzf
        ;;
      curl)
        echo "📦 Installation de curl..."
        sudo apt-get install -y curl
        ;;
      unzip)
        echo "📦 Installation de unzip..."
        sudo apt-get install -y unzip
        ;;
      docker)
        echo "📦 Installation de Docker..."
        sudo apt-get install -y docker.io
        ;;
      *)
        echo "❌ Dépendance inconnue : $dep"
        ;;
    esac
  done
}