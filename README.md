# ML Project Template — MUIA (WSL + uv, Python 3.11)

Plantilla mínima y estable para proyectos de ML con **WSL (Ubuntu)**, **uv**, **Makefile** y un ejemplo reproducible (árbol de decisión en Iris).

> Objetivo de onboarding: que cualquier alumno, desde cero en Windows, pueda ejecutar:
> 
> 
> ```bash
> make setup
> make test
> make train
> 
> ```
> 

---

## 0) Instalación desde cero (Windows → WSL → Ubuntu)

1. **Activar WSL (una sola vez)**
    - Abre **PowerShell** como administrador y ejecuta:
        
        ```powershell
        wsl --install -d Ubuntu
        
        ```
        
    - Reinicia si te lo pide. Al primer arranque pon **usuario/contraseña** de Ubuntu.
2. **Actualizar Ubuntu (en WSL)**
    - Abre **Ubuntu** (app) o terminal de **VS Code** con Ubuntu y ejecuta:
        
        ```bash
        sudo apt update && sudo apt upgrade -y
        
        ```
        
3. **Instalar Git y utilidades**
    
    ```bash
    sudo apt install -y git curl make
    
    ```
    
4. **Configurar Git (nombre y correo)**
    
    ```bash
    git config --global user.name "Tu Nombre"
    git config --global user.email "tu_email@loyola.es"
    
    ```
    
5. **Configurar SSH con GitHub (recomendado)**
    
    ```bash
    ssh-keygen -t ed25519 -C "tu_email@loyola.es"
    cat ~/.ssh/id_ed25519.pub
    
    ```
    
    - Copia la clave pública y añádela en **GitHub → Settings → SSH and GPG keys → New SSH key**.
    - Prueba:
        
        ```bash
        ssh -T git@github.com
        
        ```
        
6. **Instalar `uv` (gestor de Python/paquetes)**
    
    ```bash
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
    uv --version
    
    ```
    

---

## 1) Python por defecto (3.11)

Usamos **Python 3.11** para máxima compatibilidad.

- Instálalo (si no está ya):
    
    ```bash
    uv python install 3.11
    
    ```
    
- (El Makefile del template ya crea el entorno con 3.11.)

---

## 2) Crear tu repositorio desde la plantilla

1. En GitHub, entra a `ml-project-template` y pulsa **Use this template → Create a new repository**.
2. Clona **tu** repo (vía SSH) en WSL:
    
    ```bash
    mkdir -p ~/code && cd ~/code
    git clone git@github.com:<tu_org>/<tu_repo>.git
    cd <tu_repo>
    
    ```
    

---

## 3) Quickstart del proyecto

```bash
# crea el entorno 3.11, instala deps y deja todo listo
make setup

# verificación rápida de scikit-learn
make test

# entrenamiento mínimo (iris + DecisionTree)
make train

# artefactos (modelo y métricas) en runs/AAAAmmdd_HHMMSS/

```

Si quieres tocar algo de inmediato, edita `configs/config.yaml` (por ejemplo `max_depth`) y repite `make train`.

---

## 4) Estructura mínima

```
.
├── configs/           # configuración (YAML)
├── data/              # datos locales (ignorado en Git)
├── runs/              # salidas/artefactos (ignorado en Git)
├── src/app/train.py   # script de entrenamiento mínimo
├── Makefile           # setup/test/train
├── pyproject.toml     # deps y metadatos (uv/PEP 621)
└── .gitignore

```

**Reglas básicas**

- No subas datos pesados: `data/` está en `.gitignore`.
- Commits y PRs pequeños; ramas `feat/...`, `fix/...`.

---

## 5) Cómo pasar a Python 3.12 (o la más reciente)

Si en algún momento quieres cambiar de versión **en tu repo**:

**Opción A (puntual, sin tocar archivos)**

```bash
uv python install 3.12
make setup PY=3.12

```

**Opción B (cambiar el proyecto para usar 3.12 por defecto)**

1. Edita `pyproject.toml`:
    
    ```toml
    requires-python = "==3.12.*"   # o ">=3.12" si quieres permitir versiones futuras
    
    ```
    
2. En `Makefile`, cambia la línea superior:
    
    ```
    PY ?= 3.12
    
    ```
    
3. Regenera el entorno:
    
    ```bash
    rm -rf .venv
    make setup
    
    ```
    

> Nota: Para volver a 3.11, invierte los pasos (3.11 en requires-python, PY ?= 3.11, make setup).
> 

---

## 6) Preguntas frecuentes (WSL)

- **`Permission denied (publickey)` al clonar**
    
    → Asegúrate de haber añadido tu clave pública a GitHub y de clonar por **SSH**, no por HTTPS.
    
- **`uv: command not found`**
    
    → Abre una nueva terminal o ejecuta `source ~/.bashrc`. Verifica `echo $PATH` contiene `$HOME/.local/bin`.
    
- **¿Dónde están mis archivos?**
    
    → Trabaja en `~/code/...` (Linux). Evita rutas de Windows (`/mnt/c/...`) para no perder rendimiento.