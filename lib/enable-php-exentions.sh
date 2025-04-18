#!/bin/bash

# Activer les extensions PHP listées dans PHP_EXTENSIONS
if [ -n "$PHP_EXTENSIONS" ]; then
  echo "🔧 Activation des extensions PHP : $PHP_EXTENSIONS"
  for ext in $PHP_EXTENSIONS; do
    ini_file="/usr/local/etc/php/conf.d/docker-php-ext-$ext.ini"
    if [ -f "$ini_file" ]; then
      echo "extension=$ext" > "$ini_file"
      echo "✅ Extension activée : $ext"
    else
      echo "⚠️  Fichier de configuration introuvable pour l'extension : $ext"
    fi
  done
else
  echo "❌ Aucune extension PHP spécifiée dans PHP_EXTENSIONS."
fi