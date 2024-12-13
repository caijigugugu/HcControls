import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import HcControls
Item {
    id: _iconWindow
    width: parent.width
    height: parent.height
    TabBar {
        id: _tabBar
        height: 40
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        spacing: 8
        background: Rectangle {
            color: "transparent"  // 去掉底部边框的影响
        }
        Repeater {
            model:  [qsTr("text图标"), qsTr("svg图标")]
            HcTabButton {
                width: 145
                height: 40
                text: modelData
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    StackLayout {
        id: _stackLayout
        width: parent.width
        height: parent.height - _tabBar.height
        anchors.top: _tabBar.bottom
        anchors.topMargin: 5
        currentIndex: _tabBar.currentIndex
        //组件库自带text图标展示，ttf文件
        HcTextIconWindow {}
        //组件库自带svg图标展示
        HcSvgIconWindow {}
    }
}
