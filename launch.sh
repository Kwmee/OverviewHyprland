#!/usr/bin/env bash
# Arranca el overview (solo una instancia) o hace toggle si ya corre.
# Uso:
#   ./launch.sh          → toggle (arranca si no corre, muestra/oculta si ya corre)
#   ./launch.sh --start  → solo arranca en background, sin toggle

DIR="$(dirname "$(realpath "$0")")"

is_running() {
    quickshell ipc call -p "$DIR" overview toggle 2>/dev/null
}

if [[ "$1" == "--start" ]]; then
    quickshell -p "$DIR" &
    disown
elif ! quickshell ipc call -p "$DIR" overview toggle 2>/dev/null; then
    # No hay instancia corriendo → lanzar
    quickshell -p "$DIR" &
    disown
fi
