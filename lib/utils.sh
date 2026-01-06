#!/bin/bash

normalize_path() {
  local path="$1"

  # Si le chemin commence par ~, remplacez-le par $HOME
  if [[ "$path" == ~* ]]; then
    path="${HOME}${path:1}"
  fi

  # Convertir en chemin absolu
  path=$(realpath -m "$path")

  echo "$path"
}

implode() {
  local separator="$1"
  shift
  local arr=("$@")
  local result=""

  for element in "${arr[@]}"; do
    [[ -n "$result" ]] && result+="$separator"
    result+="$element"
  done

  echo "$result"
}
