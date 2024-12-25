import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Controls.impl
import QtQuick.Templates as T
import HcControls

T.GroupBox {
    id: control
    property int borderWidth : 1
    property color borderColor : HcTheme.dividerColor
    property color color: {
        if(Window.active){
            return HcTheme.frameActiveColor
        }
        return HcTheme.frameColor
    }
    property int radius: 4
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding,
                            implicitLabelWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)
    spacing: 6
    padding: 12
    font: HcTextStyle.Body
    topPadding: padding + (implicitLabelWidth > 0 ? implicitLabelHeight + spacing : 0)
    label: HcText {
        width: control.availableWidth
        text: control.title
        font: HcTextStyle.BodyStrong
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }
    background: Rectangle {
        y: control.topPadding - control.bottomPadding
        width: parent.width
        height: parent.height - control.topPadding + control.bottomPadding
        radius: control.radius
        border.color: control.borderColor
        border.width: control.borderWidth
        color: control.color
    }
}
