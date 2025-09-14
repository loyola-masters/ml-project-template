#!/bin/bash
# uv-envs.sh
# Simula "conda env list" para entornos uv y muestra versión de Python.

ENV_DIR=~/venvs
mkdir -p "$ENV_DIR"

if [ "$1" = "list" ]; then
    echo "Entornos en $ENV_DIR:"
    for env in "$ENV_DIR"/*; do
        if [ -d "$env" ]; then
            NAME=$(basename "$env")
            PYTHON_VER=$("$env/bin/python" -V 2>/dev/null)
            if [ -z "$PYTHON_VER" ]; then
                PYTHON_VER="(sin Python)"
            fi
            echo " - $NAME  [$PYTHON_VER]"
        fi
    done

elif [ "$1" = "activate" ] && [ -n "$2" ]; then
    ENV_PATH="$ENV_DIR/$2"
    if [ -d "$ENV_PATH" ]; then
        # Activa el entorno
        source "$ENV_PATH/bin/activate"
    else
        echo "No existe el entorno '$2' en $ENV_DIR"
    fi

else
    echo "Uso:"
    echo "  $0 list             # Lista entornos con versión de Python"
    echo "  $0 activate <name>  # Activa un entorno"
fi
