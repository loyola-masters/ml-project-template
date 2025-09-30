[Back to `README.md`](../README.md)

## 🐳 4) Docker setup & quick start

Docker permite empaquetar el entorno de desarrollo y ejecución en **contenedores reproducibles**.
Así, todos los alumnos ejecutan el proyecto con las **mismas versiones** de Python, librerías y dependencias, sin problemas de instalación local.

### 📦 Instalación de Docker

#### Windows (con WSL2)

1. Instalar **Docker Desktop** desde: [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
2. Durante la instalación, activar la opción **“Use WSL 2 based engine”**.
3. Al terminar, reinicia el sistema y comprueba:
   ```powershell
   docker --version
   docker run hello-world
   ```

Si ves el mensaje *Hello from Docker!*, todo está correcto.

#### macOS

1. Descarga **Docker Desktop for Mac** (Intel o Apple Silicon) en el mismo enlace.
2. Instálalo y arranca la app Docker Desktop.
3. Comprueba en terminal:

   ```bash
   docker --version
   docker run hello-world
   ```

#### IMPORTANTE: Instalación en Windows vs. Ubuntu WSL

1. **Docker Desktop en Windows**

   * Instala su propio motor de Docker, pero **lo hace sobre WSL2** (ya no sobre Hyper-V como antes).
   * Por eso durante la instalación aparece “Use the WSL2 based engine”.
   * Crea una distro interna llamada `docker-desktop` en WSL para gestionar contenedores.
   
   Este modo de instalación permite tener disponible Docker tanto en Windows como en WSL. 

2. **Sólo para Ubuntu en WSL**

   * WSL es una distro aparte (ej. `Ubuntu-22.04`).
   * Aquí puedes instalar **otro engine de Docker** usando `apt install docker-ce`.
3. **Posible conflicto**

   * Si instalas Docker *dentro de Ubuntu-WSL* y además usas Docker Desktop, tendrás **dos motores Docker distintos**:

     * `docker` en Ubuntu apunta al daemon de esa distro.
     * `docker` en Windows (via Docker Desktop) apunta al daemon del `docker-desktop`.
   * Esto causa confusión: imágenes, contenedores y redes no son compartidas entre ambos motores.
4. **Recomendación**

   Usa Docker Desktop como motor único. Desde tu Ubuntu-WSL, el cliente `docker` se conecta automáticamente al daemon de Docker Desktop (si tienes habilitada la integración con tu distro en “Settings → Resources → WSL Integration”).

---

### Hands On: Quickstart del proyecto con Docker

1. En la raíz del repo tienes un `Dockerfile` mínimo. Construye la imagen:

   ```bash
   docker build -t ml-template .
   ```
2. Lanza un contenedor interactivo:

   ```bash
   docker run -it --rm -v $(pwd):/workspace ml-template bash
   ```

   * `-v $(pwd):/workspace` monta tu carpeta local dentro del contenedor.
   * Así puedes editar código en tu editor y ejecutarlo dentro de Docker.
   * `--rm` elimina el contenedor al salir de él
3. Ejecutar el flujo de ejemplo (Iris):

   ```bash
   make setup
   make test
   make train
   ```

Cuando ejecutes `make setup` el terminal te avisará de que el environment de `uv` ya existe. Responde `yes` para sobreescribirlo con el setup de tu proyecto. Tras la ejecución, los artefactos (`runs/...`) quedarán en tu carpeta local, accesibles fuera del contenedor.

**TIP**: Sin `bash` ejecuta el comando por defecto en `Dockerfile`, i.e. `CMD ["make", "setup", "test", "train"]`:

```bash
   docker run -it --rm -v $(pwd):/workspace ml-template
```

#### Verificación

* `docker ps` → lista contenedores activos.
* `docker images` → lista imágenes locales.
* Comprueba que tras `make train` se genera un directorio `runs/AAAAmmdd_HHMMSS/` con modelo y métricas.

> Tips
>
> * Para liberar espacio: `docker system prune -a`

---

### ANEXO: **Instalación GPU (Ubuntu / WSL2)**

* Si trabajas con **GPU (NVIDIA)**: instala también `nvidia-docker2` y añade flag `--gpus all` al `docker run`:
  * `nvidia-docker2` es un **complemento para Docker** que permite que los contenedores accedan a la **GPU NVIDIA** instalada en tu equipo.
  * Internamente usa el *NVIDIA Container Toolkit*, que conecta los drivers de tu máquina con el contenedor.
  * Así, puedes entrenar modelos en GPU dentro de Docker sin tener que instalar CUDA/cuDNN manualmente en la imagen.

- Para Ubuntu:

1. Añadir el repositorio oficial:

   ```bash
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
   curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
   curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
   ```
2. Instalar paquete:

   ```bash
   sudo apt update
   sudo apt install -y nvidia-docker2
   ```
3. Reiniciar Docker:

   ```bash
   sudo systemctl restart docker
   ```

- Para WSL:
  *(En Windows con WSL2, basta con instalar los drivers NVIDIA + Docker Desktop con soporte WSL2 y marcar la opción GPU en settings.)*

---

Una vez instalado el toolkit, construye la nueva imagen:

```bash
docker build -t ml-template-gpu -f Dockerfile_gpu
```
El fichero para construir la imagen es `Dockerfile_gpu`, junto con CUDA se instala Pytorch, para la versión 12.4 de CUDA
Al ejecutar un contenedor solo necesitas añadir la opción `--gpus all`, que expone todas las GPUs disponibles.

**✅ Verificación dentro del contenedor**: Entra y ejecuta:

```bash
# En el host
docker run -it --rm --gpus all ml-template-gpu bash

# Y ya dentro del contenedor
nvidia-smi
```

Comprueba la información de la tarjeta gráfica.

Puedes limitar, por ejemplo, a la GPU 0:

```bash
docker run -it --rm --gpus '"device=0"' ml-template-uv bash
```

**Ejecución del proyecto:**

```bash
docker run -it --rm --gpus all ml-template-gpu
```
