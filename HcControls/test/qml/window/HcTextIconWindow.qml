import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window 2.15

import HcControls

HcPage {
    HcTextBox{
        id: text_box
        level: 2
        placeholderText: qsTr("Please enter a keyword")
        anchors{
            top: parent.top
        }
        onTextChanged: {
            grid_view.model = HcApp.iconData(text_box.text)
        }
    }
    GridView{
        id: grid_view
        cellWidth: 110
        cellHeight: 110
        clip: true
        boundsBehavior: GridView.StopAtBounds
        model: HcApp.iconData()
        ScrollBar.vertical: HcScrollBar {}
        anchors{
            topMargin: 10
            top: text_box.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        delegate: Item {
            width: 100
            height: 100
            HcIconButton{
                id:item_icon
                iconSource: modelData.icon
                iconSize: 30
                padding: 0
                verticalPadding: 0
                horizontalPadding: 0
                anchors.fill: parent
                onClicked: {
                    var text = modelData.name;
                    HcTools.clipText(text)
                    console.log(qsTr("You Copied ")+text)
                }
                display: Button.TextUnderIcon
                font.pixelSize: 12
                text: modelData.name
            }
        }
    }
}

