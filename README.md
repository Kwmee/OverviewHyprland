# hypr-overview

Overview estilo macOS Mission Control para Hyprland 0.55+ usando Quickshell.

## Estructura

```
hypr-overview/
├── shell.qml              # Raíz: PanelWindow overlay, animaciones de entrada/salida
├── shell.json             # Config Quickshell (IPC socket)
├── OverviewState.qml      # Singleton: estado visible/oculto
├── WindowGrid.qml         # Rejilla adaptativa de ventanas del workspace activo
├── WindowPreview.qml      # Tarjeta individual con captura real via Screencopy
├── WorkspaceBar.qml       # Barra superior con miniaturas de workspaces
├── WorkspaceThumbnail.qml # Miniatura individual de workspace
├── shaders/
│   └── rounded.frag       # Shader GLSL para esquinas redondeadas en previews
├── launch.sh              # Script: lanza o hace toggle del overview via IPC
└── hyprland_bind_snippet.lua  # Fragmento para tu hyprland.lua
```

## Dependencias

- `quickshell` (AUR: `quickshell-git`)
- `socat` (para el toggle IPC desde el keybind)

```bash
# Arch / Hyprland
yay -S quickshell-git socat
```

## Compilar el shader

Quickshell necesita el shader en formato `.qsb`. Con `qsb` (parte de `qt6-shader-tools`):

```bash
cd shaders
qsb --glsl 440 --batchable -o rounded.frag.qsb rounded.frag
```

## Lanzar manualmente

```bash
./launch.sh
```

## Integrar con Hyprland

Copia el contenido de `hyprland_bind_snippet.lua` a tu `~/.config/hypr/hyprland.lua`.

La ruta del script se resuelve automaticamente con `$HOME`.

## Keybinds dentro del overview

| Tecla     | Accion                          |
|-----------|---------------------------------|
| `Escape`  | Cerrar el overview              |
| Click     | Ir a esa ventana                |
| `×`       | Cerrar la ventana (hover)       |
| Click WS  | Cambiar a ese workspace         |
