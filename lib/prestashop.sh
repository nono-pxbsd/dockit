#!/bin/bash

# Télécharge le fichier ZIP de PrestaShop
download_prestashop_zip() {
  local version="$1"
  local dest_dir="$2"
  local zip_path="$dest_dir/prestashop.zip"
  local url="https://github.com/PrestaShop/PrestaShop/releases/download/${version}/prestashop_${version}.zip"

  echo "⏬ Téléchargement depuis $url"
  if ! curl -L -o "$zip_path" "$url"; then
    echo "❌ Échec du téléchargement de PrestaShop. Vérifiez votre connexion ou l'URL."
    exit 1
  fi
  echo "✅ Fichier téléchargé : $zip_path"
}

# Extrait le fichier ZIP de PrestaShop
extract_prestashop_zip() {
  local zip_path="$1"
  local dest_dir="$2"

  echo "📦 Extraction dans $dest_dir..."
  if ! unzip -q "$zip_path" -d "$dest_dir"; then
    echo "❌ Échec de l'extraction du fichier ZIP."
    exit 1
  fi
  rm "$zip_path"
  echo "✅ PrestaShop extrait dans $dest_dir"
}

# Télécharge et extrait PrestaShop
download_and_extract_prestashop() {
  local version="$1"
  local dest_dir="$2"

  # Crée le répertoire de destination s'il n'existe pas
  mkdir -p "$dest_dir"

  # Téléchargement
  download_prestashop_zip "$version" "$dest_dir"

  # Extraction
  extract_prestashop_zip "$dest_dir/prestashop.zip" "$dest_dir"
}