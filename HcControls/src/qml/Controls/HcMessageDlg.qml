pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property bool onlyConfirm: true
    property bool rejected: false

    function createMessageDlg(parent, info = "") {
        var obj = _dlgComponent.createObject(parent, {message: info})
        obj.open()

        return obj
    }

    id: control
    width: 480
    height: 320

    Component {
        id: _dlgComponent

        HcDialog {
            id: _messageDlg
            width: control.width
            height: control.height
            onlyConfirm: control.onlyConfirm

            onAccepted: {
                control.rejected = false
            }

            onRejected: {
                control.rejected = true
            }
        }
    }
}
