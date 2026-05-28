import Quickshell
import Quickshell.Hyprland
import QtQuick

Item {
    id: root

    readonly property var sortedWorkspaces: {
        const ws = [...(Hyprland.workspaces?.values ?? [])]
        ws.sort((a, b) => a.id - b.id)
        return ws
    }

    Row {
        anchors.centerIn: parent
        spacing: 12

        Repeater {
            model: root.sortedWorkspaces

            WorkspaceThumbnail {
                required property var modelData
                workspace: modelData
                isActive: modelData.id === (
                    OverviewState.selectedWorkspaceId !== -1
                        ? OverviewState.selectedWorkspaceId
                        : Hyprland.activeWorkspace?.id ?? 1
                )

                onClicked: {
                    // Toggle: si ya está seleccionado, vuelve a mostrar todas
                    if (OverviewState.selectedWorkspaceId === workspace.id) {
                        OverviewState.selectedWorkspaceId = -1
                    } else {
                        OverviewState.selectedWorkspaceId = workspace.id
                    }
                }
            }
        }
    }
}
