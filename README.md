# hypr-overview

A macOS Mission Control-style overview for Hyprland 0.55+ built with Quickshell.

![version](https://img.shields.io/badge/version-0.1.1-blue)
![hyprland](https://img.shields.io/badge/Hyprland-0.55%2B-cyan)
![quickshell](https://img.shields.io/badge/Quickshell-0.3.0%2B-purple)

## Features

- Live window previews via Wayland screencopy protocol
- Workspace bar — click to filter windows by workspace
- Multi-monitor support (each monitor shows its own overview)
- IPC toggle — no new processes spawned on each keypress
- Window focus using native Wayland `activate()`

## Requirements

- Hyprland 0.55+ with **Lua config** (`~/.config/hypr/hyprland.lua`)
- Quickshell 0.3.0+

## Installation

### 1. Install Quickshell

```bash
# Arch Linux (AUR)
yay -S quickshell-git
```

### 2. Clone the repo

```bash
git clone https://github.com/Kwmee/OverviewHyprland.git ~/Documentos/Proyectos/hypr-overview
```

> Change the path to wherever you want to keep it. Just update the path in the Hyprland config accordingly.

### 3. Add to your Hyprland Lua config

Add the following to `~/.config/hypr/hyprland.lua`:

```lua
local overview_dir = os.getenv("HOME") .. "/Documentos/Proyectos/hypr-overview"

-- Start once on login
hl.on("hyprland.start", function()
    hl.exec_cmd("quickshell -p " .. overview_dir)
end)

-- SUPER+TAB to toggle (no new processes spawned)
hl.bind(mainMod .. " + TAB",
    hl.dsp.exec_cmd("quickshell ipc -p " .. overview_dir .. " call overview toggle"))
```

> If you cloned to a different path, update `overview_dir` accordingly.

### 4. Reload Hyprland

```bash
hyprctl reload
```

The overview will start automatically on your next login. To start it immediately without rebooting:

```bash
quickshell -p ~/Documentos/Proyectos/hypr-overview &
```

## Usage

| Action | Result |
|--------|--------|
| `SUPER + TAB` | Toggle overview |
| Click a workspace (top bar) | Filter windows to that workspace. Click again to show all |
| Click a window | Focus that window and close overview |
| `Escape` | Close overview |

## Known limitations

- **XWayland apps** (e.g. Spotify) do not show a live preview — they display a placeholder instead. This is a Wayland protocol limitation.
- Windows with unusual aspect ratios (heavily portrait or landscape) may show thin black bars in the preview. This is a known issue being worked on.

## File structure

```
hypr-overview/
├── shell.qml              # Root: PanelWindow overlay + IPC handler
├── shell.json             # Quickshell config
├── OverviewState.qml      # Singleton: visible state + selected workspace
├── WindowGrid.qml         # Adaptive window grid
├── WindowPreview.qml      # Individual window card with live screencopy
├── WorkspaceBar.qml       # Top workspace thumbnail bar
├── WorkspaceThumbnail.qml # Single workspace thumbnail
└── hyprland_bind_snippet.lua  # Ready-to-use Hyprland Lua snippet
```

## Changelog

### 0.1.1
- Improved aspect ratio handling in window previews
- Restored stable grid layout after binding loop regression

### 0.1.0
- Initial release
