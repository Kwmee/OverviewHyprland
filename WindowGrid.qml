import Quickshell
import Quickshell.Hyprland
import QtQuick

Item {
    id: root
    required property var screen

    readonly property var allWindows: {
        const all = Hyprland.toplevels?.values ?? []
        const wsId = OverviewState.selectedWorkspaceId !== -1
            ? OverviewState.selectedWorkspaceId
            : (Hyprland.monitorFor(root.screen)?.activeWorkspace?.id ?? 1)
        const filtered = []
        for (let i = 0; i < all.length; i++) {
            if (all[i].workspace?.id === wsId) filtered.push(all[i])
        }
        return filtered
    }

    readonly property int cols: {
        const n = allWindows.length
        if (n <= 1) return 1
        if (n <= 4) return 2
        if (n <= 9) return 3
        return 4
    }
    readonly property int rows: Math.ceil(allWindows.length / cols)
    readonly property real cellW: cols > 0 ? (width / cols) : width
    readonly property real cellH: Math.min(
        cellW * (9 / 16) + 28,
        rows > 0 ? (height / rows) : height
    )

    Text {
        anchors.centerIn: parent
        text: "No hay ventanas abiertas"
        color: Qt.rgba(1, 1, 1, 0.35)
        font.pixelSize: 16
        font.weight: Font.Light
        visible: root.allWindows.length === 0
    }

    Grid {
        anchors.centerIn: parent
        columns: root.cols
        spacing: 0

        Repeater {
            model: root.allWindows

            WindowPreview {
                required property var modelData
                window: modelData
                width: root.cellW
                height: root.cellH

                onClicked: {
                    modelData.wayland?.activate()
                    OverviewState.hide()
                }
            }
        }
    }
}
