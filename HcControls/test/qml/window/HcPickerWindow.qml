import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import HcControls
Item {
    id: _item
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
                    anchors.verticalCenter: parent.verticalCenter
                    HcTimePicker{
                        width:150
                        hourFormat:HcTimePickerType.HH
                        onAccepted: {
                        }
                    }
                    HcTimePicker{
                        width:150
                        current: new Date()
                        onAccepted: {
                        }
                    }
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                padding: 10
                clip: true
                RowLayout{
                    spacing: 50
                    anchors.verticalCenter: parent.verticalCenter
                    HcDatePicker{
                        current: new Date()
                        onAccepted: {
                        }
                    }
                    HcDatePicker{
                        showYear: false
                        onAccepted: {
                        }
                    }
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                padding: 10
                HcColorPicker{
                    anchors.verticalCenter: parent.verticalCenter
                    onAccepted: {
                        console.log("current",current)
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
