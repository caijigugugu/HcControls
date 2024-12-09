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
                Layout.preferredHeight: 180
                padding: 10
                ColumnLayout{
                    spacing: 10
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 50
                    }
                    HcProgressBar{
                        indeterminate: _toggleButton.checked
                        value:slider.value/100
                        progressVisible: true
                        Layout.topMargin: 10
                    }
                    HcProgressRing{
                        indeterminate: _toggleButton.checked
                        progressVisible: true
                        value: slider.value/100
                    }
                    HcSlider{
                        id:slider
                        orientation: Qt.Horizontal //Qt.Vertical
                        Component.onCompleted: {
                            value = 50
                        }
                    }
                    HcToggleSwitch {
                        id: _toggleButton
                        text: qsTr("indeterminate")
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
