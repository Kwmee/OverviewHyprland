import Quickshell
import Quickshell.Hyprland
import QtQuick

Item {
    id: root

    required property var workspace
    property bool isActive: false
    property bool hovered: false

    signal clicked()

    width: 120
    height: 76

    scale: hovered ? 1.06 : 1.0
    Behavior on scale {
        NumberAnimation { duration: 160; easing.type: Easing.OutBack; easing.overshoot: 1.05 }
    }

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: root.isActive
            ? Qt.rgba(1, 1, 1, 0.18)
            : Qt.rgba(1, 1, 1, root.hovered ? 0.10 : 0.06)
        border.color: root.isActive
            ? Qt.rgba(1, 1, 1, 0.45)
            : Qt.rgba(1, 1, 1, 0.12)
        border.width: root.isActive ? 2 : 1

        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on border.color { ColorAnimation { duration: 150 } }

        Row {
            anchors.centerIn: parent
            spacing: 4

            Repeater {
                model: Math.min(windowCountForWorkspace(root.workspace.id), 6)

                Rectangle {
                    width: 6
                    height: 6
                    radius: 3
                    color: Qt.rgba(1, 1, 1, root.isActive ? 0.85 : 0.45)
                }
            }
        }

        Text {
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 5
            }
            text: root.workspace.name !== "" ? root.workspace.name : String(root.workspace.id)
            color: Qt.rgba(1, 1, 1, root.isActive ? 0.9 : 0.5)
            font.pixelSize: 10
            font.weight: root.isActive ? Font.Medium : Font.Light
        }

        Rectangle {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: -5
            }
            width: root.isActive ? 20 : 0
            height: 3
            radius: 1.5
            color: "white"
            visible: root.isActive

            Behavior on width {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.hovered = true
            onExited: root.hovered = false
            onClicked: root.clicked()
        }
    }

    function windowCountForWorkspace(wsId) {
        let count = 0
        const all = Hyprland.toplevels?.values ?? []
        for (let i = 0; i < all.length; i++) {
            if (all[i].workspace?.id === wsId) count++
        }
        return count
    }
}
