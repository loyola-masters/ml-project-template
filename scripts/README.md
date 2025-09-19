## Script `uv-envs.sh`: simulación de conda con uv

Integrado en `.bashrc` como una función (opción recomendada):

```bash
uv-env(){
 # Contenido de uv-envs.sh
}
```

Adjunto tienes el fichero `.bashrc`, que puedes utilizar y sustituir tal cual al actual en `/home/ubuntu`.

### Uso integrado en `.bashrc`

```
source ~/.bashrc
uv-env list
uv-env activate py311
```

> NOTA: El comando `source` no es necesario, ya que `.bashrc` se ejecuta cada vez que se abre un termina.

### Uso ejecutando como script separado

```
source ~/scripts/uv-envs.sh list
source ~/scripts/uv-envs.sh activate py312
```

> **NOTA**: Ambas formas son equivalentes, ya que en `.bashrc` se incluye dicho script como función (ver fichero `.bashrc` adjunto, donde la función `un-env()` se puede localizar al final):

```
# uv-env: helper para gestionar entornos uv (~/venvs por defecto)

# --- Función uv-env ---
# Simula "conda env list" y permite activar entornos uv
uv-env() {
    ENV_DIR=~/venvs
    mkdir -p "$ENV_DIR"

    if [ "$1" = "list" ]; then
    # echo "Entornos en $ENV_DIR:"
    for env in "$ENV_DIR"/*; do
        if [ -d "$env" ]; then
            NAME=$(basename "$env")
            PYTHON_VER=$("$env/bin/python" -V 2>/dev/null)
            if [ -z "$PYTHON_VER" ]; then
                PYTHON_VER="(sin Python)"
            fi
            # Marcar el entorno activo
            #echo "VIRTUAL_ENV = $VIRTUAL_ENV , env =$env "
            if [ "$VIRTUAL_ENV" = "$env" ]; then
                echo "✅ $NAME  [$PYTHON_VER]"
            else
                echo "   $NAME  [$PYTHON_VER]"
            fi
        fi
    done

    elif [ "$1" = "activate" ] && [ -n "$2" ]; then
        ENV_PATH="$ENV_DIR/$2"
        if [ -d "$ENV_PATH" ]; then
            source "$ENV_PATH/bin/activate"
            echo "✅ Entorno activado: $2"
        else
            echo "No existe el entorno '$2' en $ENV_DIR"
        fi

    else
        echo "Uso:"
        echo "  uv-env list             # Lista entornos en ~/envs y versión de Python"
        echo "  uv-env activate <name>  # Activa un entorno alojaodo en ~/envs"
    fi
}
# --- Fin uv-env ---
```
