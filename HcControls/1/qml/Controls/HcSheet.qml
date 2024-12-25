import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Window
import HcControls

Popup {
    id: control
    default property alias content : container.contentData
    property string title
    //默认弹窗顶部标题和关闭按钮
    property var header : Item{
        implicitHeight: 40
        HcIconButton{
            id: btn_close
            iconSource: HcIcons.Clear
            iconSize: 15
            verticalPadding: 6
            horizontalPadding: 6
            width: 30
            height: 30
            buttonColor:Gradient {
                GradientStop {
                    color: "transparent"
                }
            }
            borderWidth: 0
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 5
            }
            onClicked: {
                control.visible = false
            }
        }
        HcText{
            id:text_title
            text: control.title
            font: HcTextStyle.Subtitle
            anchors{
                verticalCenter: parent.verticalCenter
                left: btn_close.right
                leftMargin: 5
                right: parent.right
                rightMargin: 5
            }
        }
    }
    property int size: 278
    //描边颜色
    property string borderColor: HcTheme.dark ? Window.active ? Qt.rgba(55/255,55/255,55/255,1):Qt.rgba(45/255,45/255,45/255,1) : Qt.rgba(226/255,229/255,234/255,1)
    //背景颜色
    property string backColor: HcTheme.dark ? Window.active ?  Qt.rgba(38/255,44/255,54/255,1) : Qt.rgba(39/255,39/255,39/255,1) : Qt.rgba(251/255,251/255,253/255,1)
    closePolicy: Popup.CloseOnEscape |  Popup.CloseOnPressOutside
    padding: 0
    modal:true
    parent: Overlay.overlay
    enter: {
        if(d.position === HcSheetType.Top){
            return enter_top
        }else if(d.position === HcSheetType.Left){
            return enter_left
        }else if(d.position === HcSheetType.Right){
            return enter_right
        }else{
            return enter_bottom
        }
    }
    exit: {
        if(d.position === HcSheetType.Top){
            return exit_top
        }else if(d.position === HcSheetType.Left){
            return exit_left
        }else if(d.position === HcSheetType.Right){
            return exit_right
        }else{
            return exit_bottom
        }
    }
    Item {
        id: d
        property var win: Window.window
        onWinChanged: {
            if(win instanceof HcWindow){
                win.setHitTestVisible(container)
            }
        }
        property int position: HcSheetType.Bottom
        property int parentHeight: {
            if(control.parent){
                return control.parent.height
            }
            return control.height
        }
        property int parentWidth: {
            if(control.parent){
                return control.parent.width
            }
            return control.width
        }
    }
    Transition {
        id:enter_right
        onRunningChanged: {
            if(!running){
                control.x = Qt.binding(function(){return d.parentWidth - control.width})
            }
        }
        NumberAnimation{
            property: "x"
            duration: 167
            from: d.parentWidth
            to: d.parentWidth - control.width
            easing.type: Easing.OutCubic
        }
    }
    Transition {
        id:exit_right
        NumberAnimation{
            property: "x"
            duration: 167
            from: d.parentWidth - control.width
            to: d.parentWidth
            easing.type: Easing.OutCubic
        }
    }
    Transition {
        id:enter_left
        NumberAnimation{
            property: "x"
            duration: 167
            from: -control.width
            to: 0
            easing.type: Easing.OutCubic
        }
    }
    Transition {
        id:exit_left
        NumberAnimation{
            property: "x"
            duration: 167
            from: 0
            to:  -control.width
            easing.type: Easing.OutCubic
        }
    }
    Transition {
        id:enter_top
        NumberAnimation{
            property: "y"
            duration: 167
            from: -control.height
            to: 0
            easing.type: Easing.OutCubic
        }
    }
    Transition {
        id:exit_top
        NumberAnimation{
            property: "y"
            duration: 167
            from: 0
            to:  -control.height
            easing.type: Easing.OutCubic
        }
    }
    Transition {
        id:enter_bottom
        onRunningChanged: {
            if(!running){
                control.y = Qt.binding(function(){return d.parentHeight - control.height})
            }
        }
        NumberAnimation{
            property: "y"
            duration: 167
            from: d.parentHeight
            to: d.parentHeight - control.height
            easing.type: Easing.OutCubic
        }
    }
    Transition {
        id:exit_bottom
        NumberAnimation{
            property: "y"
            duration: 167
            from: d.parentHeight - control.height
            to: d.parentHeight
            easing.type: Easing.OutCubic
        }
    }
    //弹窗背景
    background: Rectangle {
        HcShadow{
            radius: 0
        }
        border.color: borderColor
        color: backColor
    }
    //弹窗内容容器
    Page{
        id: container
        anchors.fill: parent
        header: control.header
        background: Item{}
    }
    function open(position = HcSheetType.Bottom){
        control.x = 0
        control.y = 0

        d.position = position
        if(d.position === HcSheetType.Top || d.position === HcSheetType.Bottom){
            control.width =  Qt.binding(function(){return d.parentWidth})
            control.height = size
        }else{
            control.width =  size
            control.height = Qt.binding(function(){return d.parentHeight})
        }
        control.visible = true
    }
}
