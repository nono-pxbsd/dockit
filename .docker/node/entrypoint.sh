#!/bin/bash
cd "/var/www/html/themes/$THEME_NAME"

if [ -f package.json ]; then
  echo "📦 Installing dependencies..."
  npm install
fi

exec "$@"