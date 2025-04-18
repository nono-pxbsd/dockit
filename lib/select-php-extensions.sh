#!/bin/bash

select_php_extensions() {
  local available_extensions=(
    "pdo_mysql"       # Gestion des bases de données MySQL
    "curl"            # Requêtes HTTP
    "mbstring"        # Gestion des chaînes multioctets
    "zip"             # Gestion des fichiers ZIP
    "gd"              # Manipulation d'images
    "intl"            # Internationalisation
    "soap"            # Protocole SOAP
    "xml"             # Manipulation XML
    "opcache"         # Cache des scripts PHP
    "bcmath"          # Calculs mathématiques de précision
    "exif"            # Métadonnées des images
    "mysqli"          # Extension MySQL améliorée
    "calendar"        # Fonctions de gestion des dates
    "iconv"           # Conversion des jeux de caractères
    "readline"        # Entrée interactive
    "tokenizer"       # Analyseur lexical
    "ctype"           # Vérification des types de caractères
    "fileinfo"        # Informations sur les fichiers
    "imagick"         # Manipulation avancée d'images via ImageMagick
  )

  echo "🧩 Sélectionnez les extensions PHP nécessaires (utilisez TAB pour sélectionner plusieurs) :"
  local selected_extensions=$(printf "%s\n" "${available_extensions[@]}" | fzf --multi --prompt="Extensions PHP : " --height=10 --border --ansi)

  if [ -z "$selected_extensions" ]; then
    echo "❌ Aucune extension sélectionnée. Annulation."
    exit 1
  fi

  echo "$selected_extensions"
}