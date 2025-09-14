Tabla de equivalencias entre **uv** y **conda**:

| Tarea                       | `uv`                                                                              | `conda`                                 |
| --------------------------- | --------------------------------------------------------------------------------- | --------------------------------------- |
| Crear un entorno nuevo      | `uv venv .venv` (o `uv venv <ruta>`)                                              | `conda create -n myenv python=3.11`     |
| Activar entorno             | `source .venv/bin/activate` (Linux/macOS) <br> `.venv\Scripts\activate` (Windows) | `conda activate myenv`                  |
| Instalar paquete            | `uv add numpy`                                                                    | `conda install numpy`                   |
| Instalar desde requirements | `uv pip install -r requirements.txt`                                              | `conda install --file requirements.txt` |
| Eliminar paquete            | `uv remove numpy`                                                                 | `conda remove numpy`                    |
| Listar paquetes instalados  | `uv pip list`                                                                     | `conda list`                            |
| Exportar dependencias       | `uv pip freeze > requirements.txt`                                                | `conda env export > env.yml`            |
| Reinstalar desde lockfile   | `uv sync`                                                                         | `conda env create -f env.yml`           |
| Actualizar paquete          | `uv add --upgrade numpy`                                                          | `conda update numpy`                    |
| Borrar entorno              | borrar la carpeta `.venv`                                                         | `conda env remove -n myenv`             |

🔑 Diferencias clave:

* `uv` gestiona **virtualenvs** (como `venv` o `pip`), no entornos complejos con C/C++ libs como conda.
* Usa `uv add` en vez de `pip install`.
* No hay un “gestor central de entornos” como `conda env list`, cada venv es una carpeta.

**TIP:**Agrupa todos los envs bajo el directorio `~/envs`

Cómo usar:
```bash
uv venv ~/venvs/py311
source ~/venvs/py311/bin/activate
```

---


### Script para usar `uv` como equivalencias de `conda`

1. Guarda este script como `uv-envs.sh`
    - Previamente crea el directorio `~/scripts` para alojar aquí todos tus scripts

2. Dale permisos:
   ```bash
   chmod +x ~/scripts/uv-envs.sh
   ```

3. Úsalo como si fuera `conda`:
```bash
uv-env list
```

---
Añádelo a tu `~/.bashrc` como función, para invocarlo directamente como si fuera un comando:

```bash
function uv-env() {
    bash ~/uv-envs.sh "$@"
}
```

y luego:

```bash
uv-env list
```
