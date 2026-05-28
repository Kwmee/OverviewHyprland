import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick

Item {
    id: root

    required property var window
    property bool hovered: false

    signal clicked()

    scale: hovered ? 1.03 : 1.0
    Behavior on scale {
        NumberAnimation { duration: 160; easing.type: Easing.OutBack; easing.overshoot: 1.08 }
    }

    // Ratio real de la ventana capturada (por defecto 16:9 hasta el primer frame)
    readonly property real naturalRatio: liveView.sourceSize.width > 0
        ? liveView.sourceSize.width / liveView.sourceSize.height
        : 16 / 9

    ClippingRectangle {
        anchors.fill: parent
        anchors.margins: 0
        radius: 8

        color: Qt.rgba(0.04, 0.06, 0.12, 1)
        border.color: root.hovered ? Qt.rgba(1, 1, 1, 0.50) : "transparent"
        border.width: root.hovered ? 1 : 0
        Behavior on border.color { ColorAnimation { duration: 150 } }

        ScreencopyView {
            id: liveView
            anchors { fill: parent; bottomMargin: 28 }
            captureSource: root.window.wayland
            live: OverviewState.visible
            paintCursor: false
            visible: hasContent
        }

        Rectangle {
            anchors { fill: parent; bottomMargin: 28 }
            color: Qt.rgba(0.12, 0.13, 0.18, 1)
            visible: !liveView.visible

            Text {
                anchors.centerIn: parent
                text: root.window.wayland?.appId
                    ? root.window.wayland.appId.charAt(0).toUpperCase()
                    : "?"
                font.pixelSize: parent.height * 0.36
                font.weight: Font.Light
                color: Qt.rgba(1, 1, 1, 0.4)
            }
        }

        Rectangle {
            anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
            height: 28
            color: Qt.rgba(0, 0, 0, 0.70)

            Text {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left; right: parent.right
                    leftMargin: 10; rightMargin: 10
                }
                text: root.window.title
                color: Qt.rgba(1, 1, 1, 0.90)
                font.pixelSize: 11
                font.weight: Font.Medium
                elide: Text.ElideRight
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
}
