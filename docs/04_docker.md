## 🐳 3) Docker setup & quick start

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
2. **Tu Ubuntu en WSL**

   * Es una distro aparte (ej. `Ubuntu-22.04`).
   * Aquí puedes instalar **otro engine de Docker** usando `apt install docker-ce`.
3. **Posible conflicto**

   * Si instalas Docker *dentro de Ubuntu-WSL* y además usas Docker Desktop, tendrás **dos motores Docker distintos**:

     * `docker` en Ubuntu apunta al daemon de esa distro.
     * `docker` en Windows (via Docker Desktop) apunta al daemon del `docker-desktop`.
   * Esto causa confusión: imágenes, contenedores y redes no son compartidas entre ambos motores.
4. **Recomendación práctica**

   * **Usa Docker Desktop como motor único**. Desde tu Ubuntu-WSL, el cliente `docker` se conecta automáticamente al daemon de Docker Desktop (si tienes habilitada la integración con tu distro en “Settings → Resources → WSL Integration”).
   * Evita instalar `docker-ce` dentro de la misma Ubuntu-WLS si ya usas Docker Desktop, salvo que quieras gestionar un motor independiente.
