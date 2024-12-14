import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import HcControls
Item {
    id:_hcDialogWindow
    property bool disabled: false
    Flickable {
        id: scrollView
        anchors.fill: parent
        ScrollBar.vertical:scroll_bar
        height: parent.height
        contentHeight: container.height
         ColumnLayout {
            id:container
            width: parent.width
            spacing: 50
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 68
                padding: 10
                Row{
                    spacing: 50
                    HcButton {
                        id: _normolBtn
                        width:80
                        height: 36
                        text: qsTr("按钮")
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 20
                        enabled: !disabled
                        onClicked: {
                            checked = !checked
                        }
                    }
                    HcTextButton {
                        id: _disableBtn
                        height: 36
                        text: qsTr("文本按钮")
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 20
                        enabled: !_hcDialogWindow.disabled
                        onClicked: {
                        }
                    }
                }
                HcToggleSwitch {
                    id: _toggleButton1
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: 100
                    }
                    text: qsTr("禁用其余所有按钮")
                    onCheckedChanged: {
                        _hcDialogWindow.disabled = checked
                    }
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 68
                padding: 10
                Row{
                    spacing: 10
                    HcIconButton {
                        id: _onlyIconBtn1
                        width:40
                        height: 36
                        iconSize: 16
                        _radius: 2
                        enabled: !_hcDialogWindow.disabled
                        iconSource: "file:///E:/work/HcControls/qmlcontrols/HcControls/HcControls/qml/Icon/btn_delete.png"
                        onClicked: {
                            checked = !checked
                        }
                    }
                    HcIconButton {
                        id: _onlyIconBtn2
                        width:28
                        height: 28
                        _radius: width/2
                        enabled: !_hcDialogWindow.disabled
                        iconSource: "file:///E:/work/HcControls/qmlcontrols/HcControls/HcControls/qml/Icon/btn_add.png"
                        onClicked: {
                            checked = !checked
                        }
                    }
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                padding: 10
                Row{
                    spacing: 50
                    HcIconButton {
                        id: _iconBtn1
                        width: 220
                        height: 70
                        iconSize: 28
                        display: Button.TextBesideIcon
                        _radius: 8
                        text: qsTr("新建")
                        font.pixelSize: 28
                        enabled: !disabled
                        iconSource: "file:///E:/work/HcControls/qmlcontrols/HcControls/HcControls/qml/Icon/btn_add.png"
                        onClicked: {
                            checked = !checked
                        }
                    }
                    HcIconButton {
                        id: _iconBtn2
                        width: 220
                        height: 70
                        iconSize:28
                        display: Button.TextUnderIcon
                        _radius: 8
                        _spacing: 0
                        text: qsTr("删除")
                        enabled: !disabled
                        font.pixelSize: 28
                        iconSource: "file:///E:/work/HcControls/qmlcontrols/HcControls/HcControls/qml/Icon/btn_delete.png"
                        onClicked: {
                            checked = !checked
                        }
                    }
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                padding: 10
                HcToggleSwitch {
                    id: _toggleButton
                    buttonWidth: 80
                    buttonHeight: 30
                    text: qsTr("切换开关")
                    enabled: !disabled
                    onCheckedChanged: {
                    }
                }
            }
            HcFrame{
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                padding: 10
                Layout.topMargin: 20
                Row{
                spacing: 50
                    HcRadioButtons{
                        spacing: 8
                        disabled: _hcDialogWindow.disabled
                        HcRadioButton{
                            text: qsTr("Radio Button_1")
                        }
                        HcRadioButton{

                            text: qsTr("Radio Button_2")
                        }
                        HcRadioButton{
                            text: qsTr("Radio Button_3")
                        }
                    }
                    HcRadioButtons{
                        spacing: 8
                        disabled: _hcDialogWindow.disabled
                        orientation: Qt.Horizontal
                        anchors.verticalCenter: parent.verticalCenter
                        HcCheckBox{
                            text: qsTr("Radio Button_1")
                        }
                        HcCheckBox{
                            text: qsTr("Radio Button_2")
                        }
                        HcCheckBox{
                            text: qsTr("Radio Button_3")
                        }
                    }
                }
            }
         }
    }
    HcScrollBar {
        id: scroll_bar
        anchors{
            top: scrollView.top
            right: parent.right
            bottom: scrollView.bottom
        }
        policy: scrollView.contentHeight
                                > scrollView.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
        z:999
    }

}
