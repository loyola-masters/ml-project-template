[Back to `README.md`](../README.md)

## 1. Conectar a WSL

- Instala la extensión `WSL` tal como se aprecia en la siguiente imagen (primera extensión):
  ![1758103915531](image/05_vsc/1758103915531.png)
- En la esquina inferior izquierda verás un pequeño botón `><`. Haz click y se abrirá una nueva ventana de VSC que apunta al entorno Ubuntu de WSL
- Abre la carpeta `/home/ubuntu/code` donde verás el repositorio de la plantilla sobre el que venimos trabajando

> **NOTA**: Trabajar desde VSC es la opción recomendada. Es mucho más cómodo que hacerlo desde la terminal porque tenemos integrado código y terminal, además de todas las utilidades que nos proporcionan las extensiones.

## 2. Extensiones recomendadas

Tenemos dos entornos diferentes de VSC en Windows (en Mac es único, ya que el local es donde trabajamos directamente).
A continuación listamos las extensiones mínimas recomendadas para trabajar de una forma integrada sin necesidad de salir de VSC:

- **WSL**, sólo en el entorno local

- **UV Toolkit**: se trata de una extensión oficial del ecosistema **uv**.
  * Integra en VS Code las funciones principales de `uv`: creación/activación de entornos, instalación de paquetes, ejecución de scripts, gestión de lockfiles.
  * Muestra información contextual sobre el entorno Python usado por el proyecto.
  * Facilita ejecutar comandos `uv` sin salir del editor.

- **Python**: proporciona soporte completo para todas las versiones con soporte activo). Además proporciona puntos de acceso para que otras extensiones se puedan integar y ofrezcan soporte para IntelliSense (Pylance), depuración (Python Debugger), formateo, linting, navegación de código, refactorización, explorador de variables, explorador de tests, gestión de entornos (NUEVA extensión Python Environments).

* **Python Debugger**: extensión que soporta la depuración de Python con debugpy.

* **Python Environments**: entornos de Python.

* **Container tools (Docker)**: herramientas de contenedores (Docker)

* **Jupyter**: Visualización y ejecución interactiva de Jupyter Notebooks

* **Git Graph**: Visualizar los repositorios de Git de tu repositorio, y realizar fácilmente acciones relacionsas.

* **Git History**: Para ver el histórico de modificaciones sobre un fichero dado.

* **DVC**: esta extensión añade integración directa con proyectos que usan `dvc`. Centraliza en Visual Studio Code la gestión de datasets, modelos y experimentos de ML. Estas son sus funcionalidades:

    * **Gestión de datos y modelos**: muestra los ficheros versionados con DVC y su estado respecto al remoto.
    * **Pipelines visuales**: puedes ver, ejecutar y depurar los *stages* definidos en `dvc.yaml` (grafo de dependencias).
    * **Experimentos**: lanzar, comparar y reproducir experimentos sin salir de VSC.
    * **Sincronización remota**: subir y descargar datos/modelos desde tu remoto de DVC (ej. S3, DagsHub, Google Drive).
    * **Paneles en la barra lateral**: acceso a status de DVC, métricas (`dvc metrics`), parámetros (`params.yaml`) y gráficos (`dvc plots`).
