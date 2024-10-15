import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import HcControls
import "./content"
Item {
    id:_hcDialogWindow
    Flickable {
        id: scrollView
        anchors.fill: parent

         ColumnLayout {
            id:container
            width: parent.width

            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 68
                padding: 10
                HcButton {
                    id: _faultBtn
                    width:60
                    height: 36
                    text: qsTr("故障弹窗")
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 20

                    onClicked: {
                        try {
                            var error = {
                                "level":2,
                                "description":"故障信息",
                                "handleSuggest":"解决方法",
                                "tipInfo":"故障"
                            };
                            if (error) {
                                //故障提示窗
                                var dialog = faultDialogComponent.createObject(contentItem, {
                                                                                   level: Constants.FaultLevel.Error,
                                                                                   summary: error.description,
                                                                                   solution: error.handleSuggest,
                                                                                   detail: error.tipInfo
                                                                               });
                                if (dialog) {
                                    dialog.buttonFlags = 0x01 | 0x02 | 0x04
                                    dialog.uuid = "111"
                                    dialog.extraParams = "extraParams"
                                    dialog.popupMessage(3 , error.description, error.handleSuggest);
                                } else {
                                    console.error("Failed to create HcFaultDialog");
                                }
                            }
                        } catch (e) {
                            console.error("Failed to parse error info: " + e);
                        }
                    }
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 68
                padding: 10
                HcButton {
                    id: _messageBtn
                    width:60
                    height: 36
                    text: qsTr("提示弹窗")
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 20

                    onClicked: {
                        try {
                            var error = {
                                "level":2,
                                "description":qsTr("弹窗内容XXXXXXXXXXXXX1"),
                                "handleSuggest":"solution",
                                "tipInfo":"detail"

                            };
                            if (error) {
                                var dialog = messageDlgComponent.createObject(contentItem,{message: error.description})
                                if (dialog) {
                                    dialog.open();
                                } else {
                                    console.error("Failed to create Dialog");
                                }
                            }
                        } catch (e) {
                            console.error("Failed to parse error info: " + e);
                        }
                    }
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 68
                padding: 10
                HcButton {
                    id: _cardBtn
                    width:60
                    height: 36
                    text: qsTr("卡片弹窗")
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 20

                    onClicked: {
                        cardDlg.showInfo(qsTr("日志下载已完成日志下载已完成日志下载已完成日志下载已完成日志下载已完成"),qsTr("详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息详细信息!"),5000)
                    }
                }
            }
         }
         ScrollBar.vertical: ScrollBar {
             // policy: scrollView.contentHeight
             //         > scrollView.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
             policy:ScrollBar.AlwaysOn
         }
    }
    Component {
        id: faultDialogComponent
        HcFaultDialog {

            id: _faultPopup
            //此函数在无自定义按钮时生效
            onButtonClicked:
            (buttonFlag)=>{
                console.log("button clicked",buttonFlag,uuid,extraParams)
                _faultPopup.close()
            }
            customTitle: "hhhhh"
            buttonComponent: Row {
                spacing: 60
                HcButton {
                    id: _stopBtn1
                    width: 60
                    height: 30
                    text: "自定义1"
                    font.pixelSize: 16
                    onClicked: {
                        console.log("button clicked","自定义1",uuid,extraParams)
                        _faultPopup.close()
                    }
                }
                HcButton {
                    id: _stopBtn2
                    width: 60
                    height: 30
                    text: "自定义2"
                    font.pixelSize: 16
                    onClicked: {
                        console.log("button clicked","自定义2",uuid,extraParams)
                        _faultPopup.close()
                    }
                }
            }
        }
    }

    Component {
        id: messageDlgComponent
        HcMessageDlg {
            id: messageDlg
            popupWidth: 450
            title: qsTr("弹窗标题")

            showCloseIcon: true
            onPositiveClicked: {
                console.log("confirmBtn clicked")
            }
            onNegativeClickListener: function(){
                console.log("cancelBtn clicked")
                messageDlg.close()
            }
        }
    }
    HcCardPopupDlg {
        id:cardDlg
        root: contentItem
    }

}
