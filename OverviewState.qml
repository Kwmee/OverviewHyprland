pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root

    property bool visible: false
    property int selectedWorkspaceId: -1

    function toggle() {
        if (visible) { hide() } else { show() }
    }

    function show() {
        selectedWorkspaceId = -1
        visible = true
    }

    function hide() {
        visible = false
    }
}
