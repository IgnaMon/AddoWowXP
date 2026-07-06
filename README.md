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

# LevelPercent — Addon para World of Warcraft

LevelPercent muestra el porcentaje de experiencia de tu personaje con una barra visual y texto. Es ligero, redimensionable y configurable desde comandos dentro del juego.

Características principales

- Barra visual del progreso de nivel.
- Texto con porcentaje y valores de XP.
- Colores según porcentaje: rojo/amarillo/verde.
- Muestra XP restante y estimación (ETA) de subida de nivel.
- Tooltip con detalles (XP actual, restante, XP/h).
- Se puede mover, bloquear y redimensionar.

Novedades (v1.1.0)

- Barra visual de progreso y colores por rango.
- XP restante visible y tooltip con estadísticas de sesión.
- Nuevos comandos para texto y formato de decimales.

Estructura del proyecto

```text
LevelPercent-VSCode/
├─ LevelPercent/                # Código del addon (TOC y Lua)
├─ .vscode/                     # Configuración del espacio de trabajo (opcional)
├─ docs/                        # Documentación (instalación)
├─ scripts/                     # Scripts de empaquetado
├─ .gitignore
├─ LevelPercent.code-workspace   # Workspace para VS Code
└─ README.md
```

Instalación (en el cliente de WoW)

1. Copia la carpeta `LevelPercent` en la carpeta de addons de World of Warcraft:

   - Retail: `World of Warcraft/_retail_/Interface/AddOns/LevelPercent/`
   - Classic: `World of Warcraft/_classic_/Interface/AddOns/LevelPercent/`

2. En la pantalla de selección de personaje activa el addon `LevelPercent`.

3. Si aparece como desactualizado, activa "Load out of date AddOns" o ajusta `## Interface` en `LevelPercent/LevelPercent.toc`.

Uso dentro del juego

- `(/lp show)` — Mostrar el cuadro si está oculto.
- `(/lp hide)` — Ocultar el cuadro.
- `/lp lock` — Bloquear la posición.
- `/lp unlock` — Desbloquear para mover.
- `/lp reset` — Restaurar configuración por defecto.
- `/lp text` — Alternar texto extra.
- `/lp remaining` — Alternar XP restante.
- `/lp decimals <0|1|2>` — Establecer decimales en el porcentaje.

Mover y redimensionar

- Arrastra con clic izquierdo sobre el cuadro para moverlo.
- Usa la esquina inferior derecha para redimensionar.

Empaquetado (crear ZIP para instalar en WoW)

Desde Visual Studio Code puedes ejecutar la tarea `Empaquetar addon ZIP` (o ejecutar manualmente):

```powershell
python scripts/package.py
```

Esto generará `dist/LevelPercent.zip` listo para copiar a la carpeta de addons.

Abrir el proyecto en VS Code

1. Abre `LevelPercent.code-workspace` con Visual Studio Code.
2. Ejecuta la tarea de empaquetado con `Ctrl+Shift+B` o desde el menú de tareas.

Contribuir

- Si quieres contribuir, crea un fork y abre un Pull Request con cambios claros.

Soporte y licencia

- Si encuentras problemas abre un issue en el repositorio.
- Revisa si hay un archivo `LICENSE` para detalles de la licencia.

---

Si quieres, puedo también:

- Añadir una sección de configuración más detallada.
- Traducir mensajes internos del addon.

