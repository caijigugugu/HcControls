import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import HcControls

Item {
    id:_hcPcrWindow
    Rectangle {
        anchors.fill: parent
        HcPcr {
            id: pcr
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

}
