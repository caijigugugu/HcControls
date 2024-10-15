import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import HcControls
import "./content"
Window {
    function recursePrint(obj) {
        for (var propertyName in obj) {
            if (obj[propertyName] !== null && typeof obj[propertyName] === 'object') {
                recursePrint(obj[propertyName])
            } else {
                console.log("property = ", propertyName, ", value = ", obj[propertyName])
            }
        }
    }

    width: Screen.width
    height: Screen.height
    visible: true
    title: qsTr("TestApp")
//    flags: Qt.CustomizeWindowHint | Qt.FramelessWindowHint

    ListModel {
        id: menuModel
        Component.onCompleted: {
            menuModel.append({
                title: qsTr("HcPcr"),
                icon: "file:///E:/work/HcControls/qmlcontrols/HcControls/src/qml/Icon/收起.png",
                //icon: "qrc:/HcControls/src/qml/Icon/btn_add.png",
                subMenus: [
                    { "title": qsTr("pcr"), "icon": "file:///E:/work/HcControls/qmlcontrols/HcControls/src/qml/Icon/收起.png",
                     "qmlPath": "HcPcrWindow.qml" }
                ]
            })
            menuModel.append({
                title: qsTr("弹窗"),
                icon: "file:///E:/work/HcControls/qmlcontrols/HcControls/src/qml/Icon/收起.png",
                subMenus: [
                    { "title": qsTr("弹窗"), "icon": "", "qmlPath": "HcDialogWindow.qml" }
                ]
            })
            menuModel.append({
                title: qsTr("输入框"),
                icon: "file:///E:/work/HcControls/qmlcontrols/HcControls/src/qml/Icon/收起.png",
                subMenus: [
                    { "title": qsTr("输入框"), "icon": "", "qmlPath": "Page1.qml" },
                    { "title": qsTr("其他"), "icon": "", "qmlPath": "Page1.qml" }
                ]
            })
            menuModel.append({
                title: qsTr("导航"),
                icon: "file:///E:/work/HcControls/qmlcontrols/HcControls/src/qml/Icon/收起.png",
                subMenus: [
                    { "title": qsTr("表格"), "icon": "", "qmlPath": "HcTableViewWindow.qml" },
                    { "title": qsTr("分页"), "icon": "", "qmlPath": "HcPaginationWindow.qml" }
                ]
            })
        }

    }

    FileDialog {
        id: loadFileDlg
        acceptLabel: qsTr("选择文件")
        rejectLabel: qsTr("取消")
        nameFilters: ["Json files (*.json)"]
        fileMode: FileDialog.OpenFile

        onAccepted: {
            var file = loadFileDlg.currentFile

            if (file) {
                pcr.loadTemplate(file)
            }
        }
    }

    FileDialog {
        id: saveFileDlg
        acceptLabel: qsTr("选择文件")
        rejectLabel: qsTr("取消")
        nameFilters: ["Json files (*.json)"]
        fileMode: FileDialog.SaveFile

        onAccepted: {
            var file = saveFileDlg.currentFile

            if (file) {
                pcr.saveTemplate(file)
            }
        }
    }

    Component{
        id: menuButton

        Item{
            Behavior on height {
                NumberAnimation{
                    duration: 160
                    easing.type: Easing.OutCubic
                }
            }
            height: {
                if(model&&model._parent){
                    return model._parent.isExpand ? control.cellHeight : 0
                }
                return control.cellHeight
            }
        }
    }

    Component{
        id: listDelegate
        Column{
            id:objColumn
            Component.onCompleted: {
                for(var i = 1; i < objColumn.children.length - 1; ++i) {
                    objColumn.children[i].visible = false
                }
            }
            MouseArea{
                id: _menu
                width: scrollview.width
                height: objItem.implicitHeight
                property int currentIndex: index
                onClicked: {
                    var flag = false;
                    for(var i = 1; i < parent.children.length - 1; ++i) {
                        flag = parent.children[i].visible;
                        parent.children[i].visible = !parent.children[i].visible
                    }
                    if(!flag){
                        iconAin.from = 0
                        iconAin.to = 180
                        iconAin.start()
                    }
                    else{
                        iconAin.from = 180
                        iconAin.to = 0
                        iconAin.start()
                    }
                }
                Row {
                    id: objItem
                    spacing: 10
                    anchors.fill: parent
                    anchors.margins: 10
                    Label {
                        id: menuName
                        text: title
                        width: parent.width - _icon.width - rightMargin.width
                        font.pixelSize: 18
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Image {
                        id: _icon
                        width: 20
                        height: 20
                        source: icon
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                        RotationAnimation{
                            id:iconAin
                            target: _icon
                            duration: 100
                        }
                    }
                    Item {
                        id: rightMargin
                        width: 10
                        height: 10
                    }
                }
            }
            //子菜单 Repeater
            Repeater {
               model: subMenus
               delegate: Rectangle{
                   width: objColumn.width
                   height: 40
                   property color normalColor: "#FFFFFF"
                   property color hoverColor: "#EBEBEB"
                   property color selectedColor: "#D8D8D8"
                   // 子菜单的索引
                   property int subMenuIndex: index
                   // 通过拼接父菜单和子菜单的索引生成唯一的 globalIndex
                   property string globalIndex: _menu.currentIndex + "-" + subMenuIndex
                   property bool checked: globalIndex === scrollview.selectedIndex
                   property bool hovered: false
                   color: checked ? selectedColor : (hovered ? hoverColor : normalColor)
                   Row{
                       anchors.fill: parent
                       anchors{
                           left: parent.left
                           leftMargin: 20
                       }
                       spacing: 5
                       Image {
                           id: btnIcon
                           width: 20
                           height: 20
                           fillMode: Image.PreserveAspectFit
                           visible: false
                           source: model.icon
                           anchors.verticalCenter: parent.verticalCenter
                       }
                       Label{
                           id: btntext
                           text: model.title
                           font.pixelSize: 18
                           anchors.verticalCenter: parent.verticalCenter
                       }
                   }
                   MouseArea {
                       id: mouseArea
                       anchors.fill: parent
                       hoverEnabled: true
                       onClicked: {
                           console.log(btntext.text,scrollview.selectedIndex ,mouseArea.containsMouse)
                           _mainScreenLoader.setSource(model.qmlPath)
                           scrollview.selectedIndex = globalIndex;

                       }
                       onEntered: {
                           hovered = true
                       }
                       onExited: {
                           hovered = false
                       }
                   }
               }
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 10

        Rectangle {
            Layout.preferredWidth: 120
            Layout.fillHeight: true
            Layout.margins: 20
            border.width: 1
            border.color: "#a0b9b9"
            Item{
                anchors.fill: parent
                Flickable{
                    id:scrollview
                    width: parent.width
                    height: parent.height
                    contentHeight: menuList.contentHeight
                    property string selectedIndex: ""
                    ListView{
                        id: menuList
                        anchors.fill: parent
                        displaced: Transition {
                            NumberAnimation {
                                properties: "x,y"
                                easing.type: Easing.OutQuad
                            }
                        }
                        model: menuModel
                        delegate: listDelegate
                    }
                    ScrollBar.vertical: ScrollBar {
                        policy: scrollview.contentHeight
                                > scrollview.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
                    }
                }
            }
//             ComboBox {
//                 id: comboBox
//                 implicitWidth: 100
//                 implicitHeight: 30
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 anchors.top: parent.top
//                 anchors.topMargin: 20
//                 model: ["HcPcr"]
//                 font.pixelSize: 14

//                 onCurrentIndexChanged: {
// //                    stackLayout.currentIndex = comboBox.currentIndex
//                 }

//                 Component.onCompleted: {
// //                    console.log("implicit height = ", comboBox.implicitHeight)
// //                    console.log("minimum height = ", comboBox.Layout.minimumHeight)
//                 }
//             }

            // Column {
            //     spacing: 20
            //     anchors.horizontalCenter: parent.horizontalCenter
            //     anchors.top: parent.top
            //     anchors.topMargin: 80

            //     Button {
            //         width: 80
            //         text: "加载模板"
            //         font.pixelSize: 14

            //         onClicked: {
            //             loadFileDlg.open()
            //         }
            //     }
                // Button {
                //     width: 80
                //     text: "保存模板"
                //     font.pixelSize: 14

                //     onClicked: {
                //         //saveFileDlg.open()
                //         console.log("1111111111111",Qt.resolvedUrl(""))
                //     }
                // }
            // }
        }
        Rectangle {
            Layout.preferredWidth: parent.width - 230
            Layout.fillHeight: true
            Layout.margins: 20
            border.width: 1
            border.color: "#a0b9b9"
            StackLayout {
                id: stackLayout
                width: parent.width - 10
                height: parent.height - 10
                anchors.centerIn: parent
                Loader {
                    id: _mainScreenLoader
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    asynchronous: true
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("Number.MAX_SAFE_INTEGER =", Number.MAX_SAFE_INTEGER)
    }
}
