import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import HcControls

HcScrollablePage{
    HcFrame{
        Layout.fillWidth: true
        height: layout_column.height+20
        padding: 10
        Column{
            id: layout_column
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
            }
            HcText{
                text: qsTr("Expander")
            }
            HcExpander{
                headerText: qsTr("Open a radio box")
                Layout.topMargin: 20
                HcRadioButtons{
                    spacing: 8
                    anchors{
                        top: parent.top
                        left: parent.left
                        topMargin: 20
                        leftMargin: 20
                    }
                    HcRadioButton{
                        text: qsTr("Radio Button_1")
                    }
                    HcRadioButton{

                        text: qsTr("Radio Button_2")
                    }
                    HcRadioButton{
                        text: qsTr("Radio Button_3")
                    }
                }
            }
            HcExpander{
                Layout.topMargin: 20
                contentHeight: 80
                headerText: qsTr("Open a text box")
                Item{
                    anchors.fill: parent
                    Flickable{
                        id:scrollview
                        width: parent.width
                        height: parent.height
                        contentWidth: width
                        boundsBehavior: Flickable.StopAtBounds
                        contentHeight: text_info.height
                        ScrollBar.vertical: HcScrollBar {}
                        HcText{
                            id:text_info
                            width: scrollview.width
                            wrapMode: Text.WrapAnywhere
                            padding: 14
                            text: qsTr("1.客户为本;\n2.长期奋斗;\n3.共创共享;\n4.拥抱变化")
                        }
                    }
                }
            }
        }
    }
}
