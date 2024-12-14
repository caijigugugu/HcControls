import QtQuick 2.15
import QtQuick.Controls 2.15
import HcControls

//自定义弹窗
Popup {
    property int headerHeight: 44
    property string title: qsTr("提示")
    property bool showCloseIcon: false
    property int headerRadius: 5
    property color borderColor: "#FF1414"
    property int borderWidth: 1
    //字体大小
    property int headerFontSize: 16
    //字体颜色
    property color headerFontColor: "#FFFFFF"
    property color messageColor: "#FFFFFF"

    property int titleLeftMargin: 10
    property int titleTopMargin: 0 //标题在标题栏垂直方向距离，为0垂直居中
    //关闭图标
    property string iconSource: "../Icon/close.svg"
    property int iconWidth: 20
    property int iconHeight: 20
    property color iconColor: "#FFFFFF"
    property int iconRightMargin: 10
    property int iconTopMargin: 10
    //主体信息
    property int textTopMargin: 0   //文本距标题栏距离

    id: _popup
    modal: true
    focus: true
    width: implicitWidth
    height: implicitHeight
    anchors.centerIn: parent
    padding: 0 - headerRadius
    parent: Overlay.overlay
    closePolicy: Popup.NoAutoClose/* | Popup.CloseOnEscape*/

    // 定义弹窗总的样式，如添加圆角
    Rectangle {
        anchors.fill: parent
        radius: headerRadius
        color: Constants.bodyBackground
        border.width: borderWidth
        border.color: Constants.dialogHeadBorderColor

        HcShadow{
            radius: headerRadius
            color: Constants.dialogHeadBorderColor
        }
        // 仅定义头部矩形框
        HcRoundedRectangle {
            id: _header
            width: parent.width
            height: headerHeight
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            gradient: HcTheme.dark ?  Constants.dialogHeadDeepGradient : Constants.dialogHeadGradient
            radius: [headerRadius,headerRadius,0,0]

            Label {
                id: _title
                width: parent.width
                height: parent.height
                anchors.left: parent.left
                anchors.leftMargin: titleLeftMargin
                anchors.top: parent.top
                anchors.topMargin: titleTopMargin
                text: title
                color: headerFontColor
                font.pixelSize: headerFontSize
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.Wrap
                padding: 6
            }
            ColorImage {
                id: _closeIcon
                source: _popup.iconSource
                width: _popup.iconWidth
                height: _popup.iconHeight
                color: _popup.iconColor
                anchors.right: parent.right
                anchors.rightMargin: _popup.iconRightMargin
                anchors.top: parent.top
                anchors.topMargin: _popup.iconTopMargin
                fillMode: Image.PreserveAspectFit
                visible: showCloseIcon
                MouseArea {
                    id: _closeArea
                    anchors.fill: parent
                    onClicked: {
                        _popup.close()
                    }
                }
            }
            //分割线
            HcDivider{
                width: parent.width
                height: 1
                anchors.bottom: parent.bottom
                dividerColor: HcTheme.dark ? "#000000" : ""
            }
        }
    }
}

