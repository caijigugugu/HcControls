import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import HcControls

HcScrollablePage{
    HcFrame {
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        padding: 10
        HcText{
            text: qsTr("标题栏组件")
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    HcHeaderRectangle {}

    HcFrame {
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        padding: 10
        HcToggleSwitch {
            id: _toggleButton
            text: qsTr("正常登录结构")
            onCheckedChanged: {
            }
        }
    }
    HcFrame {
        Layout.fillWidth: true
        Layout.preferredHeight: 800
        HcLogin {
            id: _login
            isNormalMode: _toggleButton.checked
        }
    }
}
