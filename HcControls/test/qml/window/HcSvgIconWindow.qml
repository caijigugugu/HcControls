import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window 2.15
import Qt.labs.folderlistmodel

import HcControls

HcPage {
    FolderListModel {
        id: iconFolderModel
        folder: "file:///E:/work/HcControls/qmlcontrols/HcControls/HcControls/qml/Icon"
        nameFilters: ["*.svg", "*.png"]
    }
    GridView{
        id: grid_view
        cellWidth: 110
        cellHeight: 110
        clip: true
        boundsBehavior: GridView.StopAtBounds
        model: iconFolderModel
        ScrollBar.vertical: HcScrollBar {}
        anchors{
            topMargin: 10
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        delegate: Item {
            width: 100
            height: 100
            HcIconButton{
                id:item_icon
                iconSource: fileURL
                iconSize: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                //屏蔽掉组件自带的改变图标颜色功能
                iconColor:"transparent"
                anchors.fill: parent
                onClicked: {
                    var text = fileURL
                    HcTools.clipText(text)
                    console.log(qsTr("You Copied ")+text)
                }
                display: Button.TextUnderIcon
                font.pixelSize: 12
                HcText{
                    width: parent.width
                    horizontalAlignment: Qt.AlignHCenter
                    wrapMode: Text.WrapAnywhere
                    text: fileName
                    anchors.top: parent.top
                    anchors.topMargin: 60
                }
            }
        }
    }
}

