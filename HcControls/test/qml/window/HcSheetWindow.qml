import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import HcControls

HcScrollablePage{

    title: qsTr("")

    HcSheet{
        id:sheet
        title: qsTr("Title")
        HcText{
            text: qsTr("Some contents...\nSome contents...\nSome contents...")
            anchors{
                left: parent.left
                leftMargin: 10
            }
        }
    }

    HcFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 280
        padding: 10
        Column{
            anchors.centerIn: parent
            spacing: 10
            Row{
                spacing: 10
                HcButton{
                    width: 80
                    height: 30
                    text: qsTr("top")
                    onClicked: {
                        sheet.open(HcSheetType.Top)
                    }
                }
                HcButton{
                    width: 80
                    height: 30
                    text: qsTr("right")
                    onClicked: {
                        sheet.open(HcSheetType.Right)
                    }
                }
            }
            Row{
                spacing: 10
                HcButton{
                    width: 80
                    height: 30
                    text: qsTr("bottom")
                    onClicked: {
                        sheet.open(HcSheetType.Bottom)
                    }
                }
                HcButton{
                    width: 80
                    height: 30
                    text: qsTr("left")
                    onClicked: {
                        sheet.open(HcSheetType.Left)
                    }
                }
            }
        }
    }
}
