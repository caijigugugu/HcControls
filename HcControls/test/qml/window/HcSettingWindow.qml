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
            HcFrame{
                Layout.fillWidth: true
                Layout.preferredHeight: 68
                padding: 10

                ColumnLayout{
                    spacing: 10
                    HcText{
                        text:qsTr("语言")
                        Layout.bottomMargin: 4
                    }
                    Row {
                        spacing: 10
                        HcText{
                            text:qsTr("中文")
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        HcToggleSwitch {
                            checked : TranslateHelper.current === "en_US"
                            onCheckedChanged: {
                                if(checked) {
                                    TranslateHelper.current = "en_US"
                                } else {
                                    TranslateHelper.current = "zh_CN"
                                }
                            }
                        }
                        HcText{
                            text:qsTr("英文")
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
            HcFrame{
                Layout.fillWidth: true
                Layout.topMargin: 20
                height: 128
                padding: 10

                ColumnLayout{
                    spacing: 5
                    anchors{
                        top: parent.top
                        left: parent.left
                    }
                    HcText{
                        text: qsTr("主题")
                        font: HcTextStyle.BodyStrong
                        Layout.bottomMargin: 4
                    }
                    Repeater{
                        model: [{title:qsTr("跟随系统"),mode:HcThemeType.System},{title:qsTr("浅色"),mode:HcThemeType.Light},{title:qsTr("深色"),mode:HcThemeType.Dark}]
                        delegate: HcRadioButton{
                            checked : HcTheme.darkMode === modelData.mode
                            text:modelData.title
                            clickListener:function(){
                                HcTheme.darkMode = modelData.mode
                            }
                        }
                    }
                }
            }
         }
         // ScrollBar.vertical: ScrollBar {
         //     policy:ScrollBar.AlwaysOn
         // }
    }
    ScrollBar {
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
