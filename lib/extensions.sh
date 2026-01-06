#!/bin/bash

# ============================================
# Fichier : lib/extensions.sh
# Objet   : Fonctions de gestion des extensions PHP
# ============================================

# 📦 Récupère la liste des extensions PHP supportées pour une version donnée
#!/usr/bin/env bash
fetch_supported_extensions() {
  local PHP_VERSION="$1"
  local TMP_FILE
  TMP_FILE="$(mktemp)"
  local URL="https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/data/supported-extensions"

  echo "🔍 Téléchargement de la liste des extensions supportées..." >&2
  if ! curl -sSL -o "$TMP_FILE" "$URL"; then
    echo "❌ Échec du téléchargement du fichier." >&2
    return 1
  fi

  echo "🔎 Recherche des extensions compatibles avec PHP $PHP_VERSION..." >&2

  local EXTENSIONS=()
  while IFS= read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    name="$(echo "$line" | cut -d ' ' -f1)"
    if echo "$line" | grep -qw "$PHP_VERSION"; then
      EXTENSIONS+=("$name")
    fi
  done < "$TMP_FILE"

  rm -f "$TMP_FILE"

  if [[ ${#EXTENSIONS[@]} -eq 0 ]]; then
    echo "❌ Aucune extension compatible trouvée pour PHP $PHP_VERSION." >&2
    return 1
  fi

  # ✅ Renvoie la liste des extensions séparées par des newlines (une par ligne)
  source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"
  implode $'\n' "${EXTENSIONS[@]}"
}

# 🔸 UI de sélection interactive des extensions compatibles avec fzf
select_php_extensions() {
  local php_version="$1"

  # Extensions obligatoires pour PrestaShop
  local REQUIRED_EXTENSIONS="bcmath curl gd intl mbstring pdo_mysql zip xml"

  echo -e "📦 Extensions obligatoires (installées automatiquement) :" >&2
  echo -e "   ${REQUIRED_EXTENSIONS}\n" >&2

  local available_extensions
  available_extensions=$(fetch_supported_extensions "$php_version") || return 1

  # Extensions PECL à exclure (nécessitent installation via PECL, pas docker-php-ext-install)
  local PECL_EXTENSIONS="amqp redis xdebug mongodb memcached imagick apcu apcu_bc igbinary msgpack swoole pcov yaml grpc protobuf"

  # Filtrer pour ne proposer que les extensions optionnelles (pas dans REQUIRED ni PECL)
  local optional_extensions=""
  while IFS= read -r ext; do
    if ! echo "$REQUIRED_EXTENSIONS" | grep -qw "$ext" && ! echo "$PECL_EXTENSIONS" | grep -qw "$ext"; then
      optional_extensions+="$ext"$'\n'
    fi
  done <<< "$available_extensions"

  echo -e "🔷 Sélectionnez des extensions PHP optionnelles (TAB pour sélectionner, ENTER pour valider) :\n" >&2

  local selected_optional
  selected_optional=$(echo "$optional_extensions" | fzf --multi --prompt="Extensions optionnelles : " --height=15 --border)

  # Fusionner les extensions obligatoires + optionnelles sélectionnées
  local final_extensions="$REQUIRED_EXTENSIONS"
  if [[ -n "$selected_optional" ]]; then
    # Convertir les newlines en espaces et ajouter aux obligatoires
    selected_optional=$(echo "$selected_optional" | tr '\n' ' ' | sed 's/ *$//')
    final_extensions="$final_extensions $selected_optional"
  fi

  echo "$final_extensions"
}

# 🔹 Formate une liste multiline en ligne d'extensions (pour .env)
format_extensions_for_env() {
  local input="$1"
  echo "$input" | tr '\n' ' ' | sed 's/ *$//'
}

# 🔹 Applique les extensions dans un fichier .env
apply_extensions_to_env() {
  local extensions="$1"
  local env_file="$2"
  if [[ ! -f "$env_file" ]]; then
    echo "❌ Fichier introuvable : $env_file"
    return 1
  fi

  sed -i "s|^PHP_EXTENSIONS=.*|PHP_EXTENSIONS=$extensions|" "$env_file"
  echo "🌐 PHP_EXTENSIONS mis à jour dans $env_file"
}

# Appel direct possible pour test
if [[ "$0" == "$BASH_SOURCE" ]]; then
  php_version="$1"
  result=$(select_php_extensions "$php_version")
  formatted=$(format_extensions_for_env "$result")
  echo -e "\n🚀 Chaîne prête pour .env : $formatted"
fi
