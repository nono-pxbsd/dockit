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
