## 3) DagsHub & `git lfs` quick start (datasets & tracking de experimentos)

Objetivo: aprender a usar **DagsHub** para alojar datasets, versionarlos con `git lfs` y conectar experimentos de ML.

---

### 1. Crear cuenta y repo en DagsHub

1. Ve a [https://dagshub.com](https://dagshub.com) y regístrate (puedes usar tu cuenta de GitHub/GitLab).
2. Crea un nuevo repositorio, por ejemplo:
   - `ml-project-data`
   - Visibilidad: `private` si los datos son sensibles.

### 2. Instalar Git LFS en tu sistema

```bash
# Ubuntu / WSL
sudo apt install git-lfs

# macOS
brew install git-lfs

# Inicializar en tu repo
git lfs install
```

### 3. Versionar datasets con Git LFS

1. Entra en el directorio de tu dataset:
   ```bash
   cd ml-project-data
   ```
2. Indica qué tipo de archivos seguir con LFS (ej. CSV, NPZ):
   ```bash
   git lfs track "*.csv"
   git add .gitattributes
   ```
3. Añade y sube tus datos:
   ```bash
   git add data/
   git commit -m "feat: añade dataset inicial"
   git push origin main
   ```

> IMPORTANTE:
>
> * El código reside en Gitlab `ml-project-template`. Por tanto, el remoto `origin` apunta a GitLab.
> * Los datos residen en DagsHub `ml-project-data`. Por tanto, `origin` apunta a DagsHub.

### 4. Conectar repositorio de código con dataset en DagsHub

En el `README.md` de tu proyecto principal añade cómo clonar el repo de datos:

```bash
# Clonar el dataset desde DagsHub
git clone https://dagshub.com/<usuario>/ml-project-data.git
cd ml-project-data
git lfs pull
```

### 5. Tracking de experimentos con MLflow

Cada repo de DagsHub tiene un servidor MLflow integrado.

1. Genera un **token personal** en tu perfil → Settings → Access Tokens.
2. **Configura tu entorno** (`.env` en la raíz del proyecto):
   ```bash
   MLFLOW_TRACKING_URI=https://dagshub.com/<usuario>/<repo>.mlflow
   MLFLOW_TRACKING_USERNAME=<usuario>
   MLFLOW_TRACKING_PASSWORD=<token>
   ```

> En el siguiente punto se explica cómo configurar las variables de entorno.

3. Para conectar tu proyecto con el servidor de experimentos de **DagsHub (MLflow)** necesitas las citadas variables de entorno.

   a. `MLFLOW_TRACKING_USERNAME` es tu nombre de usuario de DagsHub. Puedes encontrarlo en la URL de tu perfil. Ejemplo → `https://dagshub.com/jlopez` → entonces:

   ```bash
   MLFLOW_TRACKING_USERNAME=jlopez
   ```

   b. `MLFLOW_TRACKING_PASSWORD` es un **Personal Access Token** que debes generar:

   - Entra en DagsHub → arriba a la derecha → **Settings**.
   - Menú lateral → **Access Tokens**.
   - Pulsa **Generate New Token**.

   * Nombre: `mlflow_token`
   * Permisos: `write:repo` (lectura/escritura sobre repositorios). Copia el valor generado (empieza por `ghp_...`).

Añádelo a tu fichero `.env` (que está nombrado `.gitignore` para que no sea subido a Git):

```bash
MLFLOW_TRACKING_PASSWORD=ghp_XXXXXXXXXXXXXXXXXXXXX
```

Fichero `.env` completo de ejemplo (alojado en el directorio raíz de la app `./src`):

```bash
MLFLOW_TRACKING_URI=https://dagshub.com/<usuario>/<repo>.mlflow
MLFLOW_TRACKING_USERNAME=jlopez
MLFLOW_TRACKING_PASSWORD=ghp_XXXXXXXXXXXXXXXXXXXXX
```

> **Recuerda**:
>
> * Nunca subas este fichero a Git.
> * Puedes dejar un `.env.example` con las variables vacías para que te sirva de plantilla `.env` local.

3. **Carga estas variables en tu código Python**:
   ```python
   from dotenv import load_dotenv
   import mlflow, os

   load_dotenv()
   mlflow.set_tracking_uri(os.getenv("MLFLOW_TRACKING_URI"))
   ```

Al ejecutar `mlflow.start_run()`, los experimentos quedan registrados en la web de DagsHub.

> En el proyecto de ejemplo que haremos (en el directorio `./hands-on/`) aprenderás cómo hacer el tracking de experimentos.

---

Buenas prácticas:

* Mantén el **código en GitHub/GitLab** y los  **datasets en DagsHub** .
* Usa `git lfs track` para todos los ficheros grandes.
* Documenta en tu README cómo bajar los datos.
* No subas datos sensibles a repos públicos.

---

## Introducción rápida a Git LFS

**Git LFS (Large File Storage)** es una extensión de Git que permite versionar archivos grandes (datasets, imágenes, modelos) sin llenar el repositorio principal.

- **Archivos grandes** (CSV, modelos `.pkl`, imágenes, etc.) se guardan como *punteros* en Git.
- El contenido real se almacena en un servidor compatible (GitHub, GitLab, DagsHub).
- Así, tu repo se mantiene ligero y solo baja los ficheros cuando los necesitas.

Primeros pasos:

1. **Instalar Git LFS**

```bash
# Ubuntu / WSL
sudo apt install git-lfs

# macOS
brew install git-lfs
```

2. **Inicializar en tu sistema y repo**

```bash
git lfs install
```

### Versionar archivos grandes

1. **Indicar qué tipos de archivo seguir con LFS**

```bash
git lfs track "*.csv"
git lfs track "*.npz"
```

Esto crea (o modifica) un archivo `.gitattributes`.

2. **Añadir u modificar ficheros y hacer los commits de la forma habitual**

```bash
git add .gitattributes data/iris.csv
git commit -m "feat: añade dataset con LFS"
git push origin main
```

 **3. Descargar archivos LFS:**

Cuando clones un repo con datos grandes:

```bash
git lfs pull
```

Esto baja el contenido real de los archivos, en lugar de los punteros.

**Comandos útiles:**

```bash
git lfs ls-files        # ver qué archivos están bajo LFS
git lfs track           # mostrar patrones activos
git lfs untrack "*.csv" # dejar de seguir un tipo de archivo
```

**Buenas prácticas:**

* Usa LFS para **datasets, modelos, imágenes** > 10 MB.
* Añade siempre `.gitattributes` al repositorio.
* Evita subir datos sensibles a repos públicos.
* Documenta en tu README: `git lfs pull` tras clonar el repo.
