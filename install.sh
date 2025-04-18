#!/bin/bash

TARGET="/usr/local/bin/dockit"
SOURCE="$(pwd)/bin/dockit"

echo "🔧 Installation de dockit..."

if [ -L "$TARGET" ]; then
  echo "🔁 Ancien lien détecté, suppression..."
  sudo rm "$TARGET"
fi

echo "🔗 Création du lien symbolique..."
sudo ln -s "$SOURCE" "$TARGET"

echo "✅ dockit est installé. Utilisez la commande : dockit"
