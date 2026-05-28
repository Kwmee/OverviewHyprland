-- Añade esto a tu ~/.config/hypr/hyprland.lua

local overview_dir = os.getenv("HOME") .. "/Documentos/Proyectos/hypr-overview"

-- Arranca el overview al iniciar Hyprland (una sola instancia)
hl.exec_once("quickshell -p " .. overview_dir)

-- SUPER + TAB → toggle del overview via IPC (sin abrir procesos nuevos)
hl.bind(mainMod .. " + TAB",
    hl.dsp.exec_cmd("quickshell ipc -p " .. overview_dir .. " call overview toggle"))
