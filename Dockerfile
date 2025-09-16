# syntax=docker/dockerfile:1.7

# Imagen oficial con Python + uv preinstalado (Debian 12 "bookworm" slim).
# Cambia a python3.12-bookworm-slim si lo necesitáis.
FROM ghcr.io/astral-sh/uv:0.8.17-python3.11-bookworm-slim

# Añadir utilidades de compilación y make
RUN apt-get update && \
    apt-get install -y --no-install-recommends make && \
    rm -rf /var/lib/apt/lists/*

# Opcionales: pequeñas optimizaciones recomendadas por Astral
ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_PREFERENCE=only-managed

# Carpeta de trabajo dentro del contenedor
WORKDIR /workspace

# 1) Copiamos metadatos primero para caché eficiente
COPY pyproject.toml uv.lock* Makefile ./

# 2) Instalamos dependencias (reproducible con el lockfile)
#    Cacheamos el directorio de uv para acelerar builds repetidos
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-cache

# Asegura que el venv de uv quede al frente del PATH
ENV PATH="/workspace/.venv/bin:${PATH}"

# 3) Copiamos el resto del proyecto
COPY ./src .

# (Opcional, buenas prácticas): ejecutar como usuario no root
RUN groupadd -r app && useradd -r -g app -m app && chown -R app:app /workspace
USER app

# Comando por defecto: usa make (setup + test + train)
CMD ["make", "setup", "test", "train"]
