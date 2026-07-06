<<<<<<< HEAD
# AddoWowXP
Addon para ver experiencia en WOW
=======
# LevelPercent - Proyecto para Visual Studio Code

Addon para World of Warcraft que muestra tu avance de nivel con porcentaje y barra visual.

## Novedades versión 1.1.0

- Barra visual de progreso.
- Colores según porcentaje:
  - Rojo: menos de 35%.
  - Amarillo: entre 35% y 70%.
  - Verde: sobre 70%.
- XP restante visible.
- Tooltip con XP actual, XP restante, XP/h de la sesión y ETA estimada.
- Redimensionable desde la esquina inferior derecha.
- Comandos nuevos para texto, XP restante y decimales.

## Estructura del proyecto

# LevelPercent - Proyecto para Visual Studio Code

Addon para World of Warcraft que muestra tu avance de nivel con porcentaje y barra visual.

## Novedades versión 1.1.0

- Barra visual de progreso.
- Colores según porcentaje:
  - Rojo: menos de 35%.
  - Amarillo: entre 35% y 70%.
  - Verde: sobre 70%.
- XP restante visible.
- Tooltip con XP actual, XP restante, XP/h de la sesión y ETA estimada.
- Redimensionable desde la esquina inferior derecha.
- Comandos nuevos para texto, XP restante y decimales.

## Estructura del proyecto

```text
LevelPercent-VSCode/
├─ LevelPercent/
│  ├─ LevelPercent.toc
│  └─ LevelPercent.lua
├─ .vscode/
│  ├─ extensions.json
│  ├─ settings.json
│  └─ tasks.json
├─ docs/
│  └─ instalacion.md
├─ scripts/
│  └─ package.py
├─ .gitignore
├─ LevelPercent.code-workspace
└─ README.md
```

## Cómo abrirlo en Visual Studio Code

1. Descomprime este proyecto.
2. Abre Visual Studio Code.
3. Usa **File > Open Workspace from File...**.
4. Selecciona `LevelPercent.code-workspace`.

## Instalación en WoW

Copia la carpeta `LevelPercent` a una de estas rutas:

- Retail: `World of Warcraft/_retail_/Interface/AddOns/`
- Classic: `World of Warcraft/_classic_/Interface/AddOns/`

Después activa el addon desde la pantalla de personajes.

## Empaquetar el addon

En VS Code puedes ejecutar:

- **Terminal > Run Build Task**
- O presionar `Ctrl+Shift+B`

Esto ejecuta `scripts/package.py` y crea:

```text
dist/LevelPercent.zip
```

## Comandos dentro del juego

```text
/lp show
/lp hide
/lp lock
/lp unlock
/lp reset
/lp text
/lp remaining
/lp decimals 0
/lp decimals 1
/lp decimals 2
```

También acepta:

```text
/lp mostrar
/lp ocultar
/lp bloquear
/lp desbloquear
/lp reiniciar
```
