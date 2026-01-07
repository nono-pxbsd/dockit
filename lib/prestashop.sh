#!/bin/bash

# Télécharge et extrait PrestaShop depuis le code source GitHub
download_and_extract_prestashop() {
  local version="$1"
  local dest_dir="$2"
  local temp_zip="$dest_dir/prestashop_source.zip"
  local url="https://github.com/PrestaShop/PrestaShop/archive/refs/tags/${version}.zip"

  # Crée le répertoire de destination s'il n'existe pas
  mkdir -p "$dest_dir"

  # Téléchargement du code source
  echo "⏬ Téléchargement du code source depuis $url"
  if ! curl -L -o "$temp_zip" "$url"; then
    echo "❌ Échec du téléchargement de PrestaShop. Vérifiez votre connexion ou l'URL."
    exit 1
  fi
  echo "✅ Fichier téléchargé : $temp_zip"

  # Extraction dans un répertoire temporaire
  echo "📦 Extraction des sources PrestaShop..."
  local temp_extract="$dest_dir/temp_extract"
  mkdir -p "$temp_extract"

  if ! unzip -q "$temp_zip" -d "$temp_extract"; then
    echo "❌ Échec de l'extraction du fichier ZIP."
    rm -rf "$temp_extract"
    rm "$temp_zip"
    exit 1
  fi

  # GitHub crée un dossier PrestaShop-VERSION, on déplace son contenu
  local extracted_folder=$(find "$temp_extract" -maxdepth 1 -type d -name "PrestaShop-*" | head -n 1)

  if [ -z "$extracted_folder" ]; then
    echo "❌ Structure inattendue de l'archive PrestaShop."
    rm -rf "$temp_extract"
    rm "$temp_zip"
    exit 1
  fi

  # Déplace le contenu vers le répertoire de destination
  mv "$extracted_folder"/* "$dest_dir/" 2>/dev/null
  mv "$extracted_folder"/.[!.]* "$dest_dir/" 2>/dev/null || true

  # Nettoyage
  rm -rf "$temp_extract"
  rm "$temp_zip"

  echo "✅ Sources PrestaShop extraites dans $dest_dir"
}

# Télécharge et installe le thème Hummingbird depuis GitHub
download_and_extract_hummingbird() {
  local hummingbird_version="$1"
  local dest_dir="$2"
  local theme_dir="$dest_dir/themes/hummingbird"
  local temp_zip="$dest_dir/hummingbird.zip"
  local url="https://github.com/PrestaShop/hummingbird/archive/refs/tags/${hummingbird_version}.zip"

  echo "🐦 Téléchargement du thème Hummingbird v${hummingbird_version}..."

  if ! curl -L -o "$temp_zip" "$url"; then
    echo "❌ Échec du téléchargement de Hummingbird. Vérifiez votre connexion ou l'URL."
    return 1
  fi
  echo "✅ Hummingbird téléchargé"

  # Extraction temporaire
  local temp_extract="$dest_dir/temp_hummingbird"
  mkdir -p "$temp_extract"

  if ! unzip -q "$temp_zip" -d "$temp_extract"; then
    echo "❌ Échec de l'extraction de Hummingbird."
    rm -rf "$temp_extract"
    rm "$temp_zip"
    return 1
  fi

  # GitHub crée un dossier hummingbird-VERSION
  local extracted_folder=$(find "$temp_extract" -maxdepth 1 -type d -name "hummingbird-*" | head -n 1)

  if [ -z "$extracted_folder" ]; then
    echo "❌ Structure inattendue de l'archive Hummingbird."
    rm -rf "$temp_extract"
    rm "$temp_zip"
    return 1
  fi

  # Supprimer l'ancien dossier hummingbird s'il existe
  rm -rf "$theme_dir"

  # Créer le répertoire et y déplacer le contenu
  mkdir -p "$theme_dir"
  mv "$extracted_folder"/* "$theme_dir/" 2>/dev/null
  mv "$extracted_folder"/.[!.]* "$theme_dir/" 2>/dev/null || true

  # Nettoyage
  rm -rf "$temp_extract"
  rm "$temp_zip"

  echo "✅ Thème Hummingbird installé dans themes/hummingbird"
}