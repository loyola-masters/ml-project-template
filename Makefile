PY ?= 3.11
UV ?= uv

.DEFAULT_GOAL := help

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## ' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

setup: ## Crea venv 3.11 e instala deps
	$(UV) python install $(PY)
	$(UV) venv --python $(PY) || true
	$(UV) pip install --upgrade pip
	$(UV) sync

test: ## Test de humo
	$(UV) run python -c "import sklearn; import sys; print('OK sklearn', sklearn.__version__); sys.exit(0)"

train: ## Entrena ejemplo Iris (árbol de decisión)
	$(UV) run python -m src.app.train
