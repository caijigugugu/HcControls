import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import HcControls

Item {
    id:_hcWindow
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
                Layout.preferredHeight: 80
                padding: 10
                Row{
                    spacing: 50
                    HcCalendarPicker{
                        id: calendar
                    }
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                padding: 10
                Row{
                    spacing: 100
                    HcCalendar {
                        id: calendar1
                    }
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                padding: 10
                Row{
                    spacing: 10;
                }
            }
         }
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
