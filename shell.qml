import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ShellRoot {
    id: root

    // Punto de entrada IPC: quickshell ipc call -p PATH overview toggle
    IpcHandler {
        target: "overview"
        function toggle() { OverviewState.toggle() }
        function show()   { OverviewState.show()   }
        function hide()   { OverviewState.hide()   }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: overviewPanel
            required property var modelData
            screen: modelData

            visible: OverviewState.visible
            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            WlrLayershell.layer: WlrLayer.Overlay

            color: "transparent"

            HyprlandFocusGrab {
                id: focusGrab
                active: overviewPanel.visible
                onCleared: OverviewState.hide()
            }

            // Fondo oscuro con tinte azulado para distinguirse del escritorio
            Rectangle {
                id: backdrop
                anchors.fill: parent
                color: Qt.rgba(0.04, 0.06, 0.12, 0.88)
                opacity: overviewPanel.visible ? 1 : 0
                Behavior on opacity {
                    NumberAnimation { duration: 220; easing.type: Easing.OutQuart }
                }
            }

            // Contenedor principal
            Item {
                id: mainContainer
                anchors.fill: parent

                opacity: overviewPanel.visible ? 1 : 0
                scale: overviewPanel.visible ? 1 : 0.94

                Behavior on opacity {
                    NumberAnimation { duration: 260; easing.type: Easing.OutCubic }
                }
                Behavior on scale {
                    NumberAnimation { duration: 260; easing.type: Easing.OutCubic }
                }

                // Barra superior de workspaces
                WorkspaceBar {
                    id: workspaceBar
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        topMargin: 24
                    }
                    height: 90
                }

                // Rejilla de ventanas del monitor de este panel
                WindowGrid {
                    id: windowGrid
                    screen: overviewPanel.screen
                    anchors {
                        top: workspaceBar.bottom
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        topMargin: 8
                        leftMargin: 8
                        rightMargin: 8
                        bottomMargin: 8
                    }
                }
            }

            // Item invisible que captura el teclado para cerrar con Escape
            Item {
                focus: overviewPanel.visible
                Keys.onEscapePressed: OverviewState.hide()
            }
        }
    }
}
