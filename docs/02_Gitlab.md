## 2) GitLab & `git` quick start

Objetivo: configurar rápidamente Git en tu equipo y empezar a versionar tu proyecto en **GitLab**.

### 1. Crear cuenta y repo en GitLab

1. Ve a [https://gitlab.com](https://gitlab.com) y crea tu cuenta (puedes usar tu correo académico).
2. Crea un repositorio nuevo:
   - Nombre: `ml-project-template`
   - Visibilidad: `private` (recomendado para clase)
   - Marca la opción *Initialize repository with a README* (opcional).

### 2. Configurar Git en tu equipo

Esta parte ya se presentó en la primera parte de la guía. Impleméntala si no lo hiciste entonces

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu_email@loyola.es"
git config --list
```

### 3. Configurar clave SSH con GitLab

Esta parte se presentó en la primera parte de la guía para Github.
Como durante el máster trabajaremos con Gitlab, crea otra clave y añádela a tu Gitlab.

```bash
# Crear par de claves SSH con nombre personalizado
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_gitlab -C "tu_email@loyola.es"

# Mostrar la clave pública
cat ~/.ssh/id_ed25519_gitlab.pub
```

Copia la clave pública en → GitLab → **Preferences → SSH Keys → Add key**
Puedes ver que damos un nombre específico a la nueva clave `id_ed25519_gitlab`

Prueba la conexión:

```bash
ssh -T git@gitlab.com
```

Si es correcto verás:

```
Welcome to GitLab, @tuusuario!
```

   Edita el fichero `~/.ssh/config` para añadir el nuevo host:

```
   Host github.com
       HostName github.com
       User git
       IdentityFile ~/.ssh/id_ed25519
       IdentitiesOnly yes

   Host gitlab.com
       HostName gitlab.com
       User git
       IdentityFile ~/.ssh/id_ed25519_gitlab
       IdentitiesOnly yes
```

   Y comprueba la conexión con ambos hosts:

```bash
   ssh -T git@github.com
   ssh -T git@gitlab.com
```

### 4. Clona tus repositorio en Gitlab

Recuerda que **ml-project-template** está alojado en Github.
En este caso, la clonación corresponde a próximos repositorios que vayas creando.

```bash
mkdir -p ~/code && cd ~/code
git clone git@gitlab.com:<tu_usuario>/<tu_repo>.git
cd <tu_repo>
```

`feat` se refiere al nombre de la rama donde estás trabajando, si es diferente de la principal `main`

### 5. Flujo básico de trabajo con Git

```bash
# Ver estado
git status

# Añadir cambios
git add <archivo>      # o . para todos

# Commit con mensaje claro
git commit -m "feat: añade script de preprocesado"

# Subir a GitLab
git push origin main
```

---

### Introducción rápida a Git

Git es un sistema de **control de versiones distribuido**. Permite guardar el historial de cambios de tu código, trabajar en paralelo y colaborar con otros de forma ordenada.

Conceptos básicos:

- **Repositorio (repo)**: carpeta con tu proyecto + historial de cambios.
- **Commit**: un “snapshot” del estado del proyecto en un momento dado.
- **Branch (rama)**: línea de trabajo independiente (ej. `main`, `develop`, `feat/...`).
- **Remote**: copia del repositorio alojada en un servidor (ej. GitLab/GitHub).

Primeros pasos:

1. **Crear un repositorio local**

```bash
cd ~/code
mkdir -p nuevo_proyecto
cd nuevo_proyecto
git init
```

Esto crea la carpeta `.git` con el historial en el que se registrará todo el trabajo que vayas haciendo sobre el código.

2. **Clonar un repositorio existente**

```bash
git clone git@gitlab.com:usuario/repositorio.git
```

3. **Ver estado de tus archivos**

```bash
git status
```

#### Añadir y guardar cambios

1. **Añadir archivos al área de preparación (staging area):**

```bash
git add archivo.txt       # un archivo
git add .                 # todos los archivos modificados
```

2. **Guardar cambios con un commit:**

```bash
git commit -m "feat: añade script de preprocesado"
```

#### Ramas

1. **Crear y cambiar a una nueva rama**

```bash
git checkout -b feat/nueva-funcionalidad
```

2. **Volver a la rama principal**

```bash
git checkout main
```

3. **Listar ramas**

```bash
git branch
```

#### Trabajar con repos remotos

1. **Vincular tu repositorio a un remoto**

```bash
git remote add origin git@gitlab.com:usuario/repositorio.git
```

2. **Subir cambios**

```bash
git push origin main
```

3. **Bajar cambios del remoto**

```bash
git pull origin main
```

En esta URL [git - guía sencilla](https://rogerdudler.github.io/git-guide/index.es.html) , puedes seguir el tutorial de git de manera visual.
