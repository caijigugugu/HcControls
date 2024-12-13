import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import HcControls

HcScrollablePage{

    HcMenu {
        id:menu
        title: qsTr("File")
        Action { text: qsTr("New...")}
        Action { text: qsTr("Open...") }
        Action { text: qsTr("Save") }
        HcMenuSeparator { }
        HcMenuItem{
            text: qsTr("Quit")
            onTriggered: {
            }
        }
        HcMenuItem{
            text: qsTr("Search")
            iconSource: HcIcons.Zoom
            iconSpacing: 3
            onTriggered: {
            }
        }
        Action {
            text: qsTr("Disable")
            enabled:false
            onTriggered: {
            }
        }
        HcMenuSeparator { }
        Action { text: qsTr("Check");checkable: true;checked: true}
        HcMenu{
            title: qsTr("Save As...")
            Action { text: qsTr("Doc") }
            Action { text: qsTr("PDF") }
        }
    }


    HcFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 100
        padding: 10
        Column{
            id: layout_column
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
            }

            HcText{
                text: qsTr("Menu")
            }

            HcButton{
                text: qsTr("Show Menu Popup")
                width: 150
                Layout.topMargin: 20
                onClicked:{
                    menu.popup()
                }
            }
        }
    }

    HcFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 100
        padding: 10
        Layout.topMargin: 20
        Column{
            spacing: 15
            anchors{
                verticalCenter: parent.verticalCenter
                left:parent.left
            }

            HcText{
                text: qsTr("MenuBar")
            }

            HcMenuBar {
                id:menu_bar
                HcMenu {
                    title: qsTr("File")
                    Action { text: qsTr("New...") }
                    Action { text: qsTr("Open...") }
                    Action { text: qsTr("Save") }
                    HcMenuSeparator { }
                    Action { text: qsTr("Quit") }
                    Action {
                        text: qsTr("Disable")
                        enabled:false
                    }
                    HcMenu{
                        title: qsTr("Save As...")
                        Action { text: qsTr("Doc") }
                        Action { text: qsTr("PDF") }
                    }
                }
                HcMenu {
                    title: qsTr("Edit")
                    Action { text: qsTr("Cut") }
                    Action { text: qsTr("Copy") }
                    Action { text: qsTr("Paste") }
                }
                HcMenu {
                    title: qsTr("Help")
                    Action { text: qsTr("About") }
                }
            }

        }
    }
}
