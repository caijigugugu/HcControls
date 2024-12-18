import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import HcControls
import Qt.labs.platform 1.1

HcWindowDialog {

    id:window
    title:qsTr("Hc Initializr")
    width: 600
    height: 400
    //弹窗内容
    contentDelegate:Component{
        Item{
            Connections{
                target: InitializrHelper
                function onError(message){
                    showError(message)
                }
                function onSuccess(path){
                    HcTools.showFileInFolder(path)
                    window.close()
                }
            }

            HcText{
                id:text_title
                text:qsTr("Hc Initializr")
                font: HcTextStyle.Title
                anchors{
                    left: parent.left
                    top: parent.top
                    leftMargin: 20
                    topMargin: 20
                }
            }

            Column{
                spacing: 14
                anchors{
                    left: parent.left
                    top: text_title.bottom
                    leftMargin: 20
                    topMargin: 20
                }
                HcTextBox{
                    id:text_box_name
                    width: 180
                    placeholderText: qsTr("Name")
                    focus: true
                }
                Row{
                    spacing: 8
                    HcTextBox{
                        id:text_box_path
                        width: 300
                        placeholderText: qsTr("Create In")
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    HcButton{
                        text:qsTr("Browse")
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            folder_dialog.open()
                        }
                    }
                }
            }

            FolderDialog{
                id:folder_dialog
                onAccepted: {
                    text_box_path.text = HcTools.toLocalPath(currentFolder)
                }
            }

            Rectangle{
                id:layout_actions
                width: parent.width
                height: 60
                anchors.bottom: parent.bottom
                color: HcTheme.backgroundColor
                Row{
                    height: parent.height
                    spacing: 20
                    anchors{
                        right: parent.right
                        rightMargin: 20
                    }
                    HcButton{
                        text:qsTr("Cancel")
                        width: 120
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            window.close()
                        }
                    }
                    HcButton{
                        text:qsTr("Create")
                        width: 120
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            InitializrHelper.generate(text_box_name.text,text_box_path.text)
                        }
                    }
                }
            }
        }
    }

}
