## Script `uv-envs.sh`: simulación de conda con uv

Integrado en `.bashrc` como una función (opción recomendada):
```bash
uv-env(){
 # Contenido de uv-envs.sh
}
```

Uso:
```
source ~/.bashrc
uv-env list
uv-env activate py311
```

O como un script separado:
```
source ~/scripts/uv-envs.sh list
source ~/scripts/uv-envs.sh activate py312
```
