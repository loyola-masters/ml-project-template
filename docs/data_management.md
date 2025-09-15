# [1] Comparativa de opciones para datasets

| Criterio                         | **Git LFS**                                          | **DagsHub**                                                | **Hugging Face (HF Datasets)**                             |
| -------------------------------- | ---------------------------------------------------------- | ---------------------------------------------------------------- | ---------------------------------------------------------------- |
| **Qué es**                | Extensión de Git para ficheros grandes                    | Plataforma Git + ML stack (repos, data, modelos, experimentos)   | Repositorio abierto para datasets y modelos ML                   |
| **Dónde viven los datos** | En tu mismo repo Git, pero almacenados como punteros LFS   | En repos DagsHub (sobre GitHub/GitLab/Bitbucket + LFS integrado) | En el Hub de Hugging Face (`datasets/tuusuario/...`)           |
| **Tamaño soportado**      | Hasta GBs por fichero, pero depende del plan GitHub/GitLab | Similar a Git LFS (con límites altos en plan free)              | Repos públicos: hasta 50 GB gratis; Enterprise para más        |
| **Integración con ML**    | Ninguna, solo Git                                          | ✅ DVC integrado, MLflow, data lineage, versionado               | ✅ Integración directa con `datasets`de HF y `transformers` |
| **Acceso**                 | Clonado con `git lfs pull`(requiere LFS habilitado)      | HTTP(S), Git LFS, DVC, API de DagsHub                            | HTTP(S),`datasets.load_dataset()`, git clone                   |
| **Versionado de datos**    | Básico (versiones Git)                                    | ✅ Tracking de datos, versiones, lineage                         | ✅ Cada dataset tiene versiones, splits y “revisions”          |
| **Privacidad**             | Respeta privacidad del repo (privado/público)             | Repos privados/públicos, control granular                       | Público por defecto; privado solo con cuenta pro                |
| **Coste**                  | Depende de hosting (GitHub LFS = 1 GB free, luego pago)    | Free tier generosa, planes premium para más                     | Gratis para datasets públicos (hasta 50 GB)                     |
| **Facilidad de uso**       | Muy fácil si ya usas Git                                  | Interfaz clara para ML teams, unifica código+data+experimentos  | Muy simple para comunidad ML, API Python lista                   |
| **Casos ideales**          | Proyectos pequeños o medianos con datos internos          | Equipo ML colaborativo que quiere todo en un mismo sitio         | Difusión pública de datasets para la comunidad ML              |

---

**Git LFS** :

* Pros: Simplicidad (sigues en Git).
* Contras: Muy limitado en **GitHub Free** (1 GB de almacenamiento LFS + 1 GB/mes de transferencia). Tus 8.000 alumnos en grafos → dataset grande → se queda corto enseguida.
* **DagsHub** :
* Pros: Integración brutal para proyectos de ML colaborativos → repos de datos, experiment tracking (MLflow), DVC, visualización. Ideal para  **equipo de investigación** .
* Contras: Menos conocido que HF, requiere que todos los alumnos tengan cuenta.
* **Hugging Face** :
* Pros: Perfecto si quieres **compartir datasets públicos** de sociogramas (estandariza acceso vía `datasets.load_dataset()`). Muy útil si vas a publicar o dar clase y quieres que alumnos lo carguen fácil.
* Contras: Menos práctico si los datos son **sensibles o privados** (sociogramas escolares tienen privacidad alta). Para privado, necesitas plan pago.

---

## 🚦 Recomendación práctica para tu proyecto

1. **Datos sensibles (no públicos)**
   * Usa **DagsHub repo privado** → tienes control, versión, lineage, integración con tus pipelines.
   * Alternativa mínima: **Git LFS privado** en GitHub, pero ojo con cuotas.
2. **Datos públicos (anónimos, listos para compartir con la comunidad)**
   * Usa **Hugging Face Datasets Hub** → alumnos y otros investigadores los cargan con una línea:
     ```python
     from datasets import load_dataset
     ds = load_dataset("tuusuario/sociogramas_escolares")
     ```

---

# [2] Flujo de integración GitHub ↔ DagsHub

La idea es mantener:

* **Código y notebooks** en **GitHub** (repo principal).
* **Datasets** en **DagsHub** (repositorio de datos, versionado y acceso fácil).
* Conexión: los alumnos clonan solo el código y luego tiran del dataset desde DagsHub.

**🔧 Pasos de configuración inicial (profesor/admin)**

1. **Crear cuenta en [DagsHub](https://dagshub.com/)**
   * Puedes loguearte con tu GitHub para sincronizar repos.
2. **Conectar tu repositorio de GitHub**
   * En DagsHub → *Import Repository* → selecciona el repo `ml-project-template`.
   * Esto crea un espejo (código y ramas siguen sincronizados.
3. **Crear un repositorio de datos**
   * En DagsHub puedes tener un repo separado solo para datasets (`ml-project-data`).
   * Sube allí los CSV/JSON/NPZ/etc. de ejemplo.
   * Se versionan con **DVC** o **Git LFS** (DagsHub ya trae ambos integrados).
4. **Configurar acceso**
   * Si los datasets son de clase → repo privado y dar acceso solo a los alumnos.
   * Si son públicos (ejemplo Iris, MNIST) → repo público.

**📂 Estructura del repositorio**

* `github.com/tuproyecto/ml-project-template`
  * `src/`
  * `configs/`
  * `notebooks/`
  * `Makefile`
  * `README.md` (con instrucciones para bajar dataset de DagsHub)
* `dagshub.com/tuproyecto/ml-project-data`
  * `data/raw/...`
  * `data/processed/...`
  * `dvc.yaml` (si usas DVC para versionado)
  * `README.md` (documentando dataset)

---

## 🔗 Cómo consumen los datos los alumnos

**Opción A – vía Git clone (con Git LFS o DVC activado)**

En `README.md` del proyecto pones:

```bash
# Clonar repo de datos con DagsHub (ejemplo con LFS)
git clone https://dagshub.com/<user>/ml-project-data.git
cd ml-project-data
git lfs pull
```

Y luego en el proyecto principal (`ml-project-template`) apuntas a `../ml-project-data/data/...`.

---

**Opción B – vía URL HTTP (sin clonar todo)**

DagsHub expone datos como archivos estáticos vía HTTPS.

Ejemplo en Python:

```python
import pandas as pd

url = "https://dagshub.com/<user>/ml-project-data/raw/main/data/iris.csv"
df = pd.read_csv(url)
```

Esto es muy cómodo para alumnos → no necesitan configurar LFS ni DVC, solo Pandas.

---

**Opción C – vía DVC remote**

Si usas  **DVC** :

1. Añades en el repo de código un `.dvc` que apunte al dataset.
2. Los alumnos hacen:

```bash
dvc pull
```

y obtienen exactamente la versión de datos ligada al commit de código.


---

**📌 Ventajas frente a tener `./data` en GitHub**

* Mantienes el repo de código **ligero** (solo notebooks y scripts).
* Versionas datasets con DVC o LFS sin comerte las cuotas de GitHub.
* Puedes tener **privacidad granular** (repo de código público, datasets privados).
* DagsHub añade capa de **tracking de experimentos** (MLflow integrado), por si más adelante quieres enseñar a los alumnos cómo registrar métricas.

---

# [3] Integración MLflow + DagsHub

MLflow permite:

* **Trackear experimentos** → hiperparámetros, métricas, artefactos (ej. modelos, gráficos).
* **Comparar runs** → ver qué configuración de entrenamiento dio mejores resultados.
* **Guardar modelos reproducibles** .

DagsHub integra **MLflow Tracking Server** directamente:

* Cada repo de DagsHub viene con un endpoint MLflow listo para usar (`https://dagshub.com/<user>/<repo>.mlflow`).
* No necesitas montar tu propio servidor MLflow en local.
* Permite que **todos los alumnos/trabajadores vean los mismos experimentos** desde la interfaz web.

## Pasos de configuración

**a) Crear el repo en DagsHub**

* Tu repo de código (`ml-project-template`) ya puede estar importado desde GitHub a DagsHub.
* Activa la pestaña **Experiments** → DagsHub habilita automáticamente un servidor MLflow.

**b) Autenticación**

Cada usuario necesita un  **token personal de DagsHub** :

1. Ir a  *Profile → Settings → Access Tokens* .
2. Crear token con permisos de `write:repo`.
3. Guardar en variable de entorno (Linux/WSL):

```bash
export MLFLOW_TRACKING_USERNAME=<tu_usuario>
export MLFLOW_TRACKING_PASSWORD=<tu_token>
```

**c) Configurar** `MLFLOW_TRACKING_URI`

En el entorno del proyecto (puede ir en `Makefile` o en `.env`):

```bash
export MLFLOW_TRACKING_URI=https://dagshub.com/<user>/<repo>.mlflow
```

 Las variables `MLFLOW_TRACKING_USERNAME `y `MLFLOW_TRACKING_PASSWORD `son las credenciales que permiten a tus alumnos (o a ti)  **autenticarse en el servidor MLflow que expone DagsHub** .

Para crearlas:

1. **En tu cuenta de DagsHub**
   * Ve a tu perfil →  **Settings → Access Tokens** .
   * Crea un **Personal Access Token** con permisos de lectura/escritura sobre repos.
   * Ese token servirá como `MLFLOW_TRACKING_PASSWORD`.
2. **Asignación de las variables**
   * `MLFLOW_TRACKING_USERNAME` → tu **usuario de DagsHub** (ejemplo: `dcanales-lu`).
   * `MLFLOW_TRACKING_PASSWORD` → el **token generado** en el paso anterior.

Incluirlas en el fichero `.env` en la raíz del repo:

```bash
MLFLOW_TRACKING_URI=https://dagshub.com/<usuario>/<repo>.mlflow
MLFLOW_TRACKING_USERNAME=<usuario_dagshub>
MLFLOW_TRACKING_PASSWORD=<token_personal>
```

Ejemplo:

```bash
MLFLOW_TRACKING_URI=https://dagshub.com/dcanales-lu/ml-project-template.mlflow
MLFLOW_TRACKING_USERNAME=dcanales-lu
MLFLOW_TRACKING_PASSWORD=ghp_XXXXXXXXXXXXXXXXXXXXX
```

**Cómo se usan en el código**. Con `python-dotenv`:

```python

```

Cuando ejecutes un `mlflow.start_run()`, quedará registrado directamente en el servidor de DagsHub.

**Código de ejemplo en** `src/app/train_mlflow.py`

---

**Flujo para los alumnos**

1. Clonan tu repo de GitHub.
2. Configuran `.env` con `MLFLOW_TRACKING_URI`, `MLFLOW_TRACKING_USERNAME`, `MLFLOW_TRACKING_PASSWORD`.
3. Ejecutar experimentos con diferentes configs.  `make train`.

* El run aparece en **DagsHub → Experiments** con:
  * Parámetros (`max_depth`)
  * Métricas (`accuracy`)
  * Artefactos (modelo serializado, plots, logs).

DagsHub genera tablas y gráficas comparativas entre runs automáticamente. Los resultados consolidados en la web de DagsHub, sin instalar nada más.

---

## ¿Dónde va alojado `.env`?

* Debe estar en la  **raíz del proyecto** , junto a `pyproject.toml`, `Makefile`, etc.:
  ```
  ml-project-template/
  ├── .env
  ├── Makefile
  ├── pyproject.toml
  ├── src/
  ├── configs/
  └── ...
  ```
* Se añade a  **`.gitignore`** , para que **no se suba nunca a GitHub/DagsHub** (evitamos exponer tokens).
* Puedes dejar un fichero de ejemplo (`.env.example`) en el repo con variables vacías para que los alumnos lo copien:
  ```bash
  MLFLOW_TRACKING_URI=https://dagshub.com/<user>/<repo>.mlflow
  MLFLOW_TRACKING_USERNAME=
  MLFLOW_TRACKING_PASSWORD=
  ```

---

## ¿Cómo se cargan las variables de `.env`?

1. **Desde Python (recomendado para tu plantilla)**

Usa la librería [`python-dotenv`](https://pypi.org/project/python-dotenv/):

```python
from dotenv import load_dotenv
import os

# Cargar automáticamente el .env desde la raíz
load_dotenv()

mlflow_uri = os.getenv("MLFLOW_TRACKING_URI")
mlflow_user = os.getenv("MLFLOW_TRACKING_USERNAME")
mlflow_pass = os.getenv("MLFLOW_TRACKING_PASSWORD")
```

---

2. **Desde la shell (alternativa manual)**

En Linux/WSL/Mac:

```bash
export $(grep -v '^#' .env | xargs)
```

En PowerShell (Windows):

```powershell
Get-Content .env | ForEach-Object {
  if ($_ -match "^(.*)=(.*)$") {
    Set-Item -Path Env:$($matches[1]) -Value $matches[2]
  }
}
```

Esto carga todas las variables del `.env` en el entorno actual.


---

**📌 Resumen de buenas prácticas en tu plantilla**

1. En la raíz: `.env` (privado) y `.env.example` (público).
2. Añadir a `.gitignore`:
   ```
   .env
   ```
3. En `train.py`, llamar siempre a `load_dotenv()` antes de usar `os.getenv()`.
4. Documentar en el `README.md` → "Copia `.env.example` a `.env` y rellena tus credenciales".
