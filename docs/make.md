## Makefile
Explicación paso a paso.

### 1. Variables iniciales

```makefile
PY ?= 3.11
UV ?= uv
```

* `PY` → define la versión de Python por defecto (`3.11`).
* `UV` → define el gestor de entornos y paquetes (`uv`).
* El `?=` significa “usa este valor **si no viene ya definido en el entorno**”.
  → Ejemplo: puedes sobrescribirlo con `make setup PY=3.12`.

### 2. Objetivo por defecto

```makefile
.DEFAULT_GOAL := help
```

* Indica que, si ejecutas `make` sin argumentos, correrá la tarea `help`.
* Así, el usuario siempre recibe una guía rápida de los comandos disponibles.

### 3. Target `help`

```makefile
help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## ' Makefile | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'
```

* Busca en el propio Makefile las líneas con comentarios `##` y las lista.
* Colorea el nombre de cada comando (`cyan`) y muestra la descripción.
* Es lo que genera la ayuda tipo:

  ```
  help              Muestra esta ayuda
  setup             Crea venv 3.11 e instala deps
  test              Test de humo
  train             Entrena ejemplo Iris (árbol de decisión)
  ```

### 4. Target `setup`

```makefile
setup: ## Crea venv 3.11 en '~/venvs/uv_env' e instala deps
	$(UV) python install $(PY)
	$(UV) venv --python $(PY) || true
	$(UV) pip install --upgrade pip
	$(UV) sync
```

* Instala Python 3.11 con `uv python install`.
* Crea un entorno virtual en `/.venv`. (`|| true` evita error si ya existe)
    -  `.venv` es el ubicación / nombre del entorno por defecto
* Actualiza `pip`.
* Instala todas las dependencias listadas en `pyproject.toml` / `uv.lock` con `uv sync`.

👉 Esto garantiza que todos los alumnos tienen el **mismo entorno reproducible**.

### 5. Target `test`

```makefile
test: ## Test de humo
	$(UV) run python -c "import sklearn; import sys; print('OK sklearn', sklearn.__version__); sys.exit(0)"
```

* Ejecuta un script en línea que importa `scikit-learn` y muestra su versión.
* Si todo va bien, imprime algo como:

  ```
  OK sklearn 1.7.1
  ```

**ACLARACIÓN:**
* Cuando se ejecuta `make test`, la regla es:
  ```bash
  uv run python -c "import sklearn; ..."
  ```
* `uv run` necesita un **entorno de proyecto** para resolver dependencias.
* Busca primero un **venv** en la carpeta del proyecto (por convención: `.venv`).
* Como no lo encuentra (aunque tengas otro en `~/venvs/py311`), te avisa:

  ```
  warning: VIRTUAL_ENV=/home/ubuntu/venvs/py311 does not match the project environment path `.venv`
  ```
* Resultado: ignora el que está activo y **crea automáticamente un `.venv` local** en la raíz del repo, instalando ahí las dependencias mínimas (las que tiene en `pyproject.toml` / `uv.lock`).

Asignará a este environment el nombre del directorio dentro del cual está, es decir, el del repositorio:
```bash
$ source /home/ubuntu/code/ml-project-template-gitlab/.venv/bin/activate
(ml-project-template) $ python --version
Python 3.11.13
```
---

💡 Opciones para evitar sorpresas:

1. **Usar `make setup` antes** → así ya existe `.venv` y el warning no aparece.
2. **Forzar a usar el entorno activo** con `uv run --active ...`. Esto le dice a `uv` que respete tu `VIRTUAL_ENV` actual (ej. el `~/venvs/py311`).

---

¿Quieres que te muestre cómo quedaría el `Makefile` si prefieres que **`make test` y `make train` usen tu venv activo** en lugar de crear `.venv` cada vez?


### 6. Target `train`
```makefile
train: ## Entrena ejemplo Iris (árbol de decisión)
	$(UV) run python -m src.app.train
```

* Lanza el script de entrenamiento mínimo (`src/app/train.py`).
* Entrena un árbol de decisión en el dataset Iris.
* Los artefactos (modelo + métricas) se guardan en la carpeta `runs/`.

---
En resumen:

* `make` o `make help` → muestra ayuda.
* `make setup` → prepara entorno.
* `make test` → verifica instalación.
* `make train` → corre ejemplo de ML.

