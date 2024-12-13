import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import HcControls
import "./chart"

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
            color: "transparent"
        }
        Repeater {
            id: tabRepeater
            model:  [qsTr("条形图"), qsTr("线型图"), qsTr("饼图"),
             qsTr("极坐标区域图"), qsTr("气泡图"), qsTr("散点图"), qsTr("雷达图")]
            HcTabButton {
                width: 145
                height: 40
                text: modelData
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
        HcBarChartWindow {}
        HcLineChartWindow{}
        HcPieChartWindow{}
        HcPolarChartWindow{}
        HcBubbleChartWindow{}
        HcScatterChartWindow{}
        HcRadarChartWindow{}
    }
}
