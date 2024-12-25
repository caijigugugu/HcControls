import QtQuick
import QtQuick.Controls
import HcControls

Text {
    property color textColor: HcTheme.fontPrimaryColor//"#323232"
    id:text
    color: textColor
    renderType: HcTheme.nativeText ? Text.NativeRendering : Text.QtRendering
    font: HcTextStyle.Body
}
