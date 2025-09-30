[Back to `README.md`](../README.md)

## Tabla de equivalencias entre **uv** y **conda**

| Tarea                       | `uv`                                                                                                   | `conda`                                 |
| --------------------------- | -------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| Crear un entorno nuevo      | `uv venv myenv` (o `uv venv <ruta>`)<br />Environment se crea en `./env` si no se especifica ruta | `conda create -n myenv python=3.11`     |
| Activar entorno             | `source ./myenv/bin/activate` (Linux/macOS) `<br>` `.\myvenv\Scripts\activate` (Windows)           | `conda activate myenv`                  |
| Desactivar entorno             | `deactivate`           | `conda deactivate`                  |
| Instalar paquete            | `uv add numpy`                                                                                         | `conda install numpy`                   |
| Instalar desde requirements | `uv pip install -r requirements.txt`                                                                   | `conda install --file requirements.txt` |
| Eliminar paquete            | `uv remove numpy`                                                                                      | `conda remove numpy`                    |
| Listar paquetes instalados  | `uv pip list`                                                                                          | `conda list`                            |
| Exportar dependencias       | `uv pip freeze > requirements.txt`                                                                     | `conda env export > env.yml`            |
| Reinstalar desde lockfile   | `uv sync`                                                                                              | `conda env create -f env.yml`           |
| Actualizar paquete          | `uv add --upgrade numpy`                                                                               | `conda update numpy`                    |
| Borrar entorno              | borrar la carpeta `.venv`                                                                              | `conda env remove -n myenv`             |

🔑 Diferencias clave:

* `uv` gestiona **virtualenvs** (como `venv` o `pip`), no entornos complejos con C/C++ libs como conda.
* Usa `uv add` en vez de `pip install`.
* No hay un “gestor central de entornos” como `conda env list`, cada venv es una carpeta.

**TIP:** Agrupa todos los envs bajo el directorio `~/envs`

Cómo usar:

```bash
uv venv ~/venvs/py311
source ~/venvs/py311/bin/activate
```

## Script para usar `uv` como equivalencias de `conda`

1. Script localizado en `./scripts/uv-envs.sh`. Consulta su [README](../scripts/README.md).
2. Dale permisos de ejecución:

   ```bash
   chmod +x ~/scripts/uv-envs.sh
   ```
3. **Opción 1 (recomendada)**: añádelo a tu `~/.bashrc` como función, para invocarlo directamente como si fuera un comando:

```bash
uv-env(){
 # Contenido de uv-envs.sh
}
```

>**IMPORTANTE**: Este script gestiona los environments ubicados en `~/envs/`. Los que crees en otras localizaciones de tu **home** no serán detectados. 

Uso:

```
source ~/.bashrc
uv-env list
uv-env activate py311
```

- **Opción 2**: Como un script separado `uv-envs.sh` (ver `README.md` en directorio `./scripts`del repositorio):

```
source ~/scripts/uv-envs.sh list
source ~/scripts/uv-envs.sh activate py312
```
