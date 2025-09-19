## 3) DagsHub & `dvc` quick start

Objetivo: aprender a usar **DagsHub** para alojar datasets, versionarlos con `dvc` y conectar experimentos de ML.

**1. Instala el cliente de Dagshub**
Primero necesitamos instalar `pip` en Ubuntu/WSL ó Mac. No lo hacemos desde un environment de `uv` porque queremos que el paquete esté disponible globalmente, y no haya que instalarlo localmente en cada entorno.

```bash
sudo apt install python3-pip
pip install dagshub[jupyter]
```
El instalarlo con la extensión `[jupyter]` añade funcionalidades extra en entornos Jupyter/Colab. Algunas de ellas son:

- Permite guardar y cargar notebooks de Jupyter directamente desde y hacia repositorios en Dagshub
- Facilita la interacción con archivos y datos dentro de notebooks, haciendo transparente la sincronización con el repositorio alojado en Dagshub
- Mejora la experiencia de trabajo, integrando comandos y funciones específicas de Dagshub dentro del entorno interactivo de Jupyter o Colab
- Permite que la ejecución y guardado de notebooks quede ligada automáticamente a la plataforma Dagshub

Para más detalles: https://dagshub.com/docs/client/reference/notebook.html

**2. Crear cuenta y repo en DagsHub**

- Ve a [https://dagshub.com](https://dagshub.com) y regístrate (puedes usar tu cuenta de GitHub/GitLab)

- Crea un nuevo repositorio, por ejemplo:
   - `ml-project-data`
   - Visibilidad: `private` si los datos son sensibles.

- Clona, añade README, commit y push a remoto:
```bash
git clone https://dagshub.com/loyola/ml-project-data.git
cd ml-project-data
echo "# ml-project-data" >> README.md
git add README.md
git commit -m "first commit"
git branch -M main
git push -u origin main
```
**NOTA**: Para autenticarte, usa como contraseña el token por defecto, o uno específico que crees para el proyecto. Los tokens se gestionan desde DagsHub en la siguiente ubicación_ `Dashboard > Your settings > Tokens`

### Añadir datasets al registro de `DVC`

```bash
# 1. Setup DVC
pip install dvc

# 2. Desde dentro del repositorio, inicializa dvc
cd ~/code/ml-project-data
dvc init

# 3. Configura el almacenamiento remoto con DVC
dvc remote add origin https://dagshub.com/"YOUR_USER_ID"/"YOUR_REPO_NAME".dvc
dvc remote list # Comprueba

# 4. Configura la autenticación para poder escribir en el remoto
dvc remote modify origin --local auth basic
dvc remote modify origin --local user "YOUR_USER_ID"
dvc remote modify origin --local password "YOUR_TOKEN"

# 5. Añade `iris.csv` al directorio ./data, fichero que va a ser trackeado por dvc

# 6. Crea y añade el directorio './data', que es donde van a estar alojados los datos
#    sometidos a control de configuración con DVC
mkdir -p /code/ml-project-data/data
echo '## Data will be uploaded to this folder' >> data/readme.md
dvc add data/.

# 7. Commit para git, y push para los datos
git add .
git commit -m 'Added dvc'
git push

dvc push -r origin
```

Añadimos otro dataset de ejemplo, `diabetes.csv`y repetimos el proceso:

```bash
dvc add data/diabetes.csv
dvc push -r origin

git add . # Sólo afecta al código, es decir, todo lo que no hemos especificado que trackee dvc
git commit -m 'Added diabetes.csv and track it by dvc'
git push
```

**NOTA:** Así como `dvc push` no nos requiere autenticación (porque ya la añadimos a la configuración del remoto), `git push` sí requiere cada vez usuario y contraseña (token).

### Descargar datasets de DagsHub
Basta con especificar repositorio, ruta dentro del repositorio donde están ubicados los datasets, y ruta local donde queremos que se descarguen (`.` si quieres que se descarguen en la ubicación actual).

```bash
dagshub download loyola/ml-project-data <remote_file_path> <local_file_path>
```
Ejemplo:
```bash
dagshub download loyola/ml-project-data data .
```
Descargará `iris.csv` y ´diabetes.csv`.

Igualmente podemos subir otros datasets, por ejemplo `titanic.csv`:

```bash
dagshub upload loyola/ml-project-data <local_file_path> <remote_file_path>
```
Ejemplo:
```bash
mkdir ~/code/datasets
cd ~/code/datasets
dagshub upload loyola/ml-project-data ./titanic ./data
```
En este caso los datos están divididos en dos datasets, `train.csv` y `test.csv`, por lo que al especificar el directorio donde están alojados, se suben ambos.

**IMPORTANTE**: Fíjate que los datasets no están sometidos a control de configuración con `git`, por lo que el fichero  a subir puede estar en cualquier ubicación, y también puedes descargarlo en cualquier ubicación de tu local.

Finalmente debes hacer `git pull`ya que el fichero `./data/data.dvc` ha sido modificado al hacer el *upload* y Dagshub ha generado automáticamente un commit.
```bash
cd ~/ml-project-data
git pull
```
Es conveniente añadir a `README.md` la referencia al dataset añadido y hacer `git push` al remoto.

## Clonar el repositorio (git + dvc)
Sigue estos pasos para traerte todo el código y datos de un proyecto.
```bash
git clone https://dagshub.com/loyola/ml-project-data.git

dvc remote modify origin --local auth basic
dvc remote modify origin --local user <TU_USUARIO_DAGSHUB>
dvc remote modify origin --local password <TU_TOKEN_PERSONAL>

dvc fetch -r origin -v
dvc status -r origin
dvc pull -r origin -v
```

---

## ANEXO A: S3 storage
El plugin `dvc-s3` para *Dagshub Storage* es compatible con un endpoint S3 que soporta reintentos automáticos para las subidas, lo que mejora la estabilidad en conexiones lentas o intermitentes. Para ello realiza esta configuración alternativa a la básica explicada arriba:
  
  1. Instala el plugin:
     ```bash
     pip install dvc-s3
     ```
  2. Configura el remoto S3 así:
     ```
     dvc remote add origin-s3 s3://dvc
     dvc remote modify origin-s3 endpointurl https://dagshub.com/<user>/<repo>.s3
     dvc remote modify origin-s3 --local access_key_id <Token>
     dvc remote modify origin-s3 --local secret_access_key <Token>
     ```
  3. Para subir los ficheros a trackear usa el comando:
     ```bash
     dvc push -r origin-s3
     ```
  
Este método permite que DVC maneje automáticamente los reintentos en los uploads.

## ANEXO B: Experimentos ML con DVC y comparativa con MLFlow
Ejemplo de pipeline de DVC usando el dataset **Pima Indians Diabetes** y **scikit-learn**. Esto te permitirá verlo funcionar en terminal y también visualizarlo con la extensión DVC en **VS Code**.

📂 **Estructura recomendada del repo**

```
ml-project/
│
├── data/
│   └── diabetes.csv
│
├── src/
│   ├── preprocess.py
│   └── train.py
│
├── params.yaml
├── dvc.yaml
└── requirements.txt
```

**1) Archivo `params.yaml`**

Aquí definimos hiperparámetros que DVC controlará:

```yaml
learning_rate: 0.01
epochs: 50
test_size: 0.2
random_state: 42
```

**2) Script `src/preprocess.py`**

Limpia y divide los datos:

```python
import sys
import pandas as pd
from sklearn.model_selection import train_test_split

if __name__ == "__main__":
    input_file = sys.argv[1]   # data/diabetes.csv
    output_file = sys.argv[2]  # data/processed.csv

    df = pd.read_csv(input_file)

    # Mini limpieza: quita nulos
    df = df.dropna()

    # Divide train/test pero guardamos todo en un CSV para simplificar
    train, test = train_test_split(
        df, test_size=0.2, random_state=42, stratify=df['Outcome']
    )

    processed = pd.concat([train, test])
    processed.to_csv(output_file, index=False)
```

**3) Script `src/train.py`**

Entrena un modelo simple y guarda métricas:

```python
import sys
import pandas as pd
import joblib
import json
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import yaml

if __name__ == "__main__":
    input_file = sys.argv[1]   # data/processed.csv
    model_file = sys.argv[2]   # model.pkl

    # Hiperparámetros
    params = yaml.safe_load(open("params.yaml"))
    test_size = params["test_size"]
    random_state = params["random_state"]

    df = pd.read_csv(input_file)
    X = df.drop("Outcome", axis=1)
    y = df["Outcome"]

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=test_size, random_state=random_state, stratify=y
    )

    model = LogisticRegression(max_iter=1000)
    model.fit(X_train, y_train)

    y_pred = model.predict(X_test)
    acc = accuracy_score(y_test, y_pred)

    # Guarda el modelo
    joblib.dump(model, model_file)

    # Guarda métricas en JSON
    metrics = {"accuracy": acc}
    with open("metrics.json", "w") as f:
        json.dump(metrics, f, indent=4)
```

**4) Definir pipeline con DVC**

```bash
dvc stage add -n preprocess \
  -d src/preprocess.py -d data/diabetes.csv \
  -o data/processed.csv \
  python src/preprocess.py data/diabetes.csv data/processed.csv

dvc stage add -n train \
  -d src/train.py -d data/processed.csv -p learning_rate,epochs,test_size,random_state \
  -o model.pkl -M metrics.json \
  python src/train.py data/processed.csv model.pkl
```

Esto genera un `dvc.yaml` con el grafo `preprocess → train`.

**5) Cómo se ve en VS Code con extensión DVC**

* **Sidebar DVC → Pipelines**: verás un grafo con dos nodos (`preprocess` y `train`).
* **Experiments**: podrás lanzar `dvc exp run -S learning_rate=0.02` y comparar métricas.
* **Params**: muestra automáticamente los valores de `params.yaml`.
* **Metrics**: verás `accuracy` desde `metrics.json`.

**6) Pruebas**

```bash
# Ejecuta pipeline
dvc repro

# Push de datos a remoto DVC
dvc remote add -d origin https://dagshub.com/usuario/repo.dvc
dvc push
```

### Diferencias de DVC con MLFlow
Tanto **DVC** como **MLflow** permiten trackear experimentos de ML, pero lo hacen con enfoques  distintos.

* **DVC**

  * Extiende Git para que datos, modelos y pipelines se versionen igual que el código.
  * Todo gira en torno a ficheros (`params.yaml`, `metrics.json`, datasets, modelos).
  * Muy Git-centrado: cada experimento queda asociado a un commit o a un `dvc exp`.

* **MLflow**

  * Está pensado como plataforma de experiment tracking (UI web).
  * Los experimentos son **runs** almacenados en un backend (archivo, servidor, o servicio en la nube).
  * Se integra fácilmente con notebooks y frameworks (Sklearn, Pytorch, etc.) con 2–3 líneas de logging.

**🔹 2. De qué se hace tracking**

* **DVC**

  * **Parámetros** → `params.yaml`
  * **Métricas** → JSON/YAML/CSV que se definen como outputs de un stage.
  * **Artefactos** → datasets, modelos versionados con Git LFS o DVC remote.
  * Experimentos = ramas/commits con variaciones en params + resultados.

* **MLflow**

  * **Parámetros y métricas** vía `mlflow.log_param()` / `mlflow.log_metric()`.
  * **Artefactos** → cualquier archivo (gráficos, modelos, logs).
  * **Modelo** → guardado en formato estándar MLflow (MLmodel), compatible con “Model Registry”.
  * No gestiona datasets

**🔹 3. Gestión de datos y pipelines**

* **DVC**: fuerte en **pipelines reproducibles** (`dvc.yaml`) → define dependencias y outputs, y permite re-ejecutar solo lo necesario (`dvc repro`).
* **MLflow**: no gestiona pipelines como tal; se integra con herramientas externas (Airflow, Prefect, etc.).

**🔹 4. Visualización y comparación**

* **DVC**:

  * Comparación en terminal (`dvc exp show`, `dvc metrics diff`).
  * Con la extensión VS Code, panel de Experiments.
  * Comparación gráfica básica (`dvc plots`).

* **MLflow**:

  * UI web muy completa: tablas de runs, gráficos interactivos, filtros.
  * Integración con notebooks (`mlflow.search_runs()` para análisis).

**🔹 5. Infraestructura**

* **DVC**:

  * No requiere servidor adicional.
  * Los datos se guardan en el remoto que tú elijas (DagsHub, S3, GDrive, etc.).
  * Experimentos pueden vivir en tu Git repo o en remotos Git.

* **MLflow**:

  * Puede funcionar en local con un simple `mlruns/`, pero lo potente es montar un **MLflow Tracking Server** + backend de BD (MySQL, PostgreSQL, etc.) + storage de artefactos.
  * Integración natural con **Model Registry** (despliegue, staging/production).

**🔹 6. Casos de uso típicos**

* **DVC**
  ✅ Versionado de datos y modelos en proyectos Git
  ✅ Pipelines reproducibles en equipos
  ✅ Integración con repos como GitHub/GitLab/DagsHub

* **MLflow**
  ✅ Experiment tracking a gran escala con UI amigable
  ✅ Registro centralizado de modelos (deployment CI/CD)
  ✅ Integración con frameworks de ML y MLOps pipelines

En resumen:

* **DVC** = control de versiones y pipelines reproducibles centrado en Git.
* **MLflow** = tracking y gestión de experimentos/modelos con servidor y UI rica.

De hecho, se suelen usar los dos a la vez:

* **DVC** para versionar datasets/modelos y pipelines.
* **MLflow** para registrar runs, métricas y comparar resultados en la UI.
