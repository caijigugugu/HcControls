import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Controls.Universal

Button {
    display: Button.TextBesideIcon
    //是否为触摸屏，true则没有hovered状态
    property bool isTouchDevice: false
    property int _radius: 2
    property int borderWidth: 1
    property int _imageWidth: 12
    property int _imageHeight: 12
    //icon与text间隔
    property int _spacing: 10
    property string _src: ""
    //描边颜色
    property color borderNormolColor: "#C7D6D7"
    property color borderHoverColor: "#49B8B1"
    property color borderDisableColor: "#DCDCDC"
    property color borderColor: {
        if(!enabled){
            return borderDisableColor
        }
        if(checked){
            return borderNormolColor
        }
        return hovered && !isTouchDevice ? borderHoverColor : borderNormolColor
    }
    //按钮背景颜色
    property Gradient buttonNormolGradient: Gradient {
        GradientStop {
            position: 0
            color: "#F9FBFB"
        }

        GradientStop {
            position: 1
            color: "#E6E6E6"
        }
        orientation: Gradient.Vertical
    }
    property Gradient buttonHoverGradient: buttonNormolGradient
    property Gradient buttonCheckedGradient: Gradient {
        GradientStop {
            position: 0
            color: "#54C4BE"
        }
        GradientStop {
            position: 1
            color: "#309D96"
        }
        orientation: Gradient.Vertical
    }
    property Gradient buttonDisableGradient: Gradient {
        GradientStop {
            color: "#C1C1C1"
        }
        orientation: Gradient.Vertical
    }
    property Gradient buttonColor: {
        if(!enabled){
            return buttonDisableGradient
        }
        if(checked){
            return buttonCheckedGradient
        }
        return hovered && !isTouchDevice ? buttonHoverGradient : buttonNormolGradient
    }
    //字体颜色
    property color fontNormolColor: "#4B5153"
    property color fontHoverColor: "#49B8B1"
    property color fontCheckedColor: "#FFFFFF"
    property color fontDisableColor: "#8C8C8C"
    property color textColor: {
        if(!enabled){
            return fontDisableColor
        }
        if(checked){
            return fontCheckedColor
        }
        return hovered && !isTouchDevice ? fontHoverColor : fontNormolColor
    }
    //图标颜色
    property color iconNormolColor: "#658080"
    property color iconHoverColor: "#49B8B1"
    property color iconCheckedColor: "#FFFFFF"
    property color iconDisableColor: "#8C8C8C"
    property color iconColor: {
        if(!enabled){
            return iconDisableColor
        }
        if(checked){
            return iconCheckedColor
        }
        return hovered && !isTouchDevice ? iconHoverColor : iconNormolColor
    }
    id: control
    //默认字体大小
    font.pixelSize: 28
    background: Rectangle {
        implicitWidth: 30
        implicitHeight: 30
        radius: control._radius
        gradient: control.buttonColor
        border.color: control.borderColor
        border.width: control.borderWidth
    }
    // 定制搜索图标
    contentItem: Loader {
        sourceComponent: {
            if(display === Button.TextUnderIcon){
                return com_column
            }
            return com_row
        }
        Component.onDestruction: sourceComponent = undefined
    }
    Component {
        id: com_row
        Item {
            anchors.centerIn: parent
            Row {
                anchors.centerIn: parent
                spacing: control._spacing
                ColorImage {
                    width: control._imageWidth
                    height: control._imageHeight
                    source: _src
                    color: control.iconColor
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: parent.verticalCenter
                    visible: display !== Button.TextOnly
                }

                Text {
                    text: control.text
                    font: control.font
                    color: control.textColor
                    visible: display !== Button.IconOnly
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }
    Component{
        id:com_column
        Item {
            anchors.centerIn: parent
            Column{
                anchors.centerIn: parent
                spacing: control._spacing
                ColorImage{
                    width: control._imageWidth
                    height: control._imageHeight
                    source: _src
                    color: control.iconColor
                    fillMode: Image.PreserveAspectFit
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: display !== Button.TextOnly
                }
                Text{
                    text: control.text
                    font: control.font
                    color: control.textColor
                    visible: display !== Button.IconOnly
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
