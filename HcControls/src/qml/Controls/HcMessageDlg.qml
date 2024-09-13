import QtQuick 2.15
import QtQuick.Controls 2.15


Item {
    id: _item
    property int popupWidth: 400
    property int popupHeight: 300

    property int headerHeight: 50
    property string title: qsTr("提示")
    property string message: ""
    property string positiveText: qsTr("确认")
    property string negativeText: qsTr("取消")
    property bool onlyConfirm: false
    property bool showCloseIcon: false

    //标题栏渐变色
    property Gradient headerGradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop {
            position: 0
            color: "#33494D"
        }
        GradientStop {
            position: 1
            color: "#33494D"
        }
    }
    property int headerRadius: 5
    property color borderColor: "#FF1414"
    property int borderWidth: 1
    //字体大小
    property int headerFontSize: 16
    property int messageFontSize: 16
    property int buttonFontSize: 14
    //字体颜色
    property color headerFontColor: "#FFFFFF"
    property color messageColor: "#FFFFFF"
    //主体颜色
    property color bodyBackColor: "#212B2D"

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
    //按钮，左边距指左右两个按钮分别据边距的距离
    property int buttonWidth: 90
    property int buttonHeight: 40
    property int buttonBottomMargin: 36
    property int buttonLeftMargin: 22

    signal negativeClicked
    signal positiveClicked
    //自定义按钮按下事件，此时对话框不自动关闭
    property var onNegativeClickListener
    property var onPositiveClickListener

    function close() {
        _popup.close()
    }

    function open() {
        _popup.open()
    }
    Popup {
        id: _popup
        modal:true
        focus: true
        width: popupWidth
        height: Math.max(popupHeight, _col.height + _header.height + _item.textTopMargin)
        anchors.centerIn: parent
        padding: 0 - headerRadius
        parent: Overlay.overlay
        closePolicy: Popup.NoAutoClose/* | Popup.CloseOnEscape*/

        // 定义弹窗总的样式，如添加圆角
        Rectangle {
            anchors.fill: parent
            radius: headerRadius
            color: bodyBackColor
            border.width: borderWidth
            border.color: borderColor

            Rectangle {
                id: _header
                width: parent.width - 2 * borderWidth
                height: headerHeight
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: borderWidth
                gradient: headerGradient
                radius: headerRadius

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
                    source: _item.iconSource
                    width: _item.iconWidth
                    height: _item.iconHeight
                    color: _item.iconColor
                    anchors.right: parent.right
                    anchors.rightMargin: _item.iconRightMargin
                    anchors.top: parent.top
                    anchors.topMargin: _item.iconTopMargin
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
            }
            Column {
                id: _col
                width: parent.width
                height: _row.height + _message.height
                anchors.top: _header.bottom
                anchors.topMargin: _item.textTopMargin
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: _message
                    width: parent.width - 60
                    height: Math.max(contentHeight,(popupHeight - _header.height) * 2 / 3)
                    text: _item.message
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: _item.messageFontSize
                    color: _item.messageColor
                    wrapMode: Text.Wrap
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Row {
                    id: _row
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: (popupHeight - _header.height) / 3
                    Item {
                        width: buttonLeftMargin
                        height: 10
                    }
                    HcButton {
                        id: _cancelBtn
                        width: _item.buttonWidth
                        height: _item.buttonHeight
                        text: _item.negativeText
                        visible: !(_item.onlyConfirm)
                        font.pixelSize: _item.buttonFontSize
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: buttonBottomMargin
                        onClicked: {
                            if (onNegativeClickListener) {
                                onNegativeClickListener()
                            } else {
                                negativeClicked()
                                _popup.close()
                            }
                        }
                    }
                    Item {
                        width: parent.width - _cancelBtn.width - _confirmBtn.width - 2 *buttonLeftMargin // 动态计算空隙
                        height: 10
                    }
                    HcButton {
                        id: _confirmBtn
                        width: _item.buttonWidth
                        height: _item.buttonHeight
                        text: _item.positiveText
                        font.pixelSize: _item.buttonFontSize
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: buttonBottomMargin
                        onClicked: {
                            if (onPositiveClickListener) {
                                onPositiveClickListener()
                            } else {
                                positiveClicked()
                                console.log("parent.width",parent.width,parent.height)
                                _popup.close()
                            }
                        }
                    }
                }
            }
        }
    }

}

