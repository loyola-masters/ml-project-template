# 📦 ML Project Template — MUIA

Plantilla mínima y estable para proyectos de **Machine Learning** con:

- 🐧 **WSL (Ubuntu en Windows)** o **macOS**
- ⚡ **uv** (gestor de Python y paquetes)
- 📜 **Makefile**
- 🌱 Ejemplo reproducible: *árbol de decisión en Iris*

👉 **Objetivo de onboarding**: que cualquier alumno, **desde cero en Windows o Mac**, pueda ejecutar:

```bash
make setup
make test
make train

```

---

## 🚀 0) Instalación inicial

### 🖥️ Windows → WSL + Ubuntu

1. **Activar WSL** (solo una vez)
    
    Abre **PowerShell como administrador** y ejecuta:
    
    ```powershell
    wsl --install -d Ubuntu
    
    ```
    
    Reinicia si lo pide. Al primer arranque, crea usuario/contraseña.
    
2. **Actualizar Ubuntu**
    
    ```bash
    sudo apt update && sudo apt upgrade -y
    
    ```
    
3. **Instalar Git y utilidades**
    
    ```bash
    sudo apt install -y git curl make
    
    ```
    
4. **Configurar Git**
    
    ```bash
    git config --global user.name "Tu Nombre"
    git config --global user.email "tu_email@loyola.es"
    
    ```
    
5. **Configurar SSH con GitHub (recomendado)**
    
    ```bash
    ssh-keygen -t ed25519 -C "tu_email@loyola.es"
    cat ~/.ssh/id_ed25519.pub
    
    ```
    
    Copia la clave pública en → [GitHub → Settings → SSH and GPG keys → New SSH key]
    
    Prueba:
    
    ```bash
    ssh -T git@github.com
    
    ```
    
6. **Instalar uv**
    
    ```bash
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
    uv --version
    
    ```
    

---

### 🍎 macOS (Intel / Apple Silicon)

1. **Instalar Homebrew** (si no lo tienes):
    
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    ```
    
2. **Paquetes base**
    
    ```bash
    brew install git make curl
    
    ```
    
3. **Configurar Git**
    
    ```bash
    git config --global user.name "Tu Nombre"
    git config --global user.email "tu_email@loyola.es"
    
    ```
    
4. **SSH con GitHub (recomendado)**
    
    ```bash
    ssh-keygen -t ed25519 -C "tu_email@loyola.es"
    cat ~/.ssh/id_ed25519.pub
    
    ```
    
    Añádela en GitHub → Settings → SSH and GPG keys.
    
    Si tienes varias claves, crea `~/.ssh/config`:
    
    ```
    Host github.com
      HostName github.com
      User git
      IdentityFile ~/.ssh/id_ed25519
      IdentitiesOnly yes
    
    ```
    
5. **Instalar uv**
    
    ```bash
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
    uv --version
    
    ```
    

---

## 🐍 1) Python por defecto (3.11)

El curso usa **Python 3.11** (máxima compatibilidad).

Instala (si no lo tienes):

```bash
uv python install 3.11

```

> ⚠️ El Makefile ya usa 3.11 por defecto.
> 

---

## 📂 2) Crear tu repositorio desde la plantilla

1. Entra en **ml-project-template** → pulsa **Use this template** → **Create a new repository**.
2. Clona tu repo en `~/code`:
    
    ```bash
    mkdir -p ~/code && cd ~/code
    git clone git@github.com:<tu_org>/<tu_repo>.git
    cd <tu_repo>
    
    ```
    

---

## ⚡ 3) Quickstart del proyecto

```bash
make setup   # crea el entorno 3.11 e instala dependencias
make test    # verificación rápida (scikit-learn)
make train   # entrena DecisionTree en Iris

```

- 📊 Resultados en `runs/AAAAmmdd_HHMMSS/`
    
    (incluye `model.joblib` y `metrics.json`)
    

👉 Si quieres probar rápido: edita `configs/config.yaml` (ej. `max_depth`) y vuelve a ejecutar `make train`.

---

## 🗂️ 4) Estructura mínima del repo

```
.
├── configs/           # configuración (YAML)
├── data/              # datos locales (ignorado en Git)
├── runs/              # artefactos/outputs (ignorado en Git)
├── src/app/train.py   # script de entrenamiento mínimo
├── Makefile           # setup/test/train
├── pyproject.toml     # deps y metadatos (uv/PEP 621)
└── .gitignore

```

✅ Reglas:

- No subas datos pesados (`data/` está en `.gitignore`).
- Commits pequeños; usa ramas `feat/...`, `fix/...`.

---

## 🔄 5) Cambiar de versión de Python (ej. 3.12)

### Opción A (solo para tu entorno)

```bash
uv python install 3.12
make setup PY=3.12

```

### Opción B (proyecto entero → default 3.12)

- En `pyproject.toml`:
    
    ```toml
    requires-python = "==3.12.*"
    
    ```
    
- En `Makefile`:
    
    ```makefile
    PY ?= 3.12
    
    ```
    
- Regenera entorno:
    
    ```bash
    rm -rf .venv
    make setup
    
    ```
    

Para volver: haz lo mismo con 3.11.

---

## ❓ 6) Preguntas frecuentes

- **❌ Permission denied (publickey)**
    
    → Añade tu clave SSH a GitHub y clona por SSH.
    
- **❌ uv: command not found**
    
    → Abre nueva terminal o ejecuta `source ~/.bashrc` / `~/.zshrc`.
    
- **📂 ¿Dónde están mis archivos?**
    
    → Trabaja siempre en `~/code/...` (Linux).
    
    Evita rutas `/mnt/c/...` o iCloud/Dropbox/OneDrive → **pierdes rendimiento y fiabilidad**.
    

---