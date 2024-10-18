import QtQuick
import QtQuick.Controls
import QtQuick.Templates as T
import QtQuick.Controls.Universal

Button {

    id: control
    //是否为触摸屏，true则没有hovered状态
    property bool isTouchDevice: false
    //圆角
    property int _radius: 2
    property int borderWidth: 1
    //描边颜色
    property color borderNormolColor: "#C7D6D7"
    property color borderHoverColor: "#49B8B1"
    property color borderDisableColor: "#DCDCDC"
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

    //字体颜色
    property color fontNormolColor: "#333333"
    property color fontHoverColor: "#49B8B1"
    property color fontCheckedColor: "#FFFFFF"
    property color fontDisableColor: "#8C8C8C"
    //默认字体大小
    font.pixelSize: 14
    background: Rectangle {
        id: _rect

        border.width: borderWidth
        border.color: control.enabled ? (control.checked ? borderNormolColor :
                                        (control.hovered && !isTouchDevice ? borderHoverColor : borderNormolColor))
                                        : borderDisableColor
        radius: _radius
        gradient: control.enabled ? (control.checked ? buttonCheckedGradient :
                                    (control.hovered && !isTouchDevice ? buttonHoverGradient : buttonNormolGradient))
                                    : buttonDisableGradient
    }

    contentItem: Text {
        id: _text
        text: control.text
        font: control.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: control.enabled ? (control.checked ? fontCheckedColor :
                                 (control.hovered && !isTouchDevice ? fontHoverColor : fontNormolColor))
                                 : fontDisableColor
    }
}
