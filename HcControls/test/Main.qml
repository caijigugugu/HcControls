import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import HcControls

Window {
    function recursePrint(obj) {
        for (var propertyName in obj) {
            if (obj[propertyName] !== null && typeof obj[propertyName] === 'object') {
                recursePrint(obj[propertyName])
            } else {
                console.log("property = ", propertyName, ", value = ", obj[propertyName])
            }
        }
    }

    width: Screen.width
    height: Screen.height
    visible: true
    title: qsTr("TestApp")
//    flags: Qt.CustomizeWindowHint | Qt.FramelessWindowHint


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

    RowLayout {
        anchors.fill: parent
        spacing: 10

        Rectangle {
            Layout.preferredWidth: 120
            Layout.fillHeight: true
            Layout.margins: 20
            border.width: 1
            border.color: "#a0b9b9"
//            color: "red"

            ComboBox {
                id: comboBox
                implicitWidth: 100
                implicitHeight: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 20
                model: ["HcPcr"]
                font.pixelSize: 14

                onCurrentIndexChanged: {
//                    stackLayout.currentIndex = comboBox.currentIndex
                }

                Component.onCompleted: {
//                    console.log("implicit height = ", comboBox.implicitHeight)
//                    console.log("minimum height = ", comboBox.Layout.minimumHeight)
                }
            }

            Column {
                spacing: 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 80

                Button {
                    width: 80
                    text: "加载模板"
                    font.pixelSize: 14

                    onClicked: {
                        loadFileDlg.open()
                    }
                }
                Button {
                    width: 80
                    text: "保存模板"
                    font.pixelSize: 14

                    onClicked: {
                        saveFileDlg.open()
                    }
                }
            }
        }
        Rectangle {
            Layout.preferredWidth: parent.width - 230
            Layout.fillHeight: true
            Layout.margins: 20
            border.width: 1
            border.color: "#a0b9b9"

            StackLayout {
                id: stackLayout
                width: parent.width - 10
                height: parent.height - 10
                anchors.centerIn: parent

//                Rectangle {
//                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
//                    Layout.fillWidth: true
//                    Layout.fillHeight: true
//                    color: "blue"
//                }
                HcPcr {
                    id: pcr
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("Number.MAX_SAFE_INTEGER =", Number.MAX_SAFE_INTEGER)
    }
}
