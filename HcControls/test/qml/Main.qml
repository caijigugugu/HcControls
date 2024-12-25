import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import HcControls
import "./window"
Window {
    id:app
    function recursePrint(obj) {
        for (var propertyName in obj) {
            if (obj[propertyName] !== null && typeof obj[propertyName] === 'object') {
                recursePrint(obj[propertyName])
            } else {
                console.log("property = ", propertyName, ", value = ", obj[propertyName])
            }
        }
    }
    color: HcTheme.dark ? "#575757" : "#F3F3F3"
    width: Screen.width
    height: Screen.height
    visible: true
    title: qsTr("TestApp")
//    flags: Qt.CustomizeWindowHint | Qt.FramelessWindowHint

    ListModel {
        id: menuModel
        // 模型初始化
    }

    function updateModel() {
        menuModel.clear(); // 清空模型
        // 重新添加项
        menuModel.append({
            title: qsTr("温度程序"),
            icon: "收起.png",
            subMenus: [
                { "title": qsTr("pcr"), "icon": "/qml/Icon/收起.png", "qmlPath": "./window/HcPcrWindow.qml" }
            ]
        });
        menuModel.append({
            title: qsTr("弹窗"),
            icon: "file:///E:/work/HcControls/qmlcontrols/HcControls/HcControls/qml/Icon/收起.png",
            subMenus: [
                { "title": qsTr("弹窗"), "icon": "", "qmlPath": "./window/HcDialogWindow.qml" },
                { "title": qsTr("菜单栏"), "icon": "", "qmlPath": "./window/HcMenuWindow.qml" },
                { "title": qsTr("抽屉"), "icon": "", "qmlPath": "./window/HcSheetWindow.qml" }
            ]
        });
        menuModel.append({
            title: qsTr("基本输入"),
            icon: "file:///E:/work/HcControls/qmlcontrols/HcControls/HcControls/qml/Icon/收起.png",
            subMenus: [
                { "title": qsTr("按钮"), "icon": "", "qmlPath": "./window/HcButtonWindow.qml" },
                { "title": qsTr("输入框"), "icon": "", "qmlPath": "./window/HcTextInputWindow.qml" },
                { "title": qsTr("选择器"), "icon": "", "qmlPath": "./window/HcPickerWindow.qml" }
            ]
        });
        menuModel.append({
            title: qsTr("导航"),
            icon: "file:///E:/work/HcControls/qmlcontrols/HcControls/HcControls/qml/Icon/收起.png",
            subMenus: [
                { "title": qsTr("表格"), "icon": "", "qmlPath": "./window/HcTableViewWindow.qml" },
                { "title": qsTr("树"), "icon": "", "qmlPath": "./window/HcTreeViewWindow.qml" },
                { "title": qsTr("分页"), "icon": "", "qmlPath": "./window/HcPaginationWindow.qml" },
                { "title": qsTr("日历"), "icon": "", "qmlPath": "./window/HcCalendarWindow.qml" },
                { "title": qsTr("翻转视图"), "icon": "", "qmlPath": "./window/HcFlipViewWindow.qml" }
            ]
        });
        menuModel.append({
            title: qsTr("图表"),
            icon: "file:///E:/work/HcControls/qmlcontrols/HcControls/HcControls/qml/Icon/收起.png",
            subMenus: [
                { "title": qsTr("图标"), "icon": "", "qmlPath": "./window/HcTabWindow.qml" },
                { "title": qsTr("图表"), "icon": "", "qmlPath": "./window/HcChartWindow.qml" },
                { "title": qsTr("进度条"), "icon": "", "qmlPath": "./window/HcProgressWindow.qml" }
            ]
        });
        menuModel.append({
            title: qsTr("框架结构"),
            icon: "file:///E:/work/HcControls/qmlcontrols/HcControls/HcControls/qml/Icon/收起.png",
            subMenus: [
                { "title": qsTr("框架"), "icon": "", "qmlPath": "./window/HcFrameWindow.qml" }
            ]
        });
        menuModel.append({
            title: qsTr("其他"),
            icon: "file:///E:/work/HcControls/qmlcontrols/HcControls/HcControls/qml/Icon/收起.png",
            subMenus: [
                { "title": qsTr("其他"), "icon": "", "qmlPath": "./window/HcExtraWindow.qml" }
            ]
        });
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
                    HcText {
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
                   width: objColumn.width - 2*border.width
                   height: 40
                   anchors.horizontalCenter: parent.horizontalCenter
                   property color normalColor: HcTheme.dark ? "#575757" : "#FFFFFF"
                   property color hoverColor: HcTheme.dark ? "#4f4d4d" : "#EBEBEB"
                   property color selectedColor: HcTheme.dark ? "#373737" : "#D8D8D8"
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
                       HcText {
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
            id: _leftMenu
            Layout.preferredWidth: 220
            Layout.fillHeight: true
            Layout.margins: 20
            border.width: 1
            border.color: "#a0b9b9"
            color: "transparent"
            Column{
                anchors.fill: parent
                Flickable{
                    id:scrollview
                    width: parent.width
                    height: parent.height - _settingBtn.height
                    clip: true
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
                        spacing: 10
                    }
                    ScrollBar.vertical: HcScrollBar {
                        policy: scrollview.contentHeight
                                > scrollview.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
                    }
                }
                HcTextButton {
                    id: _settingBtn
                    height: 36
                    width: parent.width - 2
                    backgroundColor: "transparent"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 18
                    text: qsTr("设置")
                    onClicked: {
                        _mainScreenLoader.setSource("./window/HcSettingWindow.qml")
                    }
                }
            }
        }
        //右侧矩形框
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            border.width: 1
            border.color: "#a0b9b9"
            color: "transparent"
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
                    //asynchronous: true
                    asynchronous: false
                }
            }
        }
    }
    Connections{
        target: TranslateHelper
        function onCurrentChanged(){
            SettingsHelper.saveLanguage(TranslateHelper.current)
            TranslateHelper.setLang()
            HcApp.setLang(Qt.locale(TranslateHelper.current))
            updateModel();
        }
    }
    Connections{
        target: HcTheme
        function onDarkModeChanged(){
            SettingsHelper.saveDarkMode(HcTheme.darkMode)
        }
    }
    Component.onCompleted: {
        updateModel();
        HcApp.init(app,Qt.locale(TranslateHelper.current))
        HcTheme.darkMode = SettingsHelper.getDarkMode()
        HcTheme.animationEnabled = true
    }
}
