#!/bin/bash

# Mapping entre versions PrestaShop et stacks recommandées
get_stack_for_ps_version() {
  local ps_version="$1"

  case "$ps_version" in
    1.7.*) echo "7.4 10.5 14" ;;
    8.0.*) echo "8.1 10.6 16" ;;
    8.1.*) echo "8.1 10.6 18" ;;
    8.2.*) echo "8.2 10.6 18" ;;
    9.*)   echo "8.2 10.6 18" ;;
    *)     echo "8.1 10.6 18" ;; # fallback
  esac
}

# Mapping entre versions PrestaShop et thème par défaut
get_theme_for_ps_version() {
  local ps_version="$1"

  case "$ps_version" in
    1.7.*) echo "classic" ;;
    8.*) echo "classic" ;; # Hummingbird NOT compatible with PS 8.x
    9.*) echo "hummingbird" ;;
    *) echo "classic" ;; # fallback
  esac
}

# Mapping entre versions PrestaShop et versions Hummingbird
get_hummingbird_version_for_ps() {
  local ps_version="$1"

  case "$ps_version" in
    8.0.*) echo "v1.0.1" ;;  # Latest stable for PS 8.0.x
    8.1.*) echo "v1.0.1" ;;  # Latest stable for PS 8.1.x
    8.2.*) echo "v1.0.1" ;;  # Latest stable for PS 8.2.x
    9.*) echo "v2.0.0-beta.2" ;;  # Latest for PS 9.x
    *) echo "v1.0.1" ;; # fallback to stable v1.x
  esac
}

# Liste complète depuis 1.7.8.2 à aujourd’hui
PS_VERSIONS=(
  9.0.0-alpha.1
  8.2.0 8.2.1
  8.1.0 8.1.1 8.1.2 8.1.3 8.1.4 8.1.5
  8.0.0 8.0.1 8.0.2 8.0.3 8.0.4 8.0.5
  1.7.8.2 1.7.8.3 1.7.8.4 1.7.8.5 1.7.8.6 1.7.8.7 1.7.8.8 1.7.8.9 1.7.8.10 1.7.8.11
)

# Sélection d'une version PrestaShop
select_prestashop_version() {
  select_option "🧩 Sélectionnez la version PrestaShop" "${PS_VERSIONS[@]}"
}
