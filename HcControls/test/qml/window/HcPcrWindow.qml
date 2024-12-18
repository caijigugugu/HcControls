import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import HcControls

Item {
    id:_hcPcrWindow

    FileDialog {
        id: loadFileDlg
        acceptLabel: qsTr("选择文件")
        rejectLabel: qsTr("取消")
        nameFilters: ["Json files (*.json)"]
        fileMode: FileDialog.OpenFile

        onAccepted: {
            var file = loadFileDlg.currentFile

            if (file) {
                pcr.loadTemplate(file)
            }
        }
    }

    FileDialog {
        id: saveFileDlg
        acceptLabel: qsTr("选择文件")
        rejectLabel: qsTr("取消")
        nameFilters: ["Json files (*.json)"]
        fileMode: FileDialog.SaveFile

        onAccepted: {
            var file = saveFileDlg.currentFile

            if (file) {
                pcr.saveTemplate(file)
            }
        }
    }
    HcFrame {
        id: _buttonList
        width: parent.width
        Layout.preferredHeight: 68
        padding: 10
        radius: 0
        background: HcRoundedRectangle{
            gradient: HcTheme.dark ?  Constants.tempDeepHeadGradient : Constants.tempHeadGradient
            borderColor: HcTheme.dark ?  Constants.tempFrameDeepBorderColor : Constants.tempFrameBorderColor
            borderWidth: 1
        }
        Row{
            spacing: 50
            anchors.right: parent.right
            anchors.rightMargin: 60
            HcButton {
                id: _loadBtn
                width:80
                height: 36
                text: qsTr("加载模板")
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: 20
                onClicked: {
                    loadFileDlg.open()
                }
            }
            HcButton {
                id: _saveBtn
                width:80
                height: 36
                text: qsTr("保存模板")
                Layout.alignment: Qt.AlignLeft
                Layout.leftMargin: 20
                onClicked: {
                    saveFileDlg.open()
                }
            }
            HcButton {
                id: editBtn
                text: "可编辑"
                width: 90
                height: 35
                onClicked: {
                    pcr.editable = !pcr.editable

                    if(pcr.editable) {
                        console.log("编辑", pcr.deviceName, "的方案")
                        text = "不可编辑"
                    } else {
                        console.log("保存", pcr.deviceName, "的方案")
                        text = "可编辑"
                    }
                }
            }
        }
    }
    Rectangle {
        width: parent.width
        height: parent.height - _buttonList.height
        anchors.top: _buttonList.bottom
        HcPcr {
            id: pcr
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
